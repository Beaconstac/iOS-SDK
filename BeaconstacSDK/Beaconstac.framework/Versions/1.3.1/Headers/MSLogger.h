//
//  MSLogger.h
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

/**
 * Provides control over BeaconstacSDK logging level.
 *
 * @code
 * [MSLogger sharedInstance]setLogLevel:MSLogLevelError]];
 * @endcode
 */
@interface MSLogger : NSObject

/**
 * Logging level enumeration
 */
typedef NS_ENUM (NSUInteger, MSLogLevel) {
    MSLogLevelNone = 0,
    MSLogLevelError = 1,
    MSLogLevelVerbose = 2,
    MSLogLevelDebug = 3,
    MSLogLevelEvents = 4
};

/**
 * Set desired logging level
 */
@property (nonatomic, assign) MSLogLevel loglevel;

/**
 * Set whether to log beacon and rule events
 */
@property (nonatomic) BOOL logEvents;

/**
 * Log a verbose message.
 */
- (void)verbose:(NSString*)message;

/**
 * Log an error message.
 */
- (void)error:(NSString*)message;

/**
 * Log a debug message.
 */
- (void)debug:(NSString*)message;

/**
 * Log all events.
 */
- (void)eventlog:(NSString*)message;

/**
 * This is a shared instance to see Logs being created.
 */
+ (MSLogger*)sharedInstance;


@end
