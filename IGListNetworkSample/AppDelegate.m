//
//  AppDelegate.m
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 12/24/16.
//  Copyright © 2016 Siarhei Yakushevich. All rights reserved.
//

#import "AppDelegate.h"
#import "Coordinator.h"
#import "NSMenuItem+Extensions.h"
#import "NSMenu+Extensions.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    NSApplication *sApp = [NSApplication sharedApplication];
    
    InitialWindowsController *iVC = (InitialWindowsController *) ((sApp.mainWindow ?: sApp.windows.firstObject).windowController);
    
    [Coordinator defineRootController:iVC];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)mockShowStatusBar:(id)sender {
    //
}

@end
