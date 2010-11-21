package{
        /*
        iiacm(�Ż�����)����ҳ��Ϸ������ www.eb163.com 
        ��ҳ��Ϸ��������
        
        A*Ѱ·��
                ʹ��A*�㷨ʵ���Զ�Ѱ�����·������
        */
        import flash.geom.Point;
        import flash.display.DisplayObject;
        public class AStar{
                //����б�
                protected var _closeList:Array=new Array();
                //�����б�
                protected var _openList:Array=new Array();
                //��ͼ�ڵ�����
                protected var _mapData:Array;
                //�洢Ѱ·���������
                protected var way:Array=new Array();
                //���ڵ�
                protected var _startNode:AStarGrid;
                //Ŀ��ڵ�
                protected var _targetNode:AStarGrid;
                //��ǰ�����ڵ�
                protected var _nowNode:AStarGrid;
                //�Ƿ��ҵ�·������ʼֵfalse�����Ѱ·��Ϊtrue
                protected var _isFind:Boolean=false;
                //�����������������ɵ�·���������ڵ���ƶ�������ֱ�߷���Ϊg=10��б�߷���ΪobliqueG=14
                public var g:Number=10;
                public var obliqueG:Number=14;
                //�Ӹ����ڵ㵽Ŀ��ڵ�Ĺ����ƶ�����
                public var h:Number=10;
                //����Ѱ�ҵķ���ֵΪ8ʱ��ʾ���Դ�8������Ѱ��·�ߣ�������б������
                //public var direct:int=8;
                //���캯������Ҫһ���洢�е�ͼ�ڵ����ݵ�����������
                public function AStar(mapData:Array){
                        _mapData=mapData;
                }
                //����Ѱ·
                public function findPath(startPos:Point, targetPos:Point):Array{
                        //������㡢�յ�
                        _startNode=new AStarGrid(startPos.x, startPos.y, _mapData[startPos.x][startPos.y]);
                        _targetNode=new AStarGrid(targetPos.x, targetPos.y, _mapData[targetPos.x][targetPos.y]);
                        //�ڵ�ͼ�ϱ�ǳ������յ�
                        _startNode.mc.alpha=0;
                        _targetNode.mc.alpha=0;
                        //��ǣ��������Ϊ��ǰ�����ڵ�
                        _nowNode=_startNode;
                        //������ʼ�ڵ�ĸ��ڵ�Ϊnull
                        setFather(_startNode, null);
                        //����Ѱ·���
                        way=new Array();
                        //������ʼ�ڵ��g, h, fֵ
                        countHG(_startNode);
                        //����ʼ�ڵ���뿪���б�����б�
                        addToOpen(_startNode);
                        addToClose(_startNode);
                        //��ȡ��ʼ�ڵ���Χ�ڵ�
                        way=getAround(_startNode);
                        //-----------------------
                        return way;
                }
                //��ȡ��ǰ�����ڵ���Χ�Ľڵ㣬ͨ���ݹ����ִ��Ѱ·����
                protected function getAround(centreNode:AStarGrid):Array{
                        //�����������飬�ֱ��ŵ�ǰ�����ڵ���Χ�Ľڵ����ݼ���Ӧ�ĵ�ͼ��Ԫ
                        var aroundArr:Array=new Array();
                        var aroundNodeArr:Array=new Array();
                        //����ǰ�����ڵ���Χ�ķǿսڵ㡢��ͼ��Ԫ�ֱ����aroundNodeArr��aroundArr���飬
                        if(centreNode.dC+1<_mapData[0].length){
                                aroundArr.push(_mapData[centreNode.dR][centreNode.dC+1]);
                                aroundNodeArr.push(dataToGrid(centreNode.dR, centreNode.dC+1, aroundArr[0]));
                        }
                        if(centreNode.dC-1>=0){
                                aroundArr.push(_mapData[centreNode.dR][centreNode.dC-1]);
                                aroundNodeArr.push(dataToGrid(centreNode.dR, centreNode.dC-1, aroundArr[1]));
                        }
                        if(centreNode.dR+1<_mapData.length){
                                aroundArr.push(_mapData[centreNode.dR+1][centreNode.dC]);
                                aroundNodeArr.push(dataToGrid(centreNode.dR+1, centreNode.dC, aroundArr[2]));
                        }
                        if(centreNode.dR-1>=0){
                                aroundArr.push(_mapData[centreNode.dR-1][centreNode.dC]);
                                aroundNodeArr.push(dataToGrid(centreNode.dR-1, centreNode.dC, aroundArr[3]));
                        }
                        if(centreNode.dR-1>=0 && centreNode.dC-1>=0){
                                aroundArr.push(_mapData[centreNode.dR-1][centreNode.dC-1]);
                                aroundNodeArr.push(dataToGrid(centreNode.dR-1, centreNode.dC-1, aroundArr[4]));
                        }
                        if(centreNode.dR+1<_mapData.length && centreNode.dC+1<_mapData[0].length){
                                aroundArr.push(_mapData[centreNode.dR+1][centreNode.dC+1]);
                                aroundNodeArr.push(dataToGrid(centreNode.dR+1, centreNode.dC+1, aroundArr[5]));
                        }
                        if(centreNode.dR-1>=0 && centreNode.dC+1<_mapData[0].length){
                                aroundArr.push(_mapData[centreNode.dR-1][centreNode.dC+1]);
                                aroundNodeArr.push(dataToGrid(centreNode.dR-1, centreNode.dC+1, aroundArr[6]));
                        }
                        if(centreNode.dR+1<_mapData.length && centreNode.dC-1>=0){
                                aroundArr.push(_mapData[centreNode.dR+1][centreNode.dC-1]);
                                aroundNodeArr.push(dataToGrid(centreNode.dR+1, centreNode.dC-1, aroundArr[7]));
                        }
                        //����һ��AStarGrid���󣬴洢�� aroundNodeArr �����о���fֵ���Ľڵ� 
                        var fMaxGrid:AStarGrid;
                        //���� aroundNodeArr ���飬�����������нڵ�ĸ��ڵ���Ϊ��ǰ�����ڵ㣬�������ǵ�g, h, fֵ����ȫ��ִ�м��뿪���б����
                        for(var n:int=0; n<aroundArr.length; n++){
                                setFather(aroundNodeArr[n], centreNode);
                                countHG(aroundNodeArr[n]);
                                addToOpen(aroundNodeArr[n]);
                        }
                        //�ҳ� aroundNodeArr �����о���fֵ���Ľڵ㣬���� fMaxGrid ����
                        for(var i:int=1; i<aroundNodeArr.length; i++){
                                for(var m:int=aroundNodeArr.length-1; m>=i; m--){
                                        if(aroundNodeArr[m].f<aroundNodeArr[m-1].f){
                                                var sNode:AStarGrid=aroundNodeArr[m-1];
                                                aroundNodeArr[m-1]=aroundNodeArr[m];
                                                aroundNodeArr[m]=sNode;
                                        }
                                }
                        }
                        //���õ�ǰ�����ڵ�Ϊ f ֵ���Ľڵ㣬������������б�
                        _nowNode=aroundNodeArr[0];
                        addToClose(aroundNodeArr[0]);
                        //�ж� _isFind ��ֵȷ���Ƿ����Ѱ·
                        var finishArr:Array=new Array();
                        if(!_isFind){
                                //�������������ǰ�ڵ����Χ�ڵ㣻
                                getAround(_nowNode);
                        }else{
                                //�ǣ������·��
                                finishArr=getPath();
                        }
                        return finishArr;
                }
                //��Ŀ��ڵ㿪ʼ�����ݸ��ڵ㣬֪�����ڵ�Ϊnull�������·���Ĳ���
                protected function getPath():Array{
                        var pathArr:Array=new Array();
                        //�ж����������յ�һ�£������̷���·������һ�¾�����Ѱ·
                        if(_targetNode.dR==_startNode.dR && _targetNode.dC==_startNode.dC){
                                pathArr.push(_targetNode);
                        }else{
                                //���Ѱ·����տ��š�����б�Ϊ�´�Ѱ·��׼��
                                var node:AStarGrid=_targetNode;
                                pathArr.push(node);
                                while(node.father!=null){
                                        var f:AStarGrid=node.father;
                                        pathArr.push(f);
                                        _mapData[node.dR][node.dC].alpha=.4;
                                        node=node.father;
                                }
                        }
                        pathArr[0].mc.alpha=0;
                        _isFind=false;
                        _closeList=new Array();
                        _openList=new Array();
                        _startNode=null;
                        _targetNode=null;
                        return pathArr;
                }
                //���ø��ڵ�
                protected function setFather(sonNode:AStarGrid, fatherNode:AStarGrid){
                        sonNode.father=fatherNode;
                }
                //����ڵ�� g, h, fֵ
                protected function countHG(node:AStarGrid){
                        countH(node);
                        countG(node);
                        node.f=node.h+node.g;
                }
                //����ڵ�� h ֵ
                protected function countH(node:AStarGrid):uint{
                        var xH:uint=Math.abs(_targetNode.dR-node.dR)*h;
                        var yH:uint=Math.abs(_targetNode.dC-node.dC)*h;
                        var hValue:uint=xH+yH;
                        node.h=hValue;
                        return hValue;
                }
                //����ڵ�� g ֵ
                protected function countG(node:AStarGrid):uint{
                        var n:AStarGrid=node;
                        var gValue:uint=0;
                        if(n.father!=null){
                                while(n.father!=null){
                                        var f:AStarGrid=n.father;
                                        if(f.dR==n.dR || f.dC==n.dC){
                                                gValue+=g;
                                        }else{
                                                gValue+=obliqueG;
                                        }
                                        n=n.father;
                                }
                        }else{
                                gValue=0;
                        }
                        node.g=gValue;
                        return gValue;
                }
                //���ڵ���뿪���б�
                protected function addToOpen(addedNode:AStarGrid){
                        /*for(var i:int=0; i<_openList.length;i++){
                                if(_openList[i].dR==_targetNode.dR && _openList[i].dC==_targetNode.dC){
                                        _isFind=true;
                                        setFather(_targetNode, addedNode);
                                        break;
                                }
                        }
                        */
                        //�жϼ��뿪���б�Ľڵ��Ƿ��ظ����ظ������¼���ڵ㾭�ɵ�ǰ�����ڵ�� g ֵ�����С��ԭ���� g ֵ���򽫽ڵ�ĸ��ڵ���Ϊ��ǰ�����ڵ㣬����ȡ�����뿪���б�
                        if(!_isFind){
                                for(var n:int=0; n<_openList.length; n++){
                                        if(_openList[n].dR==addedNode.dR && _openList[n].dC==addedNode.dC){
                                                var oldG:uint=addedNode.g;
                                                var newG:uint;
                                                if(_nowNode.dR==addedNode.dR || _nowNode.dC==addedNode.dC){
                                                        newG=_nowNode.g+g;
                                                }else{
                                                        newG=_nowNode.g+obliqueG;
                                                }
                                                if(newG<oldG){
                                                        setFather(addedNode, _nowNode);
                                                        countHG(addedNode);
                                                }else{
                                                }
                                        }else{
                                                _openList.push(addedNode);
                                        }
                                }
                        }else{
                        }
                }
                //���ڵ�������б�
                protected function addToClose(addedNode:AStarGrid){
                        _closeList.push(addedNode);
                        //�ж�Ŀ��ڵ��Ƿ��ڷ���б��У�����Ŀ��ڵ�ĸ��ڵ���Ϊ��ǰ�����ڵ㣬Ѱ·����
                        for(var i:int=0; i<_closeList.length;i++){
                                if(_closeList[i].dR==_targetNode.dR && _closeList[i].dC==_targetNode.dC){
                                        _isFind=true;
                                        setFather(_targetNode, addedNode);
                                        break;
                                }
                        }
                }
                //�ѽڵ�ת��Ϊ��Ӧ�ĵ�ͼ��Ԫ
                protected function gridToData(starGrid:AStarGrid):*{
                        return _mapData[starGrid.dR][starGrid.dC];
                }
                //�ѵ�ͼ��Ԫת��Ϊ��Ӧ�Ľڵ�
                protected function dataToGrid(r:uint, c:uint, mc:DisplayObject):*{
                        return new AStarGrid(r, c, mc, null);
                }
        }
}