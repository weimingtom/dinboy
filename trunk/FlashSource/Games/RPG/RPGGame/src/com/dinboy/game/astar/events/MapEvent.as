package com.dinboy.game.astar.events 
{
	import flash.events.Event;
	
	/**
	 * @author		DinBoy
	 * @copy		钉崽 © 2010
	 * @version		v1.0 [2010-11-20 13:34]
	 */
	public class MapEvent extends Event 
	{
		
		/**
		 * 地图数据准备完成
		 */
		public static const MAP_READY:String = "mapReady";
		
		public function MapEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new MapEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("MapEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
	
	
	
	
	
	//============================================
	//===== EventClass[MapEvent] Has Finish ======
	//============================================
	}
	
}