package 
{
	import fl.controls.Button;
	import fl.controls.UIScrollBar;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;	
	import com.dinboy.net.DinFileReferenceList;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
		
		
		
		
	/**
	 * DinFileReferenceList	组件使用方法:
	 * DinFileReferenceList(url=null,array=null)	实例化一个多文件上载组件,url:上载的路径地址,array:可用的选择器数组(每个数组元素都是FileFilter对象)
	 * multiProcess				获取/设置 是否使用多进程上载(Boolean)
	 * percen						百分比,小数点(Number)
	 * upload(url)				开始上载,url:上载的地址(void)
	 * bytesTotal					所有已经选择的总字节大小(uint)
	 * bytesUploaded			已经上载的字节大小(uint)
	 * itemsLength				所有选择的文件个数(uint)
	 * itemsLoaded				已经上载完成的文件个数(uint)
	 * itemsLoading			正在上载的文件(Array)
	 * kilobytesTotal			准备上载的大小,千字节(uint)
	 * kilobytesUploaded	完成上载的大小,千字节(uint)
	 * getTypes()					返回可用的选择器数组(Array)
	 * /
	 
	 
	 
	 
	/**
	 * ...
	 * @author 钉崽[dinboy]
	 */
	public class FlashUpload extends Sprite 
	{
		/**
		 * 自定义多选上传
		 */
		private var _customFileRef:DinFileReferenceList;
		
		/**
		 * 上传按钮
		 */
		private var _uploadButton:Button;
		
		/**
		 * 选择按钮
		 */
		private var _selectButton:Button;
		
		/**
		 * 进度文本
		 */
		private var _detailTF:TextField;
		
		/**
		 * 信息文本
		 */
		private var _inofTF:TextField;
		
		/**
		 * 配置文件加载器
		 */
		private var _initURLLoad:URLLoader;
		
		/**
		 * 可上传的扩展名列表
		 */
		private var _fileFilterArray:Array;
		
		/**
		 * 可上传的最大个数
		 */
		private var _maxCount:uint;
		
		/**
		 * 可上传的最大千字节
		 */
		private var _maxBytes:uint;
		
		/**
		 * 滚动条
		 */
		private var _scrollBar:UIScrollBar
		
		/**
		 * 上传中的文件状态文本数组
		 */
		private var _filesStates:Array;
		
		/**
		 * 缓存字符串
		 */
		private var _tempStr:String;
		
		public function FlashUpload():void 
		{
			if (stage) initStage();
			else addEventListener(Event.ADDED_TO_STAGE, initStage);
		}
		
		private function initStage(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, initStage);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			// entry point
			
			initLoad(stage.loaderInfo.parameters["initXML"]);
		}
		
		/**
		 * 加载并.初始化
		 * @param	__url	配置文件地址
		 */
		private function initLoad(__url:String):void 
		{
			if (__url == null) 
			{
				trace("配置文件错误...");
				return; 
			}
			_initURLLoad = new URLLoader();
			_initURLLoad.load(new URLRequest(__url));
			_initURLLoad.addEventListener(Event.COMPLETE, initLoaderComplete, false, 0, true);
			_initURLLoad.addEventListener(IOErrorEvent.IO_ERROR, initLoaderIOError, false, 0, true);
		}
		
		/**
		 * 加载配置文件找不到时调度
		 * @param	event
		 */
		private function initLoaderIOError(event:IOErrorEvent):void 
		{
			trace("IOError");
		}
		
		/**
		 * 加载配置文件完成时调度
		 * @param	event
		 */
		private function initLoaderComplete(event:Event):void 
		{
			init(new XML(event.currentTarget.data));
		}
		
		/**
		 * 程序初始化
		 */
		private function init(__xml:XML):void 
		{
			_tempStr = "";
			_filesStates = [];
			
			_detailTF = new TextField();
			_detailTF.selectable = false;
			//_detailTF.autoSize = "left";
			_detailTF.width = 180;
			_detailTF.height = 160;
			_detailTF.y = 40;
			_detailTF.text = "没有文件上传.";
			_detailTF.wordWrap = true;
			addChild(_detailTF);
			
			_scrollBar = new UIScrollBar();
			_scrollBar.scrollTarget = _detailTF;
			_scrollBar.height = _detailTF.height;
			_scrollBar.x = 180;
			_scrollBar.y = _detailTF.y;
			addChild(_scrollBar);
			
			
			_inofTF = new TextField();
			_inofTF.selectable = false;
			_inofTF.autoSize = "left";
			_inofTF.textColor = 0x910003;
			_inofTF.y = 20;
			_inofTF.text = "选择了0个文件";
			addChild(_inofTF);
			_maxCount = __xml.maxCount != ""?uint(__xml.maxCount):20;
			_maxBytes = __xml.maxBytes != ""?uint(__xml.maxBytes):1048576;
			_fileFilterArray = [];
			var __fileFilters:XMLList=__xml.fileFilters;
			var i:int;
			for (i = 0; i <__fileFilters.item.length(); i++) 
			{
				_fileFilterArray.push(new FileFilter(__fileFilters.item[i].@description,__fileFilters.item[i].@extension));
			}
			
			_customFileRef = new DinFileReferenceList(__xml.uploadURL);
			_customFileRef.addEventListener(DinFileReferenceList.LISTLOAD_COMPLETE, listLoadCompleteHandler, false, 0, true);
			_customFileRef.addEventListener(DinFileReferenceList.LIST_SELECT, listSelectHandler, false, 0, true);
			_customFileRef.multiProcess = false	;
			
			_uploadButton = new Button();
			_uploadButton.buttonMode = true;
			_uploadButton.useHandCursor = true;
			_uploadButton.tabEnabled = false;
			_uploadButton.mouseEnabled = false;
			_uploadButton.label = "上传";
			_uploadButton.x = 160;
			_uploadButton.width = 40;
			_uploadButton.enabled = false;
			addChild(_uploadButton);
			_uploadButton.addEventListener(MouseEvent.CLICK, uploadButtonClickHandler, false, 0, true);
			
			_selectButton = new Button();
			_selectButton.buttonMode = true; 
			_selectButton.useHandCursor = true;
			_selectButton.tabEnabled = false;
			_selectButton.label = "选择上传文件";
			addChild(_selectButton);
			_selectButton.addEventListener(MouseEvent.CLICK, _selectButtonClickHandler, false, 0, true);
		}
		
		/**
		 * 组件们正在加载时调度
		 * @param	event
		 */
		private function itemsLoadingHandler(event:Event):void 
		{
			_detailTF.text = _tempStr;
		//	_detailTF.text = _customFileRef.itemsLoaded + "个文件 " +_customFileRef.kilobytesUploaded + "KB " + ((_customFileRef.percen) * 1000 >> 0) / 10 + "%\n";
			if (_customFileRef.itemsLoading.length<=0) 
			{
				return;
			}
			_detailTF.appendText(_filesStates[_customFileRef.itemsLoading[0].name]);
			_scrollBar.update();
			_scrollBar.scrollPosition = _scrollBar.maxScrollPosition;
		}
		
		/**
		 * 更新详细
		 * @return
		 */
		private function updataDetail():String 
		{
			var __str:String="";
			for (var name:String in _filesStates) 
			{
				__str += _filesStates[name];
			}
			return __str;
		}
		
		/**
		 * 当选择按钮点击时调度
		 * @param	event
		 */
		private function _selectButtonClickHandler(event:MouseEvent):void 
		{
			_customFileRef.browse(_fileFilterArray);
		}
		
		/**
		 * 当列表选择时调度
		 * @param	event
		 */
		private function listSelectHandler(event:Event):void 
		{
			if (event.currentTarget.itemsLength>_maxCount)
			{
				_inofTF.text = "您最多只能上传"+_maxCount+"个文件";
				return;
			}
			if (event.currentTarget.bytesTotal>_maxBytes)
			{
				_inofTF.text ="您最多只能上传"+(_maxBytes>>10>>10)+"M的文件";
				return;
			}
			_inofTF.text = event.currentTarget.itemsLength + "个文件,共" + event.currentTarget.kilobytesTotal + "KB";
			_detailTF.text = "点击[上传]按钮开始上传...";
			_uploadButton.mouseEnabled = true;
			_uploadButton.enabled = true;
			
			_tempStr = "";
			
			var i:int;
			for (i = 0; i < _customFileRef.fileList.length; i++) 
			{   
					var __file:FileReference = FileReference(_customFileRef.fileList[i]);
					_filesStates[__file.name] = "文件名：" + __file.name+"\n";
					__file.addEventListener(ProgressEvent.PROGRESS, filesProgressHandler, false, 0, true);
					__file.addEventListener(Event.COMPLETE, filesCompleteHandler, false, 0, true);
			}
		}
		
		/**
		 * 当上传完毕时调度
		 * @param	event
		 */
		private function filesCompleteHandler(event:Event):void 
		{
			_tempStr += _filesStates[event.currentTarget.name] = "[" + event.currentTarget.name + " ]-> 完成!\n";
			event.currentTarget.removeEventListener(Event.COMPLETE, filesCompleteHandler);
			event.currentTarget.removeEventListener(ProgressEvent.PROGRESS, filesProgressHandler);
		}
		
		/**
		 * 当单个文件上传时调度
		 * @param	event
		 */
		private function filesProgressHandler(event:ProgressEvent):void 
		{
			_filesStates[event.currentTarget.name] ="["+ event.currentTarget.name + "-> "+((event.bytesLoaded / event.bytesTotal) * 1000 >> 0) / 10 + "%\n";
		}
		
		/**
		 * 当点击上传按钮时调度
		 * @param	event
		 */
		private function uploadButtonClickHandler(event:MouseEvent):void 
		{
			_uploadButton.mouseEnabled = false;
			_uploadButton.enabled = false;
			_selectButton.enabled = false;
			_customFileRef.upload();
			_customFileRef.addEventListener(DinFileReferenceList.ITEM_UPLOADING, itemsLoadingHandler, false, 0, true);
		}
		
		/**
		 * 当所有列表加载完毕时调度
		 * @param	event
		 */
		private function listLoadCompleteHandler(event:Event):void 
		{
			_detailTF.appendText( "所有文件已经上载完成...");
			_customFileRef.removeEventListener(DinFileReferenceList.ITEM_UPLOADING, itemsLoadingHandler);
			var i:int;
			for (i = 0; i < _customFileRef.fileList.length; i++) 
			{
				//_customFileRef.fileList[i] = null;
			}
			_selectButton.enabled = true;
		}
		
	}
	
}