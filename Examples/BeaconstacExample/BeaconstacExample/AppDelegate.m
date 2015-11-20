//
//  AppDelegate.m
//  BeaconstacExample
//
//  Copyright (c) 2015 Mobstac. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate ()<CLLocationManagerDelegate>
{
    BOOL insideBeaconRegion;
}
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Registering for receiving local notifications when a user enters a beacon region for iOS 8
    // and previous versions respectively.
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
#endif
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
#endif
    
    return YES;
}

#pragma mark - Location Manager delegate
- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    if (state == CLRegionStateInside) {
        notification.alertBody = [NSString stringWithFormat:@"You are inside region %@", region.identifier];
        insideBeaconRegion = YES;
    } else if (state == CLRegionStateOutside) {
        notification.alertBody = [NSString stringWithFormat:@"You are outside region %@", region.identifier];
        insideBeaconRegion = FALSE;
    } else {
        return;
    }
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedAlways) {
        
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"applicationDidEnterBackground");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"applicationDidBecomeActive");
}

@end
