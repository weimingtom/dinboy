package com.dinboy.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @data $(Data)
	 * @author Dinboy.com
	 */
	public class DinEvent extends Event 
	{
		/**
		 * 当文件未找到时
		 */
		public static const IO_ERROR:String = "IO_Error";
		
		public function DinEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new DinEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("DinEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		
		
		/********** [DINBOY] Say: Class The End  ************/
	}
	
}