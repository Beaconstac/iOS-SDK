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
#import "SummaryCardView.h"
#import "PhotoCardView.h"
#import "PageCardView.h"

@interface ViewController ()<BeaconstacDelegate, MusicCardDelegate, SummaryCardDelegate, YTPlayerViewDelegate,PageCardDelegate, PhotoCardDelegate, MSWebhookDelegate>
{
    NSString *mediaType;
    NSURL *mediaUrl;
    Beaconstac *beaconstac;
    MSCard *visibleCard;
    MusicCardView *musicCardView;
    SummaryCardView *summaryCardView;
    PhotoCardView *photoCardView;
    PageCardView *pageCardView;
}

@property (weak, nonatomic) UIView *visibleCardView;
@property (nonatomic, strong) NSMutableDictionary *notificationsDictionary;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Beaconstac";
    
    // Setup and initialize the Beaconstac SDK
    beaconstac = [Beaconstac sharedInstanceWithOrganizationId:<org_id> developerToken:<dev_token>];
    beaconstac.allowRangingInBackground = YES;
    [beaconstac setDelegate:self];
    [[MSLogger sharedInstance] setLoglevel:MSLogLevelError];

    NSLog(@"SDK %@",SDK_VERSION);
    
    // Start ranging beacons with the given UUID
    [beaconstac startRangingBeaconsWithUUIDString:@"F94DBB23-2266-7822-3782-57BEAC0952AC" beaconIdentifier:@"MobstacRegion" filterOptions:@{@"mybeacons":@YES}];
    
    // Demonstrates Custom Attributes functionality.
    [self customAttributeDemo];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    
    [MSNotification fetchAllNotificationsAndRegsiter:YES withCompletionBlock:^(NSArray *notifications, NSError *err) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (!err) {
            NSMutableDictionary *dict = [NSMutableDictionary new];
            for (MSNotification *notif in notifications) {
                [dict setObject:notif forKey:notif.notificationID];
            }
            self.notificationsDictionary = dict;
        } else {
            NSLog(@"Error fetching notifications %@",err);
        }
    }];
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
    [beaconstac updateFact:@"male" forKey:@"Gender"];
}

#pragma mark - Beaconstac delegate methods

- (void)beaconstac:(Beaconstac *)beaconstac didSyncRules:(NSDictionary *)ruleDict withError:(NSError *)error
{
    NSLog(@"didSyncRules with error %@",error);
}

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
    NSLog(@"CampedOnBeacon: %@", beacon);
}

