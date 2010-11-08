package com.dinboy.events
{
	import flash.events.Event;
	public class dinFunction
	{
		
		public function  dinFunction():void 
		{
			trace("哈喽,这个函数不能实例化哦~~~");
		}
		
		/**
		 * 用在AddEventListener需要传参时
		 * @param	$fun    需要传参的方法
		 * @param	...arg  所传的参数
		 * @return   
		 */
		public static function applyFun($fun:Function,...arg):Function 
		{
			return function(e:Event):void{$fun.apply(null,[e].concat(arg))};
		}
		

		}
}