// **********************************************************************
//
// Copyright (c) 2003-2008 ZeroC, Inc. All rights reserved.
//
// This copy of Ice is licensed to you under the terms described in the
// ICE_LICENSE file included in this distribution.
//
// **********************************************************************

#import <Ice/Ice.h>
#import <Ice/Router.h>
#import <TestCommon.h>
#import <Test.h>

#include <Foundation/NSThread.h>

@interface DummyHelloI : TestHello
@end

@implementation DummyHelloI
-(void) sayHello:(ICECurrent*)current
{
    // Do nothing, this is just a dummy servant.
}
@end

void
allTests(id<ICECommunicator> communicator, NSString* ref)
{
    id<TestServerManagerPrx> manager = [TestServerManagerPrx checkedCast:[communicator stringToProxy:ref]];
    id<TestTestLocatorPrx> locator = [TestTestLocatorPrx uncheckedCast:[communicator getDefaultLocator]];
    test(manager);

    tprintf("testing stringToProxy... ");
    id<ICEObjectPrx> base = [communicator stringToProxy:@"test @ TestAdapter"];
    id<ICEObjectPrx> base2 = [communicator stringToProxy:@"test @ TestAdapter"];
    id<ICEObjectPrx> base3 = [communicator stringToProxy:@"test"];
    id<ICEObjectPrx> base4 = [communicator stringToProxy:@"ServerManager"]; 
    id<ICEObjectPrx> base5 = [communicator stringToProxy:@"test2"];
    id<ICEObjectPrx> base6 = [communicator stringToProxy:@"test @ ReplicatedAdapter"];
    tprintf("ok\n");

    tprintf("testing ice_locator and ice_getLocator... ");
    test([[base ice_getLocator] compareIdentity:[communicator getDefaultLocator]] == NSOrderedSame);
    id<ICELocatorPrx> anotherLocator = [ICELocatorPrx uncheckedCast:[communicator stringToProxy:@"anotherLocator"]];
    base = [base ice_locator:anotherLocator];
    test([[base ice_getLocator] compareIdentity:anotherLocator] == NSOrderedSame);
    [communicator setDefaultLocator:0];
    base = [communicator stringToProxy:@"test @ TestAdapter"];
    test(![base ice_getLocator]);
    base = [base ice_locator:anotherLocator];
    test([[base ice_getLocator] compareIdentity:anotherLocator] == NSOrderedSame);
    [communicator setDefaultLocator:locator];
    base = [communicator stringToProxy:@"test @ TestAdapter"];
    test([[base ice_getLocator] compareIdentity:[communicator getDefaultLocator]] == NSOrderedSame); 
    
    //
    // We also test ice_router/ice_getRouter (perhaps we should add a
    // test/Ice/router test?)
    //
    test(![base ice_getRouter]);
    id<ICERouterPrx> anotherRouter = [ICERouterPrx uncheckedCast:[communicator stringToProxy:@"anotherRouter"]];
    base = [base ice_router:anotherRouter];
    test([[base ice_getRouter] compareIdentity:anotherRouter] == NSOrderedSame);
    id<ICERouterPrx> router = [ICERouterPrx uncheckedCast:[communicator stringToProxy:@"dummyrouter"]];
    [communicator setDefaultRouter:router];
    base = [communicator stringToProxy:@"test @ TestAdapter"];
    test([[base ice_getRouter] compareIdentity:[communicator getDefaultRouter]] == NSOrderedSame);
    [communicator setDefaultRouter:0];
    base = [communicator stringToProxy:@"test @ TestAdapter"];
    test(![base ice_getRouter]);
    tprintf("ok\n");

    tprintf("starting server... ");
    [manager startServer];
    tprintf("ok\n");

    tprintf("testing checked cast... ");
    id<TestTestIntfPrx> obj = [TestTestIntfPrx checkedCast:base];
    obj = [TestTestIntfPrx checkedCast:[communicator stringToProxy:@"test@TestAdapter"]];
    obj = [TestTestIntfPrx checkedCast:[communicator stringToProxy:@"test   @TestAdapter"]];
    obj = [TestTestIntfPrx checkedCast:[communicator stringToProxy:@"test@   TestAdapter"]];
    test(obj);
    id<TestTestIntfPrx> obj2 = [TestTestIntfPrx checkedCast:base2];
    test(obj2);
    id<TestTestIntfPrx> obj3 = [TestTestIntfPrx checkedCast:base3];
    test(obj3);
    id<TestServerManagerPrx> obj4 = [TestServerManagerPrx checkedCast:base4];
    test(obj4);
    id<TestTestIntfPrx> obj5 = [TestTestIntfPrx checkedCast:base5];
    test(obj5);
    id<TestTestIntfPrx> obj6 = [TestTestIntfPrx checkedCast:base6];
    test(obj6);
    tprintf("ok\n");
 
    tprintf("testing id@AdapterId indirect proxy... ");
    [obj shutdown];
    [manager startServer];
    @try
    {
        obj2 = [TestTestIntfPrx checkedCast:base2];
        [obj2 ice_ping];
    }
    @catch(ICELocalException* ex)
    {
        NSLog(@"%@", ex);
        test(NO);
    }
    tprintf("ok\n");    
    
    tprintf("testing id@ReplicaGroupId indirect proxy... ");
    [obj shutdown];
    [manager startServer];
    @try
    {
        obj6 = [TestTestIntfPrx checkedCast:base6];
        [obj6 ice_ping];
    }
    @catch(ICELocalException* ex)
    {
        NSLog(@"%@", ex);
        test(NO);
    }
    tprintf("ok\n");    

    tprintf("testing identity indirect proxy... ");
    [obj shutdown];
    [manager startServer];
    @try
    {
        obj3 = [TestTestIntfPrx checkedCast:base3];
        [obj3 ice_ping];
    }
    @catch(ICELocalException* ex)
    {
        NSLog(@"%@", ex);
        test(NO);
    }
    @try
    {
        obj2 = [TestTestIntfPrx checkedCast:base2];
        [obj2 ice_ping];
    }
    @catch(ICELocalException* ex)
    {
        NSLog(@"%@", ex);
        test(NO);
    }
    [obj shutdown];
    [manager startServer];
    @try
    {
        obj2 = [TestTestIntfPrx checkedCast:base2];
        [obj2 ice_ping];
    }
    @catch(ICELocalException* ex)
    {
        NSLog(@"%@", ex);
        test(NO);
    }
    @try
    {
        obj3 = [TestTestIntfPrx checkedCast:base3];
        [obj3 ice_ping];
    }
    @catch(ICELocalException* ex)
    {
        NSLog(@"%@", ex);
        test(NO);
    }
    [obj shutdown];
    [manager startServer];

    @try
    {
        obj2 = [TestTestIntfPrx checkedCast:base2];
        [obj2 ice_ping];
    }
    @catch(ICELocalException* ex)
    {
        NSLog(@"%@", ex);
        test(NO);
    }
    [obj shutdown];
    [manager startServer];
    @try
    {
        obj3 = [TestTestIntfPrx checkedCast:base3];
        [obj3 ice_ping];
    }
    @catch(ICELocalException* ex)
    {
        NSLog(@"%@", ex);
        test(NO);
    }
    [obj shutdown];
    [manager startServer];
    @try
    {
        obj2 = [TestTestIntfPrx checkedCast:base2];
        [obj2 ice_ping];
    }
    @catch(ICELocalException* ex)
    {
        NSLog(@"%@", ex);
        test(NO);
    }
    [obj shutdown];
    [manager startServer];

    @try
    {
        obj5 = [TestTestIntfPrx checkedCast:base5];
        [obj5 ice_ping];
    }
    @catch(ICELocalException* ex)
    {
        NSLog(@"%@", ex);
        test(NO);
    }
    tprintf("ok\n");

    tprintf("testing proxy with unknown identity... ");
    @try
    {
        base = [communicator stringToProxy:@"unknown/unknown"];
        [base ice_ping];
        test(NO);
    }
    @catch(ICENotRegisteredException* ex)
    {
        test([ex.kindOfObject isEqualToString:@"object"]);
        test([ex.id_ isEqualToString:@"unknown/unknown"]);
    }
    tprintf("ok\n");

    tprintf("testing proxy with unknown adapter... ");
    @try
    {
        base = [communicator stringToProxy:@"test @ TestAdapterUnknown"];
        [base ice_ping];
        test(NO);
    }
    @catch(ICENotRegisteredException* ex)
    {
        test([ex.kindOfObject isEqualToString:@"object adapter"]);
        test([ex.id_ isEqualToString:@"TestAdapterUnknown"]);
    }
    tprintf("ok\n");

    tprintf("testing locator cache timeout... ");

    int count = [locator getRequestCount];
    [[[communicator stringToProxy:@"test@TestAdapter"] ice_locatorCacheTimeout:0] ice_ping]; // No locator cache.
    test(++count == [locator getRequestCount]);
    [[[communicator stringToProxy:@"test@TestAdapter"] ice_locatorCacheTimeout:0] ice_ping]; // No locator cache.
    test(++count == [locator getRequestCount]);
    [[[communicator stringToProxy:@"test@TestAdapter"] ice_locatorCacheTimeout:1] ice_ping]; // 1s timeout.
    test(count == [locator getRequestCount]);
    [NSThread sleepForTimeInterval:1.2];
    [[[communicator stringToProxy:@"test@TestAdapter"] ice_locatorCacheTimeout:1] ice_ping]; // 1s timeout.
    test(++count == [locator getRequestCount]);

    [[[communicator stringToProxy:@"test"] ice_locatorCacheTimeout:0] ice_ping]; // No locator cache.
    count += 2;
    test(count == [locator getRequestCount]);
    [[[communicator stringToProxy:@"test"] ice_locatorCacheTimeout:1] ice_ping]; // 1s timeout
    test(count == [locator getRequestCount]);
    [NSThread sleepForTimeInterval:1.2];
    [[[communicator stringToProxy:@"test"] ice_locatorCacheTimeout:1] ice_ping]; // 1s timeout
    count += 2;
    test(count == [locator getRequestCount]);

    [[[communicator stringToProxy:@"test@TestAdapter"] ice_locatorCacheTimeout:-1] ice_ping]; 
    test(count == [locator getRequestCount]);
    [[[communicator stringToProxy:@"test"] ice_locatorCacheTimeout:-1] ice_ping];
    test(count == [locator getRequestCount]);
    [[communicator stringToProxy:@"test@TestAdapter"] ice_ping]; 
    test(count == [locator getRequestCount]);
    [[communicator stringToProxy:@"test"] ice_ping];
    test(count == [locator getRequestCount]);

    test([[[communicator stringToProxy:@"test"] ice_locatorCacheTimeout:99] ice_getLocatorCacheTimeout] == 99);

    tprintf("ok\n");

    tprintf("testing proxy from server... ");
    id<TestHelloPrx> hello = [obj getHello];
    test([[hello ice_getAdapterId] isEqualToString:@"TestAdapter"]);
    [hello sayHello];
    hello = [obj getReplicatedHello];
    test([[hello ice_getAdapterId] isEqualToString:@"ReplicatedAdapter"]);
    [hello sayHello];
    tprintf("ok\n");

    tprintf("testing proxy from server after shutdown... ");
    [obj shutdown];
    [manager startServer];
    [hello sayHello];
    tprintf("ok\n");

    tprintf("testing object migration... ");
    hello = [TestHelloPrx checkedCast:[communicator stringToProxy:@"hello"]];
    [obj migrateHello];
    [hello sayHello];
    [obj migrateHello];
    [hello sayHello];
    [obj migrateHello];
    [hello sayHello];
    tprintf("ok\n");

    tprintf("shutdown server... ");
    [obj shutdown];
    tprintf("ok\n");

    tprintf("testing whether server is gone... ");
    @try
    {
        [obj2 ice_ping];
        test(NO);
    }
    @catch(ICELocalException*)
    {
    }
    @try
    {
        [obj3 ice_ping];
        test(NO);
    }
    @catch(ICELocalException*)
    {
    }
    @try
    {
        [obj5 ice_ping];
        test(NO);
    }
    @catch(ICELocalException*)
    {
    }
    tprintf("ok\n");

//     tprintf("testing indirect proxies to collocated objects... ");
//     //
//     // Set up test for calling a collocated object through an indirect, adapterless reference.
//     //
//     id<ICEProperties> properties = [communicator getProperties];
//     [properties setProperty:@"Ice.PrintAdapterReady" value:@"0"];
//     id<ICEObjectAdapter> adapter = [communicator createObjectAdapterWithEndpoints:@"Hello" endpoints:@"default"];
//     [adapter setLocator:locator];

//     id<TestTestLocatorRegistryPrx> registry = [TestTestLocatorRegistryPrx checkedCast:[locator getRegistry]];
//     test(registry);
    
//     ICEIdentity* ident = [ICEIdentity identity:[ICEUtil generateUUID] category:@""];
//     [registry addObject:[adapter add:[[DummyHelloI alloc] init] identity:ident]];
//     [adapter activate];
    
//     @try
//     {
//         id<TestHelloPrx> helloPrx = [TestHelloPrx checkedCast:[communicator stringToProxy:
//                                                                                 [communicator identityToString:ident]]];
//         [helloPrx ice_getConnection];
//         test(NO);
//     }
//     @catch(ICECollocationOptimizationException*)
//     {
//     }
//     [adapter deactivate];
//     tprintf("ok\n");

    tprintf("shutdown server manager... ");
    [manager shutdown];
    tprintf("ok\n");
}
