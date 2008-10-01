// **********************************************************************
//
// Copyright (c) 2003-2008 ZeroC, Inc. All rights reserved.
//
// This copy of Ice is licensed to you under the terms described in the
// ICETOUCH_LICENSE file included in this distribution.
//
// **********************************************************************

#import <UIKit/UIKit.h>

@class TestViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate>
{
@private
    UIWindow *window;
    IBOutlet UINavigationController *navigationController;
    NSArray* tests;
    int currentTest;
    BOOL autoLaunch;
    BOOL ssl;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController* navigationController;
@property (nonatomic, readonly) NSArray* tests;
@property (nonatomic) int currentTest;
@property (nonatomic) BOOL autoLaunch;
@property (nonatomic) BOOL ssl;

-(void)testCompleted:(BOOL)success;
-(void)setAutoLaunch;

@end

