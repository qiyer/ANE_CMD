package com.platforms.ane
{
	import flash.external.ExtensionContext;
	
	public class He extends BaseInterface
	{
		public function He(_extContext:ExtensionContext)
		{
			super(_extContext);
		}
		
		public function initializeApp( ):void
		{
			extContext.call(ANESyncEvent.ANE_INIT,1);
		}
		
		public function setExtraArguments( cparms:String ):void
		{
			extContext.call(ANESyncEvent.ANE_INIT, 2, cparms);
		}
		
		public function pay(useSms:Boolean , isReated:Boolean , bill:String , cparms:String ):void
		{
			extContext.call(ANESyncEvent.ANE_INIT, 3, useSms, isReated, bill, cparms);
		}
		
		public function viewMoreGames( ):void
		{
			extContext.call(ANESyncEvent.ANE_INIT,4);
		}
		
		public function exit( ):void
		{
			extContext.call(ANESyncEvent.ANE_INIT,5);
		}
	}
}