package events 
{
	import flash.events.Event;
	
	/**
	 * @author		钉崽[Dinboy]
	 * @copy		2010 © dinboy.com
	 * @version		v1.0 [2011-3-28 13:35]
	 */
	public class DragEvent extends Event 
	{
				
		/**
		 * 开始拖放
		 */
		public static const START_MOVE:String = "startMove";
		
		/**
		 * 当正在拖放时调度
		 */
		public static const DRAG_MOVING:String = "dragMoving";		
		
		/**
		 * 停止拖放
		 */
		public static const STOP_MOVE = "stopMove";
		
		/**
		 * 开始缩放
		 */
		public static const START_RESIZE:String = "startResize"; 
		
		/**
		 * 正在缩放
		 */
		public static const RESIZING:String = "resizing";	
		
		/**
		 * 停止缩放
		 */
		public static const STOP_RESIZE:String = "stopResize";
		
		public function DragEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new DragEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("DragEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
	
	
	
	
	
	//============================================
	//===== EventClass[DragEvent] Has Finish ======
	//============================================
	}
	
}