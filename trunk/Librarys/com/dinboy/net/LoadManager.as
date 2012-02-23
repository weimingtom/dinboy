package com.dinboy.net 
{
	import com.dinboy.net.events.LoaderEvent;
	import com.dinboy.net.resource.Resource;
	import com.dinboy.net.resource.ResourceType;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author 钉崽 [dinboy]
	 */
	public class LoadManager extends EventDispatcher 
	{
		/**
		 * 加载队列
		 */
		private var _queue:Array;
		
		/**
		 * 加载地图
		 */
		private var _map:Dictionary;
		
		/**
		 * 队列个数
		 */
		private var _compleleQueueCount:int;
		
		/**
		 * 失败的队列个数
		 */
		private var _failQueueCount:int;
		
		/**
		 * 队列百分比
		 */
		private var _percentQueue:Number ;
		
		/**
		 * 加载器的上下文
		 */
		private var _loaderContext:LoaderContext;
		
		/**
		 * 加载器的状态
		 */
		private var _loadStatus:String;
		
		/**
		 * 事件数组
		 */
		private var _methods:Array;
		
		/**
		 * 最大进程数
		 */
		private var _maxThreadCount:uint;
		
		/**
		 * 加载中的进程数
		 */
		private var _loadingThreadCount:int;
		
		/**
		 * 状态为正在加载中
		 */
		public static const STATUS_LOADING:String = "loading";
		
		/**
		 * 状态为加载完毕
		 */
        public static const STATUS_STOPPED:String = "stopped";
		
		public function LoadManager() 
		{
			//初始化事件数组
			_methods = [LoaderEvent.COMPLETE, LoaderEvent.ERROR, LoaderEvent.ID3_COMPLETE, LoaderEvent.PROGRESS, LoaderEvent.QUEUE_CHANGED, LoaderEvent.QUEUE_COMPLETE, LoaderEvent.QUEUE_PROGRESS, LoaderEvent.QUEUE_START, LoaderEvent.START, LoaderEvent.STATUS_CHANGED];
			_maxThreadCount = 1;
			
			_loaderContext = new LoaderContext();
			_loaderContext.applicationDomain = ApplicationDomain.currentDomain;
		}
		
		/**
		 * 重置加载参数
		 */
		private function reset():void {
			_compleleQueueCount = 0;
			_failQueueCount = 0;
			_percentQueue = 0;
			
			_loadingThreadCount = 0;
			_map = new Dictionary();
			_queue = [];
			if (_loadStatus != STATUS_STOPPED)
            {
                setStatus(_loadStatus);
            }
		}
		
		/**
		 * 清除事件
		 * @param	event
		 */
		private function clear(event:Event = null):void 
		{
			clearCurrentItem(event);
			if (!_failQueueCount) 
			{
				reset();
			}
		}
		
		/**
		 * 设置加载状态
		 * @param	value 状态值
		 */
		private function setStatus(value:String):void 
		{
			_loadStatus = value;
		}
		
		//=============================================================================		
		//=============================== Private Methos ===============================
		//=============================================================================				
		
		/**
		 * 为指定的对象添加事件监听
		 * @param	eventDispatcher	需要监听的对象
		 */
		private function setListeners(eventDispatcher:IEventDispatcher) : void
        {
            eventDispatcher.addEventListener(Event.OPEN, openHandler, false, 0, false);
            eventDispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler, false, 0, false);
            eventDispatcher.addEventListener(Event.COMPLETE, completeHandler, false, 0, false);
            eventDispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpstatusHandler, false, 0, false);
            eventDispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler, false, 0, false);
            eventDispatcher.addEventListener(IOErrorEvent.IO_ERROR, errorHandler, false, 0, false);
            if (eventDispatcher is Sound)
            {
                eventDispatcher.addEventListener(Event.ID3, ID3Handler, false, 0, false);
            }
        }
		

		
		/**
		 * 删除加载对象侦听
		 * @param	eventDispatcher 需要删除监听的对象
		 */
		private function removeListeners(eventDispatcher:IEventDispatcher):void 
		{
			eventDispatcher.removeEventListener(Event.OPEN, openHandler);
            eventDispatcher.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
            eventDispatcher.removeEventListener(Event.COMPLETE, completeHandler);
            eventDispatcher.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpstatusHandler);
            eventDispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
            eventDispatcher.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
            if (eventDispatcher is Sound)
            {
                eventDispatcher.removeEventListener(Event.ID3, ID3Handler);
            }
		}
		

		
		/**
		 * 将参数进行打包,并生成加载器事件
		 * @param	eventType	事件类型
		 * @param	loadManager	事件管理器
		 * @param	percent		
		 * @param	percentQueue	队列百分比
		 * @param	queueResource
		 * @param	eventMsg
		 * @return
		 */
		private function packageEvent(eventType:String, loadManager:LoadManager, percent:Number, percentQueue:Number, queueResource:Resource, eventMsg:String = "") : LoaderEvent
        {
            var _loaderEvent:LoaderEvent = new LoaderEvent(eventType);
				_loaderEvent.loader = loadManager;
				_loaderEvent.percentItem = percent;
				_loaderEvent.percentQueue = percentQueue;
				_loaderEvent.item = queueResource;
				_loaderEvent.queue_count = _compleleQueueCount;
				_loaderEvent.fail_count = _failQueueCount;
				_loaderEvent.queue_length = _queue.length;
            if (!eventMsg)
            {
                _loaderEvent.msg = eventMsg;
            }
            return _loaderEvent;
        }
		
		
		/**
		 * 处理文件
		 * @param	event
		 */
		private function processFile(event:Event = null):void 
		{
			var _localLoadItem:LoadItem = null;
			var _localResource:Resource = null;
			var _localBitmap:Bitmap = null;
			
			if (event) 
			{
				_localLoadItem = _map[event.target] as LoadItem;
				if (!_localLoadItem) 
				{
					return;
				}
				_localResource = _localLoadItem.resource;
				
				if (_localResource.type == ResourceType.TYPE_BITMAP) 
				{
					_localBitmap = LoaderInfo(event.target).content is MovieClip ? (MovieClip(LoaderInfo(event.target).content).getChildAt(0) as Bitmap) : (LoaderInfo(event.target).content as Bitmap);
					_localResource.data = _localBitmap;
				}else if(_localResource.type == ResourceType.TYPE_SWF) 
				{
					_localResource.applicationDomain = LoaderInfo(event.target).applicationDomain;
					_localResource.data = LoaderInfo(event.target).content;
					_localResource.loaderInfo = LoaderInfo(event.target);
				}else if(_localResource.type == ResourceType.TYPE_MP3) 
				{
					_localResource.data = event.target;
				}else 
				{
					_localResource.data = URLLoader(event.target).data;
				}
			}
		}
		
		/**
		 * 清楚当前对象的事件侦听
		 * @param	event
		 */
		private function clearCurrentItem(event:Event = null):void 
		{
			var _localMapIndex:* = undefined;
			if (event) 
			{
				removeListeners(IEventDispatcher(event.target));
			}else 
			{
				for (_localMapIndex in _map) 
				{
					removeListeners(_localMapIndex);
				}
			}
		}
		
		
		/**
		 * 对象加载完成后执行
		 * @param	loadItem
		 */
		private function afterComplete(loadItem:LoadItem):void 
		{
			var _localQueueIndex:uint = 0;
			var _allQueueLength:uint = _queue.length;
			while (_localQueueIndex < _allQueueLength) 
			{
				if (_queue[_localQueueIndex] == loadItem) 
				{
					_queue.splice(_localQueueIndex, 1);
				}
				_localQueueIndex += 1;
			}
			if (_queue.length == 0) 
			{
				setStatus(STATUS_STOPPED);
			}
			if (_loadingThreadCount >0) 
			{
				loadingThreadCount -= 1;
			}
			
			if (loadItem.percent == 100) 
			{
				dispatchEvent(packageEvent(LoaderEvent.COMPLETE, this, 100, _percentQueue, loadItem.resource));
			}
			if (_queue.length) 
			{
				this.loadItem();
			}else 
			{
				dispatchEvent(packageEvent(LoaderEvent.QUEUE_COMPLETE, this, 100, 100, loadItem.resource));
			}
		}
		
		/**
		 * 根据文件地址查找返回数据对象
		 * @param	itemUrl	文件地址
		 * @return 返回对应的资源
		 */
		private function findItem(itemUrl:String):Resource
		{
			var _localResource:Resource = null;
			var _allQueueLength:uint = _queue.length;
			var _loopNumber:int = 0;
			while (_loopNumber < _allQueueLength) 
			{
				_localResource = LoadItem(_queue[_loopNumber]).resource;
				if (_localResource.url == itemUrl) 
				{
					return _localResource;
				}
				_loopNumber++;
			}
			return null;
		}
		
		//=============================================================================		
		//=============================== Handler Methos ===============================
		//=============================================================================		
		
		/**
		 * 当打开加载地址时调度
		 * @param	event
		 */
		private function openHandler(event:Event):void 
		{
			dispatchEvent(packageEvent(LoaderEvent.START, this, 0, _percentQueue, _map[event.target].resource));
		}
		
		/**
		 * 加载进度中的调度函数
		 * @param	event
		 */
		private function progressHandler(event:ProgressEvent):void 
		{
			var _localPercent:Number = NaN;
			var _loaderObject:* = undefined;
			var _localLoadItem:LoadItem = _map[event.target] ;
			var _allqueueLength:uint = _queue.length;
			_percentQueue = 0;
			if (event.bytesTotal < 1000) 
			{
				_localLoadItem.percent = 50;
			}
			else {
				_localLoadItem.percent = event.bytesLoaded / event.bytesTotal * 100;
			}
			
			for (var _loaderObject in _map ) 
			{
				if (_map[_loaderObject].percent) 
				{
					_percentQueue = _percentQueue + _map[_loaderObject].percent;
				}
			}
			
			_percentQueue = (100 * _compleleQueueCount + _percentQueue) / (_compleleQueueCount + _failQueueCount + _allqueueLength );
			_localPercent = _localLoadItem.percent;
			dispatchEvent(packageEvent(LoaderEvent.PROGRESS, this, _localPercent, _percentQueue, _localLoadItem.resource));
			dispatchEvent(packageEvent(LoaderEvent.QUEUE_PROGRESS, this, _localPercent, _percentQueue, _localLoadItem.resource));
			_localLoadItem.startReportTimer();
			
		}	
		
		
		
		/**
		 * 加载完成是调度
		 * @param	event
		 */
		private function completeHandler(event:Event):void 
		{
			var _localLoadItem:LoadItem = _map[event.target];
				_localLoadItem.stopReportTimer();
				_localLoadItem.removeEventListener(LoaderEvent.ERROR, unknowErrorHandler);
				if (event is Event && event.currentTarget is LoaderInfo) 
				{
					_localLoadItem.resource.loaderInfo = LoaderInfo(event.currentTarget);
				}
				processFile(event);
				delete _map[event.target];
				_localLoadItem.percent = 100;
				_compleleQueueCount += 1;
				clearCurrentItem(event);
				afterComplete(_localLoadItem);
 		}
		
		
		/**
		 * HTTP协议状态时调度
		 * @param	event
		 */
		private function httpstatusHandler(event:HTTPStatusEvent):void 
		{
			var _localLoadItem:LoadItem = null;
			if (event.status == 404) 
			{
				_localLoadItem = _map[event.target];
				_localLoadItem.stopReportTimer();
			}
		}

		
		/**
		 * ID3事件调度
		 * @param	event
		 */
		private function ID3Handler(event:Event):void 
		{
			var _localLoadEvent:LoaderEvent = packageEvent(LoaderEvent.ID3_COMPLETE, this, _map[event.target].percent, _percentQueue, _map[event.target].resource);
				_localLoadEvent.id3Info = event.target["id3"];
				dispatchEvent(_localLoadEvent);
		}
		
		
		/**
		 * 错误时调度
		 * @param	event
		 */
		private function errorHandler(event:*):void 
		{
			var _localLoadItem:LoadItem = _map[event.target];
				dispatchEvent(packageEvent(LoaderEvent.ERROR, this, _localLoadItem.percent, _percentQueue, _localLoadItem.resource, event.text))
				_failQueueCount += 1;
				clearCurrentItem(event);
				afterComplete(_localLoadItem);
		}
		
		/**
		 * 处理未知错误
		 * @param	event
		 */
		private function unknowErrorHandler(event:LoaderEvent):void 
		{
			var _localLoadItem:LoadItem = event.target as LoadItem;
			dispatchEvent(packageEvent(LoaderEvent.ERROR, this, _localLoadItem.percent, _percentQueue, _localLoadItem.resource, "[LoaderManager] unkown error"));
			_failQueueCount += 1;
			clearCurrentItem(event);
			afterComplete(_localLoadItem);
		}
		
		
				
		
		
		//=============================================================================		
		//=============================== Public Methos ===============================
		//=============================================================================	
		
		/**
		 * 加载器开始进行加载
		 */
		public function start():void 
		{
			if (_loadStatus == STATUS_STOPPED && _queue.length > 0) 
			{
				setStatus(STATUS_LOADING);
				dispatchEvent(new LoaderEvent(LoaderEvent.QUEUE_START));
				loadItem();
			}
		}
		
		/**
		 * 加载器停止加载
		 */
		public function stop():void 
		{
			if (_loadStatus == STATUS_LOADING) 
			{
				clear();
				dispatchEvent(new LoaderEvent(LoaderEvent.STATUS_CHANGED));
			}
		}
		
		/**
		 * 
		 * 添加加载对象
		 * @param	itemUrl	加载对象的路径地址
		 * @param	itemParam	加载对象的附属参数
		 * @return	返回加载对象的对应资源
		 */
		public function add(itemUrl:String,itemParam:Object = null):Resource 
		{
			
		}
		
		/**
		 * 将加载对象添加到指定的位置后面
		 * @param	itemUrl	加载对象的路径地址
		 * @param	addIndex	指定的位置
		 * @param	itemParam	加载对象的附属参数
		 * @return	返回加载对象的对应资源
		 */
		public function addAt(itemUrl:String,addIndex:int, itemParam:Object = null):Resource 
		{
			var _localLoadItem:LoadItem = null;
			var _findResource:Resource = findItem(itemUrl);
			var _paramString:String;
			if (_findResource == null) 
			{
				_findResource = new Resource();
				_findResource.url = itemUrl;
				_findResource.type = ResourceType.getType(itemUrl);
				
				_localLoadItem = new LoadItem();
				_localLoadItem.percent = 0;
				_localLoadItem.resource = _findResource;
				_localLoadItem.addEventListener(LoaderEvent.ERROR, unknowErrorHandler);
			}else 
			{
				return null;
			}
			if (itemParam !=null) 
			{
				for (_paramString in itemParam) 
				{
					_findResource[_paramString] = itemParam[_paramString];
				}
			}
			if (addIndex<2 || addIndex >_queue.length) 
			{
				return null;
			}
			if (_loadStatus == STATUS_LOADING && addIndex ==0 ) 
			{
				return null;
			}
			_queue.splice(addIndex, 0, _localLoadItem);
			return _findResource;
		}
		
		/**
		 * 移除加载对象
		 * @param	itemUrl 加载对象对象的路径地址
		 * @param	itemIndex	加载对象在队列中的索引
		 * @return	是否已经被移除
		 */
		public function removeItem(itemUrl:String,itemIndex:int=-1):Boolean
		{
			var _localMapIndex:* = undefined;
			var _allQueueLength:uint = 0;
			var _localResource:Resource = null;
			var _loopNumber:int = 0;
			for (_localMapIndex in _map) 
			{
				if (_loadStatus == STATUS_LOADING && _map[_localMapIndex].url == itemUrl) 
				{
					return false;
				}
			}
			if (itemUrl != null && itemUrl.length >4) 
			{
				_allQueueLength = _queue.length;
				_loopNumber = 0;
				while (_loopNumber < _allQueueLength) 
				{
					_localResource = LoadItem(_queue[_loopNumber]).resource;
					if (_localResource.url = itemUrl) 
					{
						_queue.splice(_loopNumber, 1);
						return true;
					}
					_loopNumber++;
				}
			}
			if (itemIndex > -1) 
			{
				_queue.splice(itemIndex, 1);
				return true;
			}
			return false;
		}
		
		/**
		 * 移除指定加载地址的加载对象
		 * @param	itemUrl	加载对象的加载地址
		 * @return	是否已经被移除
		 */
		public function remove(itemUrl:String):Boolean
		{
			return removeItem(itemUrl);
		}
		
		/**
		 * 移除指定索引的加载对象
		 * @param	removeIndex	加载对象的索引位置
		 * @return	是否已经被移除
		 */
		public function removeAt(removeIndex:int):Boolean
		{
			return removeItem(null, removeIndex);
		}
		
		/**
		 * 移除所有加载对象
		 */
		public function removeAll():void 
		{
			clear();
			reset();
			dispatchEvent(new LoaderEvent(LoaderEvent.QUEUE_CHANGED));
		}
		
		/**
		 * 开始加载对象
		 */
		public function loadItem():void 
		{
			
			var _loadItem:LoadItem = null;
			var _resource:Resource = null;
			var _urlRequest:URLRequest = null;
			var _loadObject:* = undefined;
			var _loopInt:int = 0;
			var _queueLen:int = 0;
			var _mapName:String = undefined;
			
			if (_loadStatus == STATUS_LOADING && _queue.length) 
			{
				_queueLen = _queue.length;
				while (_loopInt < _queueLen && _loadingThreadCount < _maxThreadCount) 
				{
					_loadItem = LoadItem(_queue[loadingThreadCount]);
					if (!_loadItem) 
					{
						return;
					}
					for (_mapName in _map ) 
					{
						if (_map[_mapName] == _loadItem ) 
						{
							return;
						}
					}
					_resource = _loadItem.resource;
					_urlRequest = new URLRequest(_resource.url);
					
					if (_resource.type == ResourceType.TYPE_BITMAP || _resource.type == ResourceType.TYPE_SWF) 
					{
						if (_resource.type == ResourceType.TYPE_SWF && ! _resource.url.indexOf("file://")) 
						{
							_loaderContext.securityDomain = SecurityDomain.currentDomain; 
						}else 
						{
							_loaderContext.securityDomain = null;
						}
						_loadObject = new Loader()
						setListeners(Loader(_loadObject).contentLoaderInfo);
						Loader(_loadObject).load(_urlRequest, _loaderContext);
						_loadObject = Loader(_loadObject).contentLoaderInfo;
					}
					else if (_resource.type == ResourceType.TYPE_MP3) 
					{
						_loadObject = new Sound();
						setListeners(_loadObject);
						Sound(_loadObject).load(_urlRequest);
					}
					else 
					{
						_loadObject = new URLLoader();
						if (_resource.type == ResourceType.TYPE_BINARY) 
						{
							URLLoader(_loadObject).dataFormat = URLLoaderDataFormat.BINARY;
						}
						setListeners(_loadObject);
						URLLoader(_loadObject).load(_urlRequest);
					}
					
					_map[_loadObject] = _loadItem;
					_loopInt ++;
					_loadingThreadCount += 1;
				}
			}
			
		}
		
		
		/**
		 * 添加事件监听
		 * @param	eventHandler 事件处理函数
		 */
		public function addEventListeners(eventHandler:Function):void 
		{
			var _methodType:String = null;
			for each (_methodType in _methods ) 
			{
				addEventListener(_methodType, eventHandler, false, 0, false);
			}
		}
		
		/**
		 * 删除事件侦听
		 * @param	eventHandler 事件处理函数
		 */
		public function removeEventListeners(eventHandler:Function):void 
		{
			var _methodType:String = null;
			for each (_methodType in _methods ) 
			{
				removeEventListener(_methodType, eventHandler);
			}
		}
		
		/**
		 * [只读] 加载队列个数
		 */
		public function get count ():int
		{
			return _queue.length;
		}
		
		/**
		 * 最大进程数
		 */
		public function set maxThreadCount(c:uint) : void
        {
            _maxThreadCount = Math.max(c, 0);
        }

        public function get maxThreadCount() : uint
        {
            return _maxThreadCount;
        }
		
		/**
		 * [只读] 正在加载的进程数
		 * @return
		 */
		public function loadingThreadCount ():uint 
		{
			return _loadingThreadCount;
		}
	}

}