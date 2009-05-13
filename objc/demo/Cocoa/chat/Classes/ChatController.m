// **********************************************************************
//
// Copyright (c) 2003-2009 ZeroC, Inc. All rights reserved.
//
// This copy of Ice Touch is licensed to you under the terms described in the
// ICE_TOUCH_LICENSE file included in this distribution.
//
// **********************************************************************

#import <ChatController.h>
#import <Ice/Ice.h>
#import <ChatSession.h>
#import <Glacier2/Router.h>
#import <AppDelegate.h>

@implementation ChatController

// This is called outside of the main thread.
-(id)initWithCommunicator:(id<ICECommunicator>)c
                  session:(id<ChatChatSessionPrx>)s
           sessionTimeout:(int)t
                   router:(id<ICERouterPrx>)router
                 category:(NSString*)category
{ 
    if(self = [super initWithNibName:@"ChatView" bundle:nil])
    {
        communicator = c;
        session = s;
        sessionTimeout = t;
        
        // Set up the adapter, and register the callback object, and setup the session ping.
        id<ICEObjectAdapter> adapter = [communicator createObjectAdapterWithRouter:@"ChatDemo.Client" router:router];
        [adapter activate];

        ICEIdentity* callbackId = [ICEIdentity identity:[ICEUtil generateUUID] category:category];
        
        // Here we tie the chat view controller to the ChatRoomCallback servant.
        ChatChatRoomCallback* callbackImpl = [ChatChatRoomCallback objectWithDelegate:self];
        
        // This helper ensures that all methods are dispatched in the main thread.
        ICEObject* dispatchMainThread = [ICEMainThreadDispatch mainThreadDispatch:callbackImpl];
        
        id<ICEObjectPrx> proxy = [adapter add:dispatchMainThread identity:callbackId];

        // The callback is registered in awakeFromNib, otherwise the callbacks can arrive
        // prior to the IBOutlet connections being setup.
        callbackProxy = [[ChatChatRoomCallbackPrx uncheckedCast:proxy] retain];

        // Setup the session refresh timer.
        refreshTimer = [NSTimer timerWithTimeInterval:sessionTimeout/2
                                               target:self
                                             selector:@selector(refreshSession)
                                             userInfo:nil
                                              repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:refreshTimer forMode:NSDefaultRunLoopMode];

        users = [NSMutableArray array];

        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterNoStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        
        // Cached attributes for the text view.
        whoTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSColor blueColor],
                             NSForegroundColorAttributeName,
                             nil];
        
        dateTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSColor blackColor],
                              NSForegroundColorAttributeName,
                              nil];
        
        textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSColor lightGrayColor],
                          NSForegroundColorAttributeName,
                          nil];
    }

    return self; 
}

-(void)awakeFromNib
{
    [chatView.textStorage deleteCharactersInRange:NSMakeRange(0, chatView.textStorage.length)];
    
    // Register the chat callback.
    [session setCallback_async:[ICECallbackOnMainThread callbackOnMainThread:self]
                      response:nil
                     exception:@selector(exception:)
                            cb:callbackProxy];
}

#pragma mark Session management

-(void)destroySession
{
    // Cancel the refresh timeer.
    [refreshTimer invalidate];
    refreshTimer = nil;

    // Destroy the old session, and invalidate the refresh timer.
    [session destroy_async:nil response:nil exception:nil];
    session = nil;

    // Clean up the communicator.
    [communicator destroy];
    communicator = nil;
}

-(void)windowWillClose:(NSNotification *)notification
{
    [self destroySession];
    
    // Terminate the application
    NSApplication* app = [NSApplication sharedApplication];
    [app stop:nil];
}

-(void)exception:(ICEException*)ex
{
    NSRunAlertPanel(@"Error", [ex description], @"OK", nil, nil);

    [self destroySession];

    NSApplication* app = [NSApplication sharedApplication];
    AppDelegate* del = (AppDelegate*)app.delegate;
    [del switchController:del.connectController];
}

-(void)refreshSession
{
    [session ice_invoke_async:[ICECallbackOnMainThread callbackOnMainThread:self]
                     response:nil
                    exception:@selector(exception:)
                    operation:@"ice_ping"
                         mode:ICENonmutating
                     inParams:nil];
}

