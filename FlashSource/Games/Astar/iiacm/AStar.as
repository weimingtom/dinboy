package{
        /*
        iiacm(着火骷髅)，网页游戏开发网 www.eb163.com 
        网页游戏互动社区
        
        A*寻路类
                使用A*算法实现自动寻找最佳路径功能
        */
        import flash.geom.Point;
        import flash.display.DisplayObject;
        public class AStar{
                //封闭列表
                protected var _closeList:Array=new Array();
                //开放列表
                protected var _openList:Array=new Array();
                //地图节点数据
                protected var _mapData:Array;
                //存储寻路结果的数组
                protected var way:Array=new Array();
                //起点节点
                protected var _startNode:AStarGrid;
                //目标节点
                protected var _targetNode:AStarGrid;
                //当前操作节点
                protected var _nowNode:AStarGrid;
                //是否找到路径，起始值false，完成寻路后为true
                protected var _isFind:Boolean=false;
                //从起点起点沿着已生成的路径到给定节点的移动开销，直线方向为g=10，斜线方向为obliqueG=14
                public var g:Number=10;
                public var obliqueG:Number=14;
                //从给定节点到目标节点的估计移动开销
                public var h:Number=10;
                //允许寻找的方向，值为8时表示可以从8个方向寻找路线，即允许斜线行走
                //public var direct:int=8;
                //构造函数，需要一个存储有地图节点数据的数组做参数
                public function AStar(mapData:Array){
                        _mapData=mapData;
                }
                //启动寻路
                public function findPath(startPos:Point, targetPos:Point):Array{
                        //设置起点、终点
                        _startNode=new AStarGrid(startPos.x, startPos.y, _mapData[startPos.x][startPos.y]);
                        _targetNode=new AStarGrid(targetPos.x, targetPos.y, _mapData[targetPos.x][targetPos.y]);
                        //在地图上标记出起点和终点
                        _startNode.mc.alpha=0;
                        _targetNode.mc.alpha=0;
                        //标记，设置起点为当前操作节点
                        _nowNode=_startNode;
                        //设置起始节点的父节点为null
                        setFather(_startNode, null);
                        //重置寻路结果
                        way=new Array();
                        //计算起始节点的g, h, f值
                        countHG(_startNode);
                        //将起始节点加入开放列表及封闭列表
                        addToOpen(_startNode);
                        addToClose(_startNode);
                        //获取起始节点周围节点
                        way=getAround(_startNode);
                        //-----------------------
                        return way;
                }
                //获取当前操作节点周围的节点，通过递归调用执行寻路过程
                protected function getAround(centreNode:AStarGrid):Array{
                        //声明两个数组，分别存放当前操作节点周围的节点数据及对应的地图单元
                        var aroundArr:Array=new Array();
                        var aroundNodeArr:Array=new Array();
                        //将当前操作节点周围的非空节点、地图单元分别加入aroundNodeArr和aroundArr数组，
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
                        //声明一个AStarGrid对象，存储在 aroundNodeArr 数组中具有f值最大的节点 
                        var fMaxGrid:AStarGrid;
                        //遍历 aroundNodeArr 数组，把数组中所有节点的父节点设为当前操作节点，计算他们的g, h, f值，并全部执行加入开放列表操作
                        for(var n:int=0; n<aroundArr.length; n++){
                                setFather(aroundNodeArr[n], centreNode);
                                countHG(aroundNodeArr[n]);
                                addToOpen(aroundNodeArr[n]);
                        }
                        //找出 aroundNodeArr 数组中具有f值最大的节点，存入 fMaxGrid 变量
                        for(var i:int=1; i<aroundNodeArr.length; i++){
                                for(var m:int=aroundNodeArr.length-1; m>=i; m--){
                                        if(aroundNodeArr[m].f<aroundNodeArr[m-1].f){
                                                var sNode:AStarGrid=aroundNodeArr[m-1];
                                                aroundNodeArr[m-1]=aroundNodeArr[m];
                                                aroundNodeArr[m]=sNode;
                                        }
                                }
                        }
                        //设置当前操作节点为 f 值最大的节点，并将其加入封闭列表
                        _nowNode=aroundNodeArr[0];
                        addToClose(aroundNodeArr[0]);
                        //判断 _isFind 的值确认是否完成寻路
                        var finishArr:Array=new Array();
                        if(!_isFind){
                                //否，则继续搜索当前节点的周围节点；
                                getAround(_nowNode);
                        }else{
                                //是，则输出路径
                                finishArr=getPath();
                        }
                        return finishArr;
                }
                //由目标节点开始，回溯父节点，知道父节点为null，即完成路径的查找
                protected function getPath():Array{
                        var pathArr:Array=new Array();
                        //判断如果起点与终点一致，则立刻返回路径，不一致就正常寻路
                        if(_targetNode.dR==_startNode.dR && _targetNode.dC==_startNode.dC){
                                pathArr.push(_targetNode);
                        }else{
                                //完成寻路后，清空开放、封闭列表，为下次寻路做准备
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
                //设置父节点
                protected function setFather(sonNode:AStarGrid, fatherNode:AStarGrid){
                        sonNode.father=fatherNode;
                }
                //计算节点的 g, h, f值
                protected function countHG(node:AStarGrid){
                        countH(node);
                        countG(node);
                        node.f=node.h+node.g;
                }
                //计算节点的 h 值
                protected function countH(node:AStarGrid):uint{
                        var xH:uint=Math.abs(_targetNode.dR-node.dR)*h;
                        var yH:uint=Math.abs(_targetNode.dC-node.dC)*h;
                        var hValue:uint=xH+yH;
                        node.h=hValue;
                        return hValue;
                }
                //计算节点的 g 值
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
                //将节点加入开放列表
                protected function addToOpen(addedNode:AStarGrid){
                        /*for(var i:int=0; i<_openList.length;i++){
                                if(_openList[i].dR==_targetNode.dR && _openList[i].dC==_targetNode.dC){
                                        _isFind=true;
                                        setFather(_targetNode, addedNode);
                                        break;
                                }
                        }
                        */
                        //判断加入开放列表的节点是否重复，重复则重新计算节点经由当前操作节点的 g 值，如果小于原来的 g 值，则将节点的父节点置为当前操作节点，否则取消加入开放列表
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
                //将节点加入封闭列表
                protected function addToClose(addedNode:AStarGrid){
                        _closeList.push(addedNode);
                        //判断目标节点是否在封闭列表中，在则将目标节点的父节点设为当前操作节点，寻路结束
                        for(var i:int=0; i<_closeList.length;i++){
                                if(_closeList[i].dR==_targetNode.dR && _closeList[i].dC==_targetNode.dC){
                                        _isFind=true;
                                        setFather(_targetNode, addedNode);
                                        break;
                                }
                        }
                }
                //把节点转化为相应的地图单元
                protected function gridToData(starGrid:AStarGrid):*{
                        return _mapData[starGrid.dR][starGrid.dC];
                }
                //把地图单元转化为相应的节点
                protected function dataToGrid(r:uint, c:uint, mc:DisplayObject):*{
                        return new AStarGrid(r, c, mc, null);
                }
        }
}