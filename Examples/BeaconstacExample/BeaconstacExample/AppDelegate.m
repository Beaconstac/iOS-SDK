//
//  AppDelegate.m
//  BeaconstacExample
//
//  Copyright (c) 2015 Mobstac. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import <Beaconstac/Beaconstac.h>

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
    
    if ([application respondsToSelector:@selector(shortcutItems)]) {
        UIApplicationShortcutItem *startItem = [[UIApplicationShortcutItem alloc] initWithType:@"Type1" localizedTitle:@"Start background scan" localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeMarkLocation] userInfo:nil];
        UIApplicationShortcutItem *stopItem = [[UIApplicationShortcutItem alloc] initWithType:@"Type2" localizedTitle:@"Stop background scan" localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeProhibit] userInfo:nil];
        application.shortcutItems = @[startItem,stopItem];
    }
    
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

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void(^)(BOOL succeeded))completionHandler NS_AVAILABLE_IOS(9_0)
{
    if ([shortcutItem.type isEqualToString:@"Type1"]) {
        [[Beaconstac sharedInstance] setAllowRangingInBackground:YES];
        [[Beaconstac sharedInstance] startRangingBeaconsWithUUIDString:@"F94DBB23-2266-7822-3782-57BEAC0952AC" beaconIdentifier:@"MobstacRegion" filterOptions:@{@"mybeacons":@YES}];
    } else {
        [[Beaconstac sharedInstance] setAllowRangingInBackground:NO];
        [[Beaconstac sharedInstance] stopRangingBeacons];
    }
}


- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void(^)())completionHandler
{
    [Beaconstac handleNotification:notification forApplication:application];
    completionHandler();
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
