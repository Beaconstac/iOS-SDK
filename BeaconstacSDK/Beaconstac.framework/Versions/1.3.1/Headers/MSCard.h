//
//  MSCard.h
//  Beaconstac
//
//  Created by Garima Batra on 12/22/14.
//  Copyright (c) 2014 Mobstac. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * MSCardType describes the different types of cards that can be created and used in Beaconstac
 */
typedef NS_ENUM (NSUInteger, MSCardType) {
    MSCardTypeNone = 0,
    MSCardTypeSummary = 1,
    MSCardTypePhoto = 2,
    MSCardTypeMedia = 3,
    MSCardTypePage = 4
};

@interface MSCard : NSObject <NSCopying, NSSecureCoding>

/**
 * Represents the card ID of the card
 */
@property (nonatomic, strong) NSNumber *cardID;

/**
 * Represents the name of the card
 */
@property (nonatomic, strong) NSString *title;

/**
 * Represents the body of the card
 */
@property (nonatomic, strong) NSString *body;

/**
 * Represents the organization ID associated to the card
 */
@property (nonatomic, strong) NSNumber *organizationId;

/**
 * Represents the type of the card
 * @see MSCardType
 */
@property (nonatomic) MSCardType type;

/**
 * Represents an array of MSMedia object 
 * @see MSMedia
 */
@property (nonatomic, strong) NSMutableArray *mediaArray;

/**
 * Represents meta information associated with the card
 */
@property (nonatomic, strong) NSDictionary *cardMeta;

/**
 * Represents the date when the card was created
 */
@property (nonatomic, strong) NSDate *created;

/**
 * Represents the date when the card was last modified
 */
@property (nonatomic, strong) NSDate *modified;

/**
 * Represents an array of tags associated with the card
 */
@property (nonatomic, strong) NSArray *tags;

/**
 * Represents id of the MSNotification associated with the card
 * @see MSNotification
 */
@property (nonatomic, strong) NSNumber *notification;

/**
 * Represents action associated with OK button of the card
 */
@property (nonatomic, strong) NSString *okAction;

/**
 * Represents title on the OK button of the card
 */
@property (nonatomic, strong) NSString *okLabel;

/**
 * Represents title on Cancel button of the card
 */
@property (nonatomic, strong) NSString *cancelLabel;

@end
