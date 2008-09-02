// **********************************************************************
//
// Copyright (c) 2003-2008 ZeroC, Inc. All rights reserved.
//
// This copy of Ice is licensed to you under the terms described in the
// ICE_LICENSE file included in this distribution.
//
// **********************************************************************

#import <Ice/ObjectAdapterI.h>
#import <Ice/CommunicatorI.h>
#import <Ice/ProxyI.h>
#import <Ice/IdentityI.h>
#import <Ice/ObjectI.h>
#import <Ice/Util.h>

#include <IceCpp/Locator.h>

#define OBJECTADAPTER dynamic_cast<Ice::ObjectAdapter*>(static_cast<IceUtil::Shared*>(cxxObject_))

@implementation ICEObjectAdapter
-(id) initWithCxxObject:(IceUtil::Shared*)cxxObject
{
    if(![super initWithCxxObject:cxxObject])
    {
        return nil;
    }

    try
    {
        communicator_ = [ICECommunicator wrapperWithCxxObjectNoAutoRelease:OBJECTADAPTER->getCommunicator().get()];
    }
    catch(const std::exception&)
    {
        // Ignore
    }
    return self;
}
-(void) dealloc
{
    [communicator_ release];
    [super dealloc];
}
//
// @protocol ICEObjectAdapter methods.
//

-(id<ICECommunicator>) getCommunicator
{
    try
    {
        return [ICECommunicator wrapperWithCxxObject:OBJECTADAPTER->getCommunicator().get()];
    }
    catch(const std::exception& ex)
    {
        rethrowObjCException(ex);
        return nil; // Keep the compiler happy.
    }
}

-(NSString*) getName
{
    try
    {
        return [toNSString(OBJECTADAPTER->getName()) autorelease];
    }
    catch(const std::exception& ex)
    {
        rethrowObjCException(ex);
        return nil; // Keep the compiler happy.
    }
}

-(void) activate
{
    try
    {
        OBJECTADAPTER->activate();
    }
    catch(const std::exception& ex)
    {
        rethrowObjCException(ex);
    }
}

-(void) hold
{
    try
    {
        OBJECTADAPTER->hold();
    }
    catch(const std::exception& ex)
    {
        rethrowObjCException(ex);
    }
}

-(void) waitForHold
{
    try
    {
        OBJECTADAPTER->waitForHold();
    }
    catch(const std::exception& ex)
    {
        rethrowObjCException(ex);
    }
}

-(void) deactivate
{
    try
    {
        OBJECTADAPTER->deactivate();
    }
    catch(const std::exception& ex)
    {
        rethrowObjCException(ex);
    }
}

-(void) waitForDeactivate
{
    try
    {
        OBJECTADAPTER->waitForDeactivate();
    }
    catch(const std::exception& ex)
    {
        rethrowObjCException(ex);
    }
}

-(BOOL) isDeactivated
{
    try
    {
        return OBJECTADAPTER->isDeactivated();
    }
    catch(const std::exception& ex)
    {
        rethrowObjCException(ex);
        return nil; // Keep the compiler happy.
    }
}

-(void) destroy
{
    try
    {
        OBJECTADAPTER->destroy();
    }
    catch(const std::exception& ex)
    {
        rethrowObjCException(ex);
    }
    [communicator_ removeObjectAdapter:self];
}

-(id<ICEObjectPrx>) add:(ICEObject*)servant identity:(ICEIdentity*)ident
{
    try
    {
        [servant retain];
        return [ICEObjectPrx objectPrxWithObjectPrx__:OBJECTADAPTER->add([servant object__], [ident identity])];
    }
    catch(const std::exception& ex)
    {
        rethrowObjCException(ex);
        return nil; // Keep the compiler happy.
    }
}

-(id<ICEObjectPrx>) addFacet:(ICEObject*)servant identity:(ICEIdentity*)ident facet:(NSString*)facet
{
    try
    {
        [servant retain];
        return [ICEObjectPrx objectPrxWithObjectPrx__:OBJECTADAPTER->addFacet([servant object__], [ident identity],
                                                                              fromNSString(facet))];
    }
    catch(const std::exception& ex)
    {
        rethrowObjCException(ex);
        return nil; // Keep the compiler happy.
    }
}

-(id<ICEObjectPrx>) addWithUUID:(ICEObject*)servant
{
    try
    {
        [servant retain];
        return [ICEObjectPrx objectPrxWithObjectPrx__:OBJECTADAPTER->addWithUUID([servant object__])];
    }
    catch(const std::exception& ex)
    {
        rethrowObjCException(ex);
        return nil; // Keep the compiler happy.
    }
}

-(id<ICEObjectPrx>) addFacetWithUUID:(ICEObject*)servant facet:(NSString*)facet
{
    try
    {
        [servant retain];
        return [ICEObjectPrx objectPrxWithObjectPrx__:OBJECTADAPTER->addFacetWithUUID([servant object__],
                                                                                      fromNSString(facet))];
    }
    catch(const std::exception& ex)
    {
        rethrowObjCException(ex);
        return nil; // Keep the compiler happy.
    }
}