-(void)logout:(id)sender
{
    [self destroySession];
    
    NSApplication* app = [NSApplication sharedApplication];
    AppDelegate* del = (AppDelegate*)app.delegate;
    [del switchController:del.connectController];
}

-(IBAction)sendChat:(id)sender
{
    if(inputField.stringValue.length > 0)
    {
        NSMutableString* s = [inputField.stringValue mutableCopy];
        if(s.length > 1024)
        {
            [s deleteCharactersInRange:NSMakeRange(1024, s.length-1024)];
        }
        NSAssert(s.length <= 1024, @"s.length <= 1024");
        
        [session
         send_async:[ICECallbackOnMainThread callbackOnMainThread:self]
         response:nil
         exception:@selector(exception:)
         message:s];

        inputField.stringValue = @"";
    }
}

#pragma mark Message management

-(void)append:(NSString*)text who:(NSString*)who timestamp:(ICELong)ts
{
    // De-HTMLize the incoming message.
    NSMutableString* s = [text mutableCopy];
    NSString* replace[] =
    {
        @"&quot;",
        @"\"",
        @"&#39;", @"'",
        @"&lt;", @"<",
        @"&gt;", @">",
        @"&amp;", @"&"
    };
    int i;
    for(i = 0; i < sizeof(replace)/sizeof(replace[0]); i += 2)
    {
        [s replaceOccurrencesOfString:replace[i]
                           withString:replace[i+1] options:NSCaseInsensitiveSearch
                                range:NSMakeRange(0, s.length)];
    }
    
    text = s;
    
    // The ChatMessage timestamp is ms since the UNIX epoch.
    NSDate* timestamp = [NSDate dateWithTimeIntervalSinceReferenceDate:(ts/ 1000.f) - NSTimeIntervalSince1970];
    
    [chatView.textStorage appendAttributedString:[[NSAttributedString alloc]
                                                  initWithString:[dateFormatter stringFromDate:timestamp]
                                                  attributes:dateTextAttributes]];
    [chatView.textStorage appendAttributedString:[[NSAttributedString alloc]
                                                  initWithString:@" - "]];
    [chatView.textStorage appendAttributedString:[[NSAttributedString alloc]
                                                  initWithString:who
                                                  attributes:whoTextAttributes]];
    [chatView.textStorage appendAttributedString:[[NSAttributedString alloc]
                                                  initWithString:@" - "]];
    [chatView.textStorage appendAttributedString:[[NSAttributedString alloc]
                                                  initWithString:text
                                                  attributes:textAttributes]];
    [chatView.textStorage appendAttributedString:[[NSAttributedString alloc]
                                                  initWithString:@"\n"]];
    
    // Scroll the chatView to the end.
    [chatView scrollRangeToVisible:NSMakeRange(chatView.string.length, 0)];
}

#pragma mark ChatRoomCallbck

-(void)init:(NSMutableArray *)u current:(ICECurrent*)current;
{
    users = u;
    [userTable reloadData];
}

-(void)send:(ICELong)timestamp name:(NSMutableString *)name message:(NSMutableString *)message current:(ICECurrent*)current;
{
    [self append:message who:name timestamp:timestamp];
}

-(void)join:(ICELong)timestamp name:(NSMutableString*)name current:(ICECurrent*)current;
{
    [users addObject:name];
    [userTable reloadData];
   
    NSString* s = [NSString stringWithFormat:@"%@ joined.", name];
    [self append:s who:@"system message" timestamp:timestamp];
}

-(void)leave:(ICELong)timestamp name:(NSMutableString*)name current:(ICECurrent*)current;
{
    int index = [users indexOfObject:name];
    if(index != NSNotFound)
    {
        [users removeObjectAtIndex:index];
        [userTable reloadData];
    }

    NSString* s = [NSString stringWithFormat:@"%@ left.", name];
    [self append:s who:@"system message" timestamp:timestamp];
}

#pragma mark NSTableView delegate

- (int)numberOfRowsInTableView:(NSTableView *)tv 
{ 
    return users.count;
}

-(id) tableView:(NSTableView *)tv 
objectValueForTableColumn:(NSTableColumn *)tableColumn 
            row:(int)row 
{ 
    return [users objectAtIndex:row];
}

@end
