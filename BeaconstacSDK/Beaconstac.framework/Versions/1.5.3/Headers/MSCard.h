//
//  MSCard.h
//  Beaconstac
//
//  Copyright (c) 2017 Mobstac. All rights reserved.
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

#import "MSAction.h"
#import "MSNotification.h"

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

@interface MSCard : MSAction <NSCopying, NSSecureCoding>

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
 *
 * Note: This property was formerly named 'type'. Please change all implementations to use 'cardType' instead
 * Starting v1.3.3, the 'type' property inherits from @see MSAction and refers to action type.
 */
@property (nonatomic) MSCardType cardType;

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
 * Represents an array of tags associated with the card
 */
@property (nonatomic, strong) NSArray *tags;

/**
 * Represents id of the MSNotification associated with the card
 * @see MSNotification
 */
@property (nonatomic, strong) NSNumber *notification;

/**
 * Represents the MSNotification object associated with the card
 * @see MSNotification
 */
@property (nonatomic, weak) MSNotification *notificationObject;

/**
 * Represents the @see MSAction the webhook is associated with
 */
@property (nonatomic, weak) MSAction *action;

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
