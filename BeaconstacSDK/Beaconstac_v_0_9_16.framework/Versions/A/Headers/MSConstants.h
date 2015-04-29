//
//  MSConstants.h
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

#ifndef BeaconstacSDK_MSConstants_h
#define BeaconstacSDK_MSConstants_h

#ifdef USE_QA_SERVER
    #define URL_BASE @"https://beaconstac.qa.mobstac.com/api/1.0/"
#else
    #define URL_BASE @"https://beaconstac.mobstac.com/api/1.0/"
#endif
#define URL_RULE_PATH @"rules/"
#define URL_EVENTLOGGER_PATH @"eventlogger/"
#define URL_BEACON_PATH @"beacons/"

/**
 * SDK properties
 */
#define SDK_VERSION @"0.9.16"
#define EVENT_LOG_VERSION @1.1

/**
 * Beacon thresholds
 * @todo : These values should be fetched form a table based on the device type
 * iPhone shows a lower RSSI than iPod value under same condition
 */

#define RSSI_ENTRY_THRESHOLD -75  // Defines entry criteria
#define RSSI_EXIT_THRESHOLD -90   // Defines exit criteria

#endif
