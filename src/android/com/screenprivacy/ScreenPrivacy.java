package com.screenprivacy;

import android.app.Activity;
import android.view.WindowManager;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.json.JSONArray;
import org.json.JSONException;

public class ScreenPrivacy extends CordovaPlugin {
    private static final String ACTION_BLOCK = "block";
    private static final String ACTION_UNBLOCK = "unblock";
    private ScreenPrivacy pluginContext;

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
        // Activity activity = this.cordova.getActivity();
    }

    @Override
    public boolean execute(
        String action,
        JSONArray data,
        final CallbackContext callbackContext
    ) throws JSONException {
        pluginContext = this;
        if (action.equals(ACTION_UNBLOCK)) {
            unblockScreenshot(callbackContext);
            return true;
        } else if (action.equals(ACTION_BLOCK)) {
            blockScreenshot(callbackContext);
            return true;
        } else return false;
    }

    private void blockScreenshot(final CallbackContext callbackContext) {
        pluginContext.cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                try {
                    if(android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.HONEYCOMB) {
                        pluginContext.cordova.getActivity().getWindow().setFlags(
                            WindowManager.LayoutParams.FLAG_SECURE,
                            WindowManager.LayoutParams.FLAG_SECURE
                        );
                    }
                    callbackContext.success("{\"message\": \"Screenshot Blocked\"}");
                } catch(Exception e){
                    callbackContext.error(
                        "{" 
                        + "\"message\": \"Couldn't block screenshot feature\", "
                        + "\"reason\": \"" + e.toString() + "\"" 
                        + "}"
                    );
                }
            }
        });
    }

    private void unblockScreenshot(final CallbackContext callbackContext) {
        pluginContext.cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                try {
                    if(android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.HONEYCOMB) {
                        pluginContext.cordova.getActivity().getWindow().clearFlags(
                            WindowManager.LayoutParams.FLAG_SECURE
                        );
                    }
                    callbackContext.success("{\"message\": \"Screenshot Enabled\"}");
                } catch(Exception e){
                    callbackContext.error(
                        "{" 
                        + "\"message\": \"Couldn't enable screenshot\", "
                        + "\"reason\": \"" + e.toString() + "\"" 
                        + "}"
                    );
                }
            }
        });
    }
}
