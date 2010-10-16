package com.dinboy.tool 
{
	import flash.external.ExternalInterface;
	/**
	 * ...
	 * @data $_DATA
	 * @author Dinboy.com
	 */
	public class webtrace
	{
		
		public function webtrace() 
		{

		}
		
		/**
		 * 内容输出到网页上
		 * @param	$value	需要输出的内容
		 */
		public static function trace($value:Object):void 
		{
				if (ExternalInterface.available) 
				{
					ExternalInterface.call("alert", "I'm come from Flash :\n"+$value);
				}
		}
		
		
		
		/********** [DINBOY] Say: Class The End  ************/	
	}

}