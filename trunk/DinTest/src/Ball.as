package  
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @data $_DATA
	 * @author Dinboy.com
	 */
	public class Ball extends Sprite
	{
		private var $vx:Number=0;
		private var $vy:Number=0;
		
		public function Ball() 
		{
			graphics.beginFill(0xFF0000);
			graphics.drawCircle(0, 0, 20);
			graphics.endFill();
			
		}
		
		
		public function get vx():Number 
		{
			return this.$vx;
		}
		public function set vx($value:Number):void 
		{
			this.$vx = $value;
		}
		
		public function get vy():Number 
		{
			return this.$vy;
		}
		public function set vy($value:Number):void 
		{
			this.$vy = $value;
		}
		
		
		
		
		/********** [DINBOY] Say: Class The End  ************/	
	}

}