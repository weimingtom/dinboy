package{
	import flash.display.*;
	import flash.events.*;
	public class Snow extends Sprite{
		public var radius:Number;
		public var angle:Number;
		public var speed:Number;
		public function Snow(){
			init();
			addEventListener(Event.ENTER_FRAME,enterFrameHandler);
		}
		public function init():void{
			radius=Math.random()*2;
			angle=(Math.random()+0.5)*Math.PI/2;
			speed=Math.random()+1;
			x=Math.random()*550;
			y=0;
			alpha=Math.random();
			graphics.clear();
			graphics.beginFill(0xffffff);
			graphics.drawCircle(0,0,radius);
			graphics.lineTo(100,100);
		}
		public function enterFrameHandler(e:Event):void{
			x+=speed*Math.cos(angle);
			y+=speed*Math.sin(angle);
			if(y>400||x<0||x>550){
				init();
			}
		}
	}
}