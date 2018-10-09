package com.github.bqluan.xinge;

import android.util.Log;

import org.apache.cordova.CordovaWebView;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaInterface;
import org.json.JSONArray;
import org.json.JSONException;

import com.tencent.android.tpush.XGIOperateCallback;
import com.tencent.android.tpush.XGPushManager;

public class Xinge extends CordovaPlugin {
    public static final String TAG = "Xinge";

    /**
     * Constructor.
     */
    public Xinge() {
    }

    /**
     * Sets the context of the Command. This can then be used to do things like
     * get file paths associated with the Activity.
     *
     * @param cordova The context of the main Activity.
     * @param webView The CordovaWebView Cordova is running in.
     */
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
    }

    /**
     * Executes the request and returns PluginResult.
     *
     * @param action            The action to execute.
     * @param args              JSONArry of arguments for the plugin.
     * @param callbackContext   The callback id used when calling back into JavaScript.
     * @return                  True if the action was valid, false if not.
     */
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) {
        if ("registerPush".equals(action)) {
            return registerPush(args, callbackContext);
        } else {
            return false;
        }
    }

    //--------------------------------------------------------------------------
    // LOCAL METHODS
    //--------------------------------------------------------------------------

    private boolean registerPush(JSONArray args, final CallbackContext callbackContext) {
        // run in background thread
        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                try {
                    XGPushManager.registerPush(
                        cordova.getActivity(),
                        args.getString(0), // account
                        new XGIOperateCallback() {

                            @Override
                            public void onSuccess(Object data, int flag) {
                                Log.w(TAG, "+++ . token: " + data);
                                callbackContext.success(data.toString());
                            }

                            @Override
                            public void onFail(Object data, int errCode, String msg) {
                                Log.w(TAG, "+++ register push fail. token: " + data
                                        + ", errCode: " + errCode + ", msg:"
                                        + msg);
                                callbackContext.error(msg);
                            }
                        });
                } catch (JSONException e) {
                    callbackContext.error(e.getMessage());
                }
            }
        });
        return true;
    }
}
