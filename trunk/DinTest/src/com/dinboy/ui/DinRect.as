package com.dinboy.ui 
{
	import flash.display.Sprite;
	

	/**
	 * @author		DinBoy
	 * @copy			钉崽 © 2010
	 * @version		v1.0 [2010-10-16 14:34]
	 */
	public class DinRect extends Sprite
	{
		
		public function DinRect($color:uint=0Xff0000,$width:Number=50,$height:Number=50,$alpha:Number=1) 
		{
			this.graphics.beginFill($color, $alpha);
			this.graphics.drawRect(0, 0, $width, $height);
			this.graphics.endFill();
		}






	//============================================
	//===== Class[DinRect] Has Finish ======
	//============================================
	}

}