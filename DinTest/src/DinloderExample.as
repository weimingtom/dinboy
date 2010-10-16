package  
{
	import com.dinboy.net.DinLoader;
	import flash.display.Sprite;
	import flash.events.ProgressEvent;
	
	/**
	 * ...
	 * @author Dinboy.com
	 * @copy CopyRight © 2010 DinBoy
	 */
	public class DinloderExample extends Sprite
	{
		
		private var $DinLoader:DinLoader;
		
		public function DinloderExample() 
		{
			this.$DinLoader = new DinLoader();
			
			
			this.$DinLoader.url = "ExampleImg.jpg";
			this.$DinLoader.loadStream();
			this.$DinLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, this.progressHandler, false, 0, true);
			this.addChild($DinLoader);
		}
		
		private function  progressHandler(e:ProgressEvent):void 
		{
			trace(e.bytesLoaded);
		}
		
		
		/********** [DINBOY] Say: Class The End  ************/	
	}

}