//
//  QuickSynergyController.h
//  QuickSynergy
//
//  Created by Otavio Cordeiro on 9/6/08.
//  Copyright 2009 Otávio Cordeiro. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Growl/Growl.h>
#import "SynergyHelper.h"

#define GROWL_QS_STARTED @"Started"
#define GROWL_QS_STOPPED @"Stopped"
#define GROWL_QS_ERROR   @"Error"

#define TAB_SHARE @"Share"
#define TAB_USE   @"Use"

@interface QuickSynergyController : NSObject <GrowlApplicationBridgeDelegate>
{
    SynergyHelper *synergy;
    
    IBOutlet NSTextField *clientAbove;
    IBOutlet NSTextField *clientBelow;
    IBOutlet NSTextField *clientLeft;
    IBOutlet NSTextField *clientRight;
    IBOutlet NSTextField *serverAddr;
    IBOutlet NSButton *startStopButton;
    IBOutlet NSTabView *tabview;
    IBOutlet NSMenuItem *startStopMenuItem;
}

- (IBAction)startStop:(id)sender;
- (IBAction)gotoDeveloperTwitter:(id)sender;
- (IBAction)gotoHDMPodcast:(id)sender;
@end
