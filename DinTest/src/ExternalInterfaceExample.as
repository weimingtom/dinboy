package  
{
	import flash.display.Sprite;
	import flash.external.ExternalInterface;
	

	/**
	 * @author		钉崽[Dinboy]
	 * @copy		2010 © dinboy.com
	 * @version		v1.0 [2011-5-4 14:35]
	 */
	public class ExternalInterfaceExample extends Sprite
	{
		
		public function ExternalInterfaceExample() 
		{
			if (ExternalInterface.available) 
			{
				ExternalInterface.addCallback("callBack",callBackMethod);
			}
		}
		
		private function callBackMethod(object:Object):void 
		{
			for (var name:String in object) 
			{
				trace(name + " in object is " + object[name]);
			}
		}






	//============================================
	//===== Class[ExternalInterfaceExample] Has Finish ======
	//============================================
	}

}