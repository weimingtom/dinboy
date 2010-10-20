package com.cyy.astar {

	/**
	 * ...
	 * @author Will Chen
	 * @version 1.0
	 * @email c_youyou@163.com
	 * @msn chenyouyou@live.cn
	 * @description ...
	 */
	public class AStarNode {
		public var x:int;
		public var y:int;
		public var f:Number;
		public var g:Number;
		public var h:Number;
		public var parent:AStarNode;
		public var isEmpty:Boolean = true;

		public function AStarNode(x:int, y:int){
			this.x = x;
			this.y = y;
		}
	}
}
