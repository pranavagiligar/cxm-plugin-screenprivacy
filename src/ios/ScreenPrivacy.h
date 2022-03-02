#import <Cordova/CDV.h>

@interface ScreenPrivacy : CDVPlugin

- (void)unblock_app_switcher:(CDVInvokedUrlCommand*)command;
- (void)block_app_switcher:(CDVInvokedUrlCommand*)command;
- (void)initIosSnapShotListeners:(CDVInvokedUrlCommand*)command;

@end
