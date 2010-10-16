package {
import flash.display.Sprite;
import flash.events.Event;
public class Rotate2 extends Sprite{
   private var ball:Ball;
   private var vr:Number=0.05;
   private var cos:Number=Math.cos(vr);
   private var sin:Number=Math.sin(vr);
   public function Rotate2(){
    init();
   }
   private function init():void{
    ball=new Ball();
    addChild(ball);
    ball.x=Math.random()*stage.stageWidth;
    ball.y=Math.random()*stage.stageHeight;
    addEventListener(Event.ENTER_FRAME,onEnterFrame);
   }
   private function onEnterFrame(e:Event):void{
    var x1:Number=ball.x-stage.stageWidth/2;
    var y1:Number=ball.y-stage.stageHeight/2;
    var x2:Number=cos*x1-sin*y1;
    var y2:Number=cos*y1+sin*x1;
    ball.x=stage.stageWidth/2+x2;
    ball.y=stage.stageHeight/2+y2;
   }
}
}
