package com.dinboy.net 
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLStream;
	import flash.net.URLVariables;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Dinboy.com
	 * @copy CopyRight © 2010 DinBoy
	 */
	public class DinLoader extends Loader
	{
		//######################
		// ----- 一般变量
		//######################
		
		/**
		 * 
		 */
		private var _URLRequest:URLRequest;
		
		/**
		 * 需发送的参数 对象
		 */
		private var _URLVariables:URLVariables;
		
		/**
		 * 使用二进制加载
		 */
		private var _URLStream:URLStream;
		
		/**
		 * 加载文件的地址
		 */
		private var _url:String;	
		
		/**
		 * 加载的变量参数 
		 */
		private var _object:Object;
		
		/**
		 * 加载的二进制数据
		 */
		private var _ByteArray:ByteArray;
		
		/**
		 * 存放域
		 */
		private var _context:LoaderContext;
		
		/**
		 * 已加载的字节数  用在URLStream
		 */
		private var _bytesLoaded:uint = 0;
		
		/**
		 * 总字节数 用在URLStream
		 */
		private var _bytesToal:uint = 0;
		
		/**
		 * 加载数据的方法
		 */
		private var _method:String = URLRequestMethod.GET;
		
		
		
		//######################
		// ----- 判断属性
		//######################
		
		/**
		 * 是否忽略错误
		 */
		private var _ignoreError:Boolean = false;
		
		/**
		 * 是否已经加载完成
		 */
		private var _streamComplete:Boolean;
		
		/**
		 * 数据是否有改变
		 */
		private var _dataChange:Boolean;
		

		
		
		
		//=======================================================
		//###### 内部函数
		//=======================================================		
		
		/**
		 * 判断并设置 加载的方式
		 * @param	_url
		 */
		private function  loaderMethod(_url:String=null):void 
		{
			if (!_URLRequest) _URLRequest = new URLRequest();
			if (_url) { this._url = _url; }
			_URLRequest.url = this._url;
			_URLRequest.data = null;
			_URLRequest.method =_method;
												 
			if (_object!=null) 
			{
				 _URLVariables = new URLVariables();
				for (var _item:String in  _object) 
				{
					_URLVariables[_item] = _object[_item];
				}
				_URLRequest.data = _URLVariables
			}
		}
		
		//============================================
		//==========###### 为loaderinfo添加侦听 ######============
		//============================================
		
		/**
		 * 添加侦听
		 * @param	_loaderinfo
		 */
		private function LoaderAddEvent(_loaderinfo:LoaderInfo):void 
		{
			_loaderinfo.addEventListener(IOErrorEvent.IO_ERROR, loaderIOError, false, int.MAX_VALUE,true);
			_loaderinfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loaderSecurityError, false, int.MAX_VALUE,true);
			_loaderinfo.addEventListener(Event.COMPLETE, loaderComplete, false, int.MAX_VALUE, true);
			_loaderinfo.addEventListener(ProgressEvent.PROGRESS, loaderProgress, false, int.MAX_VALUE, true);
		}
		
		/**
		 * 删除侦听
		 * @param	_loaderinfo
		 */
		private function LoaderRemoveEvent(_loaderinfo:LoaderInfo):void 
		{
			_loaderinfo.removeEventListener(IOErrorEvent.IO_ERROR, loaderIOError);
			_loaderinfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loaderSecurityError);
			_loaderinfo.removeEventListener(Event.COMPLETE, loaderComplete);
			_loaderinfo.removeEventListener(ProgressEvent.PROGRESS, loaderProgress);
		}
		
		/**
		 * 当文件加载完成时
		 * @param	evt
		 */
		private function  loaderComplete(evt:Event):void 
		{
			if (_URLStream)
			{
				if (_streamComplete) {
						_streamComplete=false;
						LoaderRemoveEvent(super.contentLoaderInfo);
				} else {
					evt.stopImmediatePropagation();
				}
			}
			else LoaderRemoveEvent(super.contentLoaderInfo);
			dispatchEvent(evt);
		}
		
		/**
		 * 当文件正在加载时
		 * @param	evt
		 */
		private function  loaderProgress(evt:ProgressEvent):void 
		{
			if (_URLStream) {
				evt.bytesLoaded=_bytesLoaded;
				evt.bytesTotal = _bytesToal;
			}
			dispatchEvent(evt);
		}
		
		
		/**
		 * 当文件未找到时
		 * @param	evt
		 */
		private function loaderIOError(evt:IOErrorEvent):void 
		{				
			evt.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, loaderIOError);
			evt.currentTarget.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loaderSecurityError);
			if (_ignoreError)  {
				trace("[DinLoader] 对不起,您[正常模式]加载的文件[" +_url+ "]不存在,请检查路径是否正确.");
			}else dispatchEvent(evt);
			
		}
		
		/**
		 * 当安全错误时
		 */
		private function loaderSecurityError(evt:SecurityErrorEvent):void 
		{
				evt.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, loaderIOError);
				evt.currentTarget.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loaderSecurityError);
			if (_ignoreError) {
				trace("[DinLoader] 对不起,您以[正常模式]加载的文件[" +_url+ "]受到安全保护,对方禁止让您加载使用!请与管理员联系.");
			}else dispatchEvent(evt);
		}
		
		//===============================================
		//==========##### 数据流加载器 侦听事件#####==========
		//===============================================
		
		/**
		 * 为数据流 添加 加载处理程序
		 */
		private function streamAddEvent():void 
		{
			_URLStream.addEventListener(Event.COMPLETE, URlStreamCompleteHandler, false, 0, true);
			_URLStream.addEventListener(ProgressEvent.PROGRESS, URlStreamProgressHandler, false, 0, true);
			_URLStream.addEventListener(IOErrorEvent.IO_ERROR, URlStreamIOErrorHandler, false, 0, true);
			_URLStream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, URlStreamSecurityErrorHandler, false, 0, true);
		}
		
		/**
		 * 为数据流 删除 加载处理程序
		 */
		private function streamRemoveEvent():void 
		{
			_URLStream.removeEventListener(Event.COMPLETE, URlStreamCompleteHandler);
			_URLStream.removeEventListener(ProgressEvent.PROGRESS, URlStreamProgressHandler);
			_URLStream.removeEventListener(IOErrorEvent.IO_ERROR, URlStreamIOErrorHandler);
			_URLStream.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, URlStreamSecurityErrorHandler);
		}
		
		/**
		 * 当数据流加载程序出错时
		 * @param	evt
		 */
		private function URlStreamCompleteHandler(evt:Event):void 
		{
			streamRemoveEvent();
			
			// 这里不删除EnterFrame事件,最后一段总是不会显示.
			// 并且complete事件里showData也不行.
			// 所以最后延时显示一次.
			
			_streamComplete = true;
			_dataChange = true;
		}
		
		/**
		 * 当数据流加载程序加载时
		 */
		private function URlStreamProgressHandler(evt:ProgressEvent):void 
		{
				_bytesLoaded = evt.bytesLoaded;
				_bytesToal = evt.bytesTotal;
		}
		
		/**
		 * 当数据流加载程序IO出错时
		 */
		private function URlStreamIOErrorHandler(evt:IOErrorEvent):void 
		{
			_URLStream.removeEventListener(IOErrorEvent.IO_ERROR, URlStreamIOErrorHandler);
			if (_ignoreError) 
			{
				trace("[DinLoader] 对不起,您以[渐进式]加载的文件[" +_url+ "]不存在,请检查路径是否正确.");
			}else dispatchEvent(evt);
			
		}
		
		/**
		 * 当出现安全沙箱错误时
		 * @param	evt
		 */
		private function URlStreamSecurityErrorHandler(evt:SecurityErrorEvent):void 
		{				
			_URLStream.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, URlStreamSecurityErrorHandler);
			if (_ignoreError) 
			{
				trace("[DinLoader] 对不起,您以[渐进式]加载的文件[" +_url+ "]存在安全沙箱问题.");
			}else dispatchEvent(evt);
		}
		
		//=============================================
		//#### 为本实例添加实时侦听,为的就是实时显示图片
		//=============================================
		
		
		/**
		 * 实时侦听,显示图片
		 * @param	evt
		 */
		private function  enterFrameHandler(evt:Event):void 
		{
			if (! _dataChange||! _URLStream.connected) return;
			
			_dataChange=false;
			if (_URLStream.bytesAvailable > 0) _URLStream.readBytes(_ByteArray, _ByteArray.length, _URLStream.bytesAvailable);
			
			if (_ByteArray.length>0) {
				super.unload();
				super.loadBytes(_ByteArray, _context);
			}
			// 加载完成 
			if (_streamComplete) {
				close();
				_streamComplete=false;
			}
		}
		
		
		//=======================================================
		//###### 类 方法
		//=======================================================	
		
		/**
		 * 关闭所有加载
		 */		
		override public function close():void 
		{
			// 清除流相关 
			if (_URLStream) {
				if (_URLStream.connected) {
					_URLStream.close();
				}
				streamRemoveEvent();
			}
			// 清除conentLoaderInfo相关的事件 
			if (contentLoaderInfo.hasEventListener(Event.COMPLETE))	LoaderRemoveEvent(super.contentLoaderInfo);

			// 清除显示数据事件 
			if (hasEventListener(Event.ENTER_FRAME)) {
				removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
//			super.close();
			_ByteArray=null;
		}

		/**
		 * 非渐进式加载 
		 * @param	_url 					需要加载的路径
		 * @param	_context			存放的域
		 */		
		public function loadNormal(_url:String=null,_context:LoaderContext=null):void 
		{
			loaderMethod(_url);
			super.unload();
			super.unloadAndStop();
			
			LoaderAddEvent(super.contentLoaderInfo);
			try 
			{
				super.load(_URLRequest, _context);
			}
			catch (err:TypeError)
			{
				trace("[DinLoader] 尝试加载["+_url+"]失败");
			}
		}
		
		/**
		 * 使用渐进式加载
		 * @param	_url
		 * @param	_context
		 */
		public function loadStream(_url:String=null,_context:LoaderContext=null):void 
		{
			loaderMethod(_url);
			if (!_URLStream) _URLStream = new URLStream();
			if (_URLStream.connected) _URLStream.close();
			
			_context = _context;
			_ByteArray = new ByteArray();
			
			super.unload();
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
			LoaderAddEvent(super.contentLoaderInfo);
			streamAddEvent();
			try 
			{
				_URLStream.load(_URLRequest);
			}
			catch (err:Error)
			{
				trace("[DinLoader] 尝试加载["+_url+"]失败");
			}
			
		}
		
		/** 
		* 加载字节数据,不会在内部触发contentLoaderInfo相关事件 
		* @param bytes 
		* @param context 
		*/
		override public function loadBytes(_bytes:ByteArray, _context:LoaderContext = null):void {
			close();
			super.unload();
			super.loadBytes(_bytes, _context);
		}
		
		
		
		//=======================================================
		//###### 获取/设置 属性
		//=======================================================
		
		
		/**
		 * 设置/获取 是否要忽略错误 默认:false
		 */
		public function get ignoreError():Boolean { return _ignoreError; }
		public function set ignoreError(_value:Boolean):void 
		{
			_ignoreError = _value;
		}
		
		
		/**
		 * 设置/获取 加载的地址
		 */
		public function get url():String { return _url; }
		public function set url(_value:String):void 
		{
			_url = _value;
		}
		
		/**
		 * 设置/获取 加载的变量参数 默认:null  
		 */
		public function get object():Object { return _object; }
		public function set object(_value:Object):void 
		{
			_object = _value;
		}
		
		/**
		 * 设置/获取 加载数据的方法 默认为:get
		 */
		public function get method():String { return _method; }
		
		public function set method(_value:String):void 
		{
			_method = _value;
		}
		
		/**
		 * 当转以文本显示时
		 */
		override public function toString():String 
		{
			return "[com.dinboy.net.DinLoader] extends by Loader";
		}
		
		
		/********** [DINBOY] Say: Class The End  ************/	
	}

}