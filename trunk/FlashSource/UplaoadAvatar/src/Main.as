package 
{
	import adobe.utils.CustomActions;
	import com.adobe.images.JPGEncoder;
	import com.dinboy.external.DinExternalInterface;
	import fl.controls.Button;
	import fl.controls.Slider;
	import fl.events.SliderEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Rectangle;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author 钉崽[Dinboy]
	 */
	public class Main extends Sprite 
	{
		[Embed(source = '../lib/wjw_logo.jpg')]
		private var TESTIMAGE:Class;
		
		private var _testImage:Bitmap;
		
		/**
		 * 编辑窗口
		 */
		private var _editWindow:EditWindow;
		
		/**
		 * 编辑信息窗口
		 */
		private var _editMessage:EditMessage;
		
		/**
		 * 大小控制器
		 */
		private var _sanpSlider:Slider;
		
		/**
		 * 浏览相片按钮
		 */
		private var _viewPhotoBtn:Button;
		
		/**
		 * 上传相片按钮
		 */
		private var _uploadPhotoBtn:Button;
		
		/**
		 * 浏览相片的元素
		 */
		private var _fileFilter:FileFilter;
		
		/**
		 * 可上传的控件
		 */
		private var _fileReference :FileReference;
		
		/**
		 * 可用的图片格式
		 */
		private var _filterType:String = "*.jpg;*.jpeg;*.png;*.gif";
		
		/**
		 * 图片加载器
		 */
		private var _bitmapLoader:Loader;
		
		/**
		 * 上传的路径
		 */
		private var postUrl:String;
		
		/**
		 * 图片的路径
		 */
		private var _photoURL:String;
		
		/**
		 * 图片的ID号
		 */
		private var _photoID:String;
		
		/**
		 * 上传完成返回的信息
		 */
		private var _requestInfo:String;
		
		/**
		 * 缓存图片
		 */
	//	private var tempBitmap:Bitmap;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			postUrl = stage.loaderInfo.parameters["postUrl"];
			
			_fileFilter = new FileFilter("图片格式(*.jpg;*.jpeg;*.png;*.gif)", _filterType);
			
			_fileReference = new FileReference();
			
			setupUI();
			
			setupEventHandler();
		}
		
		/**
		 * 配置UI对象显示
		 */
		private function  setupUI():void 
		{
			
			_testImage = new TESTIMAGE();
			_editWindow = new EditWindow(null,300,200,113,144);
			addChild(_editWindow);
			_editWindow.setSuitable();
			
			_editWindow.x = _editWindow.y = 10;
			
			_sanpSlider = new Slider();
			_sanpSlider.liveDragging = true;
			_sanpSlider.minimum = _editWindow.minimum;
			_sanpSlider.maximum = _editWindow.maximum;
			_sanpSlider.snapInterval = 0.005;
			_sanpSlider.width = _editWindow.width - 20;
			_sanpSlider.x = 20;
			_sanpSlider.y = _editWindow.y + _editWindow.height + 20;
			_sanpSlider.tickInterval = 0.5;
			
			addChild(_sanpSlider);
			
			_viewPhotoBtn = new Button();
			_viewPhotoBtn.label = "浏览相片";
			addChild(_viewPhotoBtn);
			_viewPhotoBtn.x = 50;
			
			_uploadPhotoBtn = new Button();
			_uploadPhotoBtn.label = "上传相片";
			addChild(_uploadPhotoBtn);
			_uploadPhotoBtn.enabled = false;
			_uploadPhotoBtn.x = 180;
			
			_viewPhotoBtn.y = _uploadPhotoBtn.y = _sanpSlider.y + 20;
			
			_bitmapLoader = new Loader();
			
			_editMessage = new EditMessage();
			_editMessage.x = 10;
			_editMessage.y = _viewPhotoBtn.y + 40;
			addChild(_editMessage);
		}
		
		/**
		 * 配置事件调度
		 */
		private function setupEventHandler():void 
		{
			_sanpSlider.addEventListener(SliderEvent.THUMB_DRAG, sanpSliderHandler, false, 0, true);
			_sanpSlider.addEventListener(SliderEvent.THUMB_PRESS, sanpSliderHandler, false, 0, true);
			_sanpSlider.addEventListener(SliderEvent.CHANGE, sanpSliderHandler, false, 0, true);
			
			_viewPhotoBtn.addEventListener(MouseEvent.CLICK, _viewPhotoBtnClickHandler, false, 0, true);
			_uploadPhotoBtn.addEventListener(MouseEvent.CLICK, _uploadPhotoBtnClickHandler, false, 0, true);
			
			_fileReference.addEventListener(Event.COMPLETE, filereferenceCompleteHandler,false,0,true);
			_fileReference.addEventListener(Event.SELECT, filereferenceSelectHandler, false, 0, true);
			
			_bitmapLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler, false, 0, true);
		}
		
		/**
		 * 当浏览按钮按下时调度
		 * @param	event
		 */
		private function _viewPhotoBtnClickHandler(event:MouseEvent):void 
		{
			_fileReference.browse([_fileFilter]);
		}
		
		/**
		 * 当上传按钮按下时调度
		 * @param	event
		 */
		private function _uploadPhotoBtnClickHandler(event:MouseEvent):void 
		{
			_editMessage.testPast();
			
			if (_editMessage.passed) 
			{
			_uploadPhotoBtn.enabled = false;
			sendByteToServer(_editWindow.snapSource);
			}
		}	
		
		/**
		 * 将图片数据发送到服务器
		 * @param	bit
		 */
		private function sendByteToServer(bit:BitmapData):void 
		{
			var 	jpgEncoder:JPGEncoder = new JPGEncoder(100);
            var 	byteArr:ByteArray = jpgEncoder.encode(bit);
			var  _senObject:Object = _editMessage.sendObject;
					postUrl += "&dead=" + _senObject.dead;
					postUrl += "&time=" + _senObject.time;
					postUrl += "&address=" + _senObject.address;
            var	urlRequest:URLRequest = new URLRequest(postUrl);
					urlRequest.data = byteArr;
					urlRequest.method = URLRequestMethod.POST;
					urlRequest.contentType = "application/octet-stream";
            var 	loader:URLLoader = new URLLoader();
					loader.load(urlRequest);
					loader.addEventListener(Event.COMPLETE, onUploadComplete);
				//	loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				//	loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
		}
		
		/**
		 * 当数据发送完成时调度
		 * @param	e
		 */
		private function onUploadComplete(event:Event):void 
		{
			var 	_resurt:XML = new XML(event.currentTarget.data);
					ExternalInterface.call("insertItem", _resurt.filepath.toString(), _resurt.message.toString(), _resurt.photoid.toString());
		}
		
		/**
		 * 当文件被选择时调度
		 * @param	event
		 */
		private function filereferenceSelectHandler(event:Event):void 
		{
			_fileReference.load();
		}
		
		/**
		 * 当浏览文件完成时调度
		 * @param	event
		 */
		private function filereferenceCompleteHandler(event:Event):void 
		{
			var _byteArray:ByteArray = event.currentTarget.data;
					_bitmapLoader.loadBytes(_byteArray);
		}
		
		/**
		 * 当按下滑块并随后随鼠标移动时调度
		 * @param	e
		 */
		private function sanpSliderHandler(event:SliderEvent):void 
		{
			_editWindow.size = _sanpSlider.value;
		}
		
		/**
		 * 加载器加载完成时调度
		 * @param	event
		 */
		private function loaderCompleteHandler(event:Event):void 
		{
			_editWindow.source = Bitmap(event.currentTarget.content).bitmapData;
			
			_sanpSlider.minimum = _editWindow.minimum;
			_sanpSlider.maximum = _editWindow.maximum;
			_sanpSlider.value = _editWindow.size;
			
			_uploadPhotoBtn.enabled = true;
		}
		
	}
	
}