//
//  Helpers+Cassandra.m
//  Cassandra-PrefsPane
//
//  Created by Rémy SAISSY on 22/07/12.
//  Copyright (c) 2012 Octo Technology. All rights reserved.
//

#import "Helpers+Private.h"
#import "Helpers+Cassandra.h"

@implementation Helpers (cassandra)

+ (BOOL)_startcassandraProcess
{    
    NSString *processPath = [Helpers _findBinaryNamed:@"cassandra"];
    if (processPath == nil)
        return NO;
    NSArray *arguments = [Helpers _processArgumentsForProcessPath:processPath forLaunchctl:NO];
    NSTask *task = [NSTask launchedTaskWithLaunchPath:processPath arguments:arguments];
    [task waitUntilExit];
    BOOL isStarted = [Helpers isProcessRunning];
    if (isStarted == YES)
        [NSString logInfoFromClass:[Helpers class] withSelector:_cmd withFormat:@"%@ %@", processPath, arguments];
    else
        [NSString logErrorFromClass:[Helpers class] withSelector:_cmd withFormat:@"%@ %@", processPath, arguments];
    return isStarted;
}

+ (BOOL)_stopcassandraProcess
{
    NSArray *pidList = [Helpers _pidListForProcesses];
    for (NSNumber *pid in pidList) {
        if (kill([pid intValue], SIGINT) == -1) {
            [NSString logInfoFromClass:[Helpers class] withSelector:_cmd withFormat:@"Process %@ not terminating properly, sending SIGKILL...", pid];
            kill([pid intValue], SIGKILL);
        }
        [NSString logInfoFromClass:[Helpers class] withSelector:_cmd withFormat:@"Process %@ terminated.", pid];
    }
    return YES;
}

@end
