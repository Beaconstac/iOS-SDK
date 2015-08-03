//
//  ViewController.m
//  BeaconstacExample
//
//  Created by Kshitij-Deo on 15/06/15.
//  Copyright (c) 2015 Mobstac. All rights reserved.
//

#import "ViewController.h"
#import <Beaconstac/Beaconstac.h>
#import "WebViewController.h"

@interface ViewController ()<BeaconstacDelegate>
{
    NSString *mediaType;
    NSURL *mediaUrl;
    Beaconstac *beaconstac;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Beaconstac";
    
    [[MSLogger sharedInstance] setLoglevel:MSLogLevelVerbose];
    
    // Setup and initialize the Beaconstac SDK
    beaconstac = [Beaconstac sharedInstanceWithOrganizationId:<org_id> developerToken:<dev_token>];
    
    // Start ranging beacons with the given UUID
    [beaconstac startRangingBeaconsWithUUIDString:@"F94DBB23-2266-7822-3782-57BEAC0952AC" beaconIdentifier:@"MobstacRegion" filterOptions:nil];
    [beaconstac setDelegate:self];
    
    // Demonstrates Custom Attributes functionality.
    [self customAttributeDemo];
}

//
// This method explains how to use custom attributes through Beaconstac SDK. You can create a new Custom
// Attribute from Beaconstac developer portal. You can then create (or edit) a rule and add the Custom
// attribute to the rule. Then, you can define an action for the rule you just created (or edited).
// For eg. you created a custom attribute called "gender" of type "string". In the rule, you can add a
// custom attribute, gender matches female and associate an action with the rule, say "Text Alert" saying
// "Gender is female". Now, in the app, you can set the "gender" of the user by updating facts in the SDK.
// The rule gets triggered when the facts you update in the app satisfies the custom attribute condition.
//
- (void)customAttributeDemo
{
    [beaconstac updateFact:@"female" forKey:@"Gender"];
}

#pragma mark - Beaconstac delegate

- (void)beaconstac:(Beaconstac *)beaconstac rangedBeacons:(NSDictionary *)beaconsDictionary
{
}

- (void)beaconstac:(Beaconstac *)beaconstac didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
}

- (void)beaconstac:(Beaconstac*)beaconstac campedOnBeacon:(MSBeacon*)beacon amongstAvailableBeacons:(NSDictionary *)beaconsDictionary
{
    NSLog(@"CampedOnBeacon: %@ \n visible beacons: %@", beacon, beaconsDictionary);
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = [NSString stringWithFormat:@"Camped on to Beacon: %@, %@", beacon.major, beacon.minor];
    [[UIApplication sharedApplication]presentLocalNotificationNow:notification];
}

- (void)beaconstac:(Beaconstac*)beaconstac exitedBeacon:(MSBeacon*)beacon
{
    NSLog(@"ExitedBeacon: %@", beacon);
}

- (void)beaconstac:(Beaconstac*)beaconstac didEnterBeaconRegion:(CLRegion*)region
{
    NSLog(@"Entered beacon region :%@", region.identifier);
}

- (void)beaconstac:(Beaconstac*)beaconstac didExitBeaconRegion:(CLRegion *)region
{
    NSLog(@"Exited beacon region :%@", region.identifier);
}

    // Tells the delegate that a rule is triggered with corresponding list of actions.
- (void)beaconstac:(Beaconstac *)beaconstac triggeredRuleWithRuleName:(NSString *)ruleName actionArray:(NSArray *)actionArray
{
    NSLog(@"Action Array: %@", actionArray);
    // actionArray contains the list of actions to trigger for the rule that matched.
    
    for (MSAction *action in actionArray) {
        // meta.action_type can be "popup", "webpage", "card", "media", or "custom"
    
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.alertBody = action.message;
        [[UIApplication sharedApplication]presentLocalNotificationNow:notification];
        
        switch (action.type) {
            case MSActionTypePopup:
            {
                NSLog(@"Text Alert action type");
                NSString *message = action.message;
                [[[UIAlertView alloc] initWithTitle:ruleName message:[NSString stringWithFormat:@"%@",message] delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
            }
                break;
                
            case MSActionTypeWebpage:
            {
                [self performSegueWithIdentifier:@"webSegue" sender:action];
                NSLog(@"Webpage action type");
            }
                break;
                
            case MSActionTypeCard:
            {
                MSCard *card = action.message;
                NSLog (@"Id: %@, title: %@, body: %@, cardMeta: %@", card.cardID, card.title, card.body, card.cardMeta);
                
                for (int i=0; i< card.mediaArray.count; i++) {
                    MSMedia *media = card.mediaArray[i];
                    NSLog(@"Media 1: Id: %@, name: %@", media.mediaID, media.name);
                }
            }
                break;
                
            case MSActionTypeCustom:
            {
                NSDictionary *customActionDict = action.message;
                NSLog(@"Custom action type: %@", customActionDict);
            }
                break;
            
            case MSActionTypeWebhook:
            {
                // Pass the POST params you want to pass and additional HTTP headers, if any.
                // Please note that timestamp and data available in factsDictionary is automatically posted.
                // Plesae note that HTTP headers sent from the portal are set by default
                [action executeWebhookWithParams:nil headers:nil WithCompletionBlock:^(NSNumber *statusCode, NSData *data, NSError *error) {
                    if (!error) {
                        NSLog(@"Successful");
                    } else {
                        NSLog(@"Error: %@", [error localizedDescription]);
                    }
                }];
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
