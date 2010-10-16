package  
{
	import com.dinboy.net.DinURLLoader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	/**
	 * ...
	 * @author Dinboy.com
	 * @copy CopyRight © 2010 DinBoy
	 */
	public class DinURLLoaderExample extends Sprite
	{
		
		private var $DinURLLoader:DinURLLoader;
		
		public function DinURLLoaderExample() 
		{
			$DinURLLoader = new DinURLLoader();
			$DinURLLoader.ignoreError = true;
//			trace($DinURLLoader.ignoreError);
			$DinURLLoader.addEventListener(Event.COMPLETE, completeHandler);
			$DinURLLoader.addEventListener(ProgressEvent.PROGRESS,progressHandler);
			$DinURLLoader.loadStream("http://localhost/bin/");
		}
		
		private function  completeHandler(evt:Event):void 
		{
		//	trace($DinURLLoader.data);
		}
		
		private function progressHandler(evt:ProgressEvent):void 
		{
			trace($DinURLLoader.weightPercent);
		}
		
		/********** [DINBOY] Say: Class The End  ************/	
	}

}