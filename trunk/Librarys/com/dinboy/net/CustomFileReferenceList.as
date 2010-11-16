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
	public class CustomFileReferenceList extends FileReferenceList {

		private var uploadURL:URLRequest;
		private var pendingFiles:Array;
		
		public static const LISTLOAD_COMPLETE:String = "listComplete";

		public function CustomFileReferenceList(){
			uploadURL = new URLRequest();
			uploadURL.url = "upload.php";
			uploadURL.method = "POST";
			initializeListListeners();
		}

		private function initializeListListeners():void {
			addEventListener(Event.SELECT, selectHandler);
			addEventListener(Event.CANCEL, cancelHandler);
		}

		public function getTypes():Array {
			var allTypes:Array = new Array();
			allTypes.push(getImageTypeFilter());
			allTypes.push(getTextTypeFilter());
			return allTypes;
		}

		private function getImageTypeFilter():FileFilter {
			return new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif;*.png");
		}

		private function getTextTypeFilter():FileFilter {
			return new FileFilter("Text Files (*.txt, *.rtf)", "*.txt;*.rtf");
		}

		private function doOnComplete():void {
			var event:Event = new Event(LISTLOAD_COMPLETE);
			dispatchEvent(event);
		}

		private function addPendingFile(file:FileReference):void {
			trace("addPendingFile: name=" + file.name);
			pendingFiles.push(file);
			file.addEventListener(Event.OPEN, openHandler);
			file.addEventListener(Event.COMPLETE, completeHandler);
			file.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			file.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			file.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			file.upload(uploadURL);
		}

		private function removePendingFile(file:FileReference):void {
			for (var i:uint; i < pendingFiles.length; i++){
				if (pendingFiles[i].name == file.name){
					pendingFiles.splice(i, 1);
					if (pendingFiles.length == 0){
						doOnComplete();
					}
					return;
				}
			}
		}

		private function selectHandler(event:Event):void {
			trace("selectHandler: " + fileList.length + " files");
			pendingFiles = new Array();
			var file:FileReference;
			for (var i:uint = 0; i < fileList.length; i++){
				file = FileReference(fileList[i]);
				addPendingFile(file);
			}
		}

		private function cancelHandler(event:Event):void {
			//var file:FileReference = FileReference(event.target);
			//trace("cancelHandler: name=" + file.name);
		}

		private function openHandler(event:Event):void {
			var file:FileReference = FileReference(event.target);
			trace("openHandler: name=" + file.name);
		}

		private function progressHandler(event:ProgressEvent):void {
			var file:FileReference = FileReference(event.target);
			trace("progressHandler: name=" + file.name + " bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
		}

		private function completeHandler(event:Event):void {
			var file:FileReference = FileReference(event.target);
			trace("completeHandler: name=" + file.name);
			removePendingFile(file);
		}

		private function httpErrorHandler(event:Event):void {
			var file:FileReference = FileReference(event.target);
			trace("httpErrorHandler: name=" + file.name);
		}

		private function ioErrorHandler(event:Event):void {
			var file:FileReference = FileReference(event.target);
			trace("ioErrorHandler: name=" + file.name);
		}

		private function securityErrorHandler(event:Event):void {
			var file:FileReference = FileReference(event.target);
			trace("securityErrorHandler: name=" + file.name + " event=" + event.toString());
		}







		//============================================
		//===== Class[CustomFileReferenceList] Has Finish ======
		//============================================
	}

}