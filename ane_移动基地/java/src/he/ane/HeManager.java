package com.he.ane;

import android.util.Log;
import cn.cmgame.billing.api.BillingResult;
import cn.cmgame.billing.api.GameInterface;
import cn.cmgame.billing.api.LoginResult;
import cn.cmgame.billing.api.GameInterface.*;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class HeManager implements FREFunction {
	
	private static FREContext context = null;
	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1) {
		context = arg0;
		Log.e("qiyes", "10086");
		int style =0;
		try {
			style =arg1[0].getAsInt();
		} catch (Exception e1) {}
		switch(style)
		{
			case 1:	
			{
				Log.e("qiyes", "10086-1");
			    GameInterface.initializeApp(context.getActivity());

			    GameInterface.setLoginListener(context.getActivity(), new GameInterface.ILoginCallback(){
			      @Override
			      public void onResult(int loginResult, String userId, Object args) {
			    	 
			        System.out.println("Login.Result=" + userId);
			        if(loginResult == LoginResult.SUCCESS_EXPLICIT || loginResult==LoginResult.SUCCESS_IMPLICIT){
			        	dispatch("login_sucess",userId+"");
			        	 Log.e("qiyes", "sucess:"+userId);
			        }
			        if(loginResult == LoginResult.FAILED_EXPLICIT || loginResult==LoginResult.FAILED_IMPLICIT){
			        	dispatch("login_fail","FAILED_EXPLICIT");
			        	Log.e("qiyes", "FAILED_EXPLICIT");
			        }
			        if(loginResult == LoginResult.UNKOWN){
			        	dispatch("login_fail","UNKOWN");
			        	Log.e("qiyes", "UNKOWN");
			        }
			      }});
			    
//			    
//			    Intent intent = new Intent();
//			    intent.setClass(context.getActivity(), cn.cmgame.billing.api.GameOpenActivity.class);
//			    context.getActivity().startActivity(intent);
			    
			    Log.e("qiyes", "10086-3");
				/**SDK鍒濆鍖�*/
				break;
			}
			case 2:
			{
				String cpparam = "1";
				try {
					cpparam = arg1[1].getAsString();
				} catch (Exception e1) {}
				GameInterface.setExtraArguments(cpparam);

				break;
			}
			case 3:
			{
				Log.e("qiyes", "pay-1");
				Boolean useSms=false;
				Boolean isReapted=false;
				String bill ="";
				String cpparam ="";
				try {
					useSms= arg1[1].getAsBool();
					isReapted = arg1[2].getAsBool();
					bill = arg1[3].getAsString();
					cpparam= arg1[4].getAsString();

				} catch (Exception e1) {}
				
				
			    final IPayCallback payCallback = new IPayCallback() {
			        @Override
			        public void onResult(int resultCode, String billingIndex, Object obj) {
			        	Log.e("qiyes", "code:"+resultCode);
			          switch (resultCode) {
			            case BillingResult.SUCCESS:
			            	dispatch("pay_sucess","SUCCESS");
			              break;
			            case BillingResult.FAILED:
			            	dispatch("pay_fail","FAILED:"+resultCode+":"+billingIndex);
			              break;
			            default:
			            	dispatch("pay_fail","UNKOWN"+resultCode+":"+billingIndex);
			              break;
			          }
			        }
			      };
				 GameInterface.doBilling(context.getActivity(),useSms, isReapted, bill, cpparam, payCallback);
				 Log.e("qiyes", "pay-21");
				break;
			}
			case 4://
			{
				Log.e("qiyes", "view:");
				GameInterface.viewMoreGames(context.getActivity());
				break;
			}
			case 5://
			{
				GameInterface.exit(context.getActivity(), new GameExitCallback() {
					@Override
					public void onConfirmExit() {
						dispatch("exit","");
					}

					@Override
					public void onCancelExit() {
						dispatch("onCancelExit","");
					}
				});
				
				break;
			}
		}
		return null;
	}

	public static void dispatch(String eventName,String content)
	{
		if(context!=null)
		   context.dispatchStatusEventAsync(eventName, content);
	}
}
