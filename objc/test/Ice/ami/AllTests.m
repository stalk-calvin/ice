// **********************************************************************
//
// Copyright (c) 2003-2010 ZeroC, Inc. All rights reserved.
//
// This copy of Ice Touch is licensed to you under the terms described in the
// ICE_TOUCH_LICENSE file included in this distribution.
//
// **********************************************************************

#import <Ice/Ice.h>
#import <Ice/Locator.h>
#import <TestCommon.h>
#import <AMITest.h>
 
#import <Foundation/Foundation.h>

@interface TestAMICallback : NSObject
{
    BOOL called;
    NSCondition* cond;
}
-(BOOL) check;
-(void) called;
@end

@implementation TestAMICallback
-(id) init
{
    if(![super init])
    {
        return nil;
    }
    cond = [[NSCondition alloc] init];
    return self;
}
-(void) dealloc
{
    [cond release];
    [super dealloc];
}
-(BOOL) check
{
    [cond lock];
    while(!called)
    {
        if(![cond waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:50]])
        {
            return NO;
        }
    }
    called = NO;
    [cond unlock];
    return YES;
}
-(void) called
{
    [cond lock];
    called = YES;
    [cond signal];
    [cond unlock];
}
@end

void
amiAllTests(id<ICECommunicator> communicator)
{
    NSString* ref = @"test:default -p 12010";
    id<ICEObjectPrx> base = [communicator stringToProxy:(ref)];
    id<TestAMITestIntfPrx> p = [TestAMITestIntfPrx checkedCast:base];
    test(p);

    ref = @"testController:tcp -p 12011";
    base = [communicator stringToProxy:ref];
    TestAMITestIntfControllerPrx* testController = [TestAMITestIntfControllerPrx uncheckedCast:base];
    test(testController);

    tprintf("testing begin/end invocation... ");
    {
        ICEContext* ctx = [ICEContext dictionary];
        ICEAsyncResult* result;

        result = [p begin_ice_isA:[TestAMITestIntfPrx ice_staticId]];
        test([p end_ice_isA:result]);
        result = [p begin_ice_isA:[TestAMITestIntfPrx ice_staticId] context:ctx];
        test([p end_ice_isA:result]);

        result = [p begin_ice_ping];
        [p end_ice_ping:result];
        result = [p begin_ice_ping:ctx];
        [p end_ice_ping:result];

        result = [p begin_ice_id];
        test([[p end_ice_id:result] isEqualToString:[TestAMITestIntfPrx ice_staticId]]);
        result = [p begin_ice_id:ctx];
        test([[p end_ice_id:result] isEqualToString:[TestAMITestIntfPrx ice_staticId]]);

        result = [p begin_ice_ids];
        test([[p end_ice_ids:result] count] == 2);
        result = [p begin_ice_ids:ctx];
        test([[p end_ice_ids:result] count] == 2);

        result = [p begin_op];
        [p end_op:result];
        result = [p begin_op:ctx];
        [p end_op:result];

        result = [p begin_opWithResult];
        test([p end_opWithResult:result] == 15);
        result = [p begin_opWithResult:ctx];
        test([p end_opWithResult:result] == 15);

        result = [p begin_opWithUE];
        @try
        {
            [p end_opWithUE:result];
            test(NO);
        }
        @catch(TestAMITestIntfException*)
        {
        }
        result = [p begin_opWithUE:ctx];
        @try
        {
            [p end_opWithUE:result];
            test(NO);
        }
        @catch(TestAMITestIntfException*)
        {
        }
    }
    tprintf("ok\n");

    tprintf("testing response callback... ");
    {
        TestAMICallback* cb = [[TestAMICallback alloc] init];
        ICEContext* ctx = [NSDictionary dictionary];

 	void (^isACB)(BOOL) = ^(BOOL ret) { test(ret); [cb called]; };
        [p begin_ice_isA:[TestAMITestIntfPrx ice_staticId] response:isACB exception:nil];
        [cb check];
        [p begin_ice_isA:[TestAMITestIntfPrx ice_staticId] context:ctx response:isACB exception:nil];
        [cb check];

 	void (^pingCB)() = ^ { [cb called]; };
        [p begin_ice_ping:pingCB exception:nil];
        [cb check];
        [p begin_ice_ping:ctx response:pingCB exception:nil];
        [cb check];

        void (^idCB)(NSString* typeId) = ^(NSString* typeId) 
        { 
            test([typeId isEqualToString:[TestAMITestIntfPrx ice_staticId]]); 
            [cb called]; 
        };

        [p begin_ice_id:idCB exception:nil];
        [cb check];
        [p begin_ice_id:ctx response:idCB exception:nil];
        [cb check];

        void (^idsCB)(NSArray* types) = ^(NSArray* types) 
        { 
            test([types count] == 2); 
            [cb called]; 
        };

        [p begin_ice_ids:idsCB exception:nil];
        [cb check];
        [p begin_ice_ids:ctx response:idsCB exception:nil];
        [cb check];

 	void (^opCB)() = ^ { [cb called]; };
        [p begin_op:opCB exception:nil];
        [cb check];
        [p begin_op:ctx response:opCB exception:nil];
        [cb check];

        void (^opWithResultCB)(ICEInt) = ^(ICEInt r) 
        { 
            test(r == 15); 
            [cb called]; 
        };
        [p begin_opWithResult:opWithResultCB exception:nil];
        [cb check];
        [p begin_opWithResult:ctx response:opWithResultCB exception:nil];
        [cb check];

        void (^opWithUE)() = [[ ^() { test(NO); } copy ] autorelease];
        void (^opWithUEEx)(ICEException*) = ^(ICEException* ex) 
        { 
            @try
            {
                @throw ex;
                test(NO);
            }
            @catch(TestAMITestIntfException*)
            {
                [cb called];
            }
        };
        [p begin_opWithUE:opWithUE exception:opWithUEEx];
        [cb check];
        [p begin_opWithUE:ctx response:opWithUE exception:opWithUEEx];
        [cb check];

        [cb release];
    }
    tprintf("ok\n");

    tprintf("testing local exceptions... ");
    {
        TestAMITestIntfPrx* indirect = [TestAMITestIntfPrx uncheckedCast:[p ice_adapterId:@"dummy"]];
        ICEAsyncResult* r;

        r = [indirect begin_op];
        @try
        {
            [indirect end_op:r];
            test(NO);
        }
        @catch(ICENoEndpointException*)
        {
        }

        @try
        {
            r = [[p ice_oneway] begin_ice_id];
            test(NO);
        }
        @catch(NSException* ex)
        {
            test([ex name] == NSInvalidArgumentException);
        }
        @try
        {
            r = [[p ice_oneway] begin_opWithResult];
            test(NO);
        }
        @catch(NSException* ex)
        {
            test([ex name] == NSInvalidArgumentException);
        }

        //
        // Check that CommunicatorDestroyedException is raised directly.
        //
        ICEInitializationData* initData = [[ICEInitializationData alloc] init];
        [initData setProperties:[[communicator getProperties] clone]];
        id<ICECommunicator> ic = [ICEUtil createCommunicator:initData];
        id<ICEObjectPrx> obj = [ic stringToProxy:[p ice_toString]];
        id<TestAMITestIntfPrx> p2 = [TestAMITestIntfPrx checkedCast:obj];
        [ic destroy];

        @try
        {
            [p2 begin_op];
            test(NO);
        }
        @catch(ICECommunicatorDestroyedException*)
        {
            // Expected.
        }
    }
    tprintf("ok\n");

    tprintf("testing local exceptions with response callback... ");
    {
        id<TestAMITestIntfPrx> i = [TestAMITestIntfPrx uncheckedCast:[p ice_adapterId:@"dummy"]];
        TestAMICallback* cb = [[TestAMICallback alloc] init];
        ICEContext* ctx = [NSDictionary dictionary];

        void (^exCB)(ICEException*) =  ^(ICEException* ex) {
            test([ex isKindOfClass:[ICENoEndpointException class]]);
            [cb called];
        };

        void (^isACB)(BOOL) = [[ ^(BOOL ret) { test(NO); } copy ] autorelease];
        [i begin_ice_isA:@"dummy" response:isACB exception:exCB];
        [cb check];
        [i begin_ice_isA:@"dummy" context:ctx response:isACB exception:exCB];
        [cb check];

	void (^pingCB)() = [[ ^ { test(NO); } copy ] autorelease];
        [i begin_ice_ping:pingCB exception:exCB];
        [cb check];
        [i begin_ice_ping:ctx response:pingCB exception:exCB];
        [cb check];

        void (^idCB)(NSString*) = [[ ^(NSString* ret) { test(NO); } copy ] autorelease];
        [i begin_ice_id:idCB exception:exCB];
        [cb check];
        [i begin_ice_id:ctx response:idCB exception:exCB];
        [cb check];

        void (^idsCB)(NSArray*) = [[ ^(NSArray* ret) { test(NO); } copy ] autorelease];
        [i begin_ice_ids:idsCB exception:exCB];
        [cb check];
        [i begin_ice_ids:ctx response:idsCB exception:exCB];
        [cb check];

	void (^opCB)() = [[ ^ { test(NO); } copy ] autorelease];
        [i begin_op:opCB exception:exCB];
        [cb check];
        [i begin_op:ctx response:opCB exception:exCB];
        [cb check];
        
        [cb release];
    }
    tprintf("ok\n");

    tprintf("testing sent callback... ");
    {
        TestAMICallback* cb = [[TestAMICallback alloc] init];
        ICEContext* ctx = [NSDictionary dictionary];

        void (^sentCB)(BOOL) = ^(BOOL ss) { [cb called]; };

        [p begin_ice_isA:@"test" response:nil exception:nil sent:sentCB];
        [cb check];
        [p begin_ice_isA:@"test" context:ctx response:nil exception:nil sent:sentCB];
        [cb check];

        [p begin_ice_ping:nil exception:nil sent:sentCB];
        [cb check];
        [p begin_ice_ping:ctx response:nil exception:nil sent:sentCB];
        [cb check];

        [p begin_ice_id:nil exception:nil sent:sentCB];
        [cb check];
        [p begin_ice_id:ctx response:nil exception:nil sent:sentCB];
        [cb check];

        [p begin_ice_ids:nil exception:nil sent:sentCB];
        [cb check];
        [p begin_ice_ids:ctx response:nil exception:nil sent:sentCB];
        [cb check];

        [p begin_op:nil exception:nil sent:sentCB];
        [cb check];
        [p begin_op:ctx response:nil exception:nil sent:sentCB];
        [cb check];

        ICEByte d[1024];
        ICEMutableByteSeq* seq = [ICEMutableByteSeq dataWithBytes:d length:sizeof(d)];
        [testController holdAdapter];
        NSMutableArray* cbs = [NSMutableArray array];
        @try
        {
            TestAMICallback* cb = [[TestAMICallback alloc] init];
            while(true)
            {
                if(![[p begin_opWithPayload:seq response:nil exception:nil sent: 
                            ^(BOOL ss) { 
                               [cb called];
                           }] sentSynchronously])
                {
                    [cbs addObject:cb];
                    break;
                }
                [cbs addObject:cb];
                cb = [[TestAMICallback alloc] init];
            }
        }
        @catch(NSException* ex) 
        {
            [testController resumeAdapter];
            @throw ex;
        }
        [testController resumeAdapter];
        for(TestAMICallback* cb in cbs)
        {
            [cb check];
        }
    }
    tprintf("ok\n");

    tprintf("testing illegal arguments... ");
    {
        ICEAsyncResult* result;

        result = [p begin_op];
        [p end_op:result];
        @try
        {
            [p end_op:result];
            test(NO);
        }
        @catch(NSException* ex)
        {
            test([ex name] == NSInvalidArgumentException);
        }

        result = [p begin_op];
        @try
        {
            [p end_opWithResult:result];
            test(NO);
        }
        @catch(NSException* ex)
        {
            test([ex name] == NSInvalidArgumentException);
        }

        @try
        {
            [p end_op:nil];
            test(NO);
        }
        @catch(NSException* ex)
        {
            test([ex name] == NSInvalidArgumentException);
        }
    }
    tprintf("ok\n");

    tprintf("testing unexpected exceptions from callback... ");
    {
        id<TestAMITestIntfPrx> q = [TestAMITestIntfPrx uncheckedCast:[p ice_adapterId:@"dummy"]];
        TestAMICallback* cb = [[TestAMICallback alloc] init];
        void (^thrower)() = ^(int i) {
            [cb called];
            switch(i) {
            case 0:
                @throw [ICEObjectNotExistException objectNotExistException:__FILE__ line:__LINE__];
            case 1:
                @throw [TestAMITestIntfException testIntfException];
            case 2:
                @throw [NSException exceptionWithName:@"" reason:nil userInfo:nil];
            }
        };

        int i;
        for(i = 0; i < 3; ++i)
        {
            void (^throwResponse)() = ^{ thrower(i); };
            void (^throwEx)(ICEException*) = ^(ICEException* ex){ thrower(i); };
            void (^throwSent)(BOOL) = ^(BOOL b){ thrower(i); };

            [p begin_ice_ping:throwResponse exception:nil];
            [cb check];

            [q begin_ice_ping:nil exception:throwEx];
            [cb check];

            [p begin_ice_ping:nil exception:nil sent:throwSent];
            [cb check];

            [p begin_op:throwResponse exception:nil];
            [cb check];

            [q begin_op:nil exception:throwEx];
            [cb check];

            [p begin_op:nil exception:nil sent:throwSent];
            [cb check];
        }

        [cb release];
    }
    tprintf("ok\n");

    tprintf("testing batch requests with proxy... ");
    {
        {
            test([p opBatchCount] == 0);
            id<TestAMITestIntfPrx> b1 = [p ice_batchOneway];
            [b1 opBatch];
            [b1 opBatch];
            TestAMICallback* cb = [[TestAMICallback alloc] init];
            ICEAsyncResult* r = [b1 begin_ice_flushBatchRequests:^(ICEException* ex) { test(NO); }
                                                            sent:^(BOOL sentSynchronously) { [cb called]; }];
            [cb check];
            test([r isSent]);
            test([r isCompleted]);
            test([p waitForBatch:2]);
            [cb release];
        }

        {
            test([p opBatchCount] == 0);
            id<TestAMITestIntfPrx> b1 = [p ice_batchOneway];
            [b1 opBatch];
            [[b1 ice_getConnection] close:false];
            TestAMICallback* cb = [[TestAMICallback alloc] init];
            ICEAsyncResult* r = [b1 begin_ice_flushBatchRequests:^(ICEException* ex) { [cb called]; }
                                                            sent:^(BOOL sentSynchronously) { test(NO); }];
            [cb check];
            test(![r isSent]);
            test([r isCompleted]);
            test([p opBatchCount] == 0);
            [cb release];
        }
    }
    tprintf("ok\n");

    tprintf("testing batch requests with connection... ");
    {
        {
            test([p opBatchCount] == 0);
            id<TestAMITestIntfPrx> b1 = [p ice_batchOneway];
            [b1 opBatch];
            [b1 opBatch];
            TestAMICallback* cb = [[TestAMICallback alloc] init];
            ICEAsyncResult* r = [[b1 ice_getConnection] begin_flushBatchRequests:^(ICEException* ex) { test(NO); }
                                                            sent:^(BOOL sentSynchronously) { [cb called]; }];
            [cb check];
            test([r isSent]);
            test([r isCompleted]);
            test([p waitForBatch:2]);
            [cb release];
        }

        {
            test([p opBatchCount] == 0);
            TestAMITestIntfPrx* b1 = [p ice_batchOneway];
            [b1 opBatch];
            [[b1 ice_getConnection] close:false];
            TestAMICallback* cb = [[TestAMICallback alloc] init];
            ICEAsyncResult* r = [[b1 ice_getConnection] begin_flushBatchRequests:
                                                            ^(ICEException* ex) { [cb called]; }
            sent:^(BOOL sentSynchronously) { test(NO); }];
            [cb check];
            test(![r isSent]);
            test([r isCompleted]);
            test([p opBatchCount] == 0);
            [cb release];
        }
    }
    tprintf("ok\n");

    tprintf("testing batch requests with communicator... ");
    {
        {
            test([p opBatchCount] == 0);
            id<TestAMITestIntfPrx> b1 = [p ice_batchOneway];
            [b1 opBatch];
            [b1 opBatch];
            TestAMICallback* cb = [[TestAMICallback alloc] init];
            ICEAsyncResult* r = [communicator begin_flushBatchRequests:^(ICEException* ex) { test(NO); }
                                                            sent:^(BOOL sentSynchronously) { [cb called]; }];
            [cb check];
            test([r isSent]);
            test([r isCompleted]);
            test([p waitForBatch:2]);
            [cb release];
        }

        {
            test([p opBatchCount] == 0);
            TestAMITestIntfPrx* b1 = [p ice_batchOneway];
            [b1 opBatch];
            [[b1 ice_getConnection] close:false];
            TestAMICallback* cb = [[TestAMICallback alloc] init];
            ICEAsyncResult* r = [communicator begin_flushBatchRequests:^(ICEException* ex) { test(NO); }
                                                                  sent:^(BOOL sentSynchronously) { [cb called]; }];
            [cb check];
            test([r isSent]);
            test([r isCompleted]);
            test([p opBatchCount] == 0);
            [cb release];
        }
    }
    tprintf("ok\n");

    tprintf("testing AsyncResult operations... ");
    {
        [testController holdAdapter];
        ICEAsyncResult* r1;
        ICEAsyncResult* r2;
        @try
        {
            r1 = [p begin_op];
            ICEByte d[1024];
            ICEMutableByteSeq* seq = [ICEMutableByteSeq dataWithBytes:d length:sizeof(d)];
            while([(r2 = [p begin_opWithPayload:seq]) sentSynchronously]);
            
            test(r1 == r1);
            test(r1 != r2);

            test(([r1 sentSynchronously] && [r1 isSent] && ![r1 isCompleted]) ||
                 (![r1 sentSynchronously] && ![r1 isCompleted]));
            
            test(![r2 sentSynchronously] && ![r2 isCompleted]);
        }
        @catch(NSException* ex)
        {
            [testController resumeAdapter];
            @throw ex;
        }
        [testController resumeAdapter];

        [r1 waitForSent];
        test([r1 isSent]);

        [r2 waitForSent];
        test([r2 isSent]);

        [r1 waitForCompleted];
        test([r1 isCompleted]);

        [r2 waitForCompleted];
        test([r2 isCompleted]);

        test([[r1 getOperation] isEqualToString:@"op"]);
        test([[r2 getOperation] isEqualToString:@"opWithPayload"]);
    }
    tprintf("ok\n");

    [p shutdown];
}
