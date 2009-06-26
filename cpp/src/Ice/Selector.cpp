// **********************************************************************
//
// Copyright (c) 2003-2009 ZeroC, Inc. All rights reserved.
//
// This copy of Ice is licensed to you under the terms described in the
// ICE_LICENSE file included in this distribution.
//
// **********************************************************************

#include <Ice/Selector.h>
#include <Ice/EventHandler.h>

#ifdef ICE_USE_CFSTREAM
#   include <CoreFoundation/CoreFoundation.h>
#endif

using namespace std;
using namespace IceInternal;

#if defined(ICE_USE_IOCP)
Selector::Selector(const InstancePtr& instance, int timeout) : _instance(instance), _timeout(timeout)
{
}

Selector::~Selector()
{
    CloseHandle(_handle);
}

void
Selector::setup(int sizeIO)
{
    _handle = CreateIoCompletionPort(INVALID_HANDLE_VALUE, NULL, NULL, sizeIO);
    if(_handle == NULL)
    {
        Ice::SocketException ex(__FILE__, __LINE__);
        ex.error = GetLastError();
        throw ex;
    }
}

void
Selector::initialize(EventHandler* handler)
{
    HANDLE socket = reinterpret_cast<HANDLE>(handler->getNativeInfo()->fd());
    if(CreateIoCompletionPort(socket, _handle, reinterpret_cast<ULONG_PTR>(handler), 0) == NULL)
    {
        Ice::SocketException ex(__FILE__, __LINE__);
        ex.error = GetLastError();
        throw ex;
    }
}

void
Selector::update(EventHandler* handler, SocketOperation remove, SocketOperation add)
{
    SocketOperation previous = handler->_registered;
    handler->_registered = static_cast<SocketOperation>(handler->_registered & ~remove);
    handler->_registered = static_cast<SocketOperation>(handler->_registered | add);
    if(add & SocketOperationRead && !(handler->_pending & SocketOperationRead))
    {
        if(!PostQueuedCompletionStatus(_handle, 0, reinterpret_cast<ULONG_PTR>(handler), 
                                       handler->getNativeInfo()->getAsyncInfo(SocketOperationRead)))
        {
            Ice::SocketException ex(__FILE__, __LINE__);
            ex.error = GetLastError();
            throw ex;
        }
    }
    else if(add & SocketOperationWrite && !(handler->_pending & SocketOperationWrite))
    {
        if(!PostQueuedCompletionStatus(_handle, 0, reinterpret_cast<ULONG_PTR>(handler), 
                                       handler->getNativeInfo()->getAsyncInfo(SocketOperationWrite)))
        {
            Ice::SocketException ex(__FILE__, __LINE__);
            ex.error = GetLastError();
            throw ex;
        }
    }
}

void
Selector::finish(EventHandler* handler)
{
    handler->_registered = SocketOperationNone;
}

EventHandler*
Selector::getNextHandler(SocketOperation& status)
{
    ULONG_PTR key;
    LPOVERLAPPED ol;
    DWORD count;

    //
    // TODO: Support selector timeout. We can't just set the timeout here. We also need
    // to ensure that all the other threads waiting on the completion port timeout...
    //
    //if(!GetQueuedCompletionStatus(_handle, &count, &key, &ol, _timeout > 0 ? _timeout * 1000 : INFINITE))
    if(!GetQueuedCompletionStatus(_handle, &count, &key, &ol, INFINITE))
    {
        int err = WSAGetLastError();
        if(ol == 0 && err != WAIT_TIMEOUT)
        {
            Ice::SocketException ex(__FILE__, __LINE__);
            ex.error = err;
            throw ex;
        }
        else if(ol != 0)
        {
            AsyncInfo* info = static_cast<AsyncInfo*>(ol);
            status = info->status;
            info->count = SOCKET_ERROR;
            info->error = WSAGetLastError();
            return reinterpret_cast<EventHandler*>(key);
        }
    }

    if(ol)
    {
        AsyncInfo* info = static_cast<AsyncInfo*>(ol);
        status = info->status;
        info->count = count;
        info->error = 0;
        return reinterpret_cast<EventHandler*>(key);
    }
    else
    {
        status = SocketOperationNone;
        return 0;
    }
}

