package 
{
        import flash.display.Sprite;
        import flash.events.MouseEvent;
        import flash.events.Event;
        import flash.display.Shape;
        import flash.display.StageAlign;
        import flash.display.StageScaleMode;
        public class routi extends Sprite
        {
                //存储点实例的数组
                private var pA:Array = new Array();
                
                //横向点的数目
                private var pwNum:int = 8;
                
                //纵向点的数目
                private var phNum:int = 15;
                
                //弹力系数
                private var Spring:Number = .05;
                
                //发生弹力的最小距离
                private var dmix:Number = 10;
                
                //弹力断裂的最大距离
                private var dmax:Number = 1000;
                
                private var sh:Shape = new Shape();

                public function routi()
                {


                        addChild(sh);
                        stage.align = StageAlign.TOP_LEFT;
                        stage.scaleMode = StageScaleMode.NO_SCALE;
                        //生成点
                        for (var w:int = 0; w< pwNum; w++)
                        {
                                pA[w] = new Array();
                                for (var h:int = 0; h< phNum; h++)
                                {
                                        var P:iooi = new iooi();
                                        P.x = 100 + 60 * w;
                                        P.y = 100 + 30 * h;
                                        addChild(P);
                                        pA[w].push(P);
                                }
                        }
                        
                        //定义第一行左右两个点不受力的影响
                        pA[0][0].moveMode = false;
                        pA[pwNum - 1][0].moveMode = false;
                        //一个点和其周围4个点之间的连线
                        function showline(w:int,h:int)
                        {

                                var mc:iooi = pA[w][h];
                                
                                if (h > 0)
                                {
                                        sh.graphics.moveTo(mc.x,mc.y);
                                        sh.graphics.lineTo(pA[w][h-1].x,pA[w][h-1].y);

                                }
                                if (w > 0)
                                {
                                        sh.graphics.moveTo(mc.x,mc.y);
                                        sh.graphics.lineTo(pA[w-1][h].x,pA[w-1][h].y);

                                }
                                if (w < pwNum - 1)
                                {
                                        sh.graphics.moveTo(mc.x,mc.y);
                                        sh.graphics.lineTo(pA[w+1][h].x,pA[w+1][h].y);

                                }
                                if (h < phNum - 1)
                                {
                                        sh.graphics.moveTo(mc.x,mc.y);
                                        sh.graphics.lineTo(pA[w][h+1].x,pA[w][h+1].y);

                                }
                        }
                        addEventListener(Event.ENTER_FRAME,N10);
                        function N10(e:Event)
                        {
                                sh.graphics.clear();
                                sh.graphics.lineStyle(1);
                                sh.graphics.beginFill(0x000000);
                                //一个点和其周围4个点之间的力的关系
                                for (var w:int = 0; w< pwNum; w++)
                                {
                                        for (var h:int = 0; h< phNum; h++)
                                        {
                                                var mc:iooi = pA[w][h];

                                                if (mc.moveMode)
                                                {
                                                        var dx:Number;
                                                        var dy:Number;
                                                        mc.ax = 0;
                                                        mc.ay = 0;
                                                        mc.ay += mc.g;

                                                        if (h>0)
                                                        {
                                                                dx=pA[w][h-1].x-pA[w][h].x;
                                                                dy=pA[w][h-1].y-pA[w][h].y;
                                                                countptop(mc,dx,dy);
                                                        }

                                                        if (w>0)
                                                        {
                                                                dx=pA[w-1][h].x-pA[w][h].x;
                                                                dy=pA[w-1][h].y-pA[w][h].y;
                                                                countptop(mc,dx,dy);
                                                        }
                                                        if (w<pwNum-1)
                                                        {
                                                                dx=pA[w+1][h].x-pA[w][h].x;
                                                                dy=pA[w+1][h].y-pA[w][h].y;
                                                                countptop(mc,dx,dy);
                                                        }

                                                        if (h<phNum-1)
                                                        {
                                                                dx=pA[w][h+1].x-pA[w][h].x;
                                                                dy=pA[w][h+1].y-pA[w][h].y;
                                                                countptop(mc,dx,dy);
                                                        }
                                                        mc.count();

                                                }
                                                showline(w,h);
                                                sh.graphics.endFill();
                                        }

                                }
                        }
                        //计算点的加速度
                        function countptop(mc:iooi,dx:Number,dy:Number)
                        {

                                mc.ax+=dx*Spring;
                                mc.ay+=dy*Spring;

                        }
                }


        }
}