package platform
{
	import com._9ane.platform.BasePlatform;
	import com._9ane.platform.PlatformEvent;
	import com.adobe.crypto.MD5;
	import com.freshplanet.ane.AirFacebook.Facebook;
	import com.freshplanet.ane.AirInAppPurchase.InAppPurchase;
	import com.freshplanet.ane.AirInAppPurchase.InAppPurchaseEvent;
	import com.tapjoy.extensions.ITJEventCallback;
	import com.tapjoy.extensions.ITapjoyConnectRequestCallback;
	import com.tapjoy.extensions.TJEvent;
	import com.tapjoy.extensions.TJEventRequest;
	import com.tapjoy.extensions.TapjoyAIR;
	import com.tapjoy.extensions.TapjoyDisplayAdEvent;
	import com.tapjoy.extensions.TapjoyDisplayAdSize;
	import com.tapjoy.extensions.TapjoyEvent;
	import com.tapjoy.extensions.TapjoyMacAddressOption;
	import com.tapjoy.extensions.TapjoyPointsEvent;
	import com.tapjoy.extensions.TapjoyTransition;
	import com.tapjoy.extensions.TapjoyViewChangedEvent;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.StatusEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	import net.metaps.sdk.OfferwallAIRWrapper;
	import net.metaps.sdk.OfferwallOffer;
	import net.metaps.sdk.OfferwallReceiver;
	
	import zt.platform.PlatformManager;
	
	public class PlatformGoogleAndroid extends BasePlatform implements ITapjoyConnectRequestCallback,OfferwallReceiver
	{
		//private static const googlePlayKey:String = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzD2XsmJ9LcTTdt4IxY8IRtYioqY6emqcB2aLsYCiDZ6+klw09OY8zInaYof1OIEBo0ab4LFENzbdxiQQ1FAQ46+FnlvkO7CULypsJ7/rOJhQAkZisOUyyDujCx+OmAryKEQBhAiorZ/m0QwmmjyYTzVioEosPW55vQwirJj7NgHS3zLY4GpKg9JTHf5JECq/qrS0c33VKpjnckwDgbmf/8AG2VELjajYePhHrBQQQFFdVYelGzW5YA9JAEs9nQYMg8/Pw3kEfbNKfATzYcZ+TawF/yez8qrOFm6p03zsV6tyt3bxEbJy7zvqmYkErtpcXmikqmTdHomz8434/FPU7QIDAQAB";
		private static const googlePlayKey:String = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAoICWb6WLvyWzl1ZS6Zxy6S3z0eGuFpyEvH5i4xNjGDDHWp4qRe5XSBziD70TL0YKziCF5dYjT1lsdsNSjOAVHjd8URSZFlt3HZyRQJw814K5pZFxW0d2ckgWpiU3JP2lSh9IEQUR8lp04Wa9N2dF08Xt4rmB2K0MvlPxk8NRLs3rg/S2NPM0kJoqQ8z73hDd0QboJAcYWgj85hbW7LNmwD9lEzXClbS2yurAd9yvbWWGLV9JV6LGGPq5MCm51HWezXodv6P7wTTelas7FF2EPiVkXQdZq6z2hb8lncNWbeUxpcFZgPwhbk65nGi0C4u46nDBUNArZH+4r9QN+gfknQIDAQAB";
		private var debug:Boolean = false;
		private var productID:String ="1005";
		private var productStr:String ="auer.gp.xiawu_";
		private var productIDArr:Array = [[1,"00060"],[2,"00300"],[3,"00600"],[4,"01200"],[5,"01920"],[6,"04200"],[7,"06000"]];
		
		private var applicationId:String = "GELVJKLGCQ0001";
		private var mode:int = OfferwallAIRWrapper.SDK_MODE_TEST;
		
		private var extension:TapjoyAIR;
		private var APPID:String ="a0cd3ad5-10e8-4cff-9559-ebbde2d1d24c";
		private var APPKEY:String = "nPljrtWXMt3oD79zluja";
		
		private static const APP_ID:String = "526970174074820";
		//private static const PERMISSIONS:Array = [ "user_about_me", "publish_stream"];
		private static const PERMISSIONS:Array = [ "user_about_me"];
		private var _facebook:Facebook;
		
		private var verifyURL:String = "http://wuxia18la.e7play.com/facebookGoogle2.php?app=11";
		//private var verifyURL:String = "http://54.178.163.183/facebookGoogle2.php?app=11";
		
		public function PlatformGoogleAndroid()
		{
			super();
			//_isAanLogin = false;
			_isShowFriendRequest = true;
			_isWithinPay = false;
		}
		
		override public function init(info:Object):void
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
				
				OfferwallAIRWrapper.initialize(applicationId, this, mode);
				
				var connectFlags:Object = { };
				connectFlags["enable_logging"] = true;
				TapjoyAIR.requestTapjoyConnect(APPID, APPKEY, connectFlags, this);
				
			}
			catch(error:Error)
			{
				dispatchEvent(new PlatformEvent(PlatformEvent.Init_Error));
			}
		}
		
		private function purseBack(e:InAppPurchaseEvent):void
		{
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
		
		override public function gameLogin(obj:Object):void
		{			
			userID = obj.uid;
			serverID = String(obj.serverId);
			InAppPurchase.getInstance().restoreTransactions();
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
			var url:String = verifyURL+"&uid="+userID+"&serverID="+serverID+"&data="+data+"&mode="+payStyle;
			var reqs:URLRequest = new URLRequest(url);
			reqs.method = URLRequestMethod.POST;
			var loader:URLLoader = new URLLoader(reqs);
			loader.addEventListener(Event.COMPLETE,onReceiptComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onReceiptError);
			loader.load(reqs);
			
			function onReceiptError(event:IOErrorEvent):void
			{
				dispatchEvent(new PlatformEvent(PlatformEvent.Pay_Error));
			}
			
			function onReceiptComplete(event:Event):void
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

					//var obj:Object = JSON.parse(loader.data);

					//InAppPurchase.getInstance().removePurchaseFromQueue(productID,obj["receipt"]);
					dispatchEvent(new PlatformEvent(PlatformEvent.Pay_Complete));
					
				}else{
					dispatchEvent(new PlatformEvent(PlatformEvent.Pay_Error));
					//验证失败
				}
			}
		}
		
		private function removePFQ(obj:Object):void
		{
			var receipt:Object = obj["receipt"];
			var productId:String = obj["productId"];
			
			InAppPurchase.getInstance().removePurchaseFromQueue(productId, JSON.stringify(receipt));
		}
		
		override public function login():void
		{
			_facebook.closeSessionAndClearTokenInformation();
			_facebook.openSessionWithPublishPermissions(PERMISSIONS, handler_openSessionWithPermissions);
		}
		
		override public function fastLogin():void
		{
			_facebook.closeSessionAndClearTokenInformation();
			_facebook.openSessionWithPublishPermissions(PERMISSIONS, handler_openSessionWithPermissions);
		}
		
		private function handler_openSessionWithPermissions($success:Boolean, $userCancelled:Boolean, $error:String = null):void
		{
			if($success)
			{
				_facebook.publishInstall(APP_ID);
				_platformSession = _facebook.accessToken;
				_isLogined = true;
				dispatchEvent(new PlatformEvent(PlatformEvent.Login_Complete));
			}else{
				dispatchEvent(new PlatformEvent(PlatformEvent.Login_Out));
			}
		}
		
		protected function handler_status($evt:StatusEvent):void
		{
		}
		
		override public function pay(info:Object):void
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
				dispatchEvent(new PlatformEvent(PlatformEvent.Pay_Error));
			}
		}
		
		public function connectSucceeded():void {
		}
		
		public function connectFailed():void
		{
		}
		public function sendEventSucceeded(tjEvent:TJEvent, contentIsAvailable:Boolean):void
		{
		}
		
		public function sendEventFailed(tjEvent:TJEvent, error:String):void
		{
		}
		
		public function contentDidAppear(tjEvent:TJEvent):void
		{
		}
		
		public function contentDidDisappear(tjEvent:TJEvent):void
		{
		}
		
		public function didRequestAction(tjEventRequest:TJEventRequest):void
		{
		}
		
		public function retrieve(points:int, offer:OfferwallOffer) : void
		{
		}
		
		public function finalizeOnError(offer:OfferwallOffer) : void
		{
		}
		
		private var requestCallback:Function;
		override public function request(obj:Object, callback:Function=null):void
		{
			var params:Object = { message: "7HJk98998   (这个参数就是 key)  " };
			requestCallback = callback;
			_facebook.dialog("apprequests", obj, handler_requesetWithGraphPath, true);
		}
		
		private function handler_requesetWithGraphPath($data:Object=null):void
		{
			//Debug.trace("handler_requesetWithGraphPath:", JSON.stringify($data)); 
			if($data&&$data.hasOwnProperty("params"))
			{
				if(requestCallback!=null)
					requestCallback($data.params);
			}
		}
		
		private function handler_feed_dialog($data:Object=null):void
		{
			//Debug.trace("handler_feed_dialog:", JSON.stringify($data)); 
			if($data&&$data.hasOwnProperty("params"))
			{
				if(shareCallback!=null)
					shareCallback($data.params);
			}
		}
		
		private var shareCallback:Function;
		override public function share(obj:Object,callback:Function):void
		{
			var params:Object = {
				name:"六大派",
				description:"六大派是一个移动端rpg游戏，武侠大作。。。。。。。。。。。。。",
				link: "http://testportal2.e7play.com/apps_game/promote/dicebrotherhood/index.jsp",
				picture:"http://fun.e7play.com/promote/wuxia18/images/150xicon.png",
				caption: "墨竹网络"
			};
			shareCallback = callback;
			_facebook.dialog("feed", obj, handler_feed_dialog, true);
		}
		
		override public function loginBack(obj:Object):void
		{
			_facebookData="18la:"+ obj[0];
			_facebookData ="?data=" +MD5.hash(_facebookData);
		}
		
	}
}