-(ICEObject*) remove:(ICEIdentity*)ident
{
    try
    {
        Ice::ObjectPtr wrapper = OBJECTADAPTER->remove([ident identity]);
        ICEObject* servant = IceObjC::ObjectWrapperPtr::dynamicCast(wrapper)->getObject();
        return [servant autorelease];
    }
    catch(const std::exception& ex)
    {
        rethrowObjCException(ex);
        return nil; // Keep the compiler happy.
    }
}
-(ICEObject*) removeFacet:(ICEIdentity*)ident facet:(NSString*)facet
{
    try
    {
        Ice::ObjectPtr wrapper = OBJECTADAPTER->removeFacet([ident identity], fromNSString(facet));
        ICEObject* servant = IceObjC::ObjectWrapperPtr::dynamicCast(wrapper)->getObject();
        return [servant autorelease];
    }
    catch(const std::exception& ex)
    {
        rethrowObjCException(ex);
        return nil; // Keep the compiler happy.
    }
}

-(NSDictionary*) removeAllFacets:(ICEIdentity*)ident
{
    try
    {
        Ice::FacetMap wrappers = OBJECTADAPTER->removeAllFacets([ident identity]);
        NSMutableDictionary* servants = [[NSMutableDictionary alloc] initWithCapacity:wrappers.size()];
        for(Ice::FacetMap::const_iterator p = wrappers.begin(); p != wrappers.end(); ++p)
        {
            NSObject* key = toObjC(p->first);
            NSObject* value = IceObjC::ObjectWrapperPtr::dynamicCast(p->second)->getObject();
            [servants setObject:value forKey:key];
            [key release];
            [value release];
        }
        return [servants autorelease];
    }
    catch(const std::exception& ex)
    {
        rethrowObjCException(ex);
        return nil; // Keep the compiler happy.
    }
}

-(ICEObject*) find:(ICEIdentity*)ident
{
    try
    {
        return IceObjC::ObjectWrapperPtr::dynamicCast(OBJECTADAPTER->find([ident identity]))->getObject();
    }
    catch(const std::exception& ex)
    {
        rethrowObjCException(ex);
        return nil; // Keep the compiler happy.
    }
}

-(ICEObject*) findFacet:(ICEIdentity*)ident facet:(NSString*)facet
{
    try
    {
        Ice::ObjectPtr wrapper = OBJECTADAPTER->findFacet([ident identity], fromNSString(facet));
        return IceObjC::ObjectWrapperPtr::dynamicCast(wrapper)->getObject();
    }
    catch(const std::exception& ex)
    {
        rethrowObjCException(ex);
        return nil; // Keep the compiler happy.
    }
}

-(NSDictionary*) findAllFacets:(ICEIdentity*)ident
{
    try
    {
        Ice::FacetMap wrappers = OBJECTADAPTER->findAllFacets([ident identity]);
        NSMutableDictionary* servants = [[NSMutableDictionary alloc] initWithCapacity:wrappers.size()];
        for(Ice::FacetMap::const_iterator p = wrappers.begin(); p != wrappers.end(); ++p)
        {
            [servants setObject:IceObjC::ObjectWrapperPtr::dynamicCast(p->second)->getObject() forKey:toObjC(p->first)];
        }
        return servants;
    }
    catch(const std::exception& ex)
    {
        rethrowObjCException(ex);
        return nil; // Keep the compiler happy.
    }
}

-(ICEObject*) findByProxy:(id<ICEObjectPrx>)proxy
{
    try
    {
        Ice::ObjectPrx prx = [(ICEObjectPrx*)proxy objectPrx__];
        return IceObjC::ObjectWrapperPtr::dynamicCast(OBJECTADAPTER->findByProxy(prx))->getObject();
    }
    catch(const std::exception& ex)
    {
        rethrowObjCException(ex);
        return nil; // Keep the compiler happy.
    }
}

-(id<ICEObjectPrx>) createProxy:(ICEIdentity*)ident
{
    try
    {
        return [ICEObjectPrx objectPrxWithObjectPrx__:OBJECTADAPTER->createProxy([ident identity])];
    }
    catch(const std::exception& ex)
    {
        rethrowObjCException(ex);
        return nil; // Keep the compiler happy.
    }
}

-(id<ICEObjectPrx>) createDirectProxy:(ICEIdentity*)ident
{
    try
    {
        return [ICEObjectPrx objectPrxWithObjectPrx__:OBJECTADAPTER->createDirectProxy([ident identity])];
    }
    catch(const std::exception& ex)
    {
        rethrowObjCException(ex);
        return nil; // Keep the compiler happy.
    }
}

-(id<ICEObjectPrx>) createIndirectProxy:(ICEIdentity*)ident
{
    try
    {
        return [ICEObjectPrx objectPrxWithObjectPrx__:OBJECTADAPTER->createIndirectProxy([ident identity])];
    }
    catch(const std::exception& ex)
    {
        rethrowObjCException(ex);
        return nil; // Keep the compiler happy.
    }
}

-(void) setLocator:(id<ICELocatorPrx>)loc
{
    try
    {
        OBJECTADAPTER->setLocator(Ice::LocatorPrx::uncheckedCast(Ice::ObjectPrx([(ICEObjectPrx*)loc objectPrx__])));
    }
    catch(const std::exception& ex)
    {
        rethrowObjCException(ex);
    }
}

-(void) refreshPublishedEndpoints
{
    try
    {
        OBJECTADAPTER->refreshPublishedEndpoints();
    }
    catch(const std::exception& ex)
    {
        rethrowObjCException(ex);
    }
}

@end
