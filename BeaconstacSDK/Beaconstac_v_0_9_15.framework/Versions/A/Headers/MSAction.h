//
//  MSAction.h
//  Beaconstac
//
//  Created by Garima Batra on 11/17/14.
//  Copyright (c) 2014 Mobstac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSCard.h"

/**
 * MSActionType describes the type of action triggered from a rule
 * An action can be -
 * popup - which returns a string value in message field
 * webpage - which returns a URL value in message field
 * card - which returns a reference to MSCard object
 * webhook - which returns a URL value in message field
 * custom - which returns a dictionary value in message field
 */
typedef NS_ENUM (NSUInteger, MSActionType) {
    MSActionTypeNone = 0,
    MSActionTypePopup = 1,
    MSActionTypeWebpage = 2,
    MSActionTypeCard = 3,
    MSActionTypeWebhook = 4,
    MSActionTypeCustom = 5
};

@interface MSAction : NSObject 

/**
 * Represents the action ID of the action
 */
@property (nonatomic, strong) NSNumber *actionID;

/**
 * Represents the name of the action
 */
@property (nonatomic, strong) NSString *name;

/**
 * Represents the type of the action. This can have values:
 * popup, webpage, video, audio, custom
 */
@property (nonatomic) MSActionType type;

/**
 * Represents the message of the action. This can have 
 * text, url, JSON depending on the type of action
 */
@property (nonatomic, strong) id message;

/**
 * Represents the rule ID associated to the action
 */
@property (nonatomic, strong) NSNumber *ruleID;

/**
 * Represents the name of the rule this action is associated with
 */
@property (nonatomic, strong) NSString *ruleName;

/**
 * A dictionary that contains meta information associated with the action
 */
@property (nonatomic, strong) NSMutableDictionary *actionMeta;

/**
 * Represents the status of action
 * This can have following values - 
 * A - active
 * P - paused
 * R - removed
 */
@property (nonatomic, strong) NSString *status;

/**
 * Represents the date when the action was created
 */
@property (nonatomic, strong) NSDate *created;

/**
 * Represents the date when the action was last modified
 */
@property (nonatomic, strong) NSDate *modified;

/**
 * This method must be called when action type is webhook.
 * This posts data to the URL provided in Beaconstac developer portal.
 * @param postParams A dictionary of data that you want to post to the URL. Please note that timestamp and data available in factsDictionary is automatically posted.
 * @param additionalHeaders A dictionary of HTTP headers with values. Plesae note that HTTP headers sent from the portal are set by default
 * @param completionBlock A block object to be executed when the request operation finishes. It takes three arguments: statusCode- HTTP status code sent by server, data- Server response after the request has been executed, error- which is a NSError object describing the failure of the request
 */
- (void)executeWebhookWithParams:(NSMutableDictionary*)postParams headers:(NSMutableDictionary*)additionalHeaders WithCompletionBlock:(void (^)(NSNumber *statusCode, NSData *data, NSError *error))completionBlock;

@end
