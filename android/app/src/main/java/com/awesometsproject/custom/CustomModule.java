package com.awesometsproject.custom;
import androidx.annotation.NonNull;

import com.awesometsproject.MainActivity;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import java.util.Map;
import java.util.HashMap;
import com.facebook.react.bridge.Promise;


public class CustomModule extends ReactContextBaseJavaModule {
    private static final String TAG = "CustomModule";
    private static ReactApplicationContext mReactApplicationContext;

    public CustomModule(@NonNull ReactApplicationContext reactContext) {
        super(reactContext);
        this.mReactApplicationContext=reactContext;

    }


    public static ReactApplicationContext  getReactContext(){
        return  mReactApplicationContext;
    }

    @NonNull
    @Override
    public String getName() {
        return "CustomModule";
    }

    @ReactMethod
    public void loadBundle(String name, Promise promise){
        try {
//            MainActivity mainActivity = (MainActivity) mReactApplicationContext.getCurrentActivity();
//            mainActivity.isAsset = false;
//            mainActivity.reloadScript();
            promise.resolve("reload script success:" + name);
        } catch (Exception e) {
            promise.reject("reload script failed:" + name, e);
        }

    }
}
