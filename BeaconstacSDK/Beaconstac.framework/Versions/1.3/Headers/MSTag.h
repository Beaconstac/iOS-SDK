//
//  MSTag.h
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

@interface MSTag : NSObject

/**
 * Represents tag name assigned by user
 */
@property (nonatomic, strong) NSString *name;

/**
 * Represents array of beacons attached to this Tag
 */
@property (nonatomic, strong, readonly) NSArray *beaconsArray;

/**
 * Represents the ID of the Tag
 */
@property (nonatomic, strong, readonly) NSNumber *tagID;

/**
 * Represents the date when the Tag was created
 */
@property (nonatomic, strong) NSDate *created;

/**
 * Represents the date when the Tag was last modified
 */
@property (nonatomic, strong) NSDate *modified;

/**
 * Updates the changes to the Tag object and syncs with the server
 * @param completionBlock This block is invoked when the sync is complete. It takes two arguments: succeeded - if the operation was successful, error - which is a NSError object describing the failure.
 */
- (void)saveInBackgroundWithCompletionBlock:(void (^)(BOOL succeeded, NSError *error))completionBlock;

/**
 * Deletes the Tag object from server
 * @param completionBlock This block is invoked when the deletion operation is complete. It takes two arguments: succeeded - if the operation was successful, error - which is a NSError object describing the failure.
 */
- (void)deleteInBackgroundWithCompletionBlock:(void (^)(BOOL succeeded, NSError *error))completionBlock;

/**
 * Creates a Tag object with the provided parameters
 * @param name Represents name of Tag
 * @param completionBlock This block is invoked when the server responds. It takes two arguments: tag - The tag object whcih got created on the server, error - which is a NSError object describing the failure
 */
+ (void)createTagWithName:(NSString*)name beacons:(NSArray*)beacons withCompletionBlock:(void (^)(MSTag *tag, NSError *error))completionBlock;

/**
 * Returns an array of MSTags associated with the account
 * @param completionBlock This block is invoked when the server responds. It takes two arguments: tags - An array of tags associated with the account, error - which is a NSError object describing the failure
 */
+ (void)fetchAllTagsWithCompletionBlock:(void (^)(NSArray *tags, NSError *error))completionBlock;

@end
