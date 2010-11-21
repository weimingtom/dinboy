package{
        /*
        iiacm(着火骷髅)，网页游戏开发网 www.eb163.com 
        网页游戏互动社区
        
        A*寻路算法启发性搜索 demo 文档类
        */
        import flash.display.Sprite;
        import flash.events.MouseEvent;
        import flash.geom.Point;
        public class MainClass extends Sprite{
                //设定地图单元行数
                protected var rowNum:uint=22;
                //设定地图单元列数
                protected var columnNum:uint=20;
                //设定地图单元宽度
                protected var mcWidth:uint=25;
                //设定地图单元高度
                protected var mcHeight:uint=20;
                //存储地图单元数据的数组
                protected var mcArr:Array=new Array();
                //声明一个A*寻路类的实例对象，把地图单元数据作为参数传入类的构造函数
                protected var aStar:AStar=new AStar(mcArr);
                //当前起点
                protected var nowPoint:Point=new Point(5,5);
                //当前终点
                protected var endPoint:Point;
                public function MainClass(){
                        init();
                }
                //初始化，创建地图
                protected function init(){
                        createMcs();
                }
                //根据行数列数创建地图，同时填充地图数据
                protected function createMcs(){
                        for(var i:int=0; i<columnNum; i++){
                                mcArr[i]=new Array();
                                for(var j:int=0; j<rowNum; j++){
                                        var sprite:Sprite=drawRect();
                                        sprite.x=j*mcWidth;
                                        sprite.y=i*mcHeight;
                                        sprite.name="mc_"+i+"_"+j;
                                        mcArr[i].push(sprite);
                                        addChild(sprite);
                                        sprite.addEventListener(MouseEvent.CLICK, onClickSpriteHandler);
                                }
                        }
                }
                //为地图单元添加的鼠标点击事件处理函数，由起点到被点击地图单元的位置进行寻路，改变alpha属性对找到的路径标记
                protected function onClickSpriteHandler(e:MouseEvent){
                        for(var i=0;i<mcArr.length;i++){
                                for(var j=0;j<mcArr[i].length;j++){
                                        mcArr[i][j].alpha=1;
                                }
                        }
                        endPoint=checkMapPos(e.currentTarget as Sprite);
                        aStar.findPath(nowPoint, endPoint);
                        nowPoint=endPoint;
                }
                //查找当前点击的地图单元，返回单元所在坐标
                protected function checkMapPos(mapGrid:Sprite):Point{
                        var point:Point;
                        for(var i=0;i<mcArr.length;i++){
                                for(var j=0;j<mcArr[i].length;j++){
                                        if(mapGrid.name==mcArr[i][j].name){
                                                point=new Point(i,j);
                                                break;
                                        }
                                }
                        }
                        return point;
                }
                //绘制地图单元
                protected function drawRect():Sprite{
                        var sprite:Sprite=new Sprite();
                        sprite.graphics.lineStyle(.25, 0x232323, 1);
                        sprite.graphics.beginFill(0xffffff, 0.5);
                        sprite.graphics.drawRect(0, 0, mcWidth, mcHeight);
                        sprite.graphics.endFill();
                        return sprite;
                }
        }
}