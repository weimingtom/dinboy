package com.dinboy.events 
{
	import flash.events.Event;
	
	/**
	 * 关闭对话框时
	 */
	[Event(name = "prompt_close", type = "com.dinboy.events.PromptEvent")] 
	
	/**
	 * 打开对话框时
	 */
	[Event(name = "prompt_open", type = "com.dinboy.events.PromptEvent")]
	
	/**
	 * 同意
	 */
	[Event(name = "prompt_agree", type = "com.dinboy.events.PromptEvent")]

	/**
	 * 取消
	 */
	[Event(name = "prompt_cancel", type = "com.dinboy.events.PromptEvent")]
	
	/**
	 * @author		钉崽[dinboy]
	 * @copy		dinboy © 2010
	 * @version		v1.0 [2010-11-8 17:28]
	 */
	public class PromptEvent extends Event 
	{
		/**
		 * 关闭对话框时
		 */
		public static const  PROMPT_OPEN:String = "prompt_open";
		
		/**
		 * 打开时
		 */
		public static const PROMPT_ClOSE:String = "prompt_close";
		
		/**
		 * 确定时
		 */
		public static const PROMPT_AGREE:String = "prompt_agree";
		
		/**
		 * 取消时
		 */
		public static const PROMPT_CANCEL:String = "prompt_cancel";
		
		
		
		
		/**
		 * 对话框事件
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 */
		public function PromptEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new PromptEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("PromptEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
	
	
	
	
	
	//============================================
	//===== EventClass[PromptEvent] Has Finish ======
	//============================================
	}
	
}