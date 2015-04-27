//
//  MSAnalytics.h
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
 * Provides a mechanism to send events to the analytics backend
 */
@interface MSAnalytics : NSObject

/**
 * Log an event
 * @param eventType A String that describes the type of the event. For instance, an event can be
 * ruleTriggeredEvent, ActionClicked event etc.
 * @param eventDictionary A dictionary associated to the event. This contains information that needs to be logged
 * with the associated eventType.
 */
- (void)logEventWithEventType:(NSString*)eventType andEventDictionary:(NSDictionary*)eventDictionary;

/**
 * Shared instance of MSAnalytics class
 */
+ (MSAnalytics*)sharedInstance;


@end
