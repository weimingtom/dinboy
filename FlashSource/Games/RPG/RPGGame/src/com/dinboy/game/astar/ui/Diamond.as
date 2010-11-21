package com.dinboy.game.astar.ui 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	

	/**
	 * @author		钉崽 [Dinboy]
	 * @copy		dinboy © 2010
	 * @version		v1.0.0 [2010-11-21 1:12]
	 */
	public class Diamond extends Sprite
	{
		/**
		 * 提示文本
		 */
		private var textField:TextField;
		
		/**
		 * 菱形宽度
		 */
		private var _width:Number;
		
		/**
		 * 菱形高度
		 */
		private var _height:Number;
		public function Diamond(__width:Number=40,__height:Number=20) 
		{
			_width = __width;
			_height = __height;
			graphics.lineStyle(1);
			graphics.beginFill(0x00FFFF,0.1);
			graphics.drawRect(0, 0, __width, __height);
			graphics.endFill();
			graphics.beginFill(0x00FFFF,0.5);
			graphics.moveTo(0, __height * 0.5);
			graphics.lineTo(__width * 0.5, __height);
			graphics.lineTo(__width, __height*0.5);
			graphics.lineTo(__width*0.5, 0);
			graphics.lineTo(0, __height*0.5);
			graphics.endFill();
			mouseEnabled = false;
			
			textField = new TextField();
			textField.selectable = false;
			textField.mouseEnabled = false;
			textField.autoSize = "left";
			addChild(textField);
			
		}
		
		public function set text(value:String):void 
		{
			textField.text = value;
			textField.x = (_width-textField.width) * 0.5;
			textField.y = (_height - textField.height) * 0.5;
		}






	//============================================
	//===== Class[Diamond] Has Finish ======
	//============================================
	}

}