#elif defined(ICE_USE_KQUEUE) || defined(ICE_USE_EPOLL)

Selector::Selector(const InstancePtr& instance, int timeout) : _instance(instance), _timeout(timeout)
{
    _events.resize(32);
#if defined(ICE_USE_EPOLL)
    _queueFd = epoll_create(1);
    if(_queueFd < 0)
    {
        Ice::SocketException ex(__FILE__, __LINE__);
        ex.error = IceInternal::getSocketErrno();
        throw ex;
    }
#else
    _queueFd = kqueue();
    if(_queueFd < 0)
    {
        Ice::SocketException ex(__FILE__, __LINE__);
        ex.error = getSocketErrno();
        throw ex;
    }
    _selecting = false;
#endif
}

Selector::~Selector()
{
    try
    {
        closeSocket(_queueFd);
    }
    catch(const Ice::LocalException& ex)
    {
        Ice::Error out(_instance->initializationData().logger);
        out << "exception in selector while calling closeSocket():\n" << ex;
    }
}

void
Selector::update(EventHandler* handler, SocketOperation remove, SocketOperation add)
{
    SocketOperation previous = handler->_registered;
    handler->_registered = static_cast<SocketOperation>(handler->_registered & ~remove);
    handler->_registered = static_cast<SocketOperation>(handler->_registered | add);
    if(previous == handler->_registered)
    {
        return;
    }

    SOCKET fd = handler->getNativeInfo()->fd();
#if defined(ICE_USE_EPOLL)
    epoll_event event;
    memset(&event, 0, sizeof(epoll_event));
    event.data.ptr = handler;
    SocketOperation status = handler->_registered;
    if(handler->_disabled)
    {
        status = static_cast<SocketOperation>(status & ~handler->_disabled);
        previous = static_cast<SocketOperation>(previous & ~handler->_disabled);
    }
    event.events |= status & SocketOperationRead ? EPOLLIN : 0;
    event.events |= status & SocketOperationWrite ? EPOLLOUT : 0;
    int op;
    if(!previous && status)
    {
        op = EPOLL_CTL_ADD;
    }
    else if(previous && !status)
    {
        op = EPOLL_CTL_DEL;
    }
    else if(!previous && !status)
    {
        return;
    }
    else
    {
        op = EPOLL_CTL_MOD;
    }
    if(epoll_ctl(_queueFd, op, fd, &event) != 0)
    {
        Ice::Error out(_instance->initializationData().logger);
        out << "error while updating selector:\n";
        out << IceUtilInternal::errorToString(IceInternal::getSocketErrno());
        assert(false);
    }
#else // ICE_USE_KQUEUE
    if(remove & SocketOperationRead)
    {
        struct kevent ev;
        EV_SET(&ev, fd, EVFILT_READ, EV_DELETE, 0, 0, handler);            
        _changes.push_back(ev);
    }
    if(remove & SocketOperationWrite)
    {
        struct kevent ev;
        EV_SET(&ev, fd, EVFILT_WRITE, EV_DELETE, 0, 0, handler);
        _changes.push_back(ev);
    }
    if(add & SocketOperationRead)
    {
        struct kevent ev;
        EV_SET(&ev, fd, EVFILT_READ, EV_ADD | (handler->_disabled & SocketOperationRead ? EV_DISABLE : 0), 0, 0, handler);
        _changes.push_back(ev);
    }
    if(add & SocketOperationWrite)
    {
        struct kevent ev;
        EV_SET(&ev, fd, EVFILT_WRITE, EV_ADD | (handler->_disabled & SocketOperationWrite ? EV_DISABLE : 0), 0, 0, handler);
        _changes.push_back(ev);
    }
    if(_selecting)
    {
        updateSelector();
    }
#endif
}

