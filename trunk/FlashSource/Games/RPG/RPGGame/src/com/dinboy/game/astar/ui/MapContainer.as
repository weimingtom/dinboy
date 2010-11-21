package com.dinboy.game.astar.ui 
{
	import com.dinboy.game.astar.AstarGrid;
	import com.dinboy.game.astar.core.GameConfig;
	import com.dinboy.game.astar.events.MapEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
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
		
		public function MapContainer(__mapGrid:AstarGrid) 
		{
			_mapGrid = __mapGrid;
			_hcount = _mapGrid.numRows;
			_vcount = _mapGrid.numCols;
			_cellWidth = GameConfig.cellWidth;
			_cellHeight = GameConfig.cellHeight;
			
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
			var cx:uint, cy:uint, rx:uint, ry:uint,clickX:Number,clickY:Number,endX:uint,endY:uint;
			var	__searchPathEvent:MapEvent = new MapEvent(MapEvent.MAP_SEARCHPATH);
					__searchPathEvent.startX = _player.nowX;
					__searchPathEvent.startY = _player.nowY;
					clickX = event.localX;
					clickY = event.localY;
					cx = (clickX / _cellWidth>>0) * _cellWidth + _cellWidth * 0.5;
					cy = (clickY / _cellHeight >> 0) * _cellHeight + _cellHeight * 0.5;
					rx = (clickX - cx) * _cellHeight * 0.5;
					rx = (clickY - cy) * _cellWidth * 0.5;
					
					if (Math.abs(rx)+Math.abs(ry)<=_cellWidth*_cellHeight*0.25) 
					{
						endX = clickX / _cellWidth >> 0;
						endY = (clickY / _cellHeight >> 0)*2;
					}else 
					{
						clickX = clickX - _cellWidth * 0.5;
						endX = (clickX / _cellWidth >> 0) + 1;
						
						
						clickY = clickY - _cellHeight * 0.5;
						endY = (clickY / _cellHeight >> 0) *2+ 1;
					}
					
					__searchPathEvent.endX = endX - (endY & 1);
					__searchPathEvent.endY = endY;
					
					trace(__searchPathEvent.endX,__searchPathEvent.endY);
			//		trace(__searchPathEvent.endX ,__searchPathEvent.endY);
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
			//__player.x = (_hcount  +__playerNx - __playerNy) * _cellWidth-__playerWidth>>1;
			//__player.y = (__playerNy+1) * _cellHeight / 2-__playerHeight;
		//	trace(_cellWidth-__playerWidth);
			__player.x = __playerNx*_cellWidth+(_cellWidth-__playerWidth)*0.5;
			__player.y = __playerNy*_cellHeight-__playerHeight+_cellHeight*0.5;
			//__player.x = _cellWidth * 0.5 * (__playerNx - __playerNy) + (_cellWidth-__playerWidth) * 0.5;
			//__player.y = _cellHeight * 0.5 * (__playerNx + __playerNy)-__playerHeight+_cellHeight*0.5;
			x = GameConfig.GameScrollRect.width * 0.5 - __player.x;
			y = GameConfig.GameScrollRect.height * 0.5 - __player.y;
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
					var __diamond:Diamond = new Diamond(_cellWidth, _cellHeight);
							__diamond.x = _cellWidth*i+(j%2)*_cellWidth*0.5;
							__diamond.y = j*_cellHeight*0.5
							_mapBackground.addChild(__diamond);
				}
			}
			trace(this.getBounds(this));
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