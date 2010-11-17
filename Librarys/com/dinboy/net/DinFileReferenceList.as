package  com.dinboy.net {
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	import flash.net.URLRequest;


	/**
	 * @author		钉崽[dinboy]
	 * @copy		dinboy © 2010
	 * @version		v1.0 [2010-11-16 17:34]
	 */
	public class DinFileReferenceList extends FileReferenceList {

		/**
		 * 上传的地址的URLRequest
		 */
		private var _uploadURL:URLRequest;
		
		/**
		 *	所有的文件
		 */
		private var _pendingFiles:Array;
		
		/**
		 * 上传地址
		 */
		private var _url:String;
		
		/**
		 * 是否一起加载
		 */
		private var	_togetherLoad:Boolean;
		
		/**
		 * 所选择的总字节
		 */
		private var _bytesTotal:uint;
		
		/**
		 * 已经上传的字节数
		 */
		private var _bytesUploaded:uint;
		
		/**
		 * 可选择的文件类型数组
		 */
		private var _fileFilters:Array;
		
		/**
		 *	正在上传的组件数组.
		 */
		private var _uploadingItems:Array;
		
		/**
		 * 正在上传的组件数组
		 */
		private var _upLoadArray:Array;
		
		/**
		 * 已经上传的文件个数
		 */
		private var _itemsLoaded:uint;
		
		public static const LISTLOAD_COMPLETE:String = "listloadComplete";
		public static const LIST_SELECT:String = "listSelect";
		public static const LIST_CANCEL:String = "listCancel";
		public static const ITEM_UPLOADING:String = "item_Uploading";

		public function DinFileReferenceList(__url:String = null,__fileFilters:Array = null) {
			_uploadURL = new URLRequest();
			_fileFilters = __fileFilters;
			_url = __url;
			_togetherLoad = false;
			initializeListListeners();
		}

		/**
		 * 初始化列表监听
		 */
		private function initializeListListeners():void {
			addEventListener(Event.SELECT, selectHandler);
			addEventListener(Event.CANCEL, cancelHandler);
		}

		/**
		 * 获取所有可以上传的类型
		 * @return	类型数组
		 */
		public function getTypes():Array {
			if (_fileFilters != null) return  _fileFilters;
			var __allTypes:Array = new Array();
			__allTypes.push(getAllTypeFilter());
			return __allTypes;
		}
		
		/**
		 * 返回所有可用格式
		 * @return
		 */
		private function getAllTypeFilter():FileFilter 
		{
			return new FileFilter("所有可用格式 (*.*)", "*.*");
		}
		
		/**
		 * 所有上传完毕时调度
		 */
		private function doOnComplete():void {
			var event:Event = new Event(LISTLOAD_COMPLETE);
			dispatchEvent(event);
		}
		
		/**
		 * 将文件添加到列表数组
		 * @param	file
		 */
		private function addPendingFile(__file:FileReference):void {
//		trace("addPendingFile: name=" + file.name);
			_upLoadArray[__file.name] = 0;
			__file.addEventListener(Event.OPEN, openHandler);
			__file.addEventListener(Event.COMPLETE, completeHandler);
			__file.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			__file.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			__file.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			__file.upload(_uploadURL);
		}
		
		/**
		 * 删除所有列表数组中的文件
		 * @param	file
		 */
		private function removePendingFile(__file:FileReference):void {
			for (var i:uint; i < _pendingFiles.length; i++){
				if (_pendingFiles[i].name == __file.name){
					_pendingFiles.splice(i, 1);
					if (_pendingFiles.length == 0){
						doOnComplete();
					}
					return;
				}
			}
			var j:int;
			for (j = 0; j < _uploadingItems.length; j++)
			{
				_uploadingItems.slice(__file, 1);
			}
		}
		
		/**
		 * 当完成选择时调度
		 * @param	event
		 */
		private function selectHandler(event:Event):void {
//		trace("selectHandler: " + fileList.length + " files");
			_bytesTotal = 0;
			var __file:FileReference;
			for (var i:uint = 0; i < fileList.length; i++){
				__file = FileReference(fileList[i]);
				_bytesTotal += __file.size;
			}
			dispatchEvent(new Event(LIST_SELECT));
		}
		
		/**
		 * 当取消选择时调度
		 * @param	event
		 */
		private function cancelHandler(event:Event):void {
			//var file:FileReference = FileReference(event.target);
			//trace("cancelHandler: name=" + file.name);
		}
		
		/**
		 * 当打开对话框时调度
		 * @param	event
		 */
		private function openHandler(event:Event):void {
//			var file:FileReference = FileReference(event.target);
//			trace("openHandler: name=" + file.name);
		}
		
		/**
		 * 当单个文件上传进行时调度
		 * @param	event
		 */
		private function progressHandler(event:ProgressEvent):void {
//		var file:FileReference = FileReference(event.target);
			_upLoadArray[event.target.name] = event.bytesLoaded;
			updataBytesLoaded();
			
			if (event.bytesLoaded==event.bytesTotal) 
			{
				_itemsLoaded+=1;
			}
			dispatchEvent(new Event(ITEM_UPLOADING));
		}
		
		/**
		 * 更新已经下载完成的字节
		 */
		private function updataBytesLoaded():void 
		{
			_bytesUploaded=0;
			for (var name:String in _upLoadArray) 
			{
				_bytesUploaded += _upLoadArray[name];
			}
		}
		
		/**
		 * 当单个文件加载完成时调度
		 * @param	event
		 */
		private function completeHandler(event:Event):void {
			var __file:FileReference = FileReference(event.target);
			//trace("completeHandler: name=" + file.name);
			__file.removeEventListener(Event.OPEN, openHandler);
			__file.removeEventListener(Event.COMPLETE, completeHandler);
			__file.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			__file.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			__file.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			removePendingFile(__file);
			
			//如果不是一起上载,则陆续上载.
			if (!_togetherLoad) 	{ queueUpload(); }
		}

		/**
		 * 当出现http协议错误时调度
		 * @param	event
		 */
		private function httpErrorHandler(event:Event):void {
//			var file:FileReference = FileReference(event.target);
//			trace("httpErrorHandler: name=" + file.name);
		}

		/**
		 * 当出现IO错误时调度
		 * @param	event
		 */
		private function ioErrorHandler(event:Event):void {
//			var file:FileReference = FileReference(event.target);
//			trace("ioErrorHandler: name=" + file.name);
		}

		/**
		 * 当遇到安全沙箱问题时调度
		 * @param	event
		 */
		private function securityErrorHandler(event:Event):void {
//			var file:FileReference = FileReference(event.target);
//			trace("securityErrorHandler: name=" + file.name + " event=" + event.toString());
		}
		
		/**
		 * 开始上传
		 * @param	_url	上传地址
		 */
		public function upload(__url:String=null):void 
		{
			if (__url != null) _url = __url;
			if (_url == null) return;
			_uploadURL.url=_url
			_pendingFiles = [];
			_uploadingItems = [];
			_upLoadArray = [];
			_itemsLoaded = 0;
			var __file:FileReference;
			for (var i:uint = 0; i < fileList.length; i++) {
				__file = FileReference(fileList[i]);
				_pendingFiles.push(__file);
			}
			
			if (_togetherLoad) 
			{
				togetherUpload();
			}else 
			{
				queueUpload();
			}
		}
		
		/**
		 * 所有选择的文件一起上传
		 */
		private function togetherUpload():void 
		{
			for (var i:uint = 0; i < _pendingFiles.length; i++) {
				addPendingFile(_pendingFiles[i]);
				_uploadingItems.push(_pendingFiles[i]);
			}
		}
		
		/**
		 * 队列上传
		 * @param	file	上传的文件
		 */
		private function queueUpload():void 
		{
			if (_pendingFiles.length <= 0) return;
			addPendingFile(_pendingFiles[0]);
			_uploadingItems.push(_pendingFiles[0]);
		}
		

		
		/**
		 * [只读 readOnly] 选择的所有文件个数
		 */
		public function get itemLength():uint { return fileList.length; }
		
		/**
		 * 是否一起加载
		 */
		public function get togetherLoad():Boolean { return _togetherLoad; }
		public function set togetherLoad(value:Boolean):void 
		{
			_togetherLoad = value;
		}
		
		/**
		 * [只读 readOnly] 正在加载的对象数组
		 */
		public function get uploadingItems():Array { return _uploadingItems; }
		
		/**
		 * [只读 readOnly] 已经加载的总字节数
		 */
		public function get bytesUploaded():uint { return _bytesUploaded; }
		
		/**
		 * [只读 readOnly] 所有文件的总字节
		 */
		public function get bytesTotal():uint { return _bytesTotal; }
		
		/**
		 * [只读 readOnly]	所有文件的千字节
		 */
		public function get kilobytesTotal():uint { return _bytesTotal >> 10; }
		
		/**
		 * [只读 readOnly] 已经加载的总千字节数
		 */
		public function get kilobytesUploaded():uint { return _bytesUploaded >> 10; }
		
		/**
		 *  [只读 readOnly] 百分数
		 */
		public function get percen():Number { return _bytesUploaded / _bytesTotal; }
		
		/**
		 * [只读 readOnly] 已经加载完成的个数
		 */
		public function get itemsLoaded():uint { return _itemsLoaded; }
		
		




		//============================================
		//===== Class[CustomFileReferenceList] Has Finish ======
		//============================================
	}

}