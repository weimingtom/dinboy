package com.dinboy.game.astar 
{

	/**
	 * @author		DinBoy
	 * @copy		钉崽 © 2010
	 * @version		v1.0 [2010-10-21 0:08]
	 */
	public class AstarGrid
	{
		/**
		 * 开始节点
		 */
		private var _startNode:AstarNode;
		
		/**
		 * 结束节点
		 */
		private var _endNode:AstarNode;
		
		/**
		 * 节点数组
		 */
		private var _nodesArray:Array;
		
		/**
		 * 节点列数
		 */
		private var _numCols:int;
		
		/**
		 * 节点行数
		 */
		private var _numRows:int;
		
		/**
		 * 网格
		 * @param	__numCols		网格列数
		 * @param	__numRows	网格行数
		 */
		public function AstarGrid(__numCols:int,__numRows:int) 
		{
			_numCols = __numCols;
			_numRows = __numRows;
			
			_nodesArray = new Array();				//实例初始化 节点数组
			var	__i:int,__j:int;
			for (__i = 0; __i < _numCols ; __i++) 
			{
				_nodesArray[__i] = new Array();
				for (__j = 0; __j <_numRows ; __j++) 
				{
					_nodesArray[__i][__j] = new AstarNode(__i, __j);				//开始遍历数组并添加节点
				}
			}
		}
		
		/**
		 * 获取所指示的点(__x,__y)的节点
		 * @param	__x		节点列坐标
		 * @param	__y		节点行坐标
		 * @return	一个节点
		 */
		public	function getNode(__x:int,__y:int):AstarNode
		{
			return _nodesArray[__x][__y] as AstarNode;
		}
		
		/**
		 * 设置开始节点
		 * @param	__x	开始节点的列坐标
		 * @param	__y	开始节点的行坐标
		 */
		public	function setStartNode(__x:int,__y:int):void 
		{
			_startNode[__x][__y] = _nodesArray[__x][__y] as AstarNode;
		}
		
		/**
		 * 设置结束节点
		 * @param	__x	结束节点的列坐标
		 * @param	__y	结束节点的行坐标
		 */
		public function setEndNode(__x:int,__y:int):void 
		{
			_endNode[__x][__y] = _nodesArray[__x][__y] as AstarNode;
		}
		
		/**
		 * 设置节点是否可以行走(穿越)
		 * @param	__x					节点的列坐标
		 * @param	__y					节点的行坐标
		 * @param	__walkable	是否可以穿越
		 */
		public function setWalkAble(__x:int,__y:int,__walkAble:Boolean):void 
		{
			_nodesArray[__x][__y].walkable = __walkAble;
		}
		
		/**
		 * 网格列数
		 */
		public function get numCols():int { return _numCols; }
		
		/**
		 * 网格行数
		 */
		public function get numRows():int { return _numRows; }
		
		/**
		 * 获取开始节点
		 */
		public function get startNode():AstarNode { return _startNode; }
		
		/**
		 * 获取结束节点
		 */
		public function get endNode():AstarNode { return _endNode; }





	//============================================
	//===== Class[AstarGrid] Has Finish ======
	//============================================
	}

}