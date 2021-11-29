#import <Cordova/CDV.h>
#import "ScreenRecordingDetector.h"

@interface ScreenPrivacy : CDVPlugin

- (void)unblock:(CDVInvokedUrlCommand*)command;
- (void)block:(CDVInvokedUrlCommand *)command;
- (void)unblock_app_switcher:(CDVInvokedUrlCommand*)command;
- (void)block_app_switcher:(CDVInvokedUrlCommand*)command;
- (void)initIosSnapShotListeners:(CDVInvokedUrlCommand*)command;
- (void)initIosScreenRecordListener:(CDVInvokedUrlCommand*)command;

@end
