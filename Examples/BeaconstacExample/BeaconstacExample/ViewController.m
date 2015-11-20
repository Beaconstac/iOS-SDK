//
//  ViewController.m
//  BeaconstacExample
//
//  Copyright (c) 2015 Mobstac. All rights reserved.
//

#import "ViewController.h"
#import <Beaconstac/Beaconstac.h>
#import "WebViewController.h"
#import "MusicCardView.h"

@interface ViewController ()<BeaconstacDelegate, MusicCardDelegate,YTPlayerViewDelegate>
{
    NSString *mediaType;
    NSURL *mediaUrl;
    Beaconstac *beaconstac;
    MSCard *visibleCard;
    MusicCardView *musicCardView;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Beaconstac";
    
    // Setup and initialize the Beaconstac SDK
    beaconstac = [Beaconstac sharedInstanceWithOrganizationId:<org_id> developerToken:<dev_token>];
    [beaconstac setDelegate:self];
    [[MSLogger sharedInstance] setLoglevel:MSLogLevelError];

    // Start ranging beacons with the given UUID
    [beaconstac startRangingBeaconsWithUUIDString:@"F94DBB23-2266-7822-3782-57BEAC0952AC" beaconIdentifier:@"MobstacRegion" filterOptions:nil];
    
    // Demonstrates Custom Attributes functionality.
    [self customAttributeDemo];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
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
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        return;
    }
}

- (void)beaconstac:(Beaconstac *)beaconstac didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
}

- (void)beaconstac:(Beaconstac*)beaconstac campedOnBeacon:(MSBeacon*)beacon amongstAvailableBeacons:(NSDictionary *)beaconsDictionary
{
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        NSLog(@"CampedOnBeacon: %@", beacon);
    }
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = [NSString stringWithFormat:@"Camped on to Beacon: %@, %@", beacon.major, beacon.minor];
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    
}

- (void)beaconstac:(Beaconstac*)beaconstac exitedBeacon:(MSBeacon*)beacon
{
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        NSLog(@"ExitedBeacon: %@", beacon);
        return;
    }
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = [NSString stringWithFormat:@"Exited Beacon: %@, %@", beacon.major, beacon.minor];
    [[UIApplication sharedApplication]presentLocalNotificationNow:notification];
}

- (void)beaconstac:(Beaconstac*)beaconstac didEnterBeaconRegion:(CLRegion*)region
{
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        NSLog(@"Entered beacon region :%@", region.identifier);
        return;
    }
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = [NSString stringWithFormat:@"Entered beacon region: %@", region.identifier];
    [[UIApplication sharedApplication]presentLocalNotificationNow:notification];
}

- (void)beaconstac:(Beaconstac*)beaconstac didExitBeaconRegion:(CLRegion *)region
{
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        NSLog(@"Exited beacon region :%@", region.identifier);
        return;
    }
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = [NSString stringWithFormat:@"Exited beacon region: %@", region.identifier];
    [[UIApplication sharedApplication]presentLocalNotificationNow:notification];
}

    // Tells the delegate that a rule is triggered with corresponding list of actions.
