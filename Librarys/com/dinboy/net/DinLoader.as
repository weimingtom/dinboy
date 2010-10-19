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
		private var $URLRequest:URLRequest;
		
		/**
		 * 需发送的参数 对象
		 */
		private var $URLVariables:URLVariables;
		
		/**
		 * 使用二进制加载
		 */
		private var $URLStream:URLStream;
		
		/**
		 * 加载文件的地址
		 */
		private var $url:String;	
		
		/**
		 * 加载的变量参数 
		 */
		private var $object:Object;
		
		/**
		 * 加载的二进制数据
		 */
		private var $ByteArray:ByteArray;
		
		/**
		 * 存放域
		 */
		private var $context:LoaderContext;
		
		/**
		 * 已加载的字节数  用在URLStream
		 */
		private var $bytesLoaded:uint = 0;
		
		/**
		 * 总字节数 用在URLStream
		 */
		private var $bytesToal:uint = 0;
		
		/**
		 * 加载数据的方法
		 */
		private var $method:String = URLRequestMethod.GET;
		
		
		
		//######################
		// ----- 判断属性
		//######################
		
		/**
		 * 是否忽略错误
		 */
		private var $ignoreError:Boolean = false;
		
		/**
		 * 是否已经加载完成
		 */
		private var $streamComplete:Boolean;
		
		/**
		 * 数据是否有改变
		 */
		private var $dataChange:Boolean;
		

		
		
		
		//=======================================================
		//###### 内部函数
		//=======================================================		
		
		/**
		 * 判断并设置 加载的方式
		 * @param	$url
		 */
		private function  loaderMethod($url:String=null):void 
		{
			if (!this.$URLRequest) this.$URLRequest = new URLRequest();
			if ($url) { this.$url = $url; }
			this.$URLRequest.url = this.$url;
			this.$URLRequest.data = null;
			this.$URLRequest.method =this.$method;
												 
			if ($object!=null) 
			{
				 this.$URLVariables = new URLVariables();
				for (var $item:String in  this.$object) 
				{
					this.$URLVariables[$item] = this.$object[$item];
				}
				this.$URLRequest.data = this.$URLVariables
			}
		}
		
		//============================================
		//==========###### 为loaderinfo添加侦听 ######============
		//============================================
		
		/**
		 * 添加侦听
		 * @param	$loaderinfo
		 */
		private function LoaderAddEvent($loaderinfo:LoaderInfo):void 
		{
			if(this.$ignoreError)	$loaderinfo.addEventListener(IOErrorEvent.IO_ERROR, this.loaderIOError, false, int.MAX_VALUE,true);
			if(this.$ignoreError)	$loaderinfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.loaderSecurityError, false, int.MAX_VALUE,true);
			$loaderinfo.addEventListener(Event.COMPLETE, this.loaderComplete, false, int.MAX_VALUE, true);
			$loaderinfo.addEventListener(ProgressEvent.PROGRESS, this.loaderProgress, false, int.MAX_VALUE, true);
		}
		
		/**
		 * 删除侦听
		 * @param	$loaderinfo
		 */
		private function LoaderRemoveEvent($loaderinfo:LoaderInfo):void 
		{
			$loaderinfo.removeEventListener(IOErrorEvent.IO_ERROR, this.loaderIOError);
			$loaderinfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.loaderSecurityError);
			$loaderinfo.removeEventListener(Event.COMPLETE, this.loaderComplete);
			$loaderinfo.removeEventListener(ProgressEvent.PROGRESS, this.loaderProgress);
		}
		
		/**
		 * 当文件加载完成时
		 * @param	evt
		 */
		private function  loaderComplete(evt:Event):void 
		{
			if (this.$URLStream)
			{
				if (this.$streamComplete) {
						this.$streamComplete=false;
						this.LoaderRemoveEvent(super.contentLoaderInfo);
				} else {
					evt.stopImmediatePropagation();
				}
			}
			else this.LoaderRemoveEvent(super.contentLoaderInfo);
			dispatchEvent(evt);
		}
		
		/**
		 * 当文件正在加载时
		 * @param	evt
		 */
		private function  loaderProgress(evt:ProgressEvent):void 
		{
			if (this.$URLStream) {
				evt.bytesLoaded=this.$bytesLoaded;
				evt.bytesTotal = this.$bytesToal;
			}
			dispatchEvent(evt);
		}
		
		
		/**
		 * 当文件未找到时
		 * @param	evt
		 */
		private function loaderIOError(evt:IOErrorEvent):void 
		{
//			if (this.$ignoreError)  {
				trace("[DinLoader] 对不起,您[正常模式]加载的文件[" +this.$url+ "]不存在,请检查路径是否正确.");
				evt.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, this.loaderIOError);
				evt.currentTarget.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.loaderSecurityError);
	//		}else dispatchEvent(evt);
			
		}
		
		/**
		 * 当安全错误时
		 */
		private function loaderSecurityError(evt:SecurityErrorEvent):void 
		{
	//		if (this.$ignoreError) {
				trace("[DinLoader] 对不起,您以[正常模式]加载的文件[" +this.$url+ "]受到安全保护,对方禁止让您加载使用!请与管理员联系.");
				evt.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, this.loaderIOError);
				evt.currentTarget.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.loaderSecurityError);
		//	}else dispatchEvent(evt);
		}
		
		//===============================================
		//==========##### 数据流加载器 侦听事件#####==========
		//===============================================
		
		/**
		 * 为数据流 添加 加载处理程序
		 */
		private function streamAddEvent():void 
		{
			this.$URLStream.addEventListener(Event.COMPLETE, this.URlStreamCompleteHandler, false, 0, true);
			this.$URLStream.addEventListener(ProgressEvent.PROGRESS, this.URlStreamProgressHandler, false, 0, true);
			if(this.$ignoreError)	this.$URLStream.addEventListener(IOErrorEvent.IO_ERROR, this.URlStreamIOErrorHandler, false, 0, true);
			if(this.$ignoreError)	this.$URLStream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.URlStreamSecurityErrorHandler, false, 0, true);
		}
		
		/**
		 * 为数据流 删除 加载处理程序
		 */
		private function streamRemoveEvent():void 
		{
			this.$URLStream.removeEventListener(Event.COMPLETE, this.URlStreamCompleteHandler);
			this.$URLStream.removeEventListener(ProgressEvent.PROGRESS, this.URlStreamProgressHandler);
			this.$URLStream.removeEventListener(IOErrorEvent.IO_ERROR, this.URlStreamIOErrorHandler);
			this.$URLStream.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.URlStreamSecurityErrorHandler);
		}
		
		/**
		 * 当数据流加载程序出错时
		 * @param	evt
		 */
		private function URlStreamCompleteHandler(evt:Event):void 
		{
			this.streamRemoveEvent();
			
			// 这里不删除EnterFrame事件,最后一段总是不会显示.
			// 并且complete事件里showData也不行.
			// 所以最后延时显示一次.
			
			this.$streamComplete = true;
			this.$dataChange = true;
		}
		
		/**
		 * 当数据流加载程序加载时
		 */
		private function URlStreamProgressHandler(evt:ProgressEvent):void 
		{
				this.$bytesLoaded = evt.bytesLoaded;
				this.$bytesToal = evt.bytesTotal;
		}
		
		/**
		 * 当数据流加载程序IO出错时
		 */
		private function URlStreamIOErrorHandler(evt:IOErrorEvent):void 
		{
		//	if (this.$ignoreError) 
		//	{
				this.$URLStream.removeEventListener(IOErrorEvent.IO_ERROR, this.URlStreamIOErrorHandler);
				trace("[DinLoader] 对不起,您以[渐进式]加载的文件[" +this.$url+ "]不存在,请检查路径是否正确.");
		//	}else this.dispatchEvent(evt);
			
		}
		
		/**
		 * 当出现安全沙箱错误时
		 * @param	evt
		 */
		private function URlStreamSecurityErrorHandler(evt:SecurityErrorEvent):void 
		{
		//	if (this.$ignoreError) 
		//	{
				this.$URLStream.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.URlStreamSecurityErrorHandler);
				trace("[DinLoader] 对不起,您以[渐进式]加载的文件[" +this.$url+ "]存在安全沙箱问题.");
		//	}else this.dispatchEvent(evt);
		}
		
		//=============================================
		//#### 为本实例添加实时侦听,为的就是实时显示图片
		//=============================================
		
		
		/**
		 * 实时侦听,显示图片
		 * @param	evt
		 */
		private function  onEnterFrame(evt:Event):void 
		{
			if (! this.$dataChange||! this.$URLStream.connected) return;
			
			this.$dataChange=false;
			if (this.$URLStream.bytesAvailable > 0) this.$URLStream.readBytes(this.$ByteArray, this.$ByteArray.length, this.$URLStream.bytesAvailable);
			
			if (this.$ByteArray.length>0) {
				super.unload();
				super.loadBytes(this.$ByteArray, this.$context);
			}
			// 加载完成 
			if (this.$streamComplete) {
				close();
				this.$streamComplete=false;
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
			if (this.$URLStream) {
				if (this.$URLStream.connected) {
					this.$URLStream.close();
				}
				this.streamRemoveEvent();
			}
			// 清除conentLoaderInfo相关的事件 
			if (this.contentLoaderInfo.hasEventListener(Event.COMPLETE))	this.LoaderRemoveEvent(super.contentLoaderInfo);

			// 清除显示数据事件 
			if (this.hasEventListener(Event.ENTER_FRAME)) {
				this.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
			}
//			super.close();
			this.$ByteArray=null;
		}

		/**
		 * 非渐进式加载 
		 * @param	$url 					需要加载的路径
		 * @param	$context			存放的域
		 */		
		public function loadNormal($url:String=null,$context:LoaderContext=null):void 
		{
			this.loaderMethod($url);
			super.unload();
			super.unloadAndStop();
			
			this.LoaderAddEvent(super.contentLoaderInfo);
			try 
			{
				super.load(this.$URLRequest, $context);
			}
			catch (err:TypeError)
			{
				trace("[DinLoader] 尝试加载["+this.$url+"]失败");
			}
		}
		
		/**
		 * 使用渐进式加载
		 * @param	$url
		 * @param	$context
		 */
		public function loadStream($url:String=null,$context:LoaderContext=null):void 
		{
			this.loaderMethod($url);
			if (!this.$URLStream) this.$URLStream = new URLStream();
			if (this.$URLStream.connected) this.$URLStream.close();
			
			this.$context = $context;
			this.$ByteArray = new ByteArray();
			
			super.unload();
			
			this.addEventListener(Event.ENTER_FRAME, this.onEnterFrame, false, 0, true);
			this.LoaderAddEvent(super.contentLoaderInfo);
			this.streamAddEvent();
			try 
			{
				this.$URLStream.load(this.$URLRequest);
			}
			catch (err:Error)
			{
				trace("[DinLoader] 尝试加载["+this.$url+"]失败");
			}
			
		}
		
		/** 
		* 加载字节数据,不会在内部触发contentLoaderInfo相关事件 
		* @param bytes 
		* @param context 
		*/
		override public function loadBytes($bytes:ByteArray, $context:LoaderContext = null):void {
			this.close();
			super.unload();
			super.loadBytes($bytes, $context);
		}
		
		
		
		//=======================================================
		//###### 获取/设置 属性
		//=======================================================
		
		
		/**
		 * 设置/获取 是否要忽略错误 默认:false
		 */
		public function get ignoreError():Boolean { return this.$ignoreError; }
		public function set ignoreError($value:Boolean):void 
		{
			this.$ignoreError = $value;
		}
		
		
		/**
		 * 设置/获取 加载的地址
		 */
		public function get url():String { return this.$url; }
		public function set url($value:String):void 
		{
			this.$url = $value;
		}
		
		/**
		 * 设置/获取 加载的变量参数 默认:null  
		 */
		public function get object():Object { return this.$object; }
		public function set object($value:Object):void 
		{
			this.$object = $value;
		}
		
		/**
		 * 设置/获取 加载数据的方法 默认为:get
		 */
		public function get method():String { return this.$method; }
		
		public function set method($value:String):void 
		{
			this.$method = $value;
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