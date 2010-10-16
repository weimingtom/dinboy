package  
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @data $_DATA
	 * @author Dinboy.com
	 */
	public class LoaderExample extends Sprite
	{
		
		/**
		 * 加载文件的Loader;
		 */
		private var $loader:Loader;
		
		/**
		 * 使用数据流加载字节
		 */
		private var $URLStream:URLStream;
		
		/**
		 * 数据字节流数组
		 */
		private var $ByteArray:ByteArray;
		public function LoaderExample() 
		{
			this.$loader = new Loader();
			this.$URLStream = new URLStream();
			this.$ByteArray = new ByteArray();
			
			this.$URLStream.load(new URLRequest("ExampleImg.jpg"));
			
			this.addChild(this.$loader)
			//this.$loader.load(new URLRequest("ExampleImg.jpg"));
			//this.$loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onComplete, false, 0, true);
			this.$URLStream.addEventListener(ProgressEvent.PROGRESS, this.onProgress, false, 0, true);
		}
		
		/**
		 * 当完成加载时
		 * @param	evt
		 */
		private function  onComplete(evt:Event):void 
		{
			trace(this.$loader.width);
		}
		
		/**
		 * 实时加载
		 * @param	evt
		 */
		private function onProgress(evt:ProgressEvent):void 
		{
			var $oldByteArrayLen:int = this.$ByteArray.length;
			this.$URLStream.readBytes(this.$ByteArray, this.$ByteArray.length);
			if (this.$ByteArray.length>$oldByteArrayLen) 
			{
				this.$loader.loadBytes(this.$ByteArray);
			}
		}
		
		
		/********** [DINBOY] Say: Class The End  ************/	
	}

}