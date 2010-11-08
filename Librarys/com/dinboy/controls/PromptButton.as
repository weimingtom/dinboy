package com.dinboy.controls 
{
	import flash.display.CapsStyle;
	import flash.display.GradientType;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	

	/**
	 * @author		钉崽[dinboy]
	 * @copy		dinboy © 2010
	 * @version		v1.0 [2010-11-8 14:44]
	 */
	public class PromptButton extends Sprite
	{
		/**
		 * 按钮文本
		 */
		public var  textField:TextField;
		
		/**
		 * 按钮宽度
		 */
		private var _width:Number;
		
		/**
		 * 按钮高度
		 */
		private var _height:Number;
		
		/**
		 * 渐变 转换矩阵
		 */
		private var _matrix:Matrix;
		
		/**
		 * 透明度数组
		 */
		private var _alphas:Array;
		
		/**
		 * 颜色数组
		 */
		private var _colors:Array;
		
		/**
		 * 范围数组
		 */
		private var _rations:Array;
		
		/**
		 * 对话框按钮
		 */
		public function PromptButton() 
		{
			super();
			
			textField = new TextField();
			textField.autoSize = "center";
			textField.selectable = false;
			textField.text = "label";
			textField.wordWrap = true;
			textField.multiline = false;
			addChild(textField);
			_width = 100;
			_height = 20;
			
			_matrix = new Matrix();
			
			_alphas =  [255, 255];
			_colors =  [0xFFFFFF, 0xEAEAEA];
			_rations = [0, 0xFF];
			
			//绘制i背景
			drawBackground();
			
			//设置布局
			setLayout();
			
			
		}
	//============================================
	//===== Public Function ======
	//============================================
		
	//============================================
	//===== Private Function ======
	//============================================		
	/**
	 * 绘制背景
	 */
	private function drawBackground():void 
	{
		_matrix.createGradientBox(_width, _height, Math.PI / 2);
		
		if (textField.width > _width - 10) { textField.width = _width - 10; };
		if (textField.height > _height ) { textField.height = _height ; };
		
		graphics.clear()
		graphics.beginGradientFill(GradientType.LINEAR, _colors, _alphas, _rations, _matrix);
		graphics.lineStyle(1, 0xDDDDDD, 1,true, LineScaleMode.NONE, CapsStyle.ROUND, JointStyle.ROUND);
		graphics.drawRoundRect(0, 0, _width, _height, 10, 10);
		graphics.endFill();
	}
	
	/**
	 * 设置位置布局
	 */
	private function setLayout():void 
	{

		textField.x = width -textField.width >> 1;
		textField.y = height - textField.height >> 1;
	}
		
	//============================================
	//===== Getter && Setter ======
	//============================================
		/**
		 * 设置按钮文本
		 */
		public function get label():String { return textField.text; }
		public function set label(value:String):void 
		{			
			textField.text = value;		
		}
		
		/**
		 *[重写 override] 宽度
		 */
		override public function get width():Number { return super.width; }
		override public function set width(value:Number):void 
		{			
			_width = value;			
			drawBackground();		
			setLayout();			
			super.width = _width;	
		}
		
		/**
		 *[重写 override] 高度
		 */
		override public function get height():Number { return super.height; }
		override public function set height(value:Number):void 
		{		
			_height = value;	
			drawBackground();		
			setLayout();			
			super.height = _height;
		}
		
		
		
			
		
		
		
	

	//============================================
	//===== Class[PromptButton] Has Finish ======
	//============================================
	}

}