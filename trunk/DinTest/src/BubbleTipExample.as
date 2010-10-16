package  
{
	import com.dinboy.display.BubbleTip;
	import flash.display.Sprite;
	import flash.utils.setTimeout;
	/**
	 * ...
	 * @author Dinboy.com
	 * @copy CopyRight © 2010 DinBoy
	 */
	public class BubbleTipExample extends Sprite
	{
		
		public function BubbleTipExample() 
		{
			
			BubbleTip.init( this );
			BubbleTip.autoshow = true;

			BubbleTip.text = "dsadasdasdsadasda";
			BubbleTip.show();
			BubbleTip.arrow = false;

			
			//setTimeout(function():void { BubbleTip.hide() }, 2000);
		}
		
		
		
		/********** [DINBOY] Say: Class The End  ************/	
	}

}