package com.dinboy.controls.renders 
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	

	/**
	 * @author		DinBoy
	 * @copy		钉崽 © 2010
	 * @version		v1.0 [2010-11-8 22:08]
	 */
	public class PromptHeader extends Sprite
	{
		/**
		 * 文本
		 */
		private var textField:TextField;
		
		private var _label:String;
		public function PromptHeader() 
		{
			
			super();
			textField = new TextField();
			textField.autoSize = "left";
			textField.wordWrap = false;
			textField.selectable = false;
			textField.textColor = 0xFFFFFF;
			textField.x = 5;
			textField.y = 5;
			textField.text = "label";
			addChild(textField);
			
			graphics.clear();
			graphics.beginFill(0x50B9F1);
			graphics.drawRoundRectComplex(0, 0, 100, textField.height+6,5,5,0,0);
			graphics.endFill();
			scale9Grid = new Rectangle(10+textField.width, 5 ,1, textField.height);
		}
		
		/**
		 * 文本
		 */
		public function get label():String { return textField.text; }
		public function set label(value:String):void 
		{
			textField.text = value;
			scale9Grid = new Rectangle(10+textField.width, 5 ,1, textField.height);
		}
		
		






	//============================================
	//===== Class[PromptHeader] Has Finish ======
	//============================================
	}

}