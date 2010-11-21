package{
        /*
        iiacm(着火骷髅)，网页游戏开发网 www.eb163.com 
        网页游戏互动社区
        
        A*寻路运算节点类
                为寻路提供数据节点对象
        */
        import flash.display.DisplayObject;
        public class AStarGrid{
                //节点的父节点
                public var father:AStarGrid;
                //节点所在的行号
                public var dR:uint;
                //节点所在的列号
                public var dC:uint;
                //节点对应的地图单元
                public var mc:DisplayObject;
                //从此节点到目标节点的估计移动开销
                public var h:uint=0;
                //从起点起点沿着已生成的路径到此节点的移动开销
                public var g:uint=0;
                //节点的移动开销，用来衡量此节点的路径优先度
                public var f:uint=0;
                //构造函数，初始化节点的值
                public function AStarGrid(dataR:uint=0, dataC:uint=0, displayObj:DisplayObject=null, father=null){
                        father=father;
                        dR=dataR;
                        dC=dataC;
                        mc=displayObj;
                }
        }
}