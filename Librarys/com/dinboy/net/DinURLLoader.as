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
		private var $URLStream:URLStream;
		
		/**
		 * 
		 */
		private var $URLRequest:URLRequest;
		
		/**
		 * 需发送的参数 对象
		 */
		private var $URLVariables:URLVariables;
		
		/**
		 * 二进制数据
		 */
//		private var $ByteArray:ByteArray;
		
		/**
		 * 需要加载的地址
		 */
		private var $url:String
		
		/**
		 * 加载的参数
		 */
		private var $object:Object;
		
		/**
		* 已经加载完成的数量
		 */
		private var $loadedweigth:Number;
		
		/**
		 * 被加载的长度
		 */
		private var $weight:Number;
		
		/**
		 * 加载完成的百分比 0->1 
		 */
		private var $weightPercent:Number
		
		/**
		 * 是否忽略错误
		 */
		private var $ignoreError:Boolean = false;
		
		/**
		 * 设置字符集
		 */
		private var $charSet:String;
		
		/**
		 * 加载的使用传输方法 GET|POST 默认为GET
		 */
		private var $method:String=URLRequestMethod.GET;
		
		
		/***************************/
		public function  DinURLLoader($url:String=null)
		{
			this.$url = $url;
		}

		//+++++++++++=======================================================
		//+++++++++++###### 内部函数
		//+++++++++++=======================================================		
		
		/**
		 * 判断并设置 加载的方式
		 * @param	$url
		 */
		private function  loaderMethod($url:String=null):void 
		{
			if (!this.$URLRequest) this.$URLRequest = new URLRequest();
			if ($url) { this.$url = $url; }
			this.$URLRequest.url = this.$url;
			this.$URLRequest.method = this.$method;		
			this.$URLRequest.data = null;
			if ($object!=null && $object!={}) 
			{
				this.$URLVariables = new URLVariables();
				for (var $item:String in  this.$object) 
				{
					this.$URLVariables[$item] = this.$object[$item];
				}
				this.$URLRequest.data = this.$URLVariables
			}
		}
		
		
		//↓↓↓↓↓===========================================
		//↓↓↓↓↓###### URLLoader侦听函数
		//↓↓↓↓↓===========================================
		
		/**
		 * 为加载器添加侦听
		 * @param	$loader
		 */
		private function urlloaderAddEvent($loader:URLLoader):void 
		{
			$loader.addEventListener(IOErrorEvent.IO_ERROR, this.urlloaderIOError, false, int.MAX_VALUE,true);
			$loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.urlloaderSecurityError, false, int.MAX_VALUE,true);
			$loader.addEventListener(Event.COMPLETE, this.urlloaderComplete, false, int.MAX_VALUE, true);
			$loader.addEventListener(ProgressEvent.PROGRESS, this.urlloaderProgress, false, int.MAX_VALUE, true);
		}
		
		/**
		 * 删除侦听
		 * @param	$loader
		 */
		private function urlloaderRemoveEvent($loader:URLLoader):void 
		{
			$loader.removeEventListener(IOErrorEvent.IO_ERROR, this.urlloaderIOError);
			$loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.urlloaderSecurityError);
		}
		
		/**
		 * 当文件加载完成时
		 * @param	evt
		 */
		private function  urlloaderComplete(evt:Event):void 
		{
			this.urlloaderRemoveEvent(super);
		}
		
		/**
		 * 当文件正在加载时
		 * @param	evt
		 */
		private function  urlloaderProgress(evt:ProgressEvent):void 
		{
			this.$loadedweigth = evt.bytesLoaded >>10;
			this.$weight = evt.bytesTotal >> 10;
			this.$weightPercent = evt.bytesLoaded / evt.bytesTotal * 100 >> 0;
		}
		
		
		/**
		 * 当文件未找到时
		 * @param	evt
		 */
		private function urlloaderIOError(evt:IOErrorEvent):void 
		{
			evt.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, this.urlloaderIOError);
			evt.currentTarget.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.urlloaderSecurityError);
			if (this.$ignoreError)  {
				trace("[DinURLLoader] 对不起,您[正常模式]加载的文件["+this.$url+"]不存在,请检查路径是否正确.");
			}else dispatchEvent(evt);
		}
		
		/**
		 * 当安全错误时
		 */
		private function urlloaderSecurityError(evt:SecurityErrorEvent):void 
		{
			evt.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, this.urlloaderIOError);
			evt.currentTarget.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.urlloaderSecurityError);
			if (this.$ignoreError) {
				trace("[DinURLLoader] 对不起,您以[正常模式]加载的文件["+this.$url+"]受到安全保护,对方禁止让您加载使用!请与管理员联系.");
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
		private function streamAddEvent($dispatcher:EventDispatcher):void 
		{
			$dispatcher.addEventListener(Event.COMPLETE, this.URlStreamCompleteHandler, false,int.MAX_VALUE, true);
			$dispatcher.addEventListener(ProgressEvent.PROGRESS, this.URlStreamProgressHandler, false,int.MAX_VALUE, true);
			$dispatcher.addEventListener(IOErrorEvent.IO_ERROR, this.URlStreamIOErrorHandler, false, int.MAX_VALUE, true);
			$dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, this.URLStreamHttpStausHandler, false, int.MAX_VALUE, true);
			$dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.URLStreamSecurityErrorHandler, false, int.MAX_VALUE, true);
		}
		
		/**
		 * 为数据流 删除 加载处理程序
		 */
		private function streamRemoveEvent($dispatcher:EventDispatcher):void 
		{
			$dispatcher.removeEventListener(Event.COMPLETE, this.URlStreamCompleteHandler);
			$dispatcher.removeEventListener(ProgressEvent.PROGRESS, this.URlStreamProgressHandler);
			$dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, this.URlStreamIOErrorHandler);
			$dispatcher.removeEventListener(HTTPStatusEvent.HTTP_STATUS, URLStreamHttpStausHandler);
			$dispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.URLStreamSecurityErrorHandler);
		}
		
		/**
		 * 当数据流加载程序出错时
		 * @param	evt
		 */
		private function URlStreamCompleteHandler(evt:Event):void 
		{
			this.streamRemoveEvent(this.$URLStream);
			super.data = this.$URLStream.readMultiByte(this.$URLStream.bytesAvailable, this.$charSet);
			this.close();
			this.dispatchEvent(evt);
		}
		
		/**
		 * 当数据流加载程序加载时
		 */
		private function URlStreamProgressHandler(evt:ProgressEvent):void 
		{
			this.$loadedweigth = evt.bytesLoaded >> 10;
			this.$weight = evt.bytesTotal >> 10;
			this.$weightPercent = evt.bytesLoaded / evt.bytesTotal * 100 >> 0;
			this.dispatchEvent(evt);
		}
		
		/**
		 * 当数据流加载程序IO出错时
		 */
		private function URlStreamIOErrorHandler(evt:IOErrorEvent):void 
		{
			evt.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, this.URlStreamIOErrorHandler);
			if (this.$ignoreError)
			{
				trace("[DinURLLoader] 对不起,您以[二进制]加载的文件["+this.$url+"]不存在,请检查路径是否正确.");
			}else this.dispatchEvent(evt);
		}
		
		/**
		 * 监测连接状态 入404,或505等.
		 * @param	evt
		 */
		private function URLStreamHttpStausHandler(evt:HTTPStatusEvent):void 
		{
			evt.currentTarget.removeEventListener(HTTPStatusEvent.HTTP_STATUS, this.URLStreamHttpStausHandler);
			trace("[DinURLLoader] 加载 ["+this.$url+"] 处于 ["+evt.status+"] 状态.");
			this.dispatchEvent(evt);
		}
		
		/**
		 * 遇到安全沙箱问题
		 * @param	evt
		 */
		private function URLStreamSecurityErrorHandler(evt:SecurityErrorEvent):void 
		{
			evt.currentTarget.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.URLStreamSecurityErrorHandler);
			if (this.$ignoreError) 
				{
					trace("[DinURLLoader] 对不起,您以[二进制]加载的文件 存在 ["+evt.text+"] 错误.");
				}else this.dispatchEvent(evt);
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
			this.urlloaderRemoveEvent(super);
			if (this.$URLStream) 
			{
				if (this.$URLStream.connected) 
				{
					this.$URLStream.close();
					this.streamRemoveEvent(this.$URLStream);
				}
			}
		}
		
		/** 
        *   重写 文字显示
        */
        override public function toString() : String{
            return "[DinURLLoader] 总长度:"+ this.$weight + ", 已经加载: " + this.$loadedweigth + ", 加载进度: " + this.$weightPercent; 
        }
		
		/**
		 * 使用一般加载,好处就是不用新添加URLRequest
		 * @param	$url 需要加载的地址
		 */
		public function loadNormal($url:String=null):void 
		{
			this.loaderMethod($url);
			this.urlloaderAddEvent(super);
			try
			{
				super.load(this.$URLRequest);
			}
			catch (err:Error)
			{
				trace("[DinURLLoader] 尝试加载["+$url+"]失败");
			}
		}
		
		/**
		 * 使用二进制加载
		 * @param	$url					需要加载的文件地址
		 * @param	$charSet			字符集 <strong>默认:UTF-8</strong>
		 */
		public function loadStream($url:String=null,$charSet:String="UTF-8"):void 
		{
			this.loaderMethod($url);
			if (!this.$URLStream) this.$URLStream = new URLStream();
			if (this.$URLStream.connected) this.$URLStream.close();
			this.$charSet = $charSet;
			this.streamAddEvent(this.$URLStream);
			try 
			{
				this.$URLStream.load(this.$URLRequest);
			}catch (err:Error)
			{
				trace("[DinURLLoader] 尝试加载["+$url+"]失败");
			}
		}
		
		

		//=============================================
		//#######   设置/获取 属性		 ========================
		//=============================================
		
		/**
		 * 设置/获取 地址
		 * 默认:null
		 */
		public function get url():String { return this.$url; }
		
		public function set url($value:String):void 
		{
			this.$url = $value;
		}
		
		/**
		 * 设置/获取 参数
		 * 默认:null
		 */
		public function get object():Object { return this.$object; }
		
		public function set object($value:Object):void 
		{
			this.$object = $value;
		}
		
		/**
		 * 获取 已经完成加载的量
		 */
		public function get loadedweigth():Number { return this.$loadedweigth; }
		
		/**
		 * 获取 被加载数量的长度
		 */
		public function get weight():Number { return this.$weight; }
		
		/**
		 * 获取 百分比加载量
		 */
		public function get weightPercent():Number { return this.$weightPercent; }
		
		/**
		 * 设置/获取 是否忽略错误
		 */
		public function get ignoreError():Boolean { return this.$ignoreError; }
		
		public function set ignoreError($value:Boolean):void 
		{
			this.$ignoreError = $value;
		}
		
		/**
		 * 设置/获取 加载的方法 GET|POST  默认为 "GET";
		 */
		public function get method():String { return this.$method; }
		
		public function set method($value:String):void 
		{
			this.$method = $value;
		}

		/********** [DINBOY] Say: Class The End  ************/	
		}
	}