//
//  MSIdentity.h
//  BeaconstacSDK
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
#import "MSBeaconManager.h"

/**
 * Represent user identity within Beaconstac
 */
@interface MSIdentity : NSObject

/*
 * @todo Why can't this just be a unique identifier?
 */
@property (nonatomic, strong) NSString *email;

/**
 * First name
 */
@property (nonatomic, strong) NSString *firstName;

/**
 * Last name
 */
@property (nonatomic, strong) NSString *lastName;

/**
 * Gender
 */
@property (nonatomic, strong) NSString *gender;

/**
 * Age
 */
@property (nonatomic) NSInteger *age;

/**
 * Dictionary containing any other user info
 */
@property (nonatomic, strong) NSDictionary *userInfo;

/**
 * Push token
 */
@property (nonatomic, strong) NSString *pushToken;

/**
 * Vendor ID
 */
@property (nonatomic, strong) NSString *vendorID;

/**
 * Hardware info
 */
@property (nonatomic, strong) NSString *hardwareInfo;

/**
 * OS info
 */
@property (nonatomic, strong) NSString *osInfo;

/**
 * Initialize an MSIdentity object.
 */
- (id)init;

/**
 * Initialize an MSIdentity object with the given parameters.
 *
 * @param firstName
 * @param lastName
 * @param emailAddress
 */
- (id)initWithFirstName:(NSString*)firstName lastName:(NSString*)lastName emailAddress:(NSString*)email;

/**
 * Initialize an MSIdentity object with the given parameters and user info dictionary.
 *
 * @param firstName First name
 * @param lastName Last name
 * @param emailAddress Email address
 * @param userInfo Dictionary containining any user-specific information
 */
- (id)initWithFirstName:(NSString*)firstName lastName:(NSString*)lastName emailAddress:(NSString*)email userInfo:(NSDictionary*)userInfo;

@end
