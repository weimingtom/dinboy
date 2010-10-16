package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @data $_DATA
	 * @author Dinboy.com
	 */
	public class rotationExample extends Sprite
	{
		
		private var $Sprite:Sprite = new Sprite();
		public function rotationExample() 
		{
			this.$Sprite.graphics.beginFill(0x000000);
			this.$Sprite.graphics.drawRect(0, 0, 30, 30);
			this.$Sprite.graphics.endFill();
			this.x = 200;
			this.y = 200;
			this.addChild(this.$Sprite);
			this.addEventListener(Event.ENTER_FRAME, this.enterFrame, false, 0, true);
		}
		
		private function  enterFrame(evt:Event):void 
		{
			this.$Sprite.rotationZ++;
		}
		
		
		
		/********** [DINBOY] Say: Class The End  ************/	
	}

}