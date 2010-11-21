package{
        /*
        iiacm(�Ż�����)����ҳ��Ϸ������ www.eb163.com 
        ��ҳ��Ϸ��������
        
        A*Ѱ·�㷨���������� demo �ĵ���
        */
        import flash.display.Sprite;
        import flash.events.MouseEvent;
        import flash.geom.Point;
        public class MainClass extends Sprite{
                //�趨��ͼ��Ԫ����
                protected var rowNum:uint=22;
                //�趨��ͼ��Ԫ����
                protected var columnNum:uint=20;
                //�趨��ͼ��Ԫ���
                protected var mcWidth:uint=25;
                //�趨��ͼ��Ԫ�߶�
                protected var mcHeight:uint=20;
                //�洢��ͼ��Ԫ���ݵ�����
                protected var mcArr:Array=new Array();
                //����һ��A*Ѱ·���ʵ�����󣬰ѵ�ͼ��Ԫ������Ϊ����������Ĺ��캯��
                protected var aStar:AStar=new AStar(mcArr);
                //��ǰ���
                protected var nowPoint:Point=new Point(5,5);
                //��ǰ�յ�
                protected var endPoint:Point;
                public function MainClass(){
                        init();
                }
                //��ʼ����������ͼ
                protected function init(){
                        createMcs();
                }
                //������������������ͼ��ͬʱ����ͼ����
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
                //Ϊ��ͼ��Ԫ��ӵ�������¼�������������㵽�������ͼ��Ԫ��λ�ý���Ѱ·���ı�alpha���Զ��ҵ���·�����
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
                //���ҵ�ǰ����ĵ�ͼ��Ԫ�����ص�Ԫ��������
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
                //���Ƶ�ͼ��Ԫ
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