package com.cyy.astar {

	/**
	 * ...
	 * @author Will Chen
	 * @version 1.0
	 * @email c_youyou@163.com
	 * @msn chenyouyou@live.cn
	 * @description ...
	 */
	public class AStar {
		private var openList:Array;
		private var closedList:Array;
		private var _path:Array;
		private var grid:AStarGrid;
		private var endNode:AStarNode;
		private var startNode:AStarNode;
		private var costOne:Number = 1;
		private var costSqrt:Number = Math.SQRT2;

		public function AStar(){
		}

		public function findPath(grid:AStarGrid):Boolean {
			this.grid = grid;
			openList = new Array();
			closedList = new Array();
			grid.startNode.g = 0;
			grid.startNode.h = getH(grid.startNode);
			grid.startNode.f = grid.startNode.g + grid.startNode.h;
			return begin();
		}

		private function begin():Boolean {
			var node:AStarNode = grid.startNode;
			while (node != grid.endNode){
				var beginX:int = node.x == 0 ? 0 : node.x - 1;
				var endX:int = node.x == grid.columnNum - 1 ? grid.columnNum - 1 : node.x + 1;
				var beginY:int = node.y == 0 ? 0 : node.y - 1;
				var endY:int = node.y == grid.rowNum - 1 ? grid.rowNum - 1 : node.y + 1;
				for (var i:int = beginX; i <= endX; i++){
					for (var j:int = beginY; j <= endY; j++){
						var currentNode:AStarNode = grid.getNode(i, j);
						if (currentNode == node || !currentNode.isEmpty || (!grid.getNode(node.x, currentNode.y).isEmpty && !grid.getNode(currentNode.x, node.y).isEmpty)){
							continue;
						}
						var cost:Number = costOne;
						if (!((node.x == currentNode.x) || (node.y == currentNode.y))){
							cost = costSqrt;
						}
						var g:Number = node.g + cost;
						var h:Number = getH(currentNode);
						var f:Number = g + h;
						if (openList.indexOf(currentNode) == -1 && closedList.indexOf(currentNode) == -1){
							currentNode.f = f;
							currentNode.g = g;
							currentNode.h = h;
							currentNode.parent = node;
							openList.push(currentNode);
						}
					}
				}
				closedList.push(node);
				if (openList.length == 0){
					return false
				}
				openList.sortOn("f", Array.NUMERIC);
				node = openList.shift();
			}
			_path = new Array();
			node = grid.endNode;
			_path.push(node);
			while (node != grid.startNode){
				node = node.parent;
				_path.unshift(node);
			}
			return true;
		}

		private function getH(node:AStarNode):Number {
			var dx:Number = node.x - grid.endNode.x;
			var dy:Number = node.y - grid.endNode.y;
			return Math.sqrt(dx * dx + dy * dy);
		}

		public function get path():Array {
			return _path;
		}
	}
}
