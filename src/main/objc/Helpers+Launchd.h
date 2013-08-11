//
//  Helpers+Launchd.h
//  Cassandra-PrefsPane
//
//  Created by Rémy SAISSY on 22/07/12.
//  Copyleft LGPL 2013.
//

#import "Helpers.h"

@interface Helpers (Launchd)

// Start and fork the cassandra process.
+ (BOOL)_startProcessWithLaunchd;

// Stop a forked cassandra process.
+ (BOOL)_stopProcessWithLaunchd;

//Install cassandra in launchd.
+ (BOOL)_installLaunchd;

//Uninstall cassandra from launchd.
+ (BOOL)_uninstallLaunchd;

//Create the launchd plist in its plist file form.
+ (BOOL)_createLaunchdPlistForDaemonPath:(NSString *)launchDaemonPath;

@end
