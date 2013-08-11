//
//  Helpers.h
//  Cassandra-PrefsPane
//
//  Created by Rémy SAISSY on 21/07/12.
//  Copyleft LGPL 2013.
//

#import <Cocoa/Cocoa.h>

@interface Helpers : NSObject

//Blocking call to start the process and returns YES in case of success.
+ (BOOL)startProcess;

//Blocking call to stop the process and returns YES in case of success.
+ (BOOL)stopProcess;

//Check if their is a running process (and not only application) named processName.
+ (BOOL)isProcessRunning;

//Check if the launch agent is installed.
+ (BOOL)isLaunchdInstalled;

//Install the launch agent.
+ (BOOL)installLaunchd;

//Removes the launch agent.
+ (BOOL)uninstallLaunchd;

@end
