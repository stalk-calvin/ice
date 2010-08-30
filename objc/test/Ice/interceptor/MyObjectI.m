// **********************************************************************
//
// Copyright (c) 2003-2010 ZeroC, Inc. All rights reserved.
//
// This copy of Ice Touch is licensed to you under the terms described in the
// ICE_TOUCH_LICENSE file included in this distribution.
//
// **********************************************************************

#import <Ice/Ice.h>
#import <interceptor/MyObjectI.h>
#import <TestCommon.h>

@implementation TestInterceptorMyObjectI
-(int) add:(int)x y:(int)y current:(ICECurrent*)current
{
    return x + y;
}
 
-(int) addWithRetry:(int)x y:(int)y current:(ICECurrent*)current
{
    id val = [current.ctx objectForKey:@"retry"];
                                               
    if(val == nil || ![(NSString*)val isEqualToString:@"no"])
    {
        @throw [TestInterceptorRetryException retryException:__FILE__ line:__LINE__];
    }
    return x + y;
}

-(int) badAdd:(int)x y:(int)y current:(ICECurrent*)current
{
    @throw [TestInterceptorInvalidInputException invalidInputException];
}

-(int) notExistAdd:(int)x y:(int)y current:(ICECurrent*)current
{
    @throw [ICEObjectNotExistException objectNotExistException:__FILE__ line:__LINE__];
}
 
-(int) badSystemAdd:(int)x y:(int)y current:(ICECurrent*)current
{
    @throw [ICEInitializationException initializationException:__FILE__ line:__LINE__ reason_:@"testing"];
}

@end
