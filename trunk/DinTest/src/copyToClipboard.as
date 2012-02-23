package  {
	import com.dinboy.external.DinExternalInterface;
	import flash.desktop.ClipboardFormats;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.desktop.Clipboard;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Dinboy 钉崽
	 */
	public class copyToClipboard extends Sprite 
	{
	
		/**
		 * 专门点击的影片剪辑
		 */
		private var _clickSprite:Sprite;
		
		/**
		 * HTML参数
		 */
		private var _parameters:Object;
		
		/**
		 * 需要写入剪切板的数据
		 */
		private var _clipData:String;
		
		/**
		 * 文本
		 */
		private var _textfield:TextField;
		public function copyToClipboard() 
		{
			if (stage) init()
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/**
		 * 
		 * @param	event
		 */
		private function init(event:Event=null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_parameters = stage.loaderInfo.parameters;
			
			_clickSprite = new Sprite();
			addChild(_clickSprite);
			_clickSprite.buttonMode = true;
			stage.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
			
			stage.addEventListener(Event.RESIZE, stageResizeHandler, false, 0, true);
			stage.dispatchEvent(new Event(Event.RESIZE));
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
			
			DinExternalInterface.jsAddCallback("setData", setData);
		}
		
		private function enterFrameHandler(e:Event):void 
		{
			if (stage) 
			{
				_clickSprite.graphics.clear();
				_clickSprite.graphics.beginFill(0,0.01);
				_clickSprite.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
				_clickSprite.graphics.endFill();
			}
		}
		
		/**
		 * 
		 * @param	e
		 */
		private function stageResizeHandler(e:Event):void 
		{
			if (stage.stageWidth==0) stageResizeHandler(e);
		}
		
		/**
		 * 
		 * @param	e
		 */
		private function clickHandler(e:MouseEvent=null):void 
		{
			trace(_parameters["text"]);
			try 
			{
				Clipboard.generalClipboard.clear();
				Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, _parameters["text"]);
				DinExternalInterface.jsCall("clipComplete", _parameters["text"]);
			}catch (err:Error)
			{
				trace(err);
			}
		}
		
		/**
		 * 设置数据到剪切板
		 * @param	text
		 */
		private function setData(text:String=null):void 
		{
			_clipData = text;
			stage.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
	}
}