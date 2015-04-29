//
//  MSMedia.h
//  Beaconstac
//
//  Created by Garima Batra on 12/23/14.
//  Copyright (c) 2014 Mobstac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSMedia : NSObject <NSCopying, NSSecureCoding>

/**
 * Represents the media ID of the media object
 */
@property (nonatomic, strong) NSNumber *mediaID;

/**
 * Represents the name of the media object
 */
@property (nonatomic, strong) NSString *name;

/**
 * Represents the URL of the media object
 */
@property (nonatomic, strong) NSURL *mediaUrl;

/**
 * Represents the content type of the media object
 * This can have values like image/jpeg, audio/mpeg, video/avi etc.
 */
@property (nonatomic, strong) NSString *contentType;

/**
 * Represents the organization ID associated to the media object
 */
@property (nonatomic, strong) NSNumber *organizationId;

/**
 * Represents the date when the media object was created
 */
@property (nonatomic, strong) NSDate *created;

/**
 * Represents the date when the media object was last modified
 */
@property (nonatomic, strong) NSDate *modified;

/**
 * Represents an array of tags associated to the media object
 */
@property (nonatomic, strong) NSArray *tags;

/**
 * Represents the date when the media object will expire.
 * The media object must be cached if it needs to be used post expiry.
 */
@property (nonatomic, strong) NSDate *expiryDate;

@end
