//
//  Helpers+Launchd.m
//  Cassandra-PrefsPane
//
//  Created by Rémy SAISSY on 22/07/12.
//  Copyleft LGPL 2013.
//

#import "Helpers+Private.h"
#import "Helpers+Launchd.h"

@implementation Helpers (Launchd)

+ (BOOL)_startProcessWithLaunchd
{
    NSString *launchctlProcessPath = [Helpers _findBinaryNamed:@"launchctl"];
    NSArray *arguments = @[@"start", @"com.remysaissy.cassandraprefspane"];
    NSTask *task = [NSTask launchedTaskWithLaunchPath:launchctlProcessPath arguments:arguments];
    [task waitUntilExit];
    BOOL isStarted = [Helpers isProcessRunning];
    if (isStarted == YES)
        INFO(@"Started process %@ %@", launchctlProcessPath, arguments);
    else
        ERROR(@"Could not start process %@ %@", launchctlProcessPath, arguments);
    return isStarted;
}

+ (BOOL)_stopProcessWithLaunchd
{
    NSString *launchctlProcessPath = [Helpers _findBinaryNamed:@"launchctl"];
    NSArray *arguments = @[@"stop", @"com.remysaissy.cassandraprefspane"];
    NSTask *task = [NSTask launchedTaskWithLaunchPath:launchctlProcessPath arguments:arguments];
    [task waitUntilExit];
    BOOL isStopped = ![Helpers isProcessRunning];
    if (isStopped == YES)
        INFO(@"Stopped process %@ %@", launchctlProcessPath, arguments);
    else
        ERROR(@"Could not stop process %@ %@", launchctlProcessPath, arguments);
    return isStopped;
}

+ (BOOL)_installLaunchd
{    
    BOOL isInstalled = NO;
    NSString *launchDaemonPath = [Helpers _launchDaemonPath];
    if ([Helpers _createLaunchdPlistForDaemonPath:launchDaemonPath] == YES) {
        //    At this point the agent plist file has been created if needed. Now load it.
        NSString *launchctlProcessPath = [Helpers _findBinaryNamed:@"launchctl"];
        NSTask *task = [NSTask launchedTaskWithLaunchPath:launchctlProcessPath arguments:@[@"load", launchDaemonPath]];
        [task waitUntilExit];
        isInstalled = !task.terminationStatus;
        if (isInstalled == YES)
            INFO(@"Launchd agent %@ loaded", launchDaemonPath);
        else
            ERROR(@"Could not load Launchd agent %@", launchDaemonPath);
    }
    return isInstalled;
}

+ (BOOL)_uninstallLaunchd
{
    BOOL isUninstalled = NO;
    NSString *launchDaemonPath = [Helpers _launchDaemonPath];    
    NSString *launchctlProcessPath = [Helpers _findBinaryNamed:@"launchctl"];
    NSTask *task = [NSTask launchedTaskWithLaunchPath:launchctlProcessPath arguments:@[@"unload", launchDaemonPath]];
    [task waitUntilExit];
    if (!task.terminationStatus) {
        INFO(@"Launchd agent %@ unloaded", launchDaemonPath);
        NSError *error = nil;
        isUninstalled = [[NSFileManager defaultManager] removeItemAtPath:launchDaemonPath error:&error];
        if (error != nil)
            ERROR(@"Failed to remove agent description file %@ (%@)", launchDaemonPath, error);
    } else
        ERROR(@"Could not unload agent %@", launchDaemonPath);
    return isUninstalled;
}

+ (BOOL)_createLaunchdPlistForDaemonPath:(NSString *)launchDaemonPath
{
    BOOL isCreated = NO;
    NSString *processPath = [Helpers _findBinaryNamed:@"cassandra"];
    processPath = [processPath stringByResolvingSymlinksInPath];
    NSString *workingDirectory = [[processPath stringByDeletingLastPathComponent] stringByDeletingLastPathComponent];
    NSDictionary *launchAgentContent = @{@"Label": @"com.remysaissy.cassandraprefspane",
                                         @"ProgramArguments": @[processPath, @"-f"],
                                         @"RunAtLoad": [NSNumber numberWithBool:YES],
                                         @"WorkingDirectory": workingDirectory};
    isCreated = [launchAgentContent writeToFile:launchDaemonPath atomically:YES];
    if (isCreated)
        INFO(@"Agent description file created at %@", launchDaemonPath);
    else
        ERROR(@"Could not create agent description file at %@", launchDaemonPath);
    return isCreated;
}

@end
