package com.dinboy.events
{
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author 钉崽 [DinBoy]  
	 */
	public class EventManager extends EventDispatcher
	{
		
		/**
		 * 本身
		 */
		private static var $eventManager:EventManager=null;
		
		public function EventManager() 
		{
			if ($eventManager!=null) 
			{
				trace("只能只有一个事件管理器( EventManager )");
				return;
			}
		}
		
		public static function get manager():EventManager 
		{
			if ($eventManager==null) 
			{
				$eventManager = new EventManager();
			}
			return $eventManager;
		}
		
	}

}