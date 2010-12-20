package com.dinboy.net 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.SecurityErrorEvent;	
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLStream;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @data © 2010 钉崽
	 * @author Dinboy.com
	 */
	public class DinURLLoader extends URLLoader  {
		
		/**
		 * 使用二进制加载
		 */
		private var _URLStream:URLStream;
		
		/**
		 * 
		 */
		private var _URLRequest:URLRequest;
		
		/**
		 * 需发送的参数 对象
		 */
		private var _URLVariables:URLVariables;
		
		/**
		 * 二进制数据
		 */
//		private var _ByteArray:ByteArray;
		
		/**
		 * 需要加载的地址
		 */
		private var _url:String
		
		/**
		 * 加载的参数
		 */
		private var _object:Object;
		
		/**
		* 已经加载完成的数量
		 */
		private var _loadedweigth:Number;
		
		/**
		 * 被加载的长度
		 */
		private var _weight:Number;
		
		/**
		 * 加载完成的百分比 0->1 
		 */
		private var _weightPercent:Number
		
		/**
		 * 是否忽略错误
		 */
		private var _ignoreError:Boolean = false;
		
		/**
		 * 设置字符集
		 */
		private var _charSet:String;
		
		/**
		 * 加载的使用传输方法 GET|POST 默认为GET
		 */
		private var _method:String=URLRequestMethod.GET;
		
		
		/***************************/
		public function  DinURLLoader(_url:String=null)
		{
			this._url = _url;
		}

		//+++++++++++=======================================================
		//+++++++++++###### 内部函数
		//+++++++++++=======================================================		
		
		/**
		 * 判断并设置 加载的方式
		 * @param	_url
		 */
		private function  loaderMethod(_url:String=null):void 
		{
			if (!_URLRequest) _URLRequest = new URLRequest();
			if (_url) { this._url = _url; }
			_URLRequest.url = this._url;
			_URLRequest.method = _method;		
			_URLRequest.data = null;
			if (_object!=null && _object!={}) 
			{
				_URLVariables = new URLVariables();
				for (var _item:String in  _object) 
				{
					_URLVariables[_item] = _object[_item];
				}
				_URLRequest.data = _URLVariables
			}
		}
		
		
		//↓↓↓↓↓===========================================
		//↓↓↓↓↓###### URLLoader侦听函数
		//↓↓↓↓↓===========================================
		
		/**
		 * 为加载器添加侦听
		 * @param	_loader
		 */
		private function urlloaderAddEvent(_loader:URLLoader):void 
		{
			_loader.addEventListener(IOErrorEvent.IO_ERROR, urlloaderIOError, false, int.MAX_VALUE,true);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, urlloaderSecurityError, false, int.MAX_VALUE,true);
			_loader.addEventListener(Event.COMPLETE, urlloaderComplete, false, int.MAX_VALUE, true);
			_loader.addEventListener(ProgressEvent.PROGRESS, urlloaderProgress, false, int.MAX_VALUE, true);
		}
		
		/**
		 * 删除侦听
		 * @param	_loader
		 */
		private function urlloaderRemoveEvent(_loader:URLLoader):void 
		{
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, urlloaderIOError);
			_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,urlloaderSecurityError);
		}
		
		/**
		 * 当文件加载完成时
		 * @param	evt
		 */
		private function  urlloaderComplete(evt:Event):void 
		{
			urlloaderRemoveEvent(super);
		}
		
		/**
		 * 当文件正在加载时
		 * @param	evt
		 */
		private function  urlloaderProgress(evt:ProgressEvent):void 
		{
			_loadedweigth = evt.bytesLoaded >>10;
			_weight = evt.bytesTotal >> 10;
			_weightPercent = evt.bytesLoaded / evt.bytesTotal * 100 >> 0;
		}
		
		
		/**
		 * 当文件未找到时
		 * @param	evt
		 */
		private function urlloaderIOError(evt:IOErrorEvent):void 
		{
			evt.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, urlloaderIOError);
			evt.currentTarget.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, urlloaderSecurityError);
			if (_ignoreError)  {
				trace("[DinURLLoader] 对不起,您[正常模式]加载的文件["+_url+"]不存在,请检查路径是否正确.");
			}else dispatchEvent(evt);
		}
		
		/**
		 * 当安全错误时
		 */
		private function urlloaderSecurityError(evt:SecurityErrorEvent):void 
		{
			evt.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, urlloaderIOError);
			evt.currentTarget.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, urlloaderSecurityError);
			if (_ignoreError) {
				trace("[DinURLLoader] 对不起,您以[正常模式]加载的文件["+_url+"]受到安全保护,对方禁止让您加载使用!请与管理员联系.");
				}else dispatchEvent(evt);
		}
		//↑↑↑↑↑=============================================
		//↑↑↑↑↑==========##### URLLoader侦听函数 #####===========
		//↑↑↑↑↑=============================================
		
		
		
		
		
		
		//↓↓↓↓↓=============================================
		//↓↓↓↓↓==========##### 数据流加载器 侦听事件#####=========
		//↓↓↓↓↓=============================================
		
		/**
		 * 为数据流 添加 加载处理程序
		 */
		private function streamAddEvent(_dispatcher:EventDispatcher):void 
		{
			_dispatcher.addEventListener(Event.COMPLETE, URlStreamCompleteHandler, false,int.MAX_VALUE, true);
			_dispatcher.addEventListener(ProgressEvent.PROGRESS, URlStreamProgressHandler, false,int.MAX_VALUE, true);
			_dispatcher.addEventListener(IOErrorEvent.IO_ERROR, URlStreamIOErrorHandler, false, int.MAX_VALUE, true);
			_dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, URLStreamHttpStausHandler, false, int.MAX_VALUE, true);
			_dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, URLStreamSecurityErrorHandler, false, int.MAX_VALUE, true);
		}
		
		/**
		 * 为数据流 删除 加载处理程序
		 */
		private function streamRemoveEvent(_dispatcher:EventDispatcher):void 
		{
			_dispatcher.removeEventListener(Event.COMPLETE, URlStreamCompleteHandler);
			_dispatcher.removeEventListener(ProgressEvent.PROGRESS, URlStreamProgressHandler);
			_dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, URlStreamIOErrorHandler);
			_dispatcher.removeEventListener(HTTPStatusEvent.HTTP_STATUS, URLStreamHttpStausHandler);
			_dispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, URLStreamSecurityErrorHandler);
		}
		
		/**
		 * 当数据流加载程序出错时
		 * @param	evt
		 */
		private function URlStreamCompleteHandler(evt:Event):void 
		{
			streamRemoveEvent(_URLStream);
			super.data = _URLStream.readMultiByte(_URLStream.bytesAvailable, _charSet);
			close();
			dispatchEvent(evt);
		}
		
		/**
		 * 当数据流加载程序加载时
		 */
		private function URlStreamProgressHandler(evt:ProgressEvent):void 
		{
			_loadedweigth = evt.bytesLoaded >> 10;
			_weight = evt.bytesTotal >> 10;
			_weightPercent = evt.bytesLoaded / evt.bytesTotal * 100 >> 0;
			dispatchEvent(evt);
		}
		
		/**
		 * 当数据流加载程序IO出错时
		 */
		private function URlStreamIOErrorHandler(evt:IOErrorEvent):void 
		{
			evt.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, URlStreamIOErrorHandler);
			if (_ignoreError)
			{
				trace("[DinURLLoader] 对不起,您以[二进制]加载的文件["+_url+"]不存在,请检查路径是否正确.");
			}else dispatchEvent(evt);
		}
		
		/**
		 * 监测连接状态 入404,或505等.
		 * @param	evt
		 */
		private function URLStreamHttpStausHandler(evt:HTTPStatusEvent):void 
		{
			evt.currentTarget.removeEventListener(HTTPStatusEvent.HTTP_STATUS, URLStreamHttpStausHandler);
			trace("[DinURLLoader] 加载 ["+_url+"] 处于 ["+evt.status+"] 状态.");
			dispatchEvent(evt);
		}
		
		/**
		 * 遇到安全沙箱问题
		 * @param	evt
		 */
		private function URLStreamSecurityErrorHandler(evt:SecurityErrorEvent):void 
		{
			evt.currentTarget.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, URLStreamSecurityErrorHandler);
			if (_ignoreError) 
				{
					trace("[DinURLLoader] 对不起,您以[二进制]加载的文件 存在 ["+evt.text+"] 错误.");
				}else dispatchEvent(evt);
		}
		
		//↑↑↑↑↑=============================================
		//↑↑↑↑↑==========##### 数据流加载器 侦听事件#####=========
		//↑↑↑↑↑=============================================
		
		
		
		
		
		
		
		
		
		//=======================================================
		//###### 类函数
		//=======================================================		
		
		/**
		 * 重写 关闭加载
		 */
		override	public function  close():void 
		{
			urlloaderRemoveEvent(super);
			if (_URLStream) 
			{
				if (_URLStream.connected) 
				{
					_URLStream.close();
					streamRemoveEvent(_URLStream);
				}
			}
		}
		
		/** 
        *   重写 文字显示
        */
        override public function toString() : String{
            return "[DinURLLoader] 总长度:"+ _weight + ", 已经加载: " + _loadedweigth + ", 加载进度: " + _weightPercent; 
        }
		
		/**
		 * 使用一般加载,好处就是不用新添加URLRequest
		 * @param	_url 需要加载的地址
		 */
		public function loadNormal(_url:String=null):void 
		{
			loaderMethod(_url);
			urlloaderAddEvent(super);
			try
			{
				super.load(_URLRequest);
			}
			catch (err:Error)
			{
				trace("[DinURLLoader] 尝试加载["+_url+"]失败");
			}
		}
		
		/**
		 * 使用二进制加载
		 * @param	_url					需要加载的文件地址
		 * @param	_charSet			字符集 <strong>默认:UTF-8</strong>
		 */
		public function loadStream(_url:String=null,_charSet:String="UTF-8"):void 
		{
			loaderMethod(_url);
			if (!_URLStream) _URLStream = new URLStream();
			if (_URLStream.connected) _URLStream.close();
			_charSet = _charSet;
			streamAddEvent(_URLStream);
			try 
			{
				_URLStream.load(_URLRequest);
			}catch (err:Error)
			{
				trace("[DinURLLoader] 尝试加载["+_url+"]失败");
			}
		}
		
		

		//=============================================
		//#######   设置/获取 属性		 ========================
		//=============================================
		
		/**
		 * 设置/获取 地址
		 * 默认:null
		 */
		public function get url():String { return _url; }
		
		public function set url(_value:String):void 
		{
			_url = _value;
		}
		
		/**
		 * 设置/获取 参数
		 * 默认:null
		 */
		public function get object():Object { return _object; }
		
		public function set object(_value:Object):void 
		{
			_object = _value;
		}
		
		/**
		 * 获取 已经完成加载的量
		 */
		public function get loadedweigth():Number { return _loadedweigth; }
		
		/**
		 * 获取 被加载数量的长度
		 */
		public function get weight():Number { return _weight; }
		
		/**
		 * 获取 百分比加载量
		 */
		public function get weightPercent():Number { return _weightPercent; }
		
		/**
		 * 设置/获取 是否忽略错误
		 */
		public function get ignoreError():Boolean { return _ignoreError; }
		
		public function set ignoreError(_value:Boolean):void 
		{
			_ignoreError = _value;
		}
		
		/**
		 * 设置/获取 加载的方法 GET|POST  默认为 "GET";
		 */
		public function get method():String { return _method; }
		
		public function set method(_value:String):void 
		{
			_method = _value;
		}

		/********** [DINBOY] Say: Class The End  ************/	
		}
	}