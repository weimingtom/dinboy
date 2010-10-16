package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @data $_DATA
	 * @author Dinboy.com
	 */
	public class Rotate1 extends Sprite
	{
	 private var ball:Ball;
   private var angle:Number=0;
   private var radius:Number=150;
   private var vr:Number = 0.01;
   
   public function Rotate1(){
    init();
   }
   private function init():void{
    ball=new Ball();
    addChild(ball);
    addEventListener(Event.ENTER_FRAME,onEnterFrame);
   }
   private function onEnterFrame(e:Event):void{
    ball.x=stage.stageWidth/2+Math.cos(angle)*radius;
    ball.y=stage.stageHeight/2+Math.sin(angle)*radius;
    angle += vr;
	trace(angle);
   }

		
		
		/********** [DINBOY] Say: Class The End  ************/	
	}

}