- (void)beaconstac:(Beaconstac*)beaconstac exitedBeacon:(MSBeacon*)beacon
{
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        return;
    }
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
        // action type can be "popup", "webpage", "card", "media", or "custom"
        
        switch (action.type) {
            case MSActionTypePopup:
            {
                NSLog(@"Text Alert action type");
                NSString *message = ((MSPopupAction*)action).messageBody;
                [[[UIAlertView alloc] initWithTitle:ruleName message:[NSString stringWithFormat:@"%@",message] delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
            }
                break;
                
            case MSActionTypeWebpage:
            {
                [self performSegueWithIdentifier:@"webSegue" sender:(MSWebpageAction*)action];
                NSLog(@"Webpage action type");
            }
            break;
                
            case MSActionTypeCard:
            {
                visibleCard = (MSCard*)action;
                if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground) {
                    MSNotification *notif = [self.notificationsDictionary objectForKey:visibleCard.notification];
                    if (notif) {
                        [notif showInApplication:[UIApplication sharedApplication]];
                    }
                } else if (self.visibleCardView) {
                    NSLog(@"Ignoring card");
                } else {
                    [self showCard:visibleCard];
                }
            }
                break;
            
            case MSActionTypeNotification:
            {
                MSNotification *notify = (MSNotification*)action;
                [notify showInApplication:[UIApplication sharedApplication]];
            }
                
            case MSActionTypeWebhook:
            {
                MSWebhook *webhook = (MSWebhook*)action;
                webhook.delegate = self;
                //  Implement the MSWebhookDelegate methods if you do not want to execute the Webhook
                //  Or, if you want to add additional payloads
            }
            break;
                
            case MSActionTypeCustom:
            {
                MSCustomAction *customAction = (MSCustomAction*)action;
                NSLog(@"Custom action type: %@", customAction.json);
                [[[UIAlertView alloc] initWithTitle:ruleName message:[customAction.json description] delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
            }
            break;
                
            default:
                break;
        }
    }
}

- (BOOL)webhookShouldExecute:(MSWebhook *)webhook
{
    return YES;
}

- (void)webhook:(MSWebhook *)webhook executedWithResponse:(NSURLResponse *)response error:(NSError *)error
{
    if (error) {
        [[[UIAlertView alloc] initWithTitle:@"Webhook Error" message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    } else {
        NSLog(@"Webhook executed with response %@ , error %@",response,error);
    }
}

#pragma mark - Music Card delegate
- (void)mediaCardButtonClickedAtIndex:(int)index
{
    switch (index) {
        case 0:
        {
            [UIView animateWithDuration:0.35 animations:^{
                self.visibleCardView.frame = CGRectMake(0, musicCardView.frame.size.height,musicCardView.frame.size.width, musicCardView.frame.size.height);
            } completion:^(BOOL finished) {
                [musicCardView removeFromSuperview];
                self.visibleCardView = nil;
                self.navigationController.navigationBarHidden = NO;
            }];
            [musicCardView setMode:@"pause"];
        }
            break;
            
        case 1:
        {
            if ([musicCardView.okAction length]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:musicCardView.okAction]];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)summaryButtonClickedAtIndex:(int)index
{
    switch (index) {
        case 0:
        {
            [UIView animateWithDuration:0.35 animations:^{
                self.visibleCardView.frame = CGRectMake(0, self.visibleCardView.frame.size.height, self.visibleCardView.frame.size.width, self.visibleCardView.frame.size.height);
            } completion:^(BOOL finished) {
                [summaryCardView removeFromSuperview];
                self.visibleCardView = nil;
                self.navigationController.navigationBarHidden = NO;
            }];
        }
        break;
            
        case 1:
        {
            if ([summaryCardView.okAction length]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:summaryCardView.okAction]];
            }
        }
        break;
            
        default:
            break;
    }
}

- (void)photoCardButtonClickedAtIndex:(int)index
{
    switch (index)
    {
        case 0:
        {
            [UIView animateWithDuration:0.35 animations:^{
                self.visibleCardView.frame = CGRectMake(0, self.visibleCardView.frame.size.height, self.visibleCardView.frame.size.width, self.visibleCardView.frame.size.height);
            } completion:^(BOOL finished) {
                [photoCardView removeFromSuperview];
                self.visibleCardView = nil;
                self.navigationController.navigationBarHidden = NO;
            }];
        }
            break;
            
        case 1:
        {
            if ([photoCardView.okAction length]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:photoCardView.okAction]];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)pageButtonClickedAtIndex:(int)index
{
    switch (index) {
        case 0:
        {
            [UIView animateWithDuration:0.35 animations:^{
                self.visibleCardView.frame = CGRectMake(0, self.visibleCardView.frame.size.height, self.visibleCardView.frame.size.width, self.visibleCardView.frame.size.height);
            } completion:^(BOOL finished) {
                [pageCardView removeFromSuperview];
                self.visibleCardView = nil;
                self.navigationController.navigationBarHidden = NO;
            }];
        }
            break;
            
        case 1:
        {
            if ([pageCardView.okAction length]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:pageCardView.okAction]];
            }
        }
            break;
            
        default:
            break;
    }

}

- (void)showCard:(MSCard*)card
{
    MSNotification *notif = [self.notificationsDictionary objectForKey:card.notification];
    switch (card.cardType) {
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
            musicCardView.titleLabel.text = card.title;
            musicCardView.media = [card.mediaArray firstObject];
            [musicCardView.okButton setTitle:notif.okLabel?:@"OK" forState:UIControlStateNormal];
            musicCardView.okAction = notif.okAction;
            
            self.visibleCardView = musicCardView;
            [UIView animateWithDuration:0.35 animations:^{
                musicCardView.frame = self.view.frame;
                self.navigationController.navigationBarHidden = YES;
            } completion:^(BOOL finished) {
                for (MSMedia *media in visibleCard.mediaArray) {
                    if ([media.contentType containsString:@"video"] && [[media.mediaUrl absoluteString] containsString:@"vimeo"]) {
                        [musicCardView loadVimeoWithUrl:media.mediaUrl];
                    } else if ([media.contentType containsString:@"video"]) {
                        musicCardView.ytPlayerView.delegate = self;
                        [musicCardView loadYoutubeWithUrl:media.mediaUrl];
                    } else if ([media.contentType containsString:@"audio"]) {
                        [musicCardView loadSoundCloudWithUrl:[media.mediaUrl absoluteString]];
                    } else if ([media.contentType containsString:@"video"]) {
                        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Content type is not supported" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    }
                }
            }];
        }
            break;
            
        case MSCardTypePhoto:
        {
            if (!photoCardView) {
                photoCardView = [[[NSBundle mainBundle] loadNibNamed:@"PhotoCardView"
                                                               owner:self
                                                             options:nil] firstObject];
            }
            if (!self.visibleCardView) {
                [self.view addSubview:photoCardView];
                photoCardView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
                photoCardView.layer.masksToBounds = YES;
                photoCardView.imageArray = visibleCard.mediaArray;
                photoCardView.titleLabel.text = visibleCard.title;
                photoCardView.delegate = self;
                [photoCardView.okButton setTitle:notif.okLabel?:@"OK" forState:UIControlStateNormal];
                photoCardView.okAction = notif.okAction;
                self.visibleCardView = photoCardView;
                [photoCardView.imagePager reloadData];
                
                [UIView animateWithDuration:0.35 animations:^{
                    photoCardView.frame = self.view.frame;
                    self.navigationController.navigationBarHidden = YES;
                } completion:^(BOOL finished) {
                }];
            }
        }
            break;
            
        case MSCardTypeSummary:
        {
            if (!summaryCardView) {
                summaryCardView = [[[NSBundle mainBundle] loadNibNamed:@"SummaryCardView"
                                                                 owner:self
                                                               options:nil] firstObject];
            }
            [self.view addSubview:summaryCardView];
            summaryCardView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
            summaryCardView.layer.masksToBounds = YES;
            summaryCardView.delegate = self;
            summaryCardView.titleLabel.text = visibleCard.title;
            summaryCardView.summaryView.text = visibleCard.body;
            [summaryCardView.okButton setTitle:notif.okLabel?:@"OK" forState:UIControlStateNormal];
            summaryCardView.summaryView.text = visibleCard.body;
            summaryCardView.okAction = notif.okAction;
            
            MSMedia *media = [visibleCard.mediaArray firstObject];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:media.mediaUrl];
            
            [NSURLConnection sendAsynchronousRequest:request
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                       if (!error ) {
                                           UIImage *fetchedImage = [UIImage imageWithData:data];
                                           if (fetchedImage) {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   summaryCardView.imageView.image = fetchedImage;
                                               });
                                           }
                                       }
                                   }];
            
            self.visibleCardView = summaryCardView;
            [UIView animateWithDuration:0.35 animations:^{
                summaryCardView.frame = self.view.frame;
                self.navigationController.navigationBarHidden = YES;
            } completion:^(BOOL finished) {
            }];
        }
            break;

        case MSCardTypePage:
        {
            if (!pageCardView) {
                pageCardView = [[[NSBundle mainBundle] loadNibNamed:@"PageCardView"
                                                              owner:self
                                                            options:nil] firstObject];
            }
            if (!self.visibleCardView) {
                [self.view addSubview:pageCardView];
                pageCardView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
                pageCardView.delegate = self;
                pageCardView.titleLabel.text = visibleCard.title;
                pageCardView.summaryView.text = visibleCard.body;
                [pageCardView.okButton setTitle:notif.okLabel?:@"OK" forState:UIControlStateNormal];
                pageCardView.okAction = notif.okAction;
                
                MSMedia *media = [visibleCard.mediaArray firstObject];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:media.mediaUrl];
                
                [NSURLConnection sendAsynchronousRequest:request
                                                   queue:[NSOperationQueue mainQueue]
                                       completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                           if (!error ) {
                                               UIImage *fetchedImage = [UIImage imageWithData:data];
                                               if (fetchedImage) {
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       pageCardView.imageView.image = fetchedImage;
                                                   });
                                               }
                                           }
                                       }];
                
                self.visibleCardView = pageCardView;
                [UIView animateWithDuration:0.35 animations:^{
                    pageCardView.frame = self.view.frame;
                    self.navigationController.navigationBarHidden = YES;
                } completion:^(BOOL finished) {
                }];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"webSegue"]) {
        WebViewController *webVC = (WebViewController*)segue.destinationViewController;
        webVC.url = ((MSWebpageAction*)sender).webUrl;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
