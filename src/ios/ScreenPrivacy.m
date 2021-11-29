#import "ScreenPrivacy.h"
// #define MY_ALERT(str) [[[UIAlertView alloc] initWithTitle:@"System Alert" message:str delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show]

@interface ScreenPrivacy() {
    CDVInvokedUrlCommand * _eventCommand;
}
@end

@implementation ScreenPrivacy
UIImageView* cover;
BOOL screenPrivacyEnabled = NO;
BOOL shouldBlockSnapshot = NO;
BOOL shouldBlockRecording = NO;

BOOL isSnapshotRegistered = NO;
BOOL isRecordingRegistered = NO;

- (void)pluginInitialize {
    
}

- (void)initIosSnapShotListeners:(CDVInvokedUrlCommand *)command
{
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(appDidBecomeActive)
                                                name:UIApplicationDidBecomeActiveNotification
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(applicationWillResignActive)
                                                name:UIApplicationWillResignActiveNotification
                                              object:nil];
    isSnapshotRegistered = YES;
}

- (void)initIosScreenRecordListener:(CDVInvokedUrlCommand *)command
{
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(screenCaptureStatusChanged)
                                                name:kScreenRecordingDetectorRecordingStatusChangedNotification
                                              object:nil];
    isRecordingRegistered = YES;                           
}

// block screen recording
- (void)block:(CDVInvokedUrlCommand *)command
{
    shouldBlockRecording = YES;
    if (!isSnapshotRegistered) {
        [self initIosSnapShotListeners:command];
    }
    if (!isRecordingRegistered) {
        [self initIosScreenRecordListener:command];
    }
}

- (void)unblock:(CDVInvokedUrlCommand *)command
{
    shouldBlockRecording = NO;
    [ScreenRecordingDetector triggerDetectorTimer];
}

- (void)block_app_switcher:(CDVInvokedUrlCommand *)command
{
    shouldBlockSnapshot = YES;
    if (!isSnapshotRegistered) {
        [self initIosSnapShotListeners:command];
    }
}

- (void)unblock_app_switcher:(CDVInvokedUrlCommand *)command
{
    shouldBlockSnapshot = NO;
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
    NSLog(@"SP:Active");
    // if (shouldBlockRecording) {
        [ScreenRecordingDetector triggerDetectorTimer];
    // }
    
    if (screenPrivacyEnabled) {
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
        screenPrivacyEnabled = NO;
    }
}

- (void)applicationWillResignActive {
    NSLog(@"SP:ResignActive");
    // if (shouldBlockRecording) {
        [ScreenRecordingDetector stopDetectorTimer];
    // }

    if (shouldBlockSnapshot) {
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
        screenPrivacyEnabled = YES;
    }
}

- (void)screenCaptureStatusChanged {
    if (shouldBlockRecording) {
        [self setupView];
    }
}

@end
