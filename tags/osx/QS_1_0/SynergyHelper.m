//
//  SynergyHelper.m
//  QuickSynergy
//
//  Created by Otavio Cordeiro on 9/6/08.

//  Copyright 2008 Otávio Cordeiro. All rights reserved.
//

#import "SynergyHelper.h"

@implementation SynergyHelper

- (id) init
{    
    return self;
}

- (BOOL)isSynergyRunning
{
    return [synergy2 isRunning];
}

- (void)start:(int)kind andConnectToServer:(NSString *)serverName
{
    NSArray *args;
    NSString *binaryPath;
    NSBundle *quickSynergyBundle = [NSBundle mainBundle];
    NSString *configFile = [NSString stringWithFormat:@"%@/.QuickSynergy.config",
                            NSHomeDirectory()];
    
    switch (kind) {
        case SH_SERVER:
            binaryPath = [quickSynergyBundle pathForAuxiliaryExecutable:@"Contents/Resources/synergys"];
            synergy2 = [[NSTask alloc] init];
            [synergy2 setLaunchPath:binaryPath];
            args = [NSArray arrayWithObjects:@"-f", @"-c", configFile, nil];
            [synergy2 setArguments:args];
            [synergy2 launch];
            break;
        case SH_CLIENT:
            binaryPath = [quickSynergyBundle pathForAuxiliaryExecutable:@"Contents/Resources/synergyc"];
            synergy2 = [[NSTask alloc] init];
            [synergy2  setLaunchPath:binaryPath];
            args = [NSArray arrayWithObjects:@"-f", serverName, nil];
            [synergy2 setArguments:args];
            [synergy2 launch];
            break;
        default:
            break;
    }
}

- (void)stop
{
    [synergy2 interrupt];
    [synergy2 release];
    synergy2 = nil;
}

- (BOOL)startStop:(int)kind andConnectToServer:(NSString *)serverName
{
    
    if ([self isSynergyRunning]) {
        [self stop];
    }
    else {
        [self start:kind andConnectToServer:serverName];
    }
    
    return [self isSynergyRunning];
}

- (BOOL)startStop:(int)kind
{
    [self startStop:kind andConnectToServer:(nil)];
    
    return [self isSynergyRunning];
}

-(void)dealloc
{
    [super dealloc];
}

@end
