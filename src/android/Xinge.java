package com.github.bqluan.xinge;

import android.content.Context;
import android.util.Log;

import com.tencent.android.tpush.XGIOperateCallback;
import com.tencent.android.tpush.XGPushConfig;
import com.tencent.android.tpush.XGPushManager;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.LOG;
import org.json.JSONArray;
import org.json.JSONException;

public class Xinge extends CordovaPlugin {
    public static final String TAG = "Xinge";

    private static final String XG_ACCESS_ID = "XG_ACCESS_ID";
    private static final String XG_ACCESS_KEY = "XG_ACCESS_KEY";

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
        Context ctx = cordova.getActivity();
        long accessId = preferences.getInteger(XG_ACCESS_ID, 0);
        String accessKey = preferences.getString(XG_ACCESS_KEY, "");
        Log.d(TAG, "Initializing SDK with accessId " + accessId + " and accessKey " + accessKey + " ...");
        XGPushConfig.setAccessId(ctx, accessId);
        XGPushConfig.setAccessKey(ctx, accessKey);
    }

    /**
     * Executes the request and returns PluginResult.
     *
     * @param action          The action to execute.
     * @param args            JSONArry of arguments for the plugin.
     * @param callbackContext The callback id used when calling back into JavaScript.
     * @return True if the action was valid, false if not.
     */
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) {
        if ("registerDevice".equals(action)) {
            return registerDevice(args, callbackContext);
        } else if ("bindAccount".equals(action)) {
            return bindAccount(args, callbackContext);
        } else if ("unbindAccount".equals(action)) {
            return unbindAccount(args, callbackContext);
        } else {
            return false;
        }
    }

    //--------------------------------------------------------------------------
    // LOCAL METHODS
    //--------------------------------------------------------------------------

    private boolean registerDevice(JSONArray args, final CallbackContext callbackContext) {
        // run in background thread
        cordova.getThreadPool().execute(() -> {
            LOG.d(TAG, "registerDevice");
            XGPushManager.registerPush(
                    cordova.getActivity(),
                    new XGIOperateCallback() {
                        public void onSuccess(Object data, int flag) {
                            Log.d(TAG, "+++ . token: " + data);
                            callbackContext.success(data.toString());
                        }

                        public void onFail(Object data, int errCode, String msg) {
                            Log.d(TAG, "+++ register push fail. token: " + data
                                    + ", errCode: " + errCode + ", msg:"
                                    + msg);
                            callbackContext.error(msg);
                        }
                    });
        });
        return true;
    }

    private boolean bindAccount(JSONArray args, final CallbackContext callbackContext) {
        // run in background thread
        cordova.getThreadPool().execute(() -> {
            try {
                String account = args.getString(0);
                LOG.d(TAG, "bindAccount(\"" + account + "\")");
                XGPushManager.bindAccount(
                        cordova.getActivity(),
                        account,
                        new XGIOperateCallback() {
                            public void onSuccess(Object data, int flag) {
                                Log.d(TAG, "+++ . token: " + data);
                                callbackContext.success(data.toString());
                            }

                            public void onFail(Object data, int errCode, String msg) {
                                Log.d(TAG, "+++ register push fail. token: " + data
                                        + ", errCode: " + errCode + ", msg:"
                                        + msg);
                                callbackContext.error(msg);
                            }
                        });
            } catch (JSONException e) {
                callbackContext.error(e.getMessage());
            }
        });
        return true;
    }

    private boolean unbindAccount(JSONArray args, final CallbackContext callbackContext) {
        // run in background thread
        cordova.getThreadPool().execute(() -> {
            try {
                String account = args.getString(0);
                LOG.d(TAG, "unbindAccount(\"" + account + "\")");
                XGPushManager.delAccount(
                        cordova.getActivity(),
                        account,
                        new XGIOperateCallback() {
                            public void onSuccess(Object data, int flag) {
                                Log.d(TAG, "+++ . token: " + data);
                                callbackContext.success(data.toString());
                            }

                            public void onFail(Object data, int errCode, String msg) {
                                Log.d(TAG, "+++ register push fail. token: " + data
                                        + ", errCode: " + errCode + ", msg:"
                                        + msg);
                                callbackContext.error(msg);
                            }
                        });
            } catch (JSONException e) {
                callbackContext.error(e.getMessage());
            }
        });
        return true;
    }
}