- (void)beaconstac:(Beaconstac *)beaconstac triggeredRuleWithRuleName:(NSString *)ruleName actionArray:(NSArray *)actionArray
{
    NSLog(@"triggeredRuleWithRuleName: %@", ruleName);
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
                visibleCard = action.message;
                switch (visibleCard.type) {
                        
                    case MSCardTypeMedia:
                    {
                        if (!musicCardView) {
                            musicCardView = [[[NSBundle mainBundle] loadNibNamed:@"MusicCardView"
                                                                           owner:self
                                                                         options:nil] firstObject];
                        }
                        
                        [self.view addSubview:musicCardView];
                        musicCardView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
                        musicCardView.layer.masksToBounds = YES;
                        musicCardView.delegate = self;
                        musicCardView.titleLabel.text = visibleCard.title;
                        self.navigationController.navigationBarHidden = YES;

                        [UIView animateWithDuration:0.35 animations:^{
                            musicCardView.frame = self.view.frame;
                        } completion:^(BOOL finished) {

                            for (MSMedia *media in visibleCard.mediaArray) {
                                if ([media.contentType containsString:@"video"]) {
                                    if ([[media.mediaUrl absoluteString] containsString:@"vimeo"]) {
                                        NSString *videoId = [self extractVimeoID:[media.mediaUrl absoluteString]];
                                        [musicCardView loadVimeoWithUrl:videoId];
                                    } else if ([media.contentType containsString:@"youtube"] || [media.contentType containsString:@"video"]) {
                                        musicCardView.ytPlayerView.delegate = self;
                                        [musicCardView.ytPlayerView setHidden:NO];
                                        
                                        NSDictionary *playerVars = @{
                                                                     @"controls" : @1,
                                                                     @"playsinline" : @0,
                                                                     @"autohide" : @1,
                                                                     @"showinfo" : @1,
                                                                     @"modestbranding" : @1,
                                                                     @"suggestedQuality" : @"large"
                                                                     };
                                        NSString *videoId = [self extractYoutubeID:[media.mediaUrl absoluteString]];
                                        [musicCardView.ytPlayerView loadWithVideoId:videoId playerVars:playerVars];
                                    } else {
                                        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Only Youtube and Vimeo url are supported in video" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                    }
                                } else if ([media.contentType containsString:@"audio"]) {
                                    [musicCardView loadSoundCloudWithUrl:[media.mediaUrl absoluteString]];
                                } else {
                                    continue;
                                }
                                break;
                            }
                        }];
                    }
                    break;
                
                    default:
                    {
                        for (int i=0; i< visibleCard.mediaArray.count; i++) {
                            MSMedia *media = visibleCard.mediaArray[i];
                            NSLog(@"Media 1: Id: %@, name: %@", media.mediaID, media.name);
                        }
                    }
                    break;
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

- (void)beaconstac:(Beaconstac *)beaconstac didSyncRules:(NSDictionary *)ruleDict withError:(NSError *)error
{
    NSLog(@"didSyncRules with error %@",error);
}

#pragma mark - Music Card delegate
- (void)mediaCardButtonClickedAtIndex:(int)index
{
    switch (index) {
        case 0:
        {
            [UIView animateWithDuration:0.35 animations:^{
                musicCardView.frame = CGRectMake(0, musicCardView.frame.size.height,musicCardView.frame.size.width, musicCardView.frame.size.height);
            } completion:^(BOOL finished) {
                [musicCardView removeFromSuperview];
                self.navigationController.navigationBarHidden = NO;
            }];
            [musicCardView setMode:@"pause"];
            [musicCardView.ytPlayerView stopVideo];
        }
            break;
            
        case 2:
        {
            for (MSMedia *media in visibleCard.mediaArray) {
                if ([media.contentType containsString:@"video"] && [[media.mediaUrl absoluteString] containsString:@"vimeo"]) {
                    NSString *videoId = [self extractVimeoID:[media.mediaUrl absoluteString]];
                    [musicCardView loadVimeoWithUrl:videoId];
                    break;
                } else if ([media.contentType containsString:@"youtube"]) {
                        //musicCardView.ytPlayerView.delegate = self;
                    [musicCardView.ytPlayerView setHidden:NO];
                    
                    NSDictionary *playerVars = @{
                                                 @"controls" : @1,
                                                 @"playsinline" : @1,
                                                 @"autohide" : @1,
                                                 @"showinfo" : @1,
                                                 @"modestbranding" : @1,
                                                 @"suggestedQuality" : @"large"
                                                 };
                    NSString *videoId = [self extractYoutubeID:[media.mediaUrl absoluteString]];
                    [musicCardView.ytPlayerView loadWithVideoId:videoId playerVars:playerVars];
                    break;
                }
            }
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - Extract video id form URL

- (NSString *)extractYoutubeID:(NSString *)youtubeURL
{
    NSError *error = NULL;
    NSString *regexString = @"(?<=v(=|/))([-a-zA-Z0-9_]+)|(?<=youtu.be/)([-a-zA-Z0-9_]+)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString options:NSRegularExpressionCaseInsensitive error:&error];
    NSRange rangeOfFirstMatch = [regex rangeOfFirstMatchInString:youtubeURL options:0 range:NSMakeRange(0, [youtubeURL length])];
    if(!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0)))
    {
        NSString *substringForFirstMatch = [youtubeURL substringWithRange:rangeOfFirstMatch];
        return substringForFirstMatch;
    }
    return nil;
}

- (NSString *)extractVimeoID:(NSString *)vimeoURL
{
    NSRange range = [vimeoURL rangeOfString:@"vimeo.com/"];
    if (range.location !=NSNotFound) {
        NSString *str = [vimeoURL substringFromIndex:(range.location+range.length)];
        return str;
    }
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
