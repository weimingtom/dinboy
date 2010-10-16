package com.dinboy.ui 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author 钉崽 - [DinBoy.Com]
	 * @copy    CopyRight © 2010 DinBoy
	 */
	public class dinBall extends Sprite
	{
		private var $textField:TextField;
		
		/**
		 * 绘制一个球形
		 * @param	$object	color:球的填充颜色 ; alpha:球的填充透明度 ; thickness:球的边框大小; lineColor:球的边框颜色; lineAlpha:球的边框透明度; x:绘制球的X坐标 ; y:绘制球的Y坐标; radius:球的半径
		 */
		public function dinBall($object:Object) 
		{
			this.$textField = new TextField();
			this.$textField.autoSize = "left";
			this.$textField.selectable = false;
			if (!$object["color"])
				$object["color"] = 0XFF0000;
			if (!$object["alpha"])
				$object["alpha"] = 1;
			this.graphics.beginFill($object["color"], $object["alpha"]);
			this.graphics.lineStyle($object["thickness"], $object["lineColor"], $object["lineAlpha"]);
			this.graphics.drawCircle($object["x"], $object["y"], $object["radius"])
			
			this.addChild(this.$textField);
		}
		
		/**
		 * 设置显示文本
		 */
		public function set text($value:String):void 
		{
			this.$textField.text = $value;
			this.$textField.x = this.width - this.$textField.width >> 1;
			this.$textField.y = this.height - this.$textField.height >> 1;
		}
		
		
		
		/********** [DINBOY] Say: Class The End  ************/	
	}

}