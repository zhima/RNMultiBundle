package com.awesometsproject;


import com.facebook.react.ReactActivity;


import java.io.File;

public class MainActivity extends ReactActivity {

  /**
   * Returns the name of the main component registered from JavaScript. This is used to schedule
   * rendering of the component.
   */
  @Override
  protected String getMainComponentName() {
    return "AwesomeTSProject";
  }

//  @Override
//  protected RnBundle getBundle() {
//    if (isAsset) {
//      RnBundle bundle = new RnBundle();
//      bundle.scriptType = ScriptType.ASSET;
//      bundle.scriptPath = "index.busn1.bundle";
//      bundle.scriptUrl = "index.busn1.bundle";
//      return bundle;
//    } else {
//      RnBundle bundle = new RnBundle();
//      bundle.scriptType = ScriptType.FILE;
//      bundle.scriptPath = "codeScript" + File.pathSeparator + "index2.android.bundle";
//      bundle.scriptUrl = "index2.android.bundle";
//      return bundle;
//    }
//  }
}
