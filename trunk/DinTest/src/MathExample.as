package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @data $_DATA
	 * @author Dinboy.com
	 */
	public class MathExample extends Sprite
	{
		
		private var $count:int = 6;
		private var $max:int = 6;
		private var $angel:Number = 0;
		private var $speed:Number = 0.1;
		private var $Myname:Number = 2*(Math.PI) / (360/$count);
		public function MathExample() 
		{
			//trace(Math.sin(Math.PI/2));
			
			for (var i:int =0; i < this.$count; i++)
			{
				trace(Math.sin($Myname*i));
			}
			
	//		addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		/**
		 * 实时
		 * @param	evt
		 */
		private function  onEnterFrame(evt:Event):void 
		{
			if ($count%2==0) 
			{
				trace(Math.sin(Math.PI/(360/this.$count)));
			}
			
			this.$count++;
			//$angel += this.$speed;
			/*if (this.$angel>=360) 
			{
				this.$angel-=360
			}*/
		}
		
		
		/********** [DINBOY] Say: Class The End  ************/	
	}

}