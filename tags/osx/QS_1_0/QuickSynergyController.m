//
//  QuickSynergyController.m
//  QuickSynergy
//
//  Created by Otavio Cordeiro on 9/6/08.
//  Copyright 2008 Otávio Cordeiro. All rights reserved.
//

#import "QuickSynergyController.h"

@implementation QuickSynergyController

- (id) init
{
    if ((self = [super init])) {
        [GrowlApplicationBridge setGrowlDelegate: self];
        synergy = [[SynergyHelper alloc] init];
    }
    
    return self;
}

- (NSDictionary *) registrationDictionaryForGrowl
{
    NSArray * notifications = [NSArray arrayWithObjects: GROWL_QS_STARTED,
                               GROWL_QS_STOPPED, nil];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            notifications, GROWL_NOTIFICATIONS_ALL,
            notifications, GROWL_NOTIFICATIONS_DEFAULT,
            nil];
}

- (void)enableDisable:(BOOL)flag
{
    [clientAbove setEnabled:flag];
    [clientBelow setEnabled:flag];
    [clientLeft setEnabled:flag];
    [clientRight setEnabled:flag];
    [serverAddr setEnabled:flag];
}

- (BOOL)createConfigFile
{
    NSError *error;
    NSMutableString *line;
    NSString *localhost = [[NSHost currentHost] name];
    NSString *up = [clientAbove stringValue];
    NSString *down = [clientBelow stringValue];
    NSString *left = [clientLeft stringValue];
    NSString *right = [clientRight stringValue];
    NSString *configFile = [NSString stringWithFormat:@"%@/.QuickSynergy.config",
                            NSHomeDirectory()];
    
    line = [[NSMutableString alloc] init];
    
    // Options
    [line appendString:@"section: options\n"];
    [line appendString:@"end\n\n"];
    
    // Screens
    [line appendString:@"section: screens\n"];
    [line appendFormat:@"\t%@:\n", localhost];
    if ([up compare:@""])
        [line appendFormat:@"\t%@:\n", up];
    if ([down compare:@""])
        [line appendFormat:@"\t%@:\n", down];
    if ([left compare:@""])
        [line appendFormat:@"\t%@:\n", left];
    if ([right compare:@""])
        [line appendFormat:@"\t%@:\n", right];
    [line appendString:@"end\n\n"];
    
    // Links
    [line appendString:@"section: links\n"];
    [line appendFormat:@"\t%@:\n", localhost];
    if ([up compare:@""])
        [line appendFormat:@"\t\tup\t= %@\n", up];
    if ([down compare:@""])
        [line appendFormat:@"\t\tdown\t= %@\n", down];
    if ([left compare:@""])
        [line appendFormat:@"\t\tleft\t= %@\n", left];
    if ([right compare:@""])
        [line appendFormat:@"\t\tright\t= %@\n", right];
    if ([up compare:@""]) {
        [line appendFormat:@"\t%@:\n", up];
        [line appendFormat:@"\t\tdown\t= %@\n", localhost];
    }
    if ([down compare:@""]) {
        [line appendFormat:@"\t%@:\n", down];
        [line appendFormat:@"\t\tup\t= %@\n", localhost];
    }
    if ([left compare:@""]) {
        [line appendFormat:@"\t%@:\n", left];
        [line appendFormat:@"\t\tright\t= %@\n", localhost];
    }
    if ([right compare:@""]) {
        [line appendFormat:@"\t%@:\n", right];
        [line appendFormat:@"\t\tleft\t= %@\n", localhost];
    }
    [line appendString:@"end\n"];
    
    [line writeToFile:configFile
           atomically:YES
             encoding:NSISOLatin1StringEncoding
                error:&error];
    
    [line release];
    
    return YES;
}

- (void)startServer
{
    [self createConfigFile];
    
    if ([synergy startStop:SH_SERVER andConnectToServer:[serverAddr stringValue]]) {
        [GrowlApplicationBridge notifyWithTitle: GROWL_QS_STARTED
                                    description: @"Synergy is running as Server."
                               notificationName: GROWL_QS_STARTED
                                       iconData: nil
                                       priority: 0
                                       isSticky: NO
                                   clickContext: nil];
        [self enableDisable:NO];
    }
}

- (void)startClient
{
    if ([synergy startStop:SH_CLIENT andConnectToServer:[serverAddr stringValue]]) {
        [GrowlApplicationBridge notifyWithTitle: GROWL_QS_STARTED
                                    description: @"Synergy is running as Client."
                               notificationName: GROWL_QS_STARTED
                                       iconData: nil
                                       priority: 0
                                       isSticky: NO
                                   clickContext: nil];
        [self enableDisable:NO];
    }
}

- (IBAction)startStop:(id)sender
{
    if ([synergy isSynergyRunning]) {
        if (![synergy startStop:(int)nil andConnectToServer:nil]) {
            [GrowlApplicationBridge notifyWithTitle: GROWL_QS_STOPPED
                                        description: @"Synergy was stopped!"
                                   notificationName: GROWL_QS_STOPPED
                                           iconData: nil
                                           priority: 0
                                           isSticky: NO
                                       clickContext: nil];
            [self enableDisable:YES];
            [startStopButton setTitle:@"Run"];
        }
        else {
            NSLog(@"There was an error while stopping synergy process");
        }
    }
    else {
        if (NSOrderedSame == [[[tabview selectedTabViewItem] label] compare:TAB_SHARE]) {
            [self startServer];
        }
        else if (NSOrderedSame == [[[tabview selectedTabViewItem] label] compare:TAB_USE]) {
            [self startClient];
        }
        
        if ([synergy isSynergyRunning]) {
            [startStopButton setTitle:@"Stop"];
        }
        else {
            [GrowlApplicationBridge notifyWithTitle: GROWL_QS_ERROR
                                        description: @"There was an error while starting Synergy!"
                                   notificationName: GROWL_QS_ERROR
                                           iconData: nil
                                           priority: 0
                                           isSticky: NO
                                       clickContext: nil];
        }
            
    }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    [synergy startStop:(int)nil andConnectToServer:nil];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
    return YES;
}

- (void)dealloc
{
    [synergy release];
    
    [super dealloc];
}

@end
