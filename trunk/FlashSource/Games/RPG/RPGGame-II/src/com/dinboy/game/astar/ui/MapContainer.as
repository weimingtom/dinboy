package com.dinboy.game.astar.ui 
{
	import com.dinboy.game.astar.AstarGrid;
	import com.dinboy.game.astar.core.GameConfig;
	import com.dinboy.game.astar.events.MapEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	

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
		
		/**
		 * 玩家
		 */
		private var _player:RPGPlayer;
		
		/**
		 * 地图标原点位置
		 */
		private var _mapOriginLocation:Point;
		
		public function MapContainer(__mapGrid:AstarGrid) 
		{
			_mapGrid = __mapGrid;
			_hcount = _mapGrid.numRows;
			_vcount = _mapGrid.numCols;
			_cellWidth = GameConfig.cellWidth;
			_cellHeight = GameConfig.cellHeight;
			
			_mapOriginLocation = new Point((_vcount - 1) * _cellWidth * 0.5,0);
			
			_mapBackground = new Sprite();
			addChild(_mapBackground);
			drawBackground();
			
			_mapBackground.addEventListener(MouseEvent.CLICK, mapClickedHnadler, false, 0, false);
			
		}
		
		/**
		 * 当点击地图时调度
		 * @param	event
		 */
		private function mapClickedHnadler(event:MouseEvent):void 
		{
			event.stopImmediatePropagation();
			event.stopPropagation();
			var clickX:Number,clickY:Number,rx:Number,ry:Number,endX:uint,endY:uint;
			var	__searchPathEvent:MapEvent = new MapEvent(MapEvent.MAP_SEARCHPATH);
					__searchPathEvent.startX = _player.nowX;
					__searchPathEvent.startY = _player.nowY;
					clickX = event.localX - _mapOriginLocation.x-_cellWidth*0.5;
					clickY = event.localY - _mapOriginLocation.y;
					
					endX = (clickX / _cellWidth + clickY / _cellHeight) >> 0;
					endY = (clickY / _cellHeight - clickX / _cellWidth) >> 0;
					
					__searchPathEvent.endX = endX ;
					__searchPathEvent.endY = endY;
					
					
					
				//trace(__searchPathEvent.endX,__searchPathEvent.endY);
					dispatchEvent(__searchPathEvent);
		}
		
		
		/**
		 * 给地图增加玩家
		 */
		public function  addPlayer(__player:RPGPlayer):void 
		{
			_player = __player;
			
			var __playerNx:uint = _player.nowX;
			var __playerNy:uint = _player.nowY;
			var __playerWidth:Number=_player.playerWidth;
			var __playerHeight:Number=_player.playerHeight;
			
			_player.x = _mapOriginLocation.x  + _cellWidth * 0.5 * (__playerNx - __playerNy) + (_cellWidth - __playerWidth) * 0.5;
			_player.y = _mapOriginLocation.y + _cellHeight * 0.5 * (__playerNx + __playerNy) - __playerHeight + _cellHeight;
			//__player.x = __playerNx*_cellWidth+(__playerNy&1)*_cellWidth*0.5+(_cellWidth-__playerWidth)*0.5;
			//__player.y = __playerNy*_cellHeight*0.5-__playerHeight+_cellHeight*0.5;
			
			addChild(_player);
		}
		
		/**
		 * 绘制背景表格
		 */
		private function  drawBackground():void 
		{
			//_mapBackground.graphics.clear();
			//_mapBackground.graphics.lineStyle(1);
			//_mapBackground.graphics.beginFill(0x00FFFF);
			//_mapBackground.graphics.drawRect(0, 0, _hcount * _cellWidth, _vcount * _cellHeight);
			//_mapBackground.graphics.moveTo(_hcount * _cellWidth*0.5, 0);
			//_mapBackground.graphics.lineTo(0, _vcount * _cellHeight * 0.5);
			//_mapBackground.graphics.lineTo(_hcount * _cellWidth*0.5, _vcount * _cellHeight);
			//_mapBackground.graphics.lineTo(_hcount * _cellWidth, _vcount * _cellHeight*0.5);
			//_mapBackground.graphics.lineTo(_hcount * _cellWidth*0.5, 0);
			//var i:uint;
			//for (i = 0; i <= _hcount ; i++) 
			//{
					//_mapBackground.graphics.moveTo(i*_cellWidth*0.5, (_hcount-i)*_cellHeight*0.5);
					//_mapBackground.graphics.lineTo((_hcount+i)*_cellWidth*0.5,_hcount*_cellHeight-i*_cellHeight*0.5);
			//}
			//
			//for (i = 0; i <= _vcount; i++) 
			//{
				//_mapBackground.graphics.moveTo(i*_cellWidth*0.5, (_vcount+i)*_cellHeight*0.5);
				//_mapBackground.graphics.lineTo((_vcount+i)*_cellWidth*0.5, i*_cellHeight*0.5);
			//}
			
			//var i:uint;
			//for (i = 0; i <= _hcount ; i++) 
			//{
					//_mapBackground.graphics.moveTo(0,i*_cellHeight);
					//_mapBackground.graphics.lineTo(_hcount*_cellWidth,i*_cellHeight);
			//}
			//
			//for (i = 0; i <= _vcount; i++) 
			//{
				//_mapBackground.graphics.moveTo(i*_cellWidth, 0);
				//_mapBackground.graphics.lineTo(i*_cellWidth, _vcount*_cellHeight);
			//}
			
			var i:uint,j:uint;
			for (i = 0; i < _hcount; i++) 
			{
				for (j = 0; j < _vcount; j++)
				{
					var	__diamond:Diamond = new Diamond(_cellWidth, _cellHeight);
							__diamond.x =_mapOriginLocation.x  + _cellWidth * 0.5 * (i - j);
							__diamond.y = _mapOriginLocation.y+_cellHeight * 0.5 * (i + j);
							__diamond.text = "(" + i + "," + j + ")";
							_mapBackground.addChild(__diamond);
				}
			}
			
			//_mapBackground.graphics.moveTo(_cellWidth * 0.5, 0);
			//_mapBackground.graphics.lineTo(0, _cellHeight*0.5);
			//_mapBackground.graphics.lineTo(_cellWidth*0.5, _cellHeight);
			//_mapBackground.graphics.lineTo(_cellWidth, _cellHeight*0.5);
			//_mapBackground.graphics.lineTo(_cellWidth * 0.5, 0);
			//_mapBackground.graphics.endFill();


			
		}






	//============================================
	//===== Class[MapCntainer] Has Finish ======
	//============================================
	}

}