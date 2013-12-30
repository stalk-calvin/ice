// **********************************************************************
//
// Copyright (c) 2003-2011 ZeroC, Inc. All rights reserved.
//
// This copy of Ice is licensed to you under the terms described in the
// ICE_FOR_ACTIONSCRIPT_LICENSE file included in this distribution.
//
// **********************************************************************

(function(module, name){
    var __m = function(global, module, exports, require){
        
        require("Ice/AsyncStatus");
        require("Ice/AsyncResult");
        require("Ice/BasicStream");
        require("Ice/Debug");
        require("Ice/HashMap");
        require("Ice/LocalExceptionWrapper");
        require("Ice/Current");
        require("Ice/Protocol");
        require("Ice/BuiltinSequences");
        require("Ice/Exception");
        require("Ice/LocalException");
        require("Ice/Identity");
        
        var Ice = global.Ice || {};
        
        var AsyncStatus = Ice.AsyncStatus;
        var AsyncResult = Ice.AsyncResult;
        var BasicStream = Ice.BasicStream;
        var Debug = Ice.Debug;
        var HashMap = Ice.HashMap;
        var LocalExceptionWrapper = Ice.LocalExceptionWrapper;
        var OperationMode = Ice.Current.OperationMode;
        var Protocol = Ice.Protocol;
        var Identity = Ice.Identity;

        var OutgoingAsync = function(prx, operation, completed)
        {
            //
            // OutgoingAsync can be constructed by a sub-type's prototype, in which case the
            // arguments are undefined.
            //
            if(prx !== undefined)
            {
                AsyncResult.call(this, prx.ice_getCommunicator(), operation, null, prx, null, completed);
                this._batch = this._proxy.ice_isBatchOneway() || this._proxy.ice_isBatchDatagram();

                this._batchStarted = false;

                this._timerToken = -1;
                this._timerConnection = null;

                this._handler = null;
                this._encoding = Protocol.getCompatibleEncoding(this._proxy.__reference().getEncoding());
                this._cnt = 0;
                this._mode = null;
            }
            else
            {
                AsyncResult.call(this);
            }
        };

        OutgoingAsync._emptyContext = new HashMap();

        OutgoingAsync.prototype = new AsyncResult();
        OutgoingAsync.prototype.constructor = OutgoingAsync;

        OutgoingAsync.prototype.__prepare = function(op, mode, ctx)
        {
            this._handler = null;
            this._cnt = 0;
            this._mode = mode;
            this._sentSynchronously = false;

            Protocol.checkSupportedProtocol(Protocol.getCompatibleProtocol(this._proxy.__reference().getProtocol()));

            if(ctx === null)
            {
                ctx = OutgoingAsync._emptyContext;
            }

            if(this._batch)
            {
                while(true)
                {
                    this._handler = this._proxy.__getRequestHandler();
                    Debug.assert(this._handler !== null);
                    try
                    {
                        this._handler.prepareBatchRequest(this._os);
                        this._batchStarted = true;
                        break;
                    }
                    catch(ex)
                    {
                        if(ex instanceof LocalExceptionWrapper)
                        {
                            this.handleExceptionWrapper(ex);
                        }
                        else
                        {
                            throw ex;
                        }
                    }
                }
            }
            else
            {
                this._os.writeBlob(Protocol.requestHdr);
            }

            var ref = this._proxy.__reference();

            ref.getIdentity().__write(this._os);

            //
            // For compatibility with the old FacetPath.
            //
            var facet = ref.getFacet();
            if(facet === null || facet.length === 0)
            {
                Ice.StringSeqHelper.write(this._os, null);
            }
            else
            {
                Ice.StringSeqHelper.write(this._os, [ facet ]);
            }

            this._os.writeString(this._operation);

            this._os.writeByte(mode.value);

            if(ctx !== undefined)
            {
                if(ctx !== null && !(ctx instanceof HashMap))
                {
                    throw new Error("illegal context value, expecting null or HashMap");
                }

                //
                // Explicit context
                //
                Ice.ContextHelper.write(os, ctx);
                this._os.writeSize(0);
            }
            else
            {
                //
                // Implicit context
                //
                var implicitContext = ref.getInstance().getImplicitContext();
                var prxContext = ref.getContext();

                if(implicitContext === null)
                {
                    Ice.ContextHelper.write(os, ctx);
                    this._os.writeSize(0);
                }
                else
                {
                    implicitContext.write(prxContext, this._os);
                }
            }
        };

        OutgoingAsync.prototype.__sent = function(connection)
        {
            var alreadySent = (this._state & AsyncResult.Sent) !== 0;
            this._state |= AsyncResult.Sent;

            if((this._state & AsyncResult.Done) === 0)
            {
                if(!this._proxy.ice_isTwoway())
                {
                    this._state |= AsyncResult.Done | AsyncResult.OK;
                    this._os.resize(0);
                }
                else if(connection.timeout() > 0)
                {
                    Debug.assert(this._timerToken === -1);
                    this._timerConnection = connection;
                    var self = this;
                    this._timerToken = this._instance.timer().schedule(
                        function() { self.__runTimerTask(); }, connection.timeout());
                }
            }
            return !alreadySent; // Don't call the sent callback if already sent.
        };

        OutgoingAsync.prototype.__finishedEx = function(exc, sent)
        {
            Debug.assert((this._state & AsyncResult.Done) === 0);
            if(this._timerConnection !== null)
            {
                this._instance.timer().cancel(this._timerToken);
                this._timerConnection = null;
                this._timerToken = -1;
            }

            try
            {
                var interval = this.handleException(exc, sent); // This will throw if the invocation can't be retried.
                if(interval > 0)
                {
                    this._instance.retryQueue().add(this, interval);
                }
                else
                {
                    this.__send();
                }
            }
            catch(ex)
            {
                if(ex instanceof Ice.LocalException)
                {
                    this.__exception(ex);
                }
                else
                {
                    this.fail(ex);
                }
            }
        };

        OutgoingAsync.prototype.__finishedWrapper = function(exc)
        {
            //
            // The LocalExceptionWrapper exception is only called before the invocation is sent.
            //

            try
            {
                var interval = this.handleExceptionWrapper(exc); // This will throw if the invocation can't be retried.
                if(interval > 0)
                {
                    this._instance.retryQueue().add(this, interval);
                }
                else
                {
                    this.__send();
                }
            }
            catch(ex)
            {
                if(ex instanceof Ice.LocalException)
                {
                    this.__exception(ex);
                }
                else
                {
                    this.fail(ex);
                }
            }
        };

        OutgoingAsync.prototype.__finished = function(istr)
        {
            Debug.assert(this._proxy.ice_isTwoway()); // Can only be called for twoways.

            var replyStatus;
            try
            {
                Debug.assert(this._exception === null && (this._state & AsyncResult.Done) === 0);

                if(this._timerConnection !== null)
                {
                    Debug.assert(this._timerToken !== -1);
                    this._instance.timer().cancel(this._timerToken);
                    this._timerConnection = null;
                    this._timerToken = -1;
                }

                if(this._is === null) // _is can already be initialized if the invocation is retried
                {
                    this._is = new BasicStream(this._instance, Protocol.currentProtocolEncoding, false);
                }
                this._is.swap(istr);
                replyStatus = this._is.readByte();

                switch(replyStatus)
                {
                    case Protocol.replyOK:
                    case Protocol.replyUserException:
                    {
                        break;
                    }

                    case Protocol.replyObjectNotExist:
                    case Protocol.replyFacetNotExist:
                    case Protocol.replyOperationNotExist:
                    {
                        var id = new Identity();
                        id.__read(this._is);

                        //
                        // For compatibility with the old FacetPath.
                        //
                        var facetPath = Ice.StringSeqHelper.read(this._is);
                        var facet;
                        if(facetPath.length > 0)
                        {
                            if(facetPath.length > 1)
                            {
                                throw new Ice.MarshalException();
                            }
                            facet = facetPath[0];
                        }
                        else
                        {
                            facet = "";
                        }

                        var operation = this._is.readString();

                        var rfe = null;
                        switch(replyStatus)
                        {
                        case Protocol.replyObjectNotExist:
                        {
                            rfe = new Ice.ObjectNotExistException();
                            break;
                        }

                        case Protocol.replyFacetNotExist:
                        {
                            rfe = new Ice.FacetNotExistException();
                            break;
                        }

                        case Protocol.replyOperationNotExist:
                        {
                            rfe = new Ice.OperationNotExistException();
                            break;
                        }

                        default:
                        {
                            Debug.assert(false);
                            break;
                        }
                        }

                        rfe.id = id;
                        rfe.facet = facet;
                        rfe.operation = operation;
                        throw rfe;
                    }

                    case Protocol.replyUnknownException:
                    case Protocol.replyUnknownLocalException:
                    case Protocol.replyUnknownUserException:
                    {
                        var unknown = this._is.readString();

                        var ue = null;
                        switch(replyStatus)
                        {
                        case Protocol.replyUnknownException:
                        {
                            ue = new Ice.UnknownException();
                            break;
                        }

                        case Protocol.replyUnknownLocalException:
                        {
                            ue = new Ice.UnknownLocalException();
                            break;
                        }

                        case Protocol.replyUnknownUserException:
                        {
                            ue = new Ice.UnknownUserException();
                            break;
                        }

                        default:
                        {
                            Debug.assert(false);
                            break;
                        }
                        }

                        ue.unknown = unknown;
                        throw ue;
                    }

                    default:
                    {
                        throw new Ice.UnknownReplyStatusException();
                    }
                }

                this._state |= AsyncResult.Done;
                if(replyStatus == Protocol.replyOK)
                {
                    this._state |= AsyncResult.OK;
                }
            }
            catch(ex)
            {
                if(ex instanceof Ice.LocalException)
                {
                    this.__finishedEx(ex, true);
                    return;
                }
                else
                {
                    this.fail(ex);
                    return;
                }
            }

            Debug.assert(replyStatus === Protocol.replyOK || replyStatus === Protocol.replyUserException);
            this.__response();
        };

        OutgoingAsync.prototype.__send = function()
        {
            if(this._batch)
            {
                Debug.assert(this._handler !== null);
                this._handler.finishBatchRequest(this._os);
            }
            else
            {
                while(true)
                {
                    var interval = 0;
                    try
                    {
                        this._handler = this._proxy.__getRequestHandler();
                        var status = this._handler.sendAsyncRequest(this);
                        if((status & AsyncStatus.Sent) > 0)
                        {
                            if((status & AsyncStatus.InvokeSentCallback) > 0)
                            {
                                this.__sentAsync();
                            }
                        }
                        break;
                    }
                    catch(ex)
                    {
                        if(ex instanceof LocalExceptionWrapper)
                        {
                            interval = this.handleExceptionWrapper(ex);
                        }
                        else if(ex instanceof Ice.LocalException)
                        {
                            interval = this.handleException(ex, false);
                        }
                        else
                        {
                            throw ex;
                        }
                    }

                    if(interval > 0)
                    {
                        this._instance.retryQueue().add(this, interval);
                        return false;
                    }
                }
            }

            return this._sentSynchronously;
        };

        OutgoingAsync.prototype.__startWriteParams = function(format)
        {
            this._os.startWriteEncaps(this._encoding, format);
            return this._os;
        };

        OutgoingAsync.prototype.__endWriteParams = function()
        {
            this._os.endWriteEncaps();
        };

        OutgoingAsync.prototype.__writeEmptyParams = function()
        {
            this._os.writeEmptyEncaps(this._encoding);
        };

        OutgoingAsync.prototype.__writeParamEncaps = function(encaps)
        {
            if(encaps === null || encaps.length === 0)
            {
                this._os.writeEmptyEncaps(this._encoding);
            }
            else
            {
                this._os.writeEncaps(encaps);
            }
        };

        OutgoingAsync.prototype.__exception = function(ex)
        {
            AsyncResult.prototype.__exception.call(this, ex);

            if(this._batchStarted)
            {
                Debug.assert(this._handler !== null);
                this._handler.abortBatchRequest();
            }
        };

        OutgoingAsync.prototype.handleException = function(exc, sent)
        {
            var interval = { value: 0 };
            try
            {
                //
                // A CloseConnectionException indicates graceful server shutdown, and is therefore
                // always repeatable without violating "at-most-once". That's because by sending a
                // close connection message, the server guarantees that all outstanding requests
                // can safely be repeated.
                //
                // An ObjectNotExistException can always be retried as well without violating
                // "at-most-once" (see the implementation of the checkRetryAfterException method of
                // the ProxyFactory class for the reasons why it can be useful).
                //
                if(!sent || exc instanceof Ice.CloseConnectionException || exc instanceof Ice.ObjectNotExistException)
                {
                    throw exc;
                }

                //
                // Throw the exception wrapped in a LocalExceptionWrapper, to indicate that the
                // request cannot be resent without potentially violating the "at-most-once"
                // principle.
                //
                throw new LocalExceptionWrapper(exc, false);
            }
            catch(ex)
            {
                if(ex instanceof LocalExceptionWrapper)
                {
                    if(this._mode === OperationMode.Nonmutating || this._mode === OperationMode.Idempotent)
                    {
                        this._cnt = this._proxy.__handleExceptionWrapperRelaxed(this._handler, ex, interval, this._cnt);
                    }
                    else
                    {
                        this._proxy.__handleExceptionWrapper(this._handler, ex);
                    }
                }
                else if(ex instanceof Ice.LocalException)
                {
                    this._cnt = this._proxy.__handleException(this._handler, ex, interval, this._cnt);
                }
                else
                {
                    throw ex;
                }
            }
            return interval.value;
        };

        OutgoingAsync.prototype.handleExceptionWrapper = function(ex)
        {
            var interval = { value: 0 };
            if(this._mode === OperationMode.Nonmutating || this._mode === OperationMode.Idempotent)
            {
                this._cnt = this._proxy.__handleExceptionWrapperRelaxed(this._handler, ex, interval, this._cnt);
            }
            else
            {
                this._proxy.__handleExceptionWrapper(this._handler, ex);
            }
            return interval.value;
        };

        OutgoingAsync.prototype.__runTimerTask = function()
        {
            var connection = this._timerConnection;
            this._timerConnection = null;
            this._timerToken = -1;

            if(connection !== null)
            {
                connection.exception(new Ice.TimeoutException());
            }
        };

        Ice.OutgoingAsync = OutgoingAsync;
        global.Ice = Ice;
    };
    return (module === undefined) ? this.Ice.__defineModule(__m, name) : 
                                    __m(global, module, module.exports, module.require);
}(typeof module !== "undefined" ? module : undefined, "Ice/OutgoingAsync"));
