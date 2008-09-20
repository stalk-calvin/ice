// **********************************************************************
//
// Copyright (c) 2003-2008 ZeroC, Inc. All rights reserved.
//
// This copy of Ice is licensed to you under the terms described in the
// ICE_LICENSE file included in this distribution.
//
// **********************************************************************

#import <Ice/Ice.h>
#import <TestCommon.h>
#import <Test.h>
#import <MyObjectI.h>
#import <InterceptorI.h>

#import <Foundation/NSAutoreleasePool.h>

int
run(int argc, char* argv[], id<ICECommunicator> communicator)
{
    //
    // Create OA and servants  
    //  
    id<ICEObjectAdapter> oa = [communicator createObjectAdapterWithEndpoints:@"MyOA" endpoints:@"tcp -h localhost"];
    
    id<ICEObject> servant = [[MyObjectI alloc] init];
    InterceptorI* interceptor = [[InterceptorI alloc] init:servant];
    [interceptor autorelease];
    
    id<TestMyObjectPrx> prx = [TestMyObjectPrx uncheckedCast:[oa addWithUUID:interceptor]];
    
    [oa activate];
       
    tprintf("testing simple interceptor... ");
    test([[interceptor getLastOperation] length] == 0);
    [prx ice_ping];
    test([[interceptor getLastOperation] isEqualToString:@"ice_ping"]);
    test([interceptor getLastStatus]);
    NSString* typeId = [prx ice_id];
    test([[interceptor getLastOperation] isEqualToString:@"ice_id"]);
    test([interceptor getLastStatus]);
    test([prx ice_isA:typeId]);
    test([[interceptor getLastOperation] isEqualToString:@"ice_isA"]);
    test([interceptor getLastStatus]);
    test([prx add:33 y:12] == 45);
    test([[interceptor getLastOperation] isEqualToString:@"add"]);
    test([interceptor getLastStatus]);
    tprintf("ok\n");

    /*
    tprintf("testing retry... ");
    test([prx addWithRetry:33 y:12] == 45);
    test([[interceptor getLastOperation] isEqualToString:@"addWithRetry"]);
    test([interceptor getLastStatus]);
    tprintf("ok\n");
    */

    tprintf("testing user exception... ");
    @try
    {
        [prx badAdd:33 y:12];
        test(NO);
    }
    @catch(TestInvalidInputException*)
    {
        // expected
    }
    test([[interceptor getLastOperation] isEqualToString:@"badAdd"]);
    test([interceptor getLastStatus] == NO);
    tprintf("ok\n");
    tprintf("testing ONE... ");
    
    [interceptor clear];
    @try
    {
        [prx notExistAdd:33 y:12];
        test(NO);
    }
    @catch(ICEObjectNotExistException*)
    {
        // expected
    }
    test([[interceptor getLastOperation] isEqualToString:@"notExistAdd"]);
    tprintf("ok\n");
    tprintf("testing system exception... ");
    [interceptor clear];
    @try
    {
        [prx badSystemAdd:33 y:12];
        test(NO);
    }
    @catch(ICEUnknownLocalException*)
    {
    }
    @catch(NSException*)
    {
        test(NO);
    }
    test([[interceptor getLastOperation] isEqualToString:@"badSystemAdd"]);
    tprintf("ok\n");
    
    return 0;
}


int
main(int argc, char* argv[])
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int status;
    id<ICECommunicator> communicator;

    @try
    {
        communicator = [ICEUtil createCommunicator:&argc argv:argv];
        status = run(argc, argv, communicator);
    }
    @catch(ICEException* ex)
    {
        NSLog(@"%@", ex);
        status = EXIT_FAILURE;
    }

    if(communicator)
    {
        @try
        {
            [communicator destroy];
        }
        @catch(ICEException* ex)
        {
            NSLog(@"%@", ex);
            status = EXIT_FAILURE;
        }
    }
    
    [pool release];
    return status;
}

