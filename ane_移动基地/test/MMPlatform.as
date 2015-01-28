package platforms
{
	import com.platforms.ane.ANEHelper;
	import com.platforms.ane.ANESyncEvent;
	import com.want.notice.NoticeConst;
	import com.want.notice.NoticeManager;
	
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	import starling.events.Event;

	public class MMPlatform extends Platform
	{
		private var logURL:String = "http://server.91ku.com/html/googlecallback/facebookGoogle2.php?act=5";
		private static var isLogin:Boolean =false;
		
		public function MMPlatform()
		{
			ANEHelper.getInstance().setCallBack(callback);
			initSDK();
			reset();
		}
		

		/**重置游戏后调用*/
		override public function reset():void
		{
			init();
		}
	
	public function init():void{
		NoticeManager.instance.addNotice(NoticeConst.PF_PAY_FOR_COIN, onPay);
		NoticeManager.instance.addNotice(NoticeConst.PF_USER_LANDED, initSDK);
		NoticeManager.instance.addNotice(NoticeConst.EXIT_GAME, exitGame);

	}
		
		protected function initSDK(e:* =null):void
		{
			if(!isLogin){
				ANEHelper.getInstance().heSDK.initializeApp();
				InitGame.instance.initGame();
				isLogin = true;
			}
		}
			
		private function callback(type:String,level:String):void
		{
			switch(type)
			{
				case ANESyncEvent.LOGIN_SUCESS:
					ConfigClient.USER_ID =level;
					if(ConfigClient.USER_ID !=null &&ConfigClient.USER_ID !="0"){
						InitGame.instance.loginPage();
					}else{
						isLogin = false;
						initSDK();
					}

					break;
				case ANESyncEvent.LOGIN_FAIL:
					break;
				case ANESyncEvent.PAY_SUCESS:
					break;
				case ANESyncEvent.PAY_FAIL:
					break;
			}
		}
		
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
		
		private function onPay(e:Event):void
		{
			httpLog("移动基地：pay-start");
			var data:Object = e.data;
			var needPayCoins:Number = data.credits;
			var cooOrderSerial:String = data.guid;
			var productId:String = data.id;
			var productName:String = data.name;
			var productPrice:Number = needPayCoins;
			var serverid : String= ConfigClient.ZONE_ID.toString();
			if(serverid.length==1)
			{
				serverid = serverid+"---"
			}else if(serverid.length==2){
				serverid = serverid+"--"
			}else if(serverid.length==3){
				serverid = serverid+"-"
			}
			var payDescription:String = serverid+GuildIDManager.create();
			
			
			var cost:Array = [["001",6],["002",30],["003",98],["004",198],["005",328],["006",648]];
			var payid :String = "001";
			for(var i:int=0; i< cost.length ; i++)
			{
				if(cost[i][1] == productPrice)
					payid = cost[i][0];
			}
			httpLog("移动基地：pay:"+payid +",payDescription:"+payDescription);
			ANEHelper.getInstance().heSDK.pay(true,true,payid,payDescription);
			httpLog("移动基地：pay-end");
		}
		
		private function exitGame(e:Event):void
		{
			ANEHelper.getInstance().heSDK.exit();
			isLogin = false;
		}
		
	}
}