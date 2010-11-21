package com.dinboy.game.astar.ui 
{
	import flash.display.Sprite;
	

	/**
	 * @author		钉崽 [Dinboy]
	 * @copy		dinboy © 2010
	 * @version		v1.0.0 [2010-11-21 1:12]
	 */
	public class Diamond extends Sprite
	{
		
		public function Diamond(__width:Number=40,__height:Number=20) 
		{
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
		}






	//============================================
	//===== Class[Diamond] Has Finish ======
	//============================================
	}

}