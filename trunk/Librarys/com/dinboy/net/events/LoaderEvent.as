package com.dinboy.net.events 
{
	import flash.events.Event;
	import com.dinboy.net.LoadManager
	import flash.media.ID3Info;
	import com.dinboy.net.resource.Resource;
	
	/**
	 * ...
	 * @author 钉崽 [dinboy]
	 */
	public class LoaderEvent extends Event 
	{
		/**
		 * 加载管理器
		 */
		public var loader:LoadManager;
		
		/**
		 * 队列百分比
		 */
        public var percentQueue:Number;
		
		/**
		 * 百分比个数
		 */
        public var percentItem:Number;
		
		/**
		 * 消息
		 */
        public var msg:String = "";
		
		/**
		 * 正在加载的资源
		 */
        public var item:Resource;
		
		/**
		 * 队列资源的个数
		 */
        public var queue_count:int;
		
		/**
		 * 队列的总大小
		 */
        public var queue_length:int;
		
		/**
		 * 已经加载的字节数
		 */
        public var bytesLoaded:Number;
		
		/**
		 * 队列总字节数
		 */
        public var bytesTotal:Number;
		
		/**
		 * 媒体 ID3 元数据的属性
		 */
        public var id3Info:ID3Info;
		
		/**
		 * 失败的个数
		 */
        public var fail_count:int;
		
		/**
		 * 加载状态改变
		 */
        public static const STATUS_CHANGED:String = "dinboy.net.LoaderEvent.STATUS_CHANGED";
		
		/**
		 * ID3 完成时调度
		 */
        public static const ID3_COMPLETE:String = "dinboy.net.LoaderEvent.ID3_COMPLETE";
		
		/**
		 * 加载出错
		 */
        public static const ERROR:String = "dinboy.net.LoaderEvent.ERROR";
		
		/**
		 * 加载开始
		 */
        public static const START:String = "dinboy.net.LoaderEvent.START";
		
		/**
		 * 加载进行
		 */
        public static const PROGRESS:String = "dinboy.net.LoaderEvent.PROGRESS";
		
		/**
		 * 加载完成
		 */
        public static const COMPLETE:String = "dinboy.net.LoaderEvent.COMPLETE";
		
		/**
		 * 队列资源改变
		 */
        public static const QUEUE_CHANGED:String = "dinboy.net.LoaderEvent.QUEUE_CHANGED";
		
		/**
		 * 开始进行队列
		 */
        public static const QUEUE_START:String = "dinboy.net.LoaderEvent.QUEUE_START";
		
		/**
		 * 队列进行是
		 */
        public static const QUEUE_PROGRESS:String = "dinboy.net.LoaderEvent.QUEUE_PROGRESS";
		
		/**
		 * 队列完成
		 */
        public static const QUEUE_COMPLETE:String = "dinboy.net.LoaderEvent.QUEUE_COMPLETE";
		
		public function LoaderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new LoaderEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("LoaderEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}