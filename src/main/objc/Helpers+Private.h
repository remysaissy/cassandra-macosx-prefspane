//
//  Helpers+Private.h
//  Cassandra-PrefsPane
//
//  Created by Rémy SAISSY on 22/07/12.
//  Copyleft LGPL 2013.
//

#import "Helpers.h"

@interface Helpers (Private)

//Returns the launch daemon plist file.
+ (NSString *)_launchDaemonPath;

//Returns the fullpath of a binary. nil if it has not been found.
+ (NSString *)_findBinaryNamed:(NSString *)processName;

//Returns the list of pids running a process named processName.
+ (NSArray *)_pidListForProcesses;

@end
