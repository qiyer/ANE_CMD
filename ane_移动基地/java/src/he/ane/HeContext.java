package com.he.ane;

import java.util.HashMap;
import java.util.Map;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;

public class HeContext extends FREContext {

	@Override
	public void dispose() {
		// TODO Auto-generated method stub

	}

	@Override
	public Map<String, FREFunction> getFunctions() {
		Log.e("qiyes", "100-2222");
		Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();
		functionMap.put("ane_init",new HeManager());
		return functionMap;
	}

}
