package 
{
        import flash.display.Sprite;
        import flash.events.MouseEvent;
        public class iooi extends Sprite
        {
                //点的重力加速度
                public var g:Number = 0.1;
                //加速度
                public var ax:Number = 0;
                public var ay:Number = 0;
                //速度
                public var vx:Number = 0;
                public var vy:Number = 0;
                //真为受力影响,假为不受力的影响
                public var moveMode:Boolean = true;
                //模拟摩擦系数
                private var friction:Number = 0.9;
                public function iooi()
                {
                        this.buttonMode = true;
                        graphics.beginFill(0x000000,0);
                        graphics.drawCircle(0,0,10);
                        graphics.endFill();
                        addEventListener(MouseEvent.MOUSE_DOWN,mouseD);
                        addEventListener(MouseEvent.MOUSE_UP,mouseU);
                }
                public function count()
                {
                        vx += ax;
                        vy+=ay;
                        vx*=friction;
                        vy*=friction;
                        this.x+=vx;
                        this.y+=vy;
                }
                private function mouseD(e:MouseEvent)
                {
                        this.startDrag();
                        moveMode=false;
                }
                private function mouseU(e:MouseEvent)
                {
                        this.stopDrag();
                        if (! e.ctrlKey)
                        {
                                moveMode=true;
                        }
                }


        }
}