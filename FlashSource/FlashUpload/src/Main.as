package 
{
	import com.dinboy.controls.PromptButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import com.dinboy.net.CustomFileReferenceList;
	
	/**
	 * ...
	 * @author 钉崽[dinboy]
	 */
	public class Main extends Sprite 
	{
		private var _customFileRef:CustomFileReferenceList;
		private var _uploadButton:PromptButton;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			_customFileRef = new CustomFileReferenceList();
			_customFileRef.addEventListener(CustomFileReferenceList.LISTLOAD_COMPLETE, listLoadCompleteHandler, false, 0, true);
			_uploadButton = new PromptButton();
			_uploadButton.label = "上传";
			addChild(_uploadButton);
			_uploadButton.addEventListener(MouseEvent.CLICK, uploadButtonClickHandler, false, 0, true);
		}
		
		private function uploadButtonClickHandler(event:MouseEvent):void 
		{
			_customFileRef.browse(_customFileRef.getTypes());
		}
		
		private function listLoadCompleteHandler(event:Event):void 
		{
			trace("Complete");
		}
		
	}
	
}