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
BOOL isSnapshotRegistered = NO;

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

- (void)appDidBecomeActive {
    NSLog(@"SP:Active");  
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

@end
