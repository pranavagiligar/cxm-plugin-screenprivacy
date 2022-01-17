package com.screenprivacy;

import android.app.Activity;
import android.view.WindowManager;
import android.widget.Toast;

import android.graphics.Color;
import android.view.ViewGroup;
import android.widget.LinearLayout;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.drawable.BitmapDrawable;
import android.renderscript.Allocation;
import android.renderscript.RenderScript;
import android.renderscript.ScriptIntrinsicBlur;
import android.view.View;
import android.view.ViewTreeObserver;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.json.JSONArray;
import org.json.JSONException;

public class ScreenPrivacy extends CordovaPlugin {
    private static final String ACTION_BLOCK = "block";
    private static final String ACTION_UNBLOCK = "unblock";
    private static final String ACTION_BLOCK_APP_SWITCHER = "block_app_switcher";
    private static final String ACTION_UNBLOCK_APP_SWITCHER = "unblock_app_switcher";
    private ScreenPrivacy pluginContext;

    LinearLayout layout;
    ViewGroup parentView;
    boolean featureEnabled = false;
    boolean shouldBlock = false;

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
        parentView = (ViewGroup) webView.getView().getParent();
        layout = new LinearLayout(this.cordova.getActivity().getApplicationContext());
        layout.setLayoutParams(
            new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT
            )
        );
        layout.setOrientation(LinearLayout.VERTICAL);
        layout.setBackgroundColor(Color.parseColor("#000000"));
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
        } else if (action.equals(ACTION_BLOCK_APP_SWITCHER)) {
            blockAppSwitcher(callbackContext);
            return true;
        } else if (action.equals(ACTION_UNBLOCK_APP_SWITCHER)) {
            unblockAppSwitcher(callbackContext);
            return true;
        } else return false;
    }

    @Override
    public void onPause(boolean multitasking) {
        if (shouldBlock) {
            parentView.addView(layout);
            featureEnabled = true;
        }
    }

    @Override
    public void onResume(boolean multitasking) {
        if (featureEnabled) {
            parentView.removeView(layout);
            featureEnabled = false;
        }
    }

    private void blockAppSwitcher(final CallbackContext callbackContext) {
        shouldBlock = true;
        callbackContext.success("{\"message\": \"AppSwitcher view Blocked\"}");
    }

    private void unblockAppSwitcher(final CallbackContext callbackContext) {
        shouldBlock = false;
        callbackContext.success("{\"message\": \"AppSwitcher view enabled\"}");
    }

    // blocks screenshot and screen recording
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
