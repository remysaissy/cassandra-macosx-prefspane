//
//  CassandraCassandraPrefsPane.m
//  Cassandra-PrefsPane
//
//  Created by Rémy SAISSY on 20/07/12.
//  Copyleft LGPL 2013.
//

#import "CassandraPrefsPane.h"
#import "AutoUpdater.h"
#import "Helpers.h"

//Redefine it since mainBundle refers to the system preferences app and not to our prefspane.
#undef NSLocalizedString
#define NSLocalizedString(key, comment) \
[[NSBundle bundleForClass:[self class]] localizedStringForKey:(key) value:@"" table:nil]

@interface CassandraPrefsPane()

//The last state of the server which is displayed on the UI.
@property (assign, nonatomic) BOOL  _isStarted;

//The autoupdater instance.
@property (retain, nonatomic) AutoUpdater   *_autoUpdater;

//Configure the UI with the process started.
- (void)_setProcessAsStarted;

//Configure the UI with the process stopped.
- (void)_setProcessAsStopped;

//Update the running state of the server.
- (void)_checkRunningState;

@end

@implementation CassandraPrefsPane

@synthesize instanceStatusStoppedImageView;
@synthesize instanceStatusStartedImageView;
@synthesize instanceStatusDescriptionTextField;
@synthesize panelUpdatedTextField;
@synthesize instanceStatusTextField;
@synthesize instanceStartStopButton;
@synthesize instanceAutomaticStartButton;

//Private properties.
@synthesize _isStarted;
@synthesize _autoUpdater;


- (void)mainViewDidLoad
{
    self._autoUpdater = [[[AutoUpdater alloc] init] autorelease];
    [self._autoUpdater addObserver:self forKeyPath:@"hasUpdated" options:NSKeyValueObservingOptionNew context:nil];
    [self performSelector:@selector(_checkRunningState) withObject:nil afterDelay:5];
}

- (void)didSelect
{    
    if ([Helpers isProcessRunning] == YES)
        [self _setProcessAsStarted];
    else
        [self _setProcessAsStopped];
    
    [self.instanceAutomaticStartButton setState:[Helpers isLaunchdInstalled]];
    [self._autoUpdater checkForUpdate];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{    
    if (object == self._autoUpdater 
        && [@"hasUpdated" isEqualToString:keyPath]        
        && self._autoUpdater.hasUpdated == YES) {
        [self.panelUpdatedTextField setHidden:NO];
    }
}

- (IBAction)onStartStopButtonPushed:(id)sender
{
    if (self._isStarted == YES) {
        if ([Helpers stopProcess] == YES)
            [self _setProcessAsStopped];        
    } else {
        if ([Helpers startProcess] == YES)
            [self _setProcessAsStarted];
    }
}

- (IBAction)onAutomaticStartButtonPushed:(id)sender
{
    if (self.instanceAutomaticStartButton.state) {
        if ([Helpers installLaunchd] == YES)
            [self.instanceAutomaticStartButton setState:[Helpers isLaunchdInstalled]];
    } else {
        if ([Helpers uninstallLaunchd] == YES)
            [self.instanceAutomaticStartButton setState:[Helpers isLaunchdInstalled]];
    }
    if ([Helpers isProcessRunning] == YES)
        [self _setProcessAsStarted];
    else 
        [self _setProcessAsStopped];
}

#pragma mark - Private methods.

- (void)_setProcessAsStarted
{    
    [self.instanceStatusTextField setStringValue:NSLocalizedString(@"started", nil)];
    [self.instanceStatusTextField setTextColor:[NSColor greenColor]];
    [self.instanceStartStopButton setTitle:NSLocalizedString(@"Stop Cassandra Server", nil)];
    [self.instanceStatusDescriptionTextField setStringValue:NSLocalizedString(@"The Cassandra Server is currently started. To stop it, use the \"Stop Cassandra Server\" button.", nil)];    
    [self.instanceStatusStartedImageView setHidden:NO];
    [self.instanceStatusStoppedImageView setHidden:YES];
    self._isStarted = YES;
}

- (void)_setProcessAsStopped
{
    [self.instanceStatusTextField setStringValue:NSLocalizedString(@"stopped", nil)];
    [self.instanceStatusTextField setTextColor:[NSColor redColor]];
    [self.instanceStartStopButton setTitle:NSLocalizedString(@"Start Cassandra Server", nil)];
    [self.instanceStatusDescriptionTextField setStringValue:NSLocalizedString(@"The Cassandra Server is currently stopped. To start it, use the \"Start Cassandra Server\" button.", nil)];
    [self.instanceStatusStartedImageView setHidden:YES];
    [self.instanceStatusStoppedImageView setHidden:NO];
    self._isStarted = NO;    
}

- (void)_checkRunningState
{
    if ([Helpers isProcessRunning])
        [self _setProcessAsStarted];
    else
        [self _setProcessAsStopped];
    [self performSelector:@selector(_checkRunningState) withObject:nil afterDelay:5];
}

@end