void
Selector::enable(EventHandler* handler, SocketOperation status)
{
    if(!(handler->_disabled & status))
    {
        return;
    }
    handler->_disabled = static_cast<SocketOperation>(handler->_disabled & ~status);

    if(handler->_registered & status)
    {
        SOCKET fd = handler->getNativeInfo()->fd();
#if defined(ICE_USE_EPOLL)
        SocketOperation previous = static_cast<SocketOperation>(handler->_registered & ~status);
        epoll_event event;
        memset(&event, 0, sizeof(epoll_event));
        event.data.ptr = handler;
        event.events |= handler->_registered & SocketOperationRead ? EPOLLIN : 0;
        event.events |= handler->_registered & SocketOperationWrite ? EPOLLOUT : 0;
        if(epoll_ctl(_queueFd, previous ? EPOLL_CTL_MOD : EPOLL_CTL_ADD, fd, &event) != 0)
        {
            Ice::Error out(_instance->initializationData().logger);
            out << "error while updating selector:\n";
            out << IceUtilInternal::errorToString(IceInternal::getSocketErrno());
        }
#else // ICE_USE_KQUEUE
        struct kevent ev;
        EV_SET(&ev, fd, status == SocketOperationRead ? EVFILT_READ : EVFILT_WRITE, EV_ENABLE, 0, 0, handler);
        _changes.push_back(ev);
        if(_selecting)
        {
            updateSelector();
        }
#endif
    }
}

void
Selector::disable(EventHandler* handler, SocketOperation status)
{
    if(handler->_disabled & status)
    {
        return;
    }
    handler->_disabled = static_cast<SocketOperation>(handler->_disabled | status);
    
    if(handler->_registered & status)
    {
        SOCKET fd = handler->getNativeInfo()->fd();
#if defined(ICE_USE_EPOLL)
        SocketOperation newStatus = static_cast<SocketOperation>(handler->_registered & ~status);
        epoll_event event;
        memset(&event, 0, sizeof(epoll_event));
        event.data.ptr = handler;
        event.events |= newStatus & SocketOperationRead ? EPOLLIN : 0;
        event.events |= newStatus & SocketOperationWrite ? EPOLLOUT : 0;
        if(epoll_ctl(_queueFd, newStatus ? EPOLL_CTL_MOD : EPOLL_CTL_DEL, fd, &event) != 0)
        {
            Ice::Error out(_instance->initializationData().logger);
            out << "error while updating selector:\n";
            out << IceUtilInternal::errorToString(IceInternal::getSocketErrno());
        }
#else // ICE_USE_KQUEUE
        struct kevent ev;
        EV_SET(&ev, fd, status == SocketOperationRead ? EVFILT_READ : EVFILT_WRITE, EV_DISABLE, 0, 0, handler);
        _changes.push_back(ev);
        if(_selecting)
        {
            updateSelector();
        }
#endif
    }
}

void
Selector::finish(EventHandler* handler)
{
    if(handler->_registered)
    {
        update(handler, handler->_registered, SocketOperationNone);
    }
}

#if defined(ICE_USE_KQUEUE)
void 
Selector::updateSelector()
{
    int rs = kevent(_queueFd, &_changes[0], _changes.size(), 0, 0, 0);
    if(rs < 0)
    {
        {
            Ice::Error out(_instance->initializationData().logger);
            out << "error while updating selector:\n";
            out << IceUtilInternal::errorToString(IceInternal::getSocketErrno());
        }
        assert(false);
    }
    _changes.clear();
}
#endif

