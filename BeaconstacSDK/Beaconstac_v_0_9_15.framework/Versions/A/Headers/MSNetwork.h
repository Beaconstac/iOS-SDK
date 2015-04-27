//
//  MSNetwork.h
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
 * This class helps in communicating with Beaconstac REST API.
 */
@interface MSNetwork : NSObject

/**
 * Creates and runs a network operation with a 'GET' request
 * @param URLString The URL string used to create the request URL.
 * @param parameters The parameters to be sent as payload to the server.
 * @param CompletionBlock A block object to be executed when the request operation finishes successfully. It has three arguments: statusCode - The HTTP status code of the response, responseJSON - Serialized response from server, error - An NSError object describing the reason of failure, if any.
 */
+ (void)GET:(NSString*)URLString parameters:(id)params WithCompletionBlock:(void (^)(NSNumber *statusCode, NSDictionary *responseJson, NSError *error))completionBlock;

/**
 * Creates and runs a network operation with a 'POST' request
 * @param URLString The URL string used to create the request URL.
 * @param parameters The parameters to be sent as payload to the server.
 * @param CompletionBlock A block object to be executed when the request operation finishes successfully. It has three arguments: statusCode - The HTTP status code of the response, responseJSON - Serialized response from server, error - An NSError object describing the reason of failure, if any.
 */
+ (void)POST:(NSString*)URLString parameters:(id)params WithCompletionBlock:(void (^)(NSNumber *statusCode, NSDictionary *responseJson, NSError *error))completionBlock;

/**
 * Creates and runs a network operation with a 'PUT' request
 * @param URLString The URL string used to create the request URL.
 * @param parameters The parameters to be sent as payload to the server.
 * @param CompletionBlock A block object to be executed when the request operation finishes successfully. It has three arguments: statusCode - The HTTP status code of the response, responseJSON - Serialized response from server, error - An NSError object describing the reason of failure, if any.
 */
+ (void)PUT:(NSString*)URLString parameters:(id)params WithCompletionBlock:(void (^)(NSNumber *statusCode, NSDictionary *responseJson, NSError *error))completionBlock;

/**
 * Creates and runs a network operation with a 'DELETE' request
 * @param URLString The URL string used to create the request URL.
 * @param parameters The parameters to be sent as payload to the server.
 * @param CompletionBlock A block object to be executed when the request operation finishes successfully. It has three arguments: statusCode - The HTTP status code of the response, responseJSON - Serialized response from server, error - An NSError object describing the reason of failure, if any.
 */
+ (void)DELETE:(NSString*)URLString parameters:(id)params WithCompletionBlock:(void (^)(NSNumber *statusCode, NSDictionary *responseJson, NSError *error))completionBlock;

/**
 * This is a helper method for encoding the URL string. 
 * @param URLString Raw URL String
 * @return Encoded URL string
 */
+ (NSString *)encodeForURLString:(NSString *)URLString;

@end
