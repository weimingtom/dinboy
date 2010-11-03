package com.dinboy.ui 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	

	/**
	 * @author		钉崽[dinboy]
	 * @copy		dinboy © 2010
	 * @version		v1.0 [2010-11-3 15:03]
	 */
	public class Loading extends Sprite
	{		
		[Embed(source="../../../lib/04B_08__.TTF", fontName="FONT04B_08", unicodeRange="U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E")]
		public static var FONT04B_08:Class; 
		
		/**
		 * 英文文本样式
		 */
		private var _englishTextFormat:TextFormat;
		
		/**
		 * 用户文本
		 */
		private var _logoAuthorTextField:TextField;
		
		/**
		 * 百分比
		 */
		private var _percentTextField:TextField;
		
		/**
		 * 滚动条
		 */
		private var _loadingScroller:Sprite;
		
		/**
		 * 不可使用的滚动条
		 */
		private var _loadingScrollerDisable:Sprite;
		
		/**
		 * 背景
		 */
		private var _loadingBackground:Sprite;
		
		/**
		 * 原始宽度
		 */
		private var _scrollerWidth:Number;
		
		/**
		 * 百分比宽度
		 */
		private var _percentageWidth:Number
		
		public function Loading() 
		{
			initUI();
		}
		
		/**
		 *	初始化UI对象
		 */
		private function initUI():void 
		{
			_loadingBackground = new LoadingBackground();
			addChild(_loadingBackground);
			
			_loadingScrollerDisable = new LoadingScrollerDisable();
			_loadingScrollerDisable.x = 20;
			_loadingScrollerDisable.y = 10;
			addChild(_loadingScrollerDisable);
			
			_loadingScroller = new LoadingScroller();
			_loadingScroller.x = 20;
			_loadingScroller.y = 10;
			_scrollerWidth = _loadingScroller.width;
			_percentageWidth = _scrollerWidth / 100;
			_loadingScroller.width = 0;
			addChild(_loadingScroller);
			
			_englishTextFormat = new TextFormat("FONT04B_08");
			_englishTextFormat.color = 0xD9D9D9;
			_englishTextFormat.size = 8;
			
			 _logoAuthorTextField = new TextField();
			 _logoAuthorTextField.defaultTextFormat = _englishTextFormat;
			 _logoAuthorTextField.selectable = false;
			 _logoAuthorTextField.embedFonts = true;
			 _logoAuthorTextField.autoSize = TextFieldAutoSize.RIGHT;
			 _logoAuthorTextField.x = 190;
			 _logoAuthorTextField.y = 36;
			 _logoAuthorTextField.htmlText = "Loading By <a href=\"http://www.dinboy.com\">dinboy</a>";
			 addChild(_logoAuthorTextField);
			 
			 _englishTextFormat.color = 0x000000;
			 _percentTextField = new TextField();
			 _percentTextField.defaultTextFormat = _englishTextFormat;
			 _percentTextField.selectable = false;
			 _percentTextField.embedFonts = true;
			 _percentTextField.autoSize = TextFieldAutoSize.CENTER;
			 _percentTextField.x = width>>1;
			 _percentTextField.y = 22;
			 _percentTextField.text = "100%";
			 addChild(_percentTextField);
		}
		
		/**
		 * 设置百分比
		 */
		public function set percent(value:Number):void 
		{
			_loadingScroller.width = value * _percentageWidth;
			_percentTextField.text = value + "%";
		}

		





	//============================================
	//===== Class[loading] Has Finish ======
	//============================================
	}

}