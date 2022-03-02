exports.unblockAppScreen = function (successCallback, errorCallback) {
    cordova.exec(successCallback, errorCallback, 'screenprivacy', 'unblock', []);
};
exports.blockAppScreen = function (successCallback, errorCallback) {
  cordova.exec(successCallback, errorCallback, 'screenprivacy', 'block', []);
};
exports.blockAppSwitcher = function (successCallback, errorCallback) {
  cordova.exec(successCallback, errorCallback, 'screenprivacy', 'block_app_switcher', []);
};
exports.unblockAppSwitcher = function (successCallback, errorCallback) {
  cordova.exec(successCallback, errorCallback, 'screenprivacy', 'unblock_app_switcher', []);
};
exports.initIosSnapShotListeners = function (successCallback, errorCallback) {
  cordova.exec(successCallback, errorCallback, 'screenprivacy', 'initIosSnapShotListeners', []);
};