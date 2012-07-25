//
//  Helpers+Private.m
//  Cassandra-PrefsPane
//
//  Created by Rémy SAISSY on 22/07/12.
//  Copyright (c) 2012 Octo Technology. All rights reserved.
//

#import "Helpers+Private.h"

#include <sys/sysctl.h>
#include <assert.h>
#include <errno.h>
#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h>
#include <signal.h>

#pragma mark - Static methods.

@implementation Helpers (Private)

+ (BOOL)_isProcessRunning
{    
    BOOL    isRunning = NO;
    NSTask *task = [[[NSTask alloc] init] autorelease];
    [task setLaunchPath:[Helpers _findBinaryNamed:@"jps"]];
    [task setArguments:[NSArray array]];
    NSPipe *outputPipe = [NSPipe pipe];
    [task setStandardOutput:outputPipe];
    [task launch];
    [task waitUntilExit];
    if (!task.terminationStatus) {
        NSData *data = [[outputPipe fileHandleForReading] readDataToEndOfFile];
        NSString *output = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
        NSArray *processes = [output componentsSeparatedByString:@"\n"];
        for (NSString *process in processes) {
            NSRange range = [process rangeOfString:@"CassandraDaemon"];
            if (range.length) {
                isRunning = YES;
                break;
            }
        }
    }
    return isRunning;
}

+ (NSString *)_launchDaemonPath
{
    return [@"~/Library/LaunchAgents/com.remysaissy.cassandraprefspane.plist" stringByExpandingTildeInPath];    
}

+ (NSArray *)_processArgumentsForProcessPath:(NSString *)processPath forLaunchctl:(BOOL)useLaunchctl
{    
    NSArray *arguments = nil;
    if (useLaunchctl == YES)
        arguments = [NSArray arrayWithObjects:@"-f", nil];
    else
        arguments = [NSArray array];
    return arguments;
}

+ (NSString *)_findBinaryNamed:(NSString *)processName
{
    NSString *binaryFullPath = nil;
    NSString *path = [[[[[NSProcessInfo processInfo] environment] objectForKey:@"PATH"] retain] autorelease];
    NSArray *searchPath = [path componentsSeparatedByString:@":"];
    for (NSString *filePath in searchPath) {
        binaryFullPath = [filePath stringByAppendingPathComponent:processName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:binaryFullPath] == YES)
            break;
    }    
    return binaryFullPath;    
}

+ (NSArray *)_pidListForProcesses
{
    NSMutableArray *pidList = [NSMutableArray array];
    NSTask *task = [[[NSTask alloc] init] autorelease];
    [task setLaunchPath:[Helpers _findBinaryNamed:@"jps"]];
    [task setArguments:[NSArray array]];
    NSPipe *outputPipe = [NSPipe pipe];
    [task setStandardOutput:outputPipe];
    [task launch];
    [task waitUntilExit];
    if (!task.terminationStatus) {
        NSData *data = [[outputPipe fileHandleForReading] readDataToEndOfFile];
        NSString *output = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
        NSArray *processes = [output componentsSeparatedByString:@"\n"];
        for (NSString *process in processes) {
            NSRange range = [process rangeOfString:@"CassandraDaemon"];
            if (range.length) {
                NSInteger pid;
                NSScanner *scanner = [NSScanner scannerWithString:process];
                [scanner scanInteger:&pid];
                [pidList addObject:[NSNumber numberWithInteger:pid]];
            }
        }
    }
    return pidList;
}

@end
