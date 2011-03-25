package events 
{
	import flash.events.Event;
	
	/**
	 * @author		钉崽[Dinboy]
	 * @copy		2010 © dinboy.com
	 * @version		v1.0 [2011-3-25 17:16]
	 */
	public class ScaleSliderEvent extends Event 
	{
		/**
		 * 当拖拽结束时调度
		 */
		public static const DRAGE_COMPLETE:String = "drageComplete";
		
		/**
		 * 拖拽进行时
		 */
		public static const DRAGE_PROGRESS:String = "drageProgress";
		
		public function ScaleSliderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new ScaleSliderEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ScaleSliderEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
	
	
	
	
	
	//============================================
	//===== EventClass[ScaleSliderEvent] Has Finish ======
	//============================================
	}
	
}