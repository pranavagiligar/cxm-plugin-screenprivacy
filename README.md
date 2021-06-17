# cordova-plugin-screenprivacy-cxm
Plugin can stop screenshot, screen capture and preview from app switcher

## Note: ios plugin not has block/unblock screenshot support   

## Installation
`cordova plugin add cordova-plugin-screenprivacy-cxm`

#### For local setup
  1. clone the repository to cordova directory 
  2. cordova plugin add ./cordova-plugin-screenprivacy-cxm

## Usage

```js
document.addEventListener("deviceready", onDeviceReady, false);
// To enable screenshot
function onDeviceReady() {
  window.plugins.screenprivacy.unblock(successCallback, errorCallback);
}
// To block screenshot
function onDeviceReady() {
  window.plugins.screenprivacy.block(successCallback, errorCallback);
}

// {"message": "success or failure", "reason": "reason in case of error"}
function successCallback(result) {
  console.log(result);
}

// {"message": "success or failure", "reason": "reason in case of error"}
function errorCallback(error) {
  console.log(error);
}

// Available events from the plugin
document.addEventListener("onTookScreenshot",function(){
    console.log('user took a screenshot');
});
document.addEventListener("onGoingBackground",function(){
    console.log('app went to background');
});
```