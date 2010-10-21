package com.dinboy.game.astar.util 
{
	import com.dinboy.game.astar.AstarNode;

	/**
	 * @author		DinBoy
	 * @copy		钉崽 © 2010
	 * @version		v1.0 [2010-10-21 11:33]
	 */
	public class CostsUtil
	{
		/**
		 * 直线代价
		 */
		public static var _straightCost:Number = 1.0;
		
		/**
		 *	对角线代价
		 */
		public static var _diagCost:Number = 1.4;
		
		
		/**
		 * 曼哈顿估价法
		 * @param	__startNode		开始节点
		 * @param	__endNode		结束节点
		 * @return	估价
		 */
		public static function manhattan(__startNode:AstarNode,__endNode:AstarNode):Number 
		{
			return Math.abs(__startNode.x - __endNode.x) * _straightCost + Math.abs(__startNode.y - __endNode.y) * _straightCost;
		}
		
		/**
		 * 几何评估法
		 * @param	__startNode	开始节点
		 * @param	__endNode	结束节点
		 * @return	估价
		 */
		public static function euclidian(__startNode:AstarNode,__endNode:AstarNode):Number 
		{
				var __dx:Number = __startNode.x - __endNode.x;
				var __dy:Number = __startNode.y - __endNode.y;
				
				return Math.sqrt(__dx * __dx + __dy * __dy)*_straightCost;
		}
		
		/**
		 * 对角线估价法
		 * @param	__startNode	开始节点
		 * @param	__endNode	结束节点
		 * @return	估价
		 */
		public static function diagonal(__startNode:AstarNode,__endNode:AstarNode):Number 
		{
				var __dx:Number = Math.abs(__startNode.x - __endNode.x);
				var __dy:Number = Math.abs(__startNode.y - __endNode.y);
				
				
				//最小对角
				var __diag:Number = Math.min(__dx, __dy);
				
				//直线距离
				var __straight:Number = __dx + __dy;
				
				return _diagCost * __diag + _straightCost * (__straight - 2 * __diag);
		}
		
	






	//============================================
	//===== Class[CostsUtil] Has Finish ======
	//============================================
	}

}