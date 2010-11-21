package  
{
	import ascb.util.NumberFormat;
	import com.dinboy.game.astar.AstarGrid;
	import com.dinboy.game.astar.AstarNode;
	import com.dinboy.game.astar.util.CostsUtil;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author ...
	 */
	public class AstarTest extends Sprite 
	{
		/**
		 * 开始节点
		 */
		private var _startNode:AstarNode;
		
		/**
		 * 结束节点
		 */
		private var  _endNode:AstarNode;
		
		/**
		 * 本次计算的中心点
		 */
		private var _centerNode:AstarNode;
		
		/**
		 * 直线代价
		 */
		private var _straightCost:Number = 1.0;
		
		/**
		 * 对角线代价
		 */
		private var _diagCost:Number = Math.SQRT2;
		
		/**
		 * 测试用的地图数据
		 */
		private var _astarTestGrid:AstarGrid;
		
		public function AstarTest() 
		{
			_astarTestGrid = new AstarGrid(60, 60);
			_astarTestGrid.setStartNode(0, 0);
			_astarTestGrid.setEndNode(20, 15);
			
			_startNode = _astarTestGrid.startNode;
			_endNode = _astarTestGrid.endNode;
			_centerNode = _astarTestGrid.getNode(10, 10);
			
			var __NumFormat:NumberFormat = new NumberFormat();
					__NumFormat.mask = "#.0";
					
					
			/**
			 * 中心点相对于起点的g值
			 */
			var __g1:Number = CostsUtil.diagonal(_centerNode, _startNode);
			
			var i:int,j:int; 
			for (i = 0; i < 3; i++) 
			{
				for (j = 0; j < 2; j++) 
				{
					var __testNode:AstarNode = _astarTestGrid.getNode(i, j);
					var __h:Number = CostsUtil.diagonal(__testNode, _endNode);
					var __g2:Number = CostsUtil.diagonal(__testNode, _centerNode);
					var __g:Number = __g1 + __g2;			//计算该节点的g值
					var __f:Number = __h + __g;
					trace("i=",__testNode.x,"j:",__testNode.y,"f=",__NumFormat.format(__f),"g=",__NumFormat.format(__g),"h=",__NumFormat.format(__h));
				}
			}
			
			
			
		}
		
	}

}