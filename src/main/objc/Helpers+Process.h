//
//  Helpers+Process.h
//  Cassandra-PrefsPane
//
//  Created by Rémy SAISSY on 22/07/12.
//  Copyleft LGPL 2013.
//

#import "Helpers.h"

@interface Helpers (Process)

// Start and fork the process.
+ (BOOL)_startProcess;

// Stop a forked process.
+ (BOOL)_stopProcess;

@end
