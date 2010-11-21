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
		 * 开始位置
		 */
		public var startX:uint;
		public var startY:uint;
		
		/**
		 * 人物的结束位置
		 */
		public var endX:uint;
		public var endY:uint;
		
		/**
		 * 地图数据准备完成
		 */
		public static const MAP_READY:String = "mapReady";
		
		/**
		 * 当点击地图并开始搜索路径时调度
		 */
		public static const MAP_SEARCHPATH:String="mapSearchPath"
		
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