package com.dinboy.game.astar.ui 
{
	import com.dinboy.game.astar.AstarGrid;
	import com.dinboy.game.astar.core.GameConfig;
	import com.dinboy.game.astar.events.MapEvent;
	import flash.display.Sprite;
	

	/**
	 * @author		DinBoy
	 * @copy		钉崽 © 2010
	 * @version		v1.0 [2010-11-20 13:16]
	 */
	public class MapContainer extends Sprite
	{
		
		/**
		 * 地图的横向的元素个数
		 */
		private var _hcount:uint;
		
		/**
		 * 地图的纵向元素个数
		 */
		private var _vcount:uint;
		
		/**
		 * 单元格元素宽度
		 */
		private var _cellWidth:Number;
		
		/**
		 * 单元格元素高度
		 */
		private var _cellHeight:Number;
		
		/**
		 * 地图数据
		 */
		private var _mapGrid:AstarGrid;
		
		/**
		 * 地图背景
		 */
		private var _mapBackground:Sprite;
		
		public function MapContainer(__mapGrid:AstarGrid) 
		{
			_mapGrid = __mapGrid;
			_hcount = _mapGrid.numRows;
			_vcount = _mapGrid.numCols;
			_cellWidth = GameConfig.cellWidth;
			_cellHeight = GameConfig.cellHeight;
			
			drawBackground();
			addChild(_mapBackground);
			
		}
		
		
		/**
		 * 给地图增加玩家
		 */
		private function  addPlayer(value:RPGPlayer):void 
		{
			
		}
		
		/**
		 * 绘制背景表格
		 */
		private function  drawBackground():void 
		{
			_mapBackground.graphics.clear();
			_mapBackground.graphics.lineStyle(1);
			_mapBackground.graphics.beginFill(0xFFFFFF);
			_mapBackground.graphics.drawRect(0, 0, _hcount * _cellWidth, _vcount *_cellHeight);
			var i:uint;
			for (i = 0; i <= _hcount ; i++) 
			{
					_mapBackground.graphics.moveTo(i*_cellWidth*0.5, (_hcount-i)*_cellHeight*0.5);
					_mapBackground.graphics.lineTo((_hcount+i)*_cellWidth*0.5,_hcount*_cellHeight-i*_cellHeight*0.5);
			}
			
			for (i = 0; i <= _vcount; i++) 
			{
				_mapBackground.graphics.moveTo(i*_cellWidth*0.5, (VCOUNT+i)*_cellHeight*0.5);
				_mapBackground.graphics.lineTo((_vcount+i)*_cellWidth*0.5, i*_cellHeight*0.5);
			}
			_mapBackground.graphics.endFill();
			_mapBackground.x = -_vcount * _cellWidth * 0.5;
			
			dispatchEvent(new MapEvent(MapEvent.MAP_READY));
		//	return true;
		}






	//============================================
	//===== Class[MapCntainer] Has Finish ======
	//============================================
	}

}