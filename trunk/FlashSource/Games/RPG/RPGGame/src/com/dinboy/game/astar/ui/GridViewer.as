package com.dinboy.game.astar.ui 
{
	import com.dinboy.game.astar.Astar;
	import com.dinboy.game.astar.AstarGrid;
	import com.dinboy.game.astar.AstarNode;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
		
		
	/**
	 * @author		DinBoy
	 * @copy		钉崽 © 2010
	 * @version		v1.0 [2010-10-26 0:20]
	 */
	public class GridViewer extends Sprite
	{
		/**
		 * 单元格大小
		 */
		private var _cellSize:int = 40;
		
		/**
		 * 地图数据
		 */
		private var _mapGrid:AstarGrid;
		
		public function GridViewer(__grid:AstarGrid) 
		{
			_mapGrid = __grid;
			drawGrid();
			findPath();
			addEventListener(MouseEvent.CLICK, this.stageClickHandler);
		}
		
		
		/**
		 * 绘制地图表格
		 */
		private function drawGrid():void
		{
			graphics.clear();
			var i:int;
			var j:int;
			
			for (i = 0; i < _mapGrid.numCols; i++)
			{
				for (j = 0; j < _mapGrid.numRows; j++) 
				{
					var __node:AstarNode = _mapGrid.getNode(i, j);
					graphics.lineStyle(0);
					graphics.beginFill(getColor(__node));
					graphics.drawRect(i * _cellSize, j * _cellSize, _cellSize, _cellSize);
				}
				
			}
		}

		/**
		 * 获取节点的颜色
		 * @param	__node
		 * @return	颜色值
		 */
		private function  getColor(__node:AstarNode):uint 
		{
			if (!__node.walkable) 
			{
				return 0x000000;
			}
			if (__node==_mapGrid.startNode) 
			{
				return 0xFFFF00;
			}
			if (__node==_mapGrid.endNode) 
			{
				return 0xFF0000;
			}
			return 0xFFFFFF;
		}
		
		/**
		 * 当舞台点击时调度
		 * @param	event
		 */
		private function  stageClickHandler(event:MouseEvent):void 
		{
			var __clickX:int = event.localX / _cellSize >> 0;
			var __clickY:int = event.localY / _cellSize >> 0;
			
			_mapGrid.setWalkAble(__clickX, __clickY, !_mapGrid.getNode(__clickX, __clickY).walkable);
			drawGrid();
			findPath();
		}
		
		/**
		 * 寻找路径
		 */
		private function findPath():void 
		{
			var __astar:Astar = new Astar();
			if (__astar.findPath(_mapGrid)) 
			{
				showVisited(__astar);
				showPath(__astar);
			}
		}
		
		/**
		 * 显示open列表与close列表
		 */
		private function  showVisited(__astar:Astar):void 
		{
			var __openArray:Array = __astar.openArray;
			var __closeArray:Array = __astar.closedArray;
			var __node:AstarNode;
			var i:int;
			for (i = 0; i < __openArray.length; i++) 
			{
				__node = __openArray[i] as AstarNode;
				graphics.beginFill(0xCCCCCC);
				if (__node==_mapGrid.startNode) 
				{
					graphics.beginFill(0xFFFF00);
				}
				graphics.drawRect(__node.x * _cellSize, __node.y * _cellSize, _cellSize, _cellSize);
				graphics.endFill();
			}
			
			for (i = 0; i <__closeArray.length ; i++) 
			{
				__node = __closeArray[i] as AstarNode;
				graphics.beginFill(0xFFFF00);
				graphics.drawRect(__node.x * _cellSize, __node.y * _cellSize, _cellSize, _cellSize);
				graphics.endFill();
			}
			
			
		}
		
		/**
		 * 绘制出寻找的路径
		 * @param	__astar
		 */
		private function  showPath(__astar:Astar):void 
		{
			var __path:Array = __astar.path;
			
			var i:int;
			for (i = 0; i < __path.length; i++) 
			{
				graphics.lineStyle(0);
				graphics.beginFill(0);
				graphics.drawCircle(__path[i].x * _cellSize-_cellSize >> 1, __path[i].y - _cellSize >> 1, _cellSize / 3);
				
			}
			graphics.endFill();
		}




	//============================================
	//===== Class[GridViewer] Has Finish ======
	//============================================
	}

}