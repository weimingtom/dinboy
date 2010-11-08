package com.dinboy.controls.renders 
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	

	/**
	 * @author		DinBoy
	 * @copy		钉崽 © 2010
	 * @version		v1.0 [2010-11-8 22:14]
	 */
	public class PromptContainer extends Sprite
	{
		private var _scale9Grid:Rectangle= new Rectangle(5,.1,40, 15);
		public function PromptContainer() 
		{
			
			super();
			this.graphics.clear();
			this.graphics.beginFill(0xE1F3FD);
			this.graphics.drawRoundRectComplex(0, 0, 50, 20,0,0,5,5);
			this.graphics.endFill();

		
			
			scale9Grid = _scale9Grid;
			
		}






	//============================================
	//===== Class[PromptContainer] Has Finish ======
	//============================================
	}

}