package com.dinboy.net 
{
	import com.dinboy.net.resource.Resource;
	import flash.events.EventDispatcher;
	import com.dinboy.net.events.LoaderEvent;
	
	/**
	 * ...
	 * @author 钉崽 [dinboy]
	 */
	public class LoadItem extends EventDispatcher 
	{
		/**
		 * 加载的资源
		 */
		public var resource:Resource;
		
		/**
		 * 进度
		 */
		public var percent:Number;
		
		/**
		 * 计时器编号
		 */
		private var _intervalID:uint;
		
		public function LoadItem() 
		{
			
		}
		
		/**
		 * 开始进行报告计时器
		 */
		public function startReportTimer() : void
		{
			stopReportTimer();
			_intervalID = setInterval(handleTimeComplete, 5000);
		}

		/**
		 * 关闭报告计时器
		 */
		public function stopReportTimer() : void
		{
			if (_intervalID)
			{
				clearInterval(_intervalID);
				_intervalID = 0;
			}
		}

		/**
		 * 计时器执行的函数
		 */
		private function handleTimeComplete() : void
		{
			stopReportTimer();
			dispatchEvent(new LoaderEvent(LoaderEvent.ERROR));
		}
		
	}

}