void 
Selector::select(vector<pair<EventHandler*, SocketOperation> >& handlers)
{
    int ret = 0;
    while(true)
    {
#if defined(ICE_USE_EPOLL)
        ret = epoll_wait(_queueFd, &_events[0], _events.size(), _timeout > 0 ? _timeout * 1000 : -1);
#else
        assert(!_events.empty());
        if(_timeout > 0)
        {
            struct timespec ts;
            ts.tv_sec = _timeout;
            ts.tv_nsec = 0;
            ret = kevent(_queueFd, 0, 0, &_events[0], _events.size(), &ts);
        }
        else
        {
            ret = kevent(_queueFd, 0, 0, &_events[0], _events.size(), 0);
        }
#endif
        if(ret == SOCKET_ERROR)
        {
            if(interrupted())
            {
                continue;
            }

            assert(false);
            Ice::SocketException ex(__FILE__, __LINE__);
            ex.error = IceInternal::getSocketErrno();
            throw ex;
        }
        break;
    }

    assert(ret >= 0);
    handlers.clear();
    for(int i = 0; i < ret; ++i)
    {
        std::pair<EventHandler*, SocketOperation> p;
#if defined(ICE_USE_EPOLL)
        struct epoll_event& ev = _events[i];
        p.first = reinterpret_cast<EventHandler*>(ev.data.ptr);
        p.second = static_cast<SocketOperation>(((ev.events & EPOLLIN) ? SocketOperationRead : Finished) | 
                                                ((ev.events & EPOLLOUT) ? SocketOperationWrite : Finished));
#else
        struct kevent& ev = _events[i];
        if(ev.flags & EV_ERROR)
        {
            Ice::Error out(_instance->initializationData().logger);
            out << "error while updating selector:\n";
            out << IceUtilInternal::errorToString(ev.data);
            continue;
        }
        p.first = reinterpret_cast<EventHandler*>(ev.udata);
        p.second = (ev.filter == EVFILT_READ) ? SocketOperationRead : SocketOperationWrite;
#endif
        handlers.push_back(p);
    }
}

#elif defined(ICE_USE_CFSTREAM)

namespace
{

void selectorInterrupt(void* info)
{
    reinterpret_cast<Selector*>(info)->processInterrupt();
}

void selectorReadCallback(CFReadStreamRef, CFStreamEventType, void* info)
{
    reinterpret_cast<EventHandlerWrapper*>(info)->selector().ready(reinterpret_cast<EventHandlerWrapper*>(info), 
                                                                   SocketOperationRead);
}

void selectorWriteCallback(CFWriteStreamRef, CFStreamEventType type, void* info)
{
    reinterpret_cast<EventHandlerWrapper*>(info)->selector().ready(
        reinterpret_cast<EventHandlerWrapper*>(info), 
        static_cast<SocketOperation>(SocketOperationConnect | SocketOperationWrite));
}
 
const void* eventHandlerWrapperRetain(const void* info)
{
    reinterpret_cast<EventHandlerWrapper*>(const_cast<void*>(info))->__incRef();
    return info;
}

void eventHandlerWrapperRelease(const void* info)
{
    reinterpret_cast<EventHandlerWrapper*>(const_cast<void*>(info))->__decRef();
}

void* eventHandlerWrapperRetain(void* info)
{
    reinterpret_cast<EventHandlerWrapper*>(info)->__incRef();
    return info;
}

void eventHandlerWrapperRelease(void* info)
{
    reinterpret_cast<EventHandlerWrapper*>(info)->__decRef();
}

void eventHandlerSocketCallback(CFSocketRef, CFSocketCallBackType callbackType, CFDataRef, const void* d, void* info)
{
    if(callbackType == kCFSocketReadCallBack)
    {
        reinterpret_cast<EventHandlerWrapper*>(info)->selector().ready(reinterpret_cast<EventHandlerWrapper*>(info), 
                                                                       SocketOperationRead);
    }
    else if(callbackType == kCFSocketWriteCallBack)
    {
        reinterpret_cast<EventHandlerWrapper*>(info)->selector().ready(reinterpret_cast<EventHandlerWrapper*>(info), 
                                                                       SocketOperationWrite);
    }
    else if(callbackType == kCFSocketConnectCallBack)
    {
        reinterpret_cast<EventHandlerWrapper*>(info)->selector().ready(reinterpret_cast<EventHandlerWrapper*>(info),
                                                                       SocketOperationConnect, 
                                                                       d ? *reinterpret_cast<const SInt32*>(d) : 0);
    }
}

class SelectorHelperThread : public IceUtil::Thread
{
public:

