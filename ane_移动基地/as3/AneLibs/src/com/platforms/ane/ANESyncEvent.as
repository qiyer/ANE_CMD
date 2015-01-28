package com.platforms.ane
{
	import flash.events.Event;
	
	public class ANESyncEvent extends Event
	{
		public static const ANE_SYSC_EVENT:String = "ane_sysc_event";
		
		public static const ANE_INIT:String = "ane_init";
		
		public static const LOGIN_SUCESS:String = "login_sucess"; 
		public static const LOGIN_FAIL:String = "login_fail";
		public static const PAY_SUCESS:String = "pay_sucess";
		public static const PAY_FAIL:String = "pay_fail";
		public static const EXIT:String = "exit";
		public static const EXIT_CANCEL:String = "onCancelExit";
		
		public function ANESyncEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		public var code:String;
		public var level:String;
	}
}