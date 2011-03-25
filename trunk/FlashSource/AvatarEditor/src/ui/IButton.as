package ui 
{
	
	/**
	 * @author		钉崽[Dinboy]
	 * @copy		2010 © dinboy.com
	 * @version		v1.0 [2011-3-25 11:25]
	 */
	public interface IButton 
	{
		
		function get label():String;
		function set label(value:String):void;
		
		function get enabled():Boolean 
		function set enabled(value:Boolean):void 
		
		function addEventListener (type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void;

	
	
	
	
	
	//============================================
	//===== interface[IButton] Has Finish ======
	//============================================
	}
	
}