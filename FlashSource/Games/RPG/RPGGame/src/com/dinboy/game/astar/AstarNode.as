package com.dinboy.game.astar 
{

	/**
	 * @author		DinBoy
	 * @copy		钉崽 © 2010
	 * @version		v1.0 [2010-10-20 23:08]
	 */
	public class AstarNode
	{
		
		/**
		 * 节点的X值
		 */
		public var x:int;
		
		/**
		 * 节点的Y值
		 */
		public var y:int;
		
		/**
		 * 节点的权重(节点到终点的总代价)
		 */
		public var f:Number;
		
		/**
		 * g代表(从指定节点到相邻)节点本身的代价
		 */
		public var g:Number;
		
		/**
		 * h代表从指定节点到目标节点（根据不同的估价公式）估算出来的代价。
		 */
		public var h:Number;
		
		/**
		 * 此节点是否可以穿透（通常把障碍物节点设置为false） 
		 */
		public var walkable:Boolean = true;
		
		/**
		 * 此节点的父级节点
		 */
		public var parent:AstarNode;
		
		/**
		 * 代价因子  
		 */
		public var costMultiplier:Number = 1.0;
		
		/**
		 * 实例化一个节点
		 * @param	__x	节点的横坐标点
		 * @param	__y	节点的纵坐标点
		 */
		public function AstarNode(__x:int,__y:int) 
		{
			this.x = __x;
			this.y = __y;
		}






	//============================================
	//===== Class[AstarNode] Has Finish ======
	//============================================
	}

}