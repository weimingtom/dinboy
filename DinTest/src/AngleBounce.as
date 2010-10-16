package {
import flash.display.Sprite;
import flash.events.Event;
public class AngleBounce extends Sprite{
   private var ball:Ball;
   private var line:Sprite;
   private var gravity:Number=0.3;
   private var bounce:Number=-0.6;
   public function AngleBounce(){
    init();
   }
   private function init():void{
    ball=new Ball();
    addChild(ball);
    ball.x=100;
    ball.y=100;
    line=new Sprite();
    line.graphics.lineStyle(1);
    line.graphics.lineTo(300,0);
    addChild(line);
    line.x=50;
    line.y=200;
    line.rotation=30;
    addEventListener(Event.ENTER_FRAME,onEnterFrame);
   }
   private function onEnterFrame(e:Event):void{
    //普通的运动代码
    ball.vy+=gravity;
    ball.x+=ball.vx;
    ball.y+=ball.vy;
    //获得角度及正余弦值
    var angle:Number=line.rotation*Math.PI/180;
    var cos:Number=Math.cos(angle);
    var sin:Number=Math.sin(angle);
    //获得ball与line的相对位置
    var x1:Number=ball.x-line.x;
    var y1:Number=ball.y-line.y;
    //旋转坐标
    var x2:Number=cos*x1+sin*y1;
    var y2:Number=cos*y1-sin*x1;
    //旋转速度向量
    var vx1:Number=cos*ball.vx+sin*ball.vy;
    var vy1:Number=cos*ball.vy-sin*ball.vx;
    //实现反弹
    if(y2>-ball.height/2){
     y2=-ball.height/2;
     vy1*=bounce;
    }
    //将一切旋转回去
    x1=cos*x2-sin*y2;
    y1=cos*y2+sin*x2;
    ball.vx=cos*vx1-sin*vy1;
    ball.vy=cos*vy1-sin*vx1;
    ball.x=line.x+x1;
    ball.y=line.y+y1;
   }
}
}