//
//  MSWebhook.h
//  Beaconstac
//
//  Copyright © 2016 Mobstac. All rights reserved.
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
#import "MSAction.h"

@class MSWebhook;

/**
 * Protocol to receive events from the MSWebhook.
 */
@protocol MSWebhookDelegate <NSObject>

@optional

/**
 * Webhook will be executed executed if the method returns true.
 */
- (BOOL)webhookShouldExecute:(MSWebhook*)webhook;

/**
 * Gets a list of additional parameters to be passed in the Webhook POST request.
 */
- (NSDictionary*)addPayloadToWebhook:(MSWebhook*)webhook;

/**
 * Called when Webhook POST request is complete.
 */
- (void)webhook:(MSWebhook*)webhook executedWithResponse:(NSURLResponse*)response error:(NSError*)error;

@end


@interface MSWebhook : NSObject

/**
 * Delegate for MSWebhook
 */
@property (nonatomic, weak) id <MSWebhookDelegate> delegate;

/**
 * Represents the ID of the webhook
 */
@property (nonatomic, strong) NSNumber *webhookID;

/**
 * Represents the name of the webhook
 */
@property (nonatomic, strong) NSString *name;

/**
 * Represents the organization ID associated with the webhook
 */
@property (nonatomic, strong) NSNumber *organizationId;

/**
 * Represents the url string associated with the webhook
 */
@property (nonatomic, strong) NSString *urlString;

/**
 * Represents the parameters dictionary associated with the webhook
 */
@property (nonatomic, strong) NSDictionary *params;

/**
 * Represents the status of the webhook
 */
@property (nonatomic) BOOL status;

/**
 * Represents if the webhook is active
 */
@property (nonatomic) BOOL isActive;

/**
 * Represents the @see MSAction the webhook is associated with
 */
@property (nonatomic, weak) MSAction *action;

/**
 * Represents the date when the webhook was created
 */
@property (nonatomic, strong) NSDate *created;

/**
 * Represents the date when the webhook was last modified
 */
@property (nonatomic, strong) NSDate *modified;

/**
 * This method is automatically called when action type is webhook.
 * This makes a POST request to the URL provided in Beaconstac Admin Console.
 * @param completionBlock A block object to be executed when the request operation finishes. It takes three arguments: statusCode- HTTP status code sent by server, data- Server response after the request has been executed, error- which is a NSError object describing the failure of the request
 */
- (void)executeWebhookWithCompletionBlock:(void (^)(NSNumber *statusCode, NSData *data, NSError *error))completionBlock;

@end
