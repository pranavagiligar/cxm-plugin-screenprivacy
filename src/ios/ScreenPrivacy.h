#import <Cordova/CDV.h>
#import "ScreenRecordingDetector.h"

@interface ScreenPrivacy : CDVPlugin

- (void)initiate:(CDVInvokedUrlCommand*)command;
- (void)unblock:(CDVInvokedUrlCommand*)command;
- (void)block:(CDVInvokedUrlCommand *)command;
- (void)listen:(CDVInvokedUrlCommand*)command;

@end
