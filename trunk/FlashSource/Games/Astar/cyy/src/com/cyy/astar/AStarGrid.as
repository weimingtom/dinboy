package com.cyy.astar {

	/**
	 * ...
	 * @author Will Chen
	 * @version 1.0
	 * @email c_youyou@163.com
	 * @msn chenyouyou@live.cn
	 * @description ...
	 */
	public class AStarGrid {
		public var startNode:AStarNode;
		public var endNode:AStarNode;
		public var nodes:Array;
		public var columnNum:int;
		public var rowNum:int;

		public function AStarGrid(columnNum:int, rowNum:int){
			this.columnNum = columnNum;
			this.rowNum = rowNum;
			nodes = new Array();
			for (var i:int = 0; i < columnNum; i++){
				nodes[i] = new Array();
				for (var j:int = 0; j < rowNum; j++){
					nodes[i][j] = new AStarNode(i, j);
				}
			}
		}

		public function getNode(x:int, y:int):AStarNode {
			return nodes[x][y];
		}

		public function setEndNode(x:int, y:int):AStarNode {
			if (x < this.columnNum && y < this.rowNum){
				endNode = nodes[x][y];
			} else {
				endNode = null;
			}
			return endNode;
		}

		public function setStartNode(x:int, y:int):AStarNode {
			if (x < this.columnNum && y < this.rowNum){
				startNode = nodes[x][y];
			} else {
				startNode = null;
			}
			return startNode;
		}

		public function setNodeEmpty(x:int, y:int, value:Boolean):void {
			nodes[x][y].isEmpty = value;
		}
	}
}
