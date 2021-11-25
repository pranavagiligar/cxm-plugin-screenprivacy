#import "ScreenPrivacy.h"
@interface ScreenPrivacy() {
    CDVInvokedUrlCommand * _eventCommand;
}
@end

@implementation ScreenPrivacy
UIImageView* cover;
BOOL screenPrivacyEnabled;

- (void)pluginInitialize {

    screenPrivacyEnabled = NO;
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

- (void)block:(CDVInvokedUrlCommand *)command
{
    screenPrivacyEnabled = YES;
}

- (void)listen:(CDVInvokedUrlCommand*)command {
    _eventCommand = command;
}

- (void)unblock:(CDVInvokedUrlCommand *)command
{
    screenPrivacyEnabled = NO;
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
    // if(cover!=nil) {
    //     [cover removeFromSuperview];
    //     cover = nil;
    // }
    if(cover!=nil) {
        UIView *blurEffectView = [cover viewWithTag:1234];

        // fade away colour view from main view
        [UIView animateWithDuration:0.5 animations:^{
            blurEffectView.alpha = 0;
        } completion:^(BOOL finished) {
            // remove when finished fading
            [blurEffectView removeFromSuperview];
        }];
        [cover removeFromSuperview];
        cover = nil;
    }
}

- (void)applicationWillResignActive {
    [ScreenRecordingDetector stopDetectorTimer];
    if(cover == nil) {
        cover = [[UIImageView alloc] initWithFrame:[self.webView frame]];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = cover.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

        blurEffectView.tag = 1234;
        blurEffectView.alpha = 0;
        cover.backgroundColor = [UIColor clearColor];
        [cover addSubview:blurEffectView];
        [cover bringSubviewToFront:blurEffectView];

        [UIView animateWithDuration:0.5 animations:^{
            blurEffectView.alpha = 1;
        }];
        [self.webView addSubview:cover];
    }
}

- (void)screenCaptureStatusChanged {
    [self setupView];
}

@end
