var plugin = {
  unblock: function (successCallback, errorCallback) {
    cordova.exec(successCallback, errorCallback, 'screenprivacy', 'unblock', []);
  },
  block: function (successCallback, errorCallback) {
    cordova.exec(successCallback, errorCallback, 'screenprivacy', 'block', []);
  },
  registerListener : function(callback) {
    // For webview to detect system events from plugin
    cordova.exec(callback, callback, 'screenprivacy', 'listen', []);
  }
}

cordova.addConstructor(function () {
  if (!window.plugins) {window.plugins = {};}
  window.plugins.screenprivacy = plugin;
  plugin.registerListener(function(sysEvent) {
    if(sysEvent === "background") {
      var event = new Event('onGoingBackground');
      document.dispatchEvent(event);
      return;
    }
    if(sysEvent === "tookScreenshot") {
      var event = new Event('onTookScreenshot');
      document.dispatchEvent(event);
      return;
    }
  });
  return window.plugins.screenprivacy;
});