    SelectorHelperThread(Selector& selector) : _selector(selector)
    {
    }
    
    virtual void run()
    {
        _selector.run();
    }

private:

    Selector& _selector;
};

CFOptionFlags
toCFCallbacks(SocketOperation op)
{
    CFOptionFlags cbs;
    if(op & SocketOperationRead)
    {
        cbs |= kCFSocketReadCallBack;
    }
    if(op & SocketOperationWrite)
    {
        cbs |= kCFSocketWriteCallBack;
    }
    if(op & SocketOperationConnect)
    {
        cbs |= kCFSocketConnectCallBack;
    }
    return cbs;
}

}

EventHandlerWrapper::EventHandlerWrapper(const EventHandlerPtr& handler, Selector& selector) : 
    _handler(handler), 
    _selector(selector),
    _ready(SocketOperationNone),
    _finish(false),
    _readStreamRegistered(false),
    _writeStreamRegistered(false)
{
    if(!StreamNativeInfoPtr::dynamicCast(handler->getNativeInfo()))
    {
        SOCKET fd = handler->getNativeInfo()->fd();
        CFSocketContext ctx = { 0, this, eventHandlerWrapperRetain, eventHandlerWrapperRelease, 0 };
        _socket = CFSocketCreateWithNative(kCFAllocatorDefault, 
                                           fd,
                                           kCFSocketReadCallBack | 
                                           kCFSocketWriteCallBack | 
                                           kCFSocketConnectCallBack,
                                           eventHandlerSocketCallback, 
                                           &ctx);
        
        // Disable automatic re-enabling of callbacks and closing of the native socket.
        CFSocketSetSocketFlags(_socket, 0);
        CFSocketDisableCallBacks(_socket, kCFSocketReadCallBack | kCFSocketWriteCallBack | kCFSocketConnectCallBack);
        _source = CFSocketCreateRunLoopSource(kCFAllocatorDefault, _socket, 0);
    }
    else
    {
        _socket = 0;
        _source = 0;

        StreamNativeInfoPtr nativeInfo = StreamNativeInfoPtr::dynamicCast(_handler->getNativeInfo());

        CFOptionFlags events;
        CFStreamClientContext ctx = { 0, this, eventHandlerWrapperRetain, eventHandlerWrapperRelease, 0 };

        events = kCFStreamEventOpenCompleted | kCFStreamEventCanAcceptBytes | kCFStreamEventErrorOccurred;
        CFWriteStreamSetClient(nativeInfo->writeStream(), events, selectorWriteCallback, &ctx);

        events = kCFStreamEventHasBytesAvailable | kCFStreamEventErrorOccurred;
        CFReadStreamSetClient(nativeInfo->readStream(), events, selectorReadCallback, &ctx);
    }
}

EventHandlerWrapper::~EventHandlerWrapper()
{
    if(_socket)
    {
        CFRelease(_socket);
        CFRelease(_source);
    }
}

