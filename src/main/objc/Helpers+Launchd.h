//
//  Helpers+Launchd.h
//  Cassandra-PrefsPane
//
//  Created by Rémy SAISSY on 22/07/12.
//  Copyright (c) 2012 Octo Technology. All rights reserved.
//

#import "Helpers.h"

@interface Helpers (Launchd)

// Start and fork the cassandra process.
+ (BOOL)_startProcessWithAutomaticStartup;

// Stop a forked cassandra process.
+ (BOOL)_stopProcessWithAutomaticStartup;

//Install cassandra in launchd.
+ (BOOL)_installLaunchd;

//Uninstall cassandra from launchd.
+ (BOOL)_uninstallLaunchd;

//Create the launchd plist in its NSDictionary form.
+ (NSDictionary *)_createLaunchdPlistDictionary;

//Create the launchd plist in its plist file form.
+ (BOOL)_createLaunchdPlistForDaemonPath:(NSString *)launchDaemonPath;

//Neutralize any other launchd process. Returns YES if there was a launchd running process.
//One interesting point here is that a previous plist from homebrew for example will simply
//be migrated and not deleted. So your customizations to the file won't be erased.
+ (BOOL)_neutralizeAnotherLaunchdProcess;

@end