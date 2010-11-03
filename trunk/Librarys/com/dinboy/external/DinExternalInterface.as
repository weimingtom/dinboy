package com.dinboy.external 
{
	import flash.external.ExternalInterface;

	/**
	 * @author		钉崽[dinboy]
	 * @copy		dinboy © 2010
	 * @version		v1.0 [2010-11-1 10:40]
	 */
	public class DinExternalInterface
	{
		/**
		 * 替换flash默认JS于AS的方法
		 */
		public function DinExternalInterface() 
		{
			
		}
		
		/**
		 *	调用JS参数,并返回JS传回的值
		 * @param	functionName	Js函数名称
		 * @param	...rest	附带的参数
		 * @return	Js返回值
		 */
		public static function jsCall(functionName:String,...rest):* 
		{
			if (ExternalInterface.available)
			{
				return ExternalInterface.call(functionName, rest);
			}
		}
		
		/**
		 * 从JS调用as内部方法,可传参
		 * @param	functionName	Js函数名称
		 * @param	closure				as内部函数名称
		 */
		public static function jsAddCallback(functionName:String,closure:Function):void
		{
			if (ExternalInterface.available)
			{
				ExternalInterface.addCallback(functionName, closure);
			}
		}
		
		/**
		 * 调用Js的alert
		 * @param	message alert的信息
		 */
		public static function alert(message:String):void 
		{
			if (ExternalInterface.available)
			{
				return ExternalInterface.call("alert", message);
			}
		}






	//============================================
	//===== Class[ExternalInterface] Has Finish ======
	//============================================
	}

}