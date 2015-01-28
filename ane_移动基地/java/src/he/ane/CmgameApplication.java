package com.he.ane;

import android.app.Application;
import android.util.Log;

/**
 * Created by afwang on 13-9-17.
 */
public class CmgameApplication extends Application {
  public void onCreate() {
	 Log.e("qiyes", "0000");
    System.loadLibrary("megjb");
  }
}
