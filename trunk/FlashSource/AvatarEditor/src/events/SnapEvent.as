package events 
{
	import flash.events.Event;
	
	/**
	 * @author		钉崽[Dinboy]
	 * @copy		2010 © dinboy.com
	 * @version		v1.0 [2011-3-25 12:28]
	 */
	public class SnapEvent extends Event 
	{
		/**
		 * 数据已经锁定
		 */
		public static const SNAPED:String = "snaped";
		public function SnapEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new SnapEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("SnapEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
	
	
	
	
	
	//============================================
	//===== EventClass[SnapEvent] Has Finish ======
	//============================================
	}
	
}