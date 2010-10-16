package  
{
	import com.dinboy.display.StageMask;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Dinboy.com
	 * @copy CopyRight © 2010 DinBoy
	 */
	public class StageMaskExample extends Sprite
	{
		
		public function StageMaskExample() 
		{
			StageMask.init(this);
			StageMask.htmlText = "<b>111111111</b>";
			StageMask.show();

			StageMask.hiden();
			
			
		}
		
		
		
		/********** [DINBOY] Say: Class The End  ************/	
	}

}