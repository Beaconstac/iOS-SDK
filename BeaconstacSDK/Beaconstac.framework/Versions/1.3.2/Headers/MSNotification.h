//
//  MSNotification.h
//  Beaconstac
//
//  Copyright© 2014, MobStac Inc. All rights reserved.
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
#import <UIKit/UIKit.h>

@interface MSNotification : NSObject

/**
 * Represents the ID of the Notification
 */
@property (nonatomic, strong) NSNumber *notificationID;

/**
 * Represents the title of the notitfication.
 */
@property (nonatomic, strong) NSString *title;

/**
 * Represents the message body of the notitfication.
 */
@property (nonatomic, strong) NSString *body;

/**
 * Represents the organization ID associated to the card
 */
@property (nonatomic, strong) NSNumber *organizationId;

/**
 * Represents an array of MSMedia object
 * @see MSMedia
 */
@property (nonatomic, strong) NSMutableArray *mediaArray;

/**
 * Title of the Ok button
 */
@property (nonatomic, strong) NSString *okLabel;

/**
 * Action associated with the OK button
 */
@property (nonatomic, strong) NSString *okAction;

/**
 * Title of the Cancel
 */
@property (nonatomic, strong) NSString *cancelLabel;

/**
 * Action associated with the Cancel button
 */
@property (nonatomic, strong) NSString *cancelAction;

/**
 * Represents the status of action - whether it is active or paused
 */
@property (nonatomic) BOOL isActive;

/**
 * ID of the card which created the notification
 */
@property (nonatomic, strong) NSNumber *cardID;

/**
 * Represents whether the notification was created by a card or separately
 */
@property (nonatomic) BOOL createdByCard;

/**
 * Represents the date when the Notification was created
 */
@property (nonatomic, strong) NSDate *created;

/**
 * Represents the date when the Notification was last modified
 */
@property (nonatomic, strong) NSDate *modified;

/**
 * Show notification in application
 */
- (void)showInApplication:(UIApplication*)application;

/**
 * Register for User notifications with button titles
 */
- (void)registerForUserNotification;

/**
 * Register for All User notifications in the Rules
 */
+ (void)registerForAllUserNotifications:(NSArray*)notifications;

/**
 * Returns an array of MSNotifications associated with the account
 * @param completionBlock This block is invoked when the server responds. It takes two arguments: notifications - An array of MSNotifications associated with the account, error - which is a NSError object describing the failure
 * @see MSNotifications
 */
+ (void)fetchAllNotificationsWithCompletionBlock:(void (^)(NSArray *notifications, NSError *error))completionBlock;

/**
 * Returns an array of MSNotifications associated with the account
 * @param completionBlock This block is invoked when the server responds. It takes two arguments: notifications - An array of @see MSNotifications associated with the account, error - which is a NSError object describing the failure
 * @param autoRegister If true, the method also registers all the notifications receieved from server
 */
+ (void)fetchAllNotificationsAndRegsiter:(BOOL)autoRegister withCompletionBlock:(void(^)(NSArray *notifications, NSError *error))completionBlock;

@end
