package ui 
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * @author		钉崽[Dinboy]
	 * @copy		2010 © dinboy.com
	 * @version		v1.0 [2011-3-24 17:10]
	 */
	public class ButtonBase extends MovieClip implements IButton
	{
		/**
		 * 是否禁用
		 */
		protected var _enabled:Boolean;
		
		/**
		 * 文本
		 */
		protected var _textField:TextField;
		
		/**
		 * 文本
		 */
		protected var _label:String;
		
		protected var _width:Number;
		
		protected var _height:Number;
		
		/**
		 * 文本样式
		 */
		protected var _textFormat:TextFormat;
		
		public function ButtonBase() 
		{
			addFrameScript(0, frame_1, 1, frame_2);
			super();
			setupUI();
		}
		
		private function frame_1():void 
		{
			stop();
		}
		
		private function frame_2():void 
		{
			stop();
		}
		
		private function setupUI():void 
		{
			_textField = new TextField();
			_textField.autoSize = "left";
			_textField.selectable = false;
			_textField.mouseEnabled = false;
			_textField.wordWrap = false;
			_textField.multiline = false;
			addChild(_textField);
			_width = width;
			_height = height;
			
			_textFormat = new TextFormat();
			_textFormat.color = 0x333333;
			_textField.setTextFormat(_textFormat);
		}
		
		private function setStyle():void 
		{
			_textField.x = _width - _textField.width >> 1;
			_textField.y = _height - _textField.height >> 1;
		}
		
		override	public function get enabled():Boolean 
		{
			return super._enabled;
		}
		
		override	public function set enabled(value:Boolean):void 
		{
			_enabled = value;
			if (_enabled) 
			{
				mouseEnabled = true;
				mouseChildren = true;
			}else 
			{
				mouseEnabled = false;
				mouseChildren = false;
			}
			super.enabled = _enabled;
		}
		
		public function get label():String 
		{
			return _label;
		}
		
		public function set label(value:String):void 
		{
			_label = value;
			_textField.text = _label;
			setStyle();
		}
		
		
		






	//============================================
	//===== Class[ButtonBase] Has Finish ======
	//============================================
	}

}