void
EventHandlerWrapper::updateRunLoop()
{
    SocketOperation op = _handler->_registered;
    assert(!op || !_finish);

    if(_socket)
    {
        CFSocketDisableCallBacks(_socket, kCFSocketReadCallBack | kCFSocketWriteCallBack | kCFSocketConnectCallBack);
        if(op)
        {
            CFSocketEnableCallBacks(_socket, toCFCallbacks(op));
        }

        if(op && !CFRunLoopContainsSource(CFRunLoopGetCurrent(), _source, kCFRunLoopDefaultMode))
        {
            CFRunLoopAddSource(CFRunLoopGetCurrent(), _source, kCFRunLoopDefaultMode);
        }
        else if(!op && CFRunLoopContainsSource(CFRunLoopGetCurrent(), _source, kCFRunLoopDefaultMode))
        {
            CFRunLoopRemoveSource(CFRunLoopGetCurrent(), _source, kCFRunLoopDefaultMode);
        }

        if(_finish)
        {
            CFSocketInvalidate(_socket);
        }
    }
    else
    {
        SocketOperation readyOp = SocketOperationNone;
        StreamNativeInfoPtr nativeInfo = StreamNativeInfoPtr::dynamicCast(_handler->getNativeInfo());

        if(op & (SocketOperationConnect | SocketOperationWrite))
        {
            CFWriteStreamRef stream = nativeInfo->writeStream();
            if(op & SocketOperationConnect && CFWriteStreamGetStatus(stream) > kCFStreamStatusOpening)
            {
                readyOp = static_cast<SocketOperation>(readyOp | SocketOperationConnect);
            }
            else if(op & SocketOperationWrite && CFWriteStreamCanAcceptBytes(stream))
            {
                readyOp = static_cast<SocketOperation>(readyOp | SocketOperationWrite);
            }
            else if(!_writeStreamRegistered)
            {
                //
                // Schedule the stream with the runloop. Note that this might call ready() so 
                // it's important to set the registered boolean *after* to ensure read won't 
                // unregister the stream from the loop (which isn't safe). Instead, we check
                // if ready() was called below by checking the _ready flags and unregister the
                // stream from the loop
                //
                CFWriteStreamScheduleWithRunLoop(stream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
                _writeStreamRegistered = true; // Note: this must be set after the schedule call, see above
                if(CFWriteStreamGetStatus(stream) == kCFStreamStatusNotOpen)
                {
                    CFWriteStreamOpen(stream);
                }
            }
        }

        if(!(op & (SocketOperationConnect | SocketOperationWrite)) || 
           _ready & (SocketOperationConnect | SocketOperationWrite))
        {
            if(_writeStreamRegistered)
            {
                CFWriteStreamRef stream = nativeInfo->writeStream();
                CFWriteStreamUnscheduleFromRunLoop(stream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
                _writeStreamRegistered = false;
            }
        }

        if(op & SocketOperationRead)
        {
            CFReadStreamRef stream = nativeInfo->readStream();
            if(op & SocketOperationRead && CFReadStreamHasBytesAvailable(stream))
            {
                readyOp = static_cast<SocketOperation>(readyOp | SocketOperationRead);
            }
            else if(!_readStreamRegistered)
            {
                //
                // Schedule the stream with the runloop. Note that this might call ready() so 
                // it's important to set the registered boolean *after* to ensure read won't 
                // unregister the stream from the loop (which isn't safe). Instead, we check
                // if ready() was called below by checking the _ready flags and unregister the
                // stream from the loop
                //

                CFReadStreamScheduleWithRunLoop(stream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
                _readStreamRegistered = true; // Note: this must be set after the schedule call, see above
                if(CFReadStreamGetStatus(stream) == kCFStreamStatusNotOpen)
                {
                    CFReadStreamOpen(stream);
                }
            }
        }

        if(!(op & SocketOperationRead) || _ready & SocketOperationRead)
        {
            if(_readStreamRegistered)
            {
                CFReadStreamRef stream = nativeInfo->readStream();
                CFReadStreamUnscheduleFromRunLoop(stream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
                _readStreamRegistered = false;
            }
        }

        if(readyOp)
        {
            ready(readyOp, 0);
        }

        if(_finish)
        {
            CFReadStreamSetClient(nativeInfo->readStream(), kCFStreamEventNone, 0, 0);        
            CFWriteStreamSetClient(nativeInfo->writeStream(), kCFStreamEventNone, 0, 0);

            CFReadStreamClose(nativeInfo->readStream());
            CFWriteStreamClose(nativeInfo->writeStream());
        }
    }
}

void
EventHandlerWrapper::ready(SocketOperation op, int error)
{
    if(!_socket)
    {
        //
        // Unregister the stream from the runloop as soon as we got the callback. This is
        // required to allow thread pool thread to perform read/write operations on the
        // stream (which can't be used from another thread than the run loop thread if 
        // it's registered with a run loop).
        //
        StreamNativeInfoPtr nativeInfo = StreamNativeInfoPtr::dynamicCast(_handler->getNativeInfo());
        if(op & (SocketOperationConnect | SocketOperationWrite))
        {
            if(_writeStreamRegistered)
            {
                CFWriteStreamRef stream = nativeInfo->writeStream();
                CFWriteStreamUnscheduleFromRunLoop(stream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
                _writeStreamRegistered = false;
            }
        }
        if(op & SocketOperationRead)
        {
            if(_readStreamRegistered)
            {
                CFReadStreamRef stream = nativeInfo->readStream();
                CFReadStreamUnscheduleFromRunLoop(stream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
                _readStreamRegistered = false;                
            }
        }
    }

    op = static_cast<SocketOperation>(_handler->_registered & op);
    if(!op || _ready & op)
    {
        return;
    }

    if(_socket)
    {
        if(op & SocketOperationConnect)
        {
            _handler->getNativeInfo()->setConnectError(error);
        }
    }

    _ready = static_cast<SocketOperation>(_ready | op);
    if(!(_handler->_disabled & op))
    {
        _selector.addReadyHandler(this);
    }
}

void
EventHandlerWrapper::checkReady()
{
    if(_ready & _handler->_registered)
    {
        _selector.addReadyHandler(this);
    }   
}

SocketOperation
EventHandlerWrapper::readyOp()
{
    assert(!(~_handler->_registered & _ready));
    SocketOperation op = static_cast<SocketOperation>(~_handler->_disabled & _ready);
    _ready = static_cast<SocketOperation>(~op & _ready);
    return op;
}

bool
EventHandlerWrapper::update(SocketOperation remove, SocketOperation add)
{
    SocketOperation previous = _handler->_registered;
    _handler->_registered = static_cast<SocketOperation>(_handler->_registered & ~remove);
    _handler->_registered = static_cast<SocketOperation>(_handler->_registered | add);    
    if(previous == _handler->_registered)
    {
        return false;
    }

    // Clear ready flags which might not be valid anymore.
    _ready = static_cast<SocketOperation>(_ready & _handler->_registered);
    return true;
}

void
EventHandlerWrapper::finish()
{
    _finish = true;
    _ready = SocketOperationNone;
    _handler->_registered = SocketOperationNone;
}

Selector::Selector(const InstancePtr& instance, int timeout = 0) : _instance(instance), _timeout(timeout)
{
    CFRunLoopSourceContext ctx;
    memset(&ctx, 0, sizeof(CFRunLoopSourceContext));
    ctx.info = this;
    ctx.perform = selectorInterrupt;
    _source = CFRunLoopSourceCreate(0, 0, &ctx);
    _runLoop = 0;

    _thread = new SelectorHelperThread(*this);
    _thread->start();

    Lock sync(*this);
    while(!_runLoop)
    {
        wait();
    }
}

Selector::~Selector()
{
}

void
Selector::destroy()
{
    Lock sync(*this);

    //
    // Make sure any pending changes are processed to ensure remaining
    // streams/sockets are closed.
    //
    while(!_changes.empty())
    {
        CFRunLoopSourceSignal(_source);
        CFRunLoopWakeUp(_runLoop);
        
        wait();
    }

    CFRunLoopStop(_runLoop);
    _thread->getThreadControl().join();
    _thread = 0;

    CFRelease(_source);

    assert(_wrappers.empty());
    _readyHandlers.clear();
    _selectedHandlers.clear();
}

void
Selector::initialize(EventHandler* handler)
{
    Lock sync(*this);
    _wrappers[handler] = new EventHandlerWrapper(handler, *this);
}

void 
Selector::update(EventHandler* handler, SocketOperation remove, SocketOperation add)
{
    Lock sync(*this);
    EventHandlerWrapperPtr wrapper = _wrappers[handler];
    assert(wrapper);
    if(wrapper->update(remove, add))
    {
        _changes.insert(wrapper);
        notify();
    }
}

void 
Selector::enable(EventHandler* handler, SocketOperation op)
{
    Lock sync(*this);
    if(!(handler->_disabled & op))
    {
        return;
    }
    handler->_disabled = static_cast<SocketOperation>(handler->_disabled & ~op);

    if(handler->_registered & op)
    {
        _wrappers[handler]->checkReady();
    }
}

void
Selector::disable(EventHandler* handler, SocketOperation op)
{
    Lock sync(*this);
    if(handler->_disabled & op)
    {
        return;
    }
    handler->_disabled = static_cast<SocketOperation>(handler->_disabled | op);
}

void
Selector::finish(EventHandler* handler)
{
    Lock sync(*this);
    std::map<EventHandlerPtr, EventHandlerWrapperPtr, EventHandlerCI>::iterator p = _wrappers.find(handler);
    assert(p != _wrappers.end());
    EventHandlerWrapperPtr wrapper = p->second;
    wrapper->finish();
    _wrappers.erase(p);
    _changes.insert(wrapper);
    notify();
}
    
void
Selector::select(std::vector<std::pair<EventHandler*, SocketOperation> >& handlers)
{
    Lock sync(*this);

    //
    // Re-enable callbacks for previously selected handlers.
    //
    if(!_selectedHandlers.empty())
    {
        vector<pair<EventHandlerWrapperPtr, SocketOperation> >::const_iterator p;
        for(p = _selectedHandlers.begin(); p != _selectedHandlers.end(); ++p)
        {
            _changes.insert(p->first);
        }
        _selectedHandlers.clear();
    }

    //
    // Wait for handlers to be ready.
    // 
    handlers.clear();
    while(_selectedHandlers.empty())
    {
        while(!_changes.empty())
        {
            CFRunLoopSourceSignal(_source);
            CFRunLoopWakeUp(_runLoop);
 
            wait();
        }

        if(_readyHandlers.empty())
        {
            if(_timeout > 0)
            {
                if(!timedWait(IceUtil::Time::seconds(_timeout)))
                {
                    break;
                }
            }
            else
            {
                wait();
            }
        }

        if(!_changes.empty())
        {
            continue; // Make sure to process the changes first.
        }

        for(vector<EventHandlerWrapperPtr>::const_iterator p = _readyHandlers.begin(); p != _readyHandlers.end(); ++p)
        {
            SocketOperation op = (*p)->readyOp();
            if(op)
            {
                _selectedHandlers.push_back(pair<EventHandlerWrapperPtr, SocketOperation>(*p, op));
                handlers.push_back(pair<EventHandler*, SocketOperation>((*p)->_handler.get(), op));
            }
        }
        _readyHandlers.clear();
    }
}

void
Selector::processInterrupt()
{
    Lock sync(*this);
    if(!_changes.empty())
    {
        for(set<EventHandlerWrapperPtr>::const_iterator p = _changes.begin(); p != _changes.end(); ++p)
        {
            (*p)->updateRunLoop();
        }
        _changes.clear();
        notify();
    }
}

void 
Selector::ready(EventHandlerWrapper* wrapper, SocketOperation op, int error)
{
    Lock sync(*this);
    wrapper->ready(op, error);
}

void
Selector::addReadyHandler(EventHandlerWrapper* wrapper)
{
    // Called from ready()
    _readyHandlers.push_back(wrapper);
    if(_readyHandlers.size() == 1)
    {
        notify();
    }
}

void 
Selector::run()
{
    {
        Lock sync(*this);
        _runLoop = CFRunLoopGetCurrent();
        notify();
    }

    CFRunLoopAddSource(CFRunLoopGetCurrent(), _source, kCFRunLoopDefaultMode);
    CFRunLoopRun();
    CFRunLoopRemoveSource(CFRunLoopGetCurrent(), _source, kCFRunLoopDefaultMode);
}

#endif
