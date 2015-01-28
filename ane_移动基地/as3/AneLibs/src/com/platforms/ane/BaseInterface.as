package com.platforms.ane
{
	import flash.events.EventDispatcher;
	import flash.external.ExtensionContext;
	
	public class BaseInterface extends EventDispatcher
	{
		protected  var extContext:ExtensionContext = null;
		public function BaseInterface(_extContext:ExtensionContext)
		{
			extContext = _extContext;
		}
		public function dispose():void{
			extContext = null;
		}
	}
}