//
//  AutoUpdater.h
//  Cassandra-PrefsPane
//
//  Created by Rémy SAISSY on 24/07/12.
//  Copyleft LGPL 2013.
//

#import <Foundation/Foundation.h>

@interface AutoUpdater : NSObject<NSURLConnectionDelegate>

//YES if a new version has been installed.
@property (assign, nonatomic) BOOL  hasUpdated;

//Check for a new version.
- (void)checkForUpdate;

@end
