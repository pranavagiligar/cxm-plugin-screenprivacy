# cxm-plugin-screenprivacy
Plugin can stop screenshot, screen capture and preview from app switcher on Android and can stops preview from app switcher on iOS

## Installation [Stable]
`cordova plugin add cxm-plugin-screenprivacy@2.0.0`
Also works as Capacitor plugin

#### For local setup / plugin development and enhancement
  1. clone the repository to cordova directory 
  2. cordova plugin add ./cxm-plugin-screenprivacy

## Warning: Backwad version breaking!
Due to problems with iOS implementation, in his version iOS doesnt provide screen recording and sreenshot privacy and it is only avaiable for android. For iOS screen record prevention feature go back to version 1.1.0

## Usage

```js
// {"message": "success or failure", "reason": "reason in case of error"}
function successCallback(result) {
  console.log(result);
}

// {"message": "success or failure", "reason": "reason in case of error"}
function errorCallback(error) {
  console.log(error);
}

// To block screen recording and screenshots in android
// Alternative: unblockAppScreen()
window.plugins.screenprivacy.blockAppScreen(
  successCallback, errorCallback
);

// Alternative: unblockAppSwitcher()
// To block only screens in app switcher on android and ios
window.plugins.screenprivacy.blockAppSwitcher({}, {});
```

Can activate both feature at the same time to enable full screen privacy that possibly provided by the platform

Thanks to [flotrugliocoffice](https://github.com/flotrugliocoffice/cordova-plugin-prevent-screenshot-coffice)