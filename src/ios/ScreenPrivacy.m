#import "ScreenPrivacy.h"
@interface ScreenPrivacy() {
    CDVInvokedUrlCommand * _eventCommand;
}
@end

@implementation ScreenPrivacy

- (void)pluginInitialize {

    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(appDidBecomeActive)
                                                name:UIApplicationDidBecomeActiveNotification
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(applicationWillResignActive)
                                                name:UIApplicationWillResignActiveNotification
                                              object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tookScreenshot)
                                                 name:UIApplicationUserDidTakeScreenshotNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(goingBackground)
                                                name:UIApplicationWillResignActiveNotification
                                              object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(screenCaptureStatusChanged)
                                                 name:kScreenRecordingDetectorRecordingStatusChangedNotification
                                               object:nil];
}

- (void)unblock:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult* pluginResult = nil;
}

- (void)listen:(CDVInvokedUrlCommand*)command {
    _eventCommand = command;
}

-(void) goingBackground {
    if(_eventCommand!=nil) {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"background"];
        [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:_eventCommand.callbackId];
    }
}

- (void)tookScreenshot {
    if(_eventCommand!=nil) {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"tookScreenshot"];
        [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:_eventCommand.callbackId];
    }
}

- (void)setupView {
    BOOL isCaptured = [[UIScreen mainScreen] isCaptured];

    if ([[ScreenRecordingDetector sharedInstance] isRecording]) {
        [self webView].alpha = 0.f;
    } else {
        [self webView].alpha = 1.f;
    }
}

- (void)appDidBecomeActive {
    [ScreenRecordingDetector triggerDetectorTimer];
}

- (void)applicationWillResignActive {
    [ScreenRecordingDetector stopDetectorTimer];
}

- (void)screenCaptureStatusChanged {
    [self setupView];
}

@end
