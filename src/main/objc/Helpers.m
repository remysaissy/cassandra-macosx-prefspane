//
//  Helpers.m
//  Cassandra-PrefsPane
//
//  Created by Rémy SAISSY on 21/07/12.
//  Copyleft LGPL 2013.
//

#import "Helpers.h"
#import "Helpers+Private.h"
#import "Helpers+Process.h"
#import "Helpers+Launchd.h"

#pragma mark - Public implementation.

@implementation Helpers

#pragma mark - Manual start/stop process methods.

+ (BOOL)startProcess
{
    if ([Helpers isLaunchdInstalled] == YES)
        return [Helpers _startProcessWithLaunchd];
    else
        return [Helpers _startProcess];
}

+ (BOOL)stopProcess
{
    if ([Helpers isLaunchdInstalled] == YES)
        return [Helpers _stopProcessWithLaunchd];
    else
        return [Helpers _stopProcess];
}

+ (BOOL)isProcessRunning
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

#pragma mark - Launch agent methods.

+ (BOOL)isLaunchdInstalled
{
    NSString *launchDaemonPath = [Helpers _launchDaemonPath];
    return [[NSFileManager defaultManager] fileExistsAtPath:launchDaemonPath];
}

+ (BOOL)installLaunchd
{
    BOOL wasRunning = [Helpers isProcessRunning];
    if (wasRunning == YES)
        [Helpers _stopProcess];
    BOOL isInstalled = [Helpers _installLaunchd];
    if (wasRunning == YES)
        [Helpers startProcess];
    return isInstalled;
}

+ (BOOL)uninstallLaunchd
{
    BOOL wasRunning = [Helpers isProcessRunning];
    if (wasRunning == YES)
        [Helpers _stopProcessWithLaunchd];
    BOOL isUninstalled = [Helpers _uninstallLaunchd];
    if (wasRunning == YES)
        [Helpers startProcess];
    return isUninstalled;
}

@end
