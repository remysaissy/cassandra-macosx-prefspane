//
//  Helpers+Private.h
//  Cassandra-PrefsPane
//
//  Created by Rémy SAISSY on 22/07/12.
//  Copyright (c) 2012 Octo Technology. All rights reserved.
//

#import "Helpers.h"

@interface Helpers (Private)

//Check if a process is running.
+ (BOOL)_isProcessRunning;

//Returns the launch daemon plist file.
+ (NSString *)_launchDaemonPath;

//Returns the process arguments
+ (NSArray *)_processArgumentsForProcessPath:(NSString *)processPath forLaunchctl:(BOOL)useLaunchctl;

//Returns the fullpath of a binary. nil if it has not been found.
+ (NSString *)_findBinaryNamed:(NSString *)processName;

//Returns the list of pids running a process named processName.
+ (NSArray *)_pidListForProcesses;

@end
