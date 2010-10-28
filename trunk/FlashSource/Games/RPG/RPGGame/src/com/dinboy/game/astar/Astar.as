package com.dinboy.game.astar 
{
	import com.dinboy.game.astar.util.CostsUtil;

	/**
	 * @author		DinBoy
	 * @copy		钉崽 © 2010
	 * @version		v1.0 [2010-10-21 22:55]
	 */
	public class Astar
	{
		/**
		 * 开放列表
		 */
		private var _openArray:Array;
		
		/**
		 * 关闭列表
		 */
		private var _closedArray:Array;
		
		/**
		 * 地图表格
		 */
		private var _mapGrid:AstarGrid;
		
		/**
		 * 开始节点
		 */
		private var _startNode:AstarNode;
		
		/**
		 * 结束节点
		 */
		private var _endNode:AstarNode;
		
		/**
		 * 路径数组
		 */
		private var _astarPath:Array;
		
		/**
		 * 估价公式
		 */
		private const _heuristic:Function = CostsUtil.diagonal;
		
		/**
		 * 直线代价
		 */
		private var _straightCost:Number = CostsUtil.straightCost;
		
		/**
		 * 对角线代价
		 */
		private var _diagCost:Number = CostsUtil.diagCost;
		public function Astar() 
		{
			
		}
		
		/**
		 * 判断节点是否在开启队列里面
		 * @param	__node	被检测的节点
		 * @return	节点是否开启
		 */
		private function isOpen(__node:AstarNode):Boolean
		{
			var i:int;
			for (i = 0; i < _openArray.length; i++) 
			{
				if (_openArray[i] == __node) return true;
			}
			return false;
		}
		
		/**
		 * 检测节点是否是在关闭队列里面
		 * @param	__node	需要被检测的节点
		 * @return	节点是否在关闭队列里面
		 */
		private function  isClosed(__node:AstarNode):Boolean
		{
			var i:int;
			for (i = 0; i < _closedArray.length; i++) 
			{
					if (_closedArray[i] == __node) return true;
			}
			return false;
		}
		
		/**
		 * 对指定的网格进行寻找路径,并返回是否找到路径
		 * @param	__grid	地图表格
		 * @return	是否找到路径
		 */
		public function findPath(__grid:AstarGrid):Boolean 
		{
			_mapGrid = __grid;
			_openArray = [];
			_closedArray = [];
			_startNode = _mapGrid.startNode;
			_endNode = _mapGrid.endNode;
			_startNode.g = 0;
			_startNode.h = _heuristic(_startNode,_endNode);
			_startNode.f = _startNode.g + _startNode.h;
			return searchPath();
		}
		
		/**
		 * 开始寻找路径,找到以后进行路径绘制,并返回是否找到路径
		 * @return	是否找到路径
		 */
		private function searchPath():Boolean
		{
			//路径搜寻的次数
			var __searchTimes:uint = 1;
			var __node:AstarNode = _startNode;
			
			//如果当前搜寻的节点不是结束节点,则继续搜寻
			while (__node!=_endNode) 
			{
				//找出相邻节点的X,Y
				var __startX:int = Math.max(0, __node.x - 1);
				var __startY:int = Math.max(0, __node.y - 1);
				var __endX:int = Math.min(_mapGrid.numCols - 1, __node.x + 1);
				var __endY:int = Math.min(_mapGrid.numRows - 1, __node.y + 1);
				
				var i:int;
				var j:int;
				
				//循环处理相邻的节点
				for (i = __startX; i <=__endX ; i++) 
				{
					for (j =__startY; j <= __endY; j++) 
					{
						var __testNode:AstarNode = _mapGrid.getNode(i, j);
						
						//如果被检测的节点是当前节点或者不能穿越,则跳过并继续
						if (__testNode == __node || !__testNode.walkable || !_mapGrid.getNode(__node.x, __testNode.y).walkable || !_mapGrid.getNode(__testNode.x, __node.y)) continue;
						
						//节点的对应代价
						var __cost:Number = _straightCost;
						//如果是对角线,则使用对角线代价
						if (!((__node.x == __testNode.x) || (__node.y == __testNode.y))) __cost = _diagCost;
						var  __g:Number = __node.g + __cost * __testNode.costMultiplier;
						var __h:Number = _heuristic(__testNode,_endNode);
						var __f:Number = __g + __h;
						
						//如果该节点在开放列表或者关闭列表里头
						if (isOpen(__testNode)||isClosed(__testNode)) 
						{
							//如果本次计算的代价更小,则以本次计算为准
							if (__f<__testNode.f) 
							{
								__testNode.f = __f;
								__testNode.g = __g;
								__testNode.h = __h;
								//重新指向该点的父级节点为计算节点
								__testNode.parent = __node;
							}
						}
						else 	//如果该点不在open列表中,则,除了更新代价以及父级节点以外,还必须加入到open列表里面
							{
								__testNode.f = __f;
								__testNode.g = __g;
								__testNode.h = __h;
								__testNode.parent = __node;
								
								//将测试节点加入到open列表
								_openArray.push(__testNode);
							}
					}
				}
				//把本轮处理过的节点加入到关闭列表
				_closedArray.push(__node);
				
				if (_openArray.length <= 0) return false; 
				
				//按总代价从小到大排列
				_openArray.sortOn("f", Array.NUMERIC);
				//从开放列表中删除代价最小的节点,同时把该节点赋值给__node,作为下次的中心点
				__node = _openArray.shift() as AstarNode;
				
				trace("第" + __searchTimes + "轮的最佳节点:" + __node.x,__node.y);
				__searchTimes++;
			}
			
			//循环过后进行路径创建
			buildPath();
			
			return true;
		}
		
		/**
		 * 根据父节点指向,从终点反向链接到开始点
		 */
		private function buildPath():void
		{
			_astarPath = [];
			var __Node:AstarNode = _endNode;
			_astarPath.push(__Node);
			while (__Node!=_startNode) 
			{
				__Node = __Node.parent;
				_astarPath.unshift(__Node);
			}
		}
		
		/**
		 * 开放列表
		 */
		public function get openArray():Array { return _openArray ; }
		
		/**
		 * 关闭列表
		 */
		public function get closedArray():Array { return _closedArray ; }
		
		/**
		 * 路径列表
		 */
		public function get path():Array { return _astarPath ; }






	//============================================
	//===== Class[Astar] Has Finish ======
	//============================================
	}

}