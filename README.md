# cxm-plugin-screenprivacy
Plugin can stop screenshot, screen capture and preview from app switcher on iOS and Android

## Installation [Stable]
`cordova plugin add cxm-plugin-screenprivacy@1.0.0`

#### For local setup / plugin development and enhancement
  1. clone the repository to cordova directory 
  2. cordova plugin add ./cxm-plugin-screenprivacy

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

// To block screen recording and screenshots in android and screen recording in ios
// Alternative: unblockAppScreen()
window.plugins.screenprivacy.blockAppScreen(
  successCallback, errorCallback
);

// Alternative: unblockAppSwitcher()
// To block only screens in app switcher on android and ios
window.plugins.screenprivacy.blockAppSwitcher({}, {});
```

Can activate both feature at the same time to enable full screen privacy that possibly provided by the playform