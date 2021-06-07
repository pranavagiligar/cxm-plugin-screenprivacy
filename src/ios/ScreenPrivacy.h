#import <Cordova/CDV.h>
#import "ScreenRecordingDetector.h"

@interface ScreenPrivacy : CDVPlugin

- (void)unblock:(CDVInvokedUrlCommand*)command;
- (void)listen:(CDVInvokedUrlCommand*)command;

@end
