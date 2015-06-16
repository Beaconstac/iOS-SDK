//
//  AppDelegate.m
//  BeaconstacExample
//
//  Created by Kshitij-Deo on 15/06/15.
//  Copyright (c) 2015 Mobstac. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate ()<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    return YES;
}

#pragma mark - Location Manager delegate
- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    if (state == CLRegionStateInside) {
        notification.alertBody = [NSString stringWithFormat:@"You are inside region %@", region.identifier];
    } else if (state == CLRegionStateOutside) {
        notification.alertBody = [NSString stringWithFormat:@"You are outside region %@", region.identifier];
    } else {
        return;
    }
    
        // Registering for receiving local notifications when a user enters a beacon region for iOS 8
        // and previous versions respectively.
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
#else
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
#endif
}


- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
