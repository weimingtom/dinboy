package com.dinboy.game.astar.events 
{
	import flash.events.Event;
	
	/**
	 * @author		DinBoy
	 * @copy		钉崽 © 2010
	 * @version		v1.0 [2010-11-17 22:35]
	 */
	public class PlayerEvent extends Event 
	{
		/**
		 * 人物已经初始化完成
		 */
		public static const  PLAYER_INITED:String = "playerInited";
		
		/**
		 * 人物站立的横坐标
		 */
		public var standX:uint;
		
		/**
		 * 人物站立的纵坐标
		 */
		public var standY:uint;
		
		public function PlayerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new PlayerEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("PlayerEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
	
	
	
	
	
	//============================================
	//===== EventClass[PlayerEvent] Has Finish ======
	//============================================
	}
	
}