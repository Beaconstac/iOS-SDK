//
//  MSMedia.h
//  Beaconstac
//
//  Copyright (c) 2016 Mobstac. All rights reserved.
//
//  All information contained herein is, and remains the property of MobStac Inc.
//  The intellectual and technical concepts contained herein are proprietary to
//  MobStac Inc and may be covered by U.S. and Foreign Patents, patents in process,
//  and are protected by trade secret or copyright law. This product can not be
//  redistributed in full or parts without permission from MobStac Inc. Dissemination
//  of this information or reproduction of this material is strictly forbidden unless
//  prior written permission is obtained from MobStac Inc.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

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
