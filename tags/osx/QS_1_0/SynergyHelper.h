//
//  SynergyHelper.h
//  QuickSynergy
//
//  Created by Otavio Cordeiro on 9/6/08.
//  Copyright 2008 Otávio Cordeiro. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define SH_SERVER 0x0001
#define SH_CLIENT 0x0002

@interface SynergyHelper : NSObject
{
    NSTask *synergy2;
}

- (BOOL)isSynergyRunning;
- (BOOL)startStop:(int)kind;
- (BOOL)startStop:(int)kind andConnectToServer:(NSString *)serverName;

@end
