//
//  Helpers+cassandra.h
//  Cassandra-PrefsPane
//
//  Created by Rémy SAISSY on 22/07/12.
//  Copyright (c) 2012 Octo Technology. All rights reserved.
//

#import "Helpers.h"

@interface Helpers (Cassandra)

// Start and fork the cassandra process.
+ (BOOL)_startCassandraProcess;

// Stop a forked cassandra process.
+ (BOOL)_stopCassandraProcess;

@end
