package platforms
{
	import com.freshplanet.ane.AirFacebook.Facebook;
	import com.freshplanet.ane.AirGooglePlayGames.AirGooglePlayGames;
	import com.freshplanet.ane.AirGooglePlayGames.AirGooglePlayGamesEvent;
	import com.freshplanet.ane.AirInAppPurchase.InAppPurchase;
	import com.freshplanet.ane.AirInAppPurchase.InAppPurchaseEvent;
	import com.want.base.LanguageData;
	import com.want.notice.NoticeConst;
	import com.want.notice.NoticeManager;
	
	import flash.events.IOErrorEvent;
	import flash.events.StatusEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	//import AppsFlyerInterface;
	
	import starling.events.Event;
	
	
	public class GooglePlatform extends Platform
	{
		
		private static const googlePlayKey:String = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApFybrPfpJpZsgoj/RhiOrZZLpP4sNnjEVzHUYq7aSWzNCMGDZ2Bz/gonBteBB7+Z7bza2MEdyts0Z4mYnwKOVflQEygaX9dKqwU31vwJJ8BzxX4obhWWBkTlA/lK+VwQUPJuZzJ3TFu1DCAuMyBbw/j3p0AouQ2Ty5Szf/XKuhjZ2X7UcCnmpvgEAWIpzmAhbZ33ao0wCUWS+Kgmh4xDObb+aSqNxlU0klwhn+9vl4nz92x6HVzJ8y7UqCtT4v+d4Tzgo6xvrfpuvD8Xa4HjSOb74Kae+RDRrGNpQSfRyGkTT4zj0R----------------";
		private var debug:Boolean = true;
		private var productID:String ="cbs.lets.fight.00060";
		private var productStr:String ="cbs.lets.fight.";
		private var productIDArr:Array = [[60,"00060"],[300,"00300"],[600,"00600"],[1200,"01200"],[1920,"01920"],[4200,"04200"],[6000,"06000"]];
		
		private static const APP_ID:String = "1518397091772641";
		private static const PERMISSIONS:Array = [ "user_about_me", "publish_stream"];
//		private static const PERMISSIONS:Array = [ "user_about_me"];
		private static var isGoogle:Boolean =false;
		private var _facebook:Facebook;
		
		private var verifyURL:String = "http://djlogin.91ku.com/html/googlecallback/facebookGoogle2.php?app=11";
		private var loginURL:String = "http://djlogin.91ku.com/html/googlecallback/facebookGoogle2.php?act=4";
		private var logURL:String = "http://djlogin.91ku.com/html/googlecallback/facebookGoogle2.php?act=5";
		
		//private var afInterface:AppsFlyerInterface ;
		public function GooglePlatform()
		{
			initSDK();
			init();
			InitGame.instance.initGame();
		}
		
		/**重置游戏后调用*/
		override public function reset():void
		{
			init();
		}
		
		public function init():void{
			NoticeManager.instance.addNotice(NoticeConst.PF_PAY_FOR_COIN, onPay);
			NoticeManager.instance.addNotice(NoticeConst.PF_USER_LANDED, onLogin);
			NoticeManager.instance.addNotice(NoticeConst.GOOGLE_INTIVE, onIntive);
			NoticeManager.instance.addNotice(NoticeConst.GOOGLE_SHARE, onShare);
			NoticeManager.instance.addNotice(NoticeConst.GOOGLE_LOGIN, onFacebookLogin);
			//			NoticeManager.instance.addNotice(NoticeConst.EXIT_GAME, exitGame);
			//LoadManager.instance.showLogin(true);
		}
		
		/**登陆*/
		private function onLogin(evt:Event = null):void
		{
			httpLog("ConfigClient.functionState:"+ConfigClient.functionState);
			if(ConfigClient.functionState ==2)
			{
				faceBookLogin();
			}else{
				//afInterface.sendTrackingWithEvent("google+","login"); 
				if(!isGoogle){
					AirGooglePlayGames.getInstance().startAtLaunch();
				}else{
					AirGooglePlayGames.getInstance().signIn();
				}
				isGoogle = true;
			}
//			InAppPurchase.getInstance().restoreTransactions();
		}
		
		/**登陆*/
		private function onFacebookLogin(evt:Event = null):void
		{
			faceBookLogin();
		}
		
		/**邀请*/
		private function onIntive(evt:Event = null):void
		{
			Game.command.getIntive(getIntiveResult);
		}
		
		private function getIntiveResult(data:Object):void{
			if(int(data.data.error)==0){
				request({message:"key:"+data.data['invite_code']},function ():void{
					Game.command.getIntive(getIntiveResult);
				});
			}
		}
		
		/**分享*/
		private function onShare(evt:Event = null):void
		{
			share(null,function ():void{
				Game.command.shareResult(shareBack);
			});
		}
		
		private function shareBack(data:Object):void{
			if(data.data.error==0){
				Game.gameUser.mybeef+=int(data.data.power);
				Game.instance.mainui.refreshUI(4);
				Game.worldtip.addTips(LanguageData.getItemConfig(550100)['t23']+"+"+int(data.data.power));
			}
		}

		/**支付
		 * @param total        定额支付总金额，单位为人民币分
		 * @param unitName     虚拟货币名称
		 * @param count       购买虚拟货币数量
		 * @param callBackInfo 由游戏开发者定义传入的字符串，回与支付结果一同发送给游戏服务器，游戏服务器可通过该字段判断交易的详细内容（金额 角色等）
		 * @param callBackUrl  该比支付结果通知给游戏服务器时的通知地址url，交易结束后，系统会向该url发送http请求，通知交易的结果金额callbackInfo等信息*/
		private function onPay(evt:Event = null):void
		{
			httpLog("pay start");
			var data:Object = evt.data
			var total:int = data['credits'];				
			var callBackInfo:String = data['id'];				
			var unitName:String = data['name'];
			//var arr:Array = data['uid'].split('|');
			//			var paramRoleId:String = arr[0];
			//			var paramZoneId:int = arr[1];
			//var count:int = 1;
			//var callBackUrl:String = 'http://www.yourpayurl.com';
			httpLog("pay total:"+total);
			try{
				serverID = ConfigClient.SERVER_LIST_PLAT;
				var value :int = total;
				for(var i:int=0;i<7;i++)
				{
					if(productIDArr[i][0]==value)  productID = productStr + productIDArr[i][1];
				}
				InAppPurchase.getInstance().makePurchase(productID);
				httpLog("pay ----productID:"+productID);
			}
			catch(error:Error){
				httpLog("pay-----error");
			}
		}
		
		protected function initSDK():void
		{
			try
			{
				if(Facebook.isSupported)
				{
					_facebook = Facebook.getInstance();
					if(_facebook)
					{
						_facebook.addEventListener(StatusEvent.STATUS, handler_status);
						_facebook.init(APP_ID);
					}
				}
				InAppPurchase.getInstance().init(googlePlayKey,debug);
				InAppPurchase.getInstance().addEventListener(InAppPurchaseEvent.PURCHASE_DISABLED,purseBack);
				InAppPurchase.getInstance().addEventListener(InAppPurchaseEvent.PRODUCT_INFO_ERROR,purseBack);
				InAppPurchase.getInstance().addEventListener(InAppPurchaseEvent.PRODUCT_INFO_RECEIVED,purseBack);
				InAppPurchase.getInstance().addEventListener(InAppPurchaseEvent.PURCHASE_ENABLED,purseBack);
				InAppPurchase.getInstance().addEventListener(InAppPurchaseEvent.PURCHASE_ERROR,purseBack);
				InAppPurchase.getInstance().addEventListener(InAppPurchaseEvent.PURCHASE_SUCCESSFULL,purseBack);
				InAppPurchase.getInstance().addEventListener(InAppPurchaseEvent.RESTORE_INFO_RECEIVED,purseBack);
				InAppPurchase.getInstance().addEventListener(InAppPurchaseEvent.SUBSCRIPTION_DISABLED,purseBack);
				InAppPurchase.getInstance().addEventListener(InAppPurchaseEvent.SUBSCRIPTION_ENABLED,purseBack);				
				
				AirGooglePlayGames.getInstance().addEventListener(AirGooglePlayGamesEvent.ON_SIGN_IN_SUCCESS, onSignInSuccess);
				AirGooglePlayGames.getInstance().addEventListener(AirGooglePlayGamesEvent.ON_SIGN_OUT_SUCCESS, onSignOutSuccess);
				AirGooglePlayGames.getInstance().addEventListener(AirGooglePlayGamesEvent.ON_SIGN_IN_FAIL, onSignInFail);
				
				//afInterface = new AppsFlyerInterface();
				//afInterface.setDeveloperKey("WaSMDCZVThojxZBWyWweAT",null);
				//afInterface.sendTracking();
				
				//afInterface.sendTrackingWithEvent("startApp","start"); 
			}
			catch(error:Error)
			{
				
			}
		}
		
		protected function onSignInFail(event:AirGooglePlayGamesEvent):void
		{
			InitGame.instance.showLoginPage();
		}
		
		protected function onSignOutSuccess(event:AirGooglePlayGamesEvent):void
		{
			InitGame.instance.showLoginPage();
		}
		
		protected function onSignInSuccess(event:AirGooglePlayGamesEvent):void
		{
			ConfigClient.USER_ID = String(AirGooglePlayGames.getInstance().getActivePlayerName());
			InitGame.instance.loginPage();
		}

//*****************facebook    login*********************************************************************************
		public function faceBookLogin():void
		{
			//_facebook.closeSessionAndClearTokenInformation();
			_facebook.openSessionWithPublishPermissions(PERMISSIONS, handler_openSessionWithPermissions);
			//afInterface.sendTrackingWithEvent("facebook","login"); 
		}
		
		private function handler_openSessionWithPermissions($success:Boolean, $userCancelled:Boolean, $error:String = null):void
		{		
			try{
				_facebook.publishInstall(APP_ID);
			}catch(e:Error){
				
			}
			try
			{
				if($success)
				{
					var session:String = _facebook.accessToken;
					var url:String = loginURL+"&SessionId="+session;
					var reqs:URLRequest = new URLRequest(url);
					reqs.method = URLRequestMethod.POST;
					var loader:URLLoader = new URLLoader(reqs);
					loader.addEventListener(flash.events.Event.COMPLETE,onReceiptComplete);
					loader.addEventListener(IOErrorEvent.IO_ERROR, onReceiptError);
					loader.load(reqs);
					
					function onReceiptError(event:IOErrorEvent):void
					{
						InitGame.instance.showLoginPage();
					}
					
					function onReceiptComplete(event:flash.events.Event):void
					{
						if(loader.data!="0"&&loader.data!="")
						{
							ConfigClient.USER_ID = String(loader.data);
							ConfigClient.faceBookUid = ConfigClient.USER_ID;
							InitGame.instance.loginPage();
						}else{
							InitGame.instance.showLoginPage();
						}
					}
					
				}else{
					trace("login 失败");
					InitGame.instance.showLoginPage();
				}
			}
			catch(error:Error)
			{
				InitGame.instance.showLoginPage();
			}
		}
		
		protected function handler_status($evt:StatusEvent):void
		{	
		}
//**********************************log*****************************************************************
		private function httpLog(error:String = null):void
		{		
			try{
				var url:String = logURL+"&data="+error;
				var reqs:URLRequest = new URLRequest(url);
				reqs.method = URLRequestMethod.POST;
				var loader:URLLoader = new URLLoader(reqs);
				loader.addEventListener(flash.events.Event.COMPLETE,onReceiptComplete);
				loader.addEventListener(IOErrorEvent.IO_ERROR, onReceiptError);
				loader.load(reqs);
				
				function onReceiptError(event:IOErrorEvent):void
				{
					
				}
				
				function onReceiptComplete(event:flash.events.Event):void
				{
					
				}
			}catch(e:Error){
				
			}
		}
//******************************Google pay********************************************************************
		public function pay(info:Object):void
		{
			try{
				payStyle = int(info.rechargeMode);
				serverID = info.serverId;
				//orderId = uid+"!"+info.roleId+"_"+info.serverId+"_"+info.guiId;
				var value :int = int(info.rmb);
				if(payStyle==1)
					value =2;
				for(var i:int=0;i<7;i++)
				{
					if(productIDArr[i][0]==value)  productID = productStr + productIDArr[i][1];
				}
				InAppPurchase.getInstance().makePurchase(productID);
			}
			catch(error:Error){
				
			}
		}
		
		private function purseBack(e:InAppPurchaseEvent):void
		{
			httpLog("purseBack ----e.type:"+e.type +",......e.data:"+e.data);
			switch(e.type)
			{
				case InAppPurchaseEvent.PURCHASE_SUCCESSFULL:
					verifyURLfunc(e.data);
					break;
				case InAppPurchaseEvent.RESTORE_INFO_RECEIVED:
					verifyURLfunc(e.data);
					break;
			}
		}
		
		
		private var userID:String;
		private var serverID:String;
		
		private var payStyle:int=0;
		
		private function verifyPay(datas:String):void
		{
			var news:String = datas;
			verifyURLfunc(datas);
			
			try{
				while(datas.indexOf('"{') != -1){
					datas = datas.replace('"{', '{');
				}
				while(datas.indexOf('}"') != -1){
					datas = datas.replace('}"', '}');
				}
				var obj:Object = JSON.parse(datas); 
				var arr:Array = obj["purchases"] as Array;
				var jsonArr:Array = [];
				var startIndex:int;
				var endIndex:int;
				var i:int = 0;
				while(datas.indexOf('{"receiptType":') != -1){
					startIndex = datas.indexOf('{"receiptType":');
					if(datas.indexOf('"},{"')!=-1)
					{
						endIndex = datas.indexOf('"},{"');
					}else{
						endIndex = datas.indexOf('"}]}');
					}
					
					jsonArr[i] = datas.slice(startIndex+1, endIndex +1);
					jsonArr[i] = "{"+jsonArr[i]+"}";
					datas = datas.replace(jsonArr[i], "");
					i ++;
				}
				
				if(arr!=null)
				{
					for(var n:int=0;n<arr.length;n++)
					{
						var newdata:String =JSON.stringify(arr[n]);
						//verifyURLfunc(newdata,jsonArr[n]);
					}
				}
			}catch(e:Error){}
		}
		
		private function verifyURLfunc(data:String):void
		{
			var url:String = verifyURL+"&uid="+ConfigClient.USER_ID+"&serverID="+ConfigClient.SERVER_LIST_PLAT+"&data="+data+"&zoneID="+ConfigClient.ZONE_ID.toString();
			var reqs:URLRequest = new URLRequest(url);
			reqs.method = URLRequestMethod.POST;
			var loader:URLLoader = new URLLoader(reqs);
			loader.addEventListener(flash.events.Event.COMPLETE,onReceiptComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onReceiptError);
			loader.load(reqs);
			
			function onReceiptError(event:IOErrorEvent):void
			{
				trace("支付失败");
			}
			
			function onReceiptComplete(event:flash.events.Event):void
			{
				if(loader.data!="0"&&loader.data!="")
				{
					var back:String = loader.data;
					var isW:Boolean = false;
					while(back.indexOf('}{"receiptType":"GooglePlay"')!=-1)
					{
						var site:int = back.indexOf('}{"receiptType":"GooglePlay"');
						var news:String = back.slice(0,site) + "}";
						var obj1:Object = JSON.parse(news);
						removePFQ(obj1);
						isW = true;
						back = back.replace(news,"");
					}
					
					if(!isW)
					{
						var obj2:Object = JSON.parse(loader.data);
						removePFQ(obj2);
					}else{
						var obj3:Object = JSON.parse(back);
						removePFQ(obj3);
					}
					
					trace("支付成功");
					
				}else{
					trace("支付失败");
					//验证失败
				}
			}
		}
		
		private function removePFQ(obj:Object):void
		{
			var receipt:Object = obj["receipt"];
			var productId:String = obj["productId"];
			InAppPurchase.getInstance().removePurchaseFromQueue(productId, JSON.stringify(receipt));
			//afInterface.sendTrackingWithEvent("purchase",productId); 
		}
		
//*********************************邀请************************************************************************
		private var requestCallback:Function;
		public function request(obj:Object, callback:Function=null):void
		{
			var params:Object = { message: "7HJk98998   (这个参数就是 key)  " };
			requestCallback = callback;
			_facebook.dialog("apprequests", obj, handler_requesetWithGraphPath, true);
		}
		
		private function handler_requesetWithGraphPath($data:Object=null):void
		{
			//trace("handler_requesetWithGraphPath:", JSON.stringify($data)); 
			if($data&&$data.hasOwnProperty("params"))
			{
				if(requestCallback!=null)
					requestCallback($data.params);
			}
		}
		
		private function handler_feed_dialog($data:Object=null):void
		{
			//trace("handler_feed_dialog:", JSON.stringify($data)); 
			if($data&&$data.hasOwnProperty("params"))
			{
				if(shareCallback!=null)
					shareCallback($data.params);
			}
		}
//****************************分享***************************************************
		private var shareCallback:Function;
		public function share(obj:Object,callback:Function):void
		{
			var params:Object = {
				name:"大家一起上",
				description:"Come on！Let's fight！",
				link: "https://www.facebook.com/pcs.fight",
				picture:"https://fbcdn-sphotos-h-a.akamaihd.net/hphotos-ak-xpf1/v/t1.0-9/10806302_862695980419569_1266707511965053078_n.jpg?oh=8528e3091575e345d6c2f0b7d5b62094&oe=55335926&__gda__=1428394316_6db5addbb231fb6c25868c45d4d942e9",
				caption: "酷酷网络"
			};
			if(obj==null) obj = params;
			shareCallback = callback;
			_facebook.dialog("feed", obj, handler_feed_dialog, true);
		}
	}
}