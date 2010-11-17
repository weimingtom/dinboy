package com.dinboy.game.astar.ui 
{
	import com.dinboy.game.astar.core.GameConfig;
	import com.dinboy.game.astar.events.PlayerEvent;
	import com.dinboy.net.DinLoader;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	

	/**
	 * @author		DinBoy
	 * @copy		钉崽 © 2010
	 * @version		v1.0 [2010-11-15 22:32]
	 */
	public class RPGPlayer extends Sprite
	{
		
		/**
		 * 人物初始化的横坐标
		 */
		public var _startX:Number;
		
		/**
		 * 人物初始化的纵坐标
		 */
		public var _startY:Number;
		
		/**
		 * 人物现在位置横坐标 节点 
		 */
		public var _nowX:uint;
		
		/**
		 * 人物现在位置 纵坐标 节点
		 */
		public var _nowY:uint;
		
		/**
		 * 人物宽度
		 */
		public var _playerW:Number;
		
		/**
		 * 人物高度
		 */
		public var _playerH:Number;
		
		/**
		 * 人物加载器
		 */
		private var _playerLoader:DinLoader;
		
		/**
		 * 人物行走的动作次数
		 */
		private const PLAYER_STEP:uint = 4;
		
		/**
		 * 存放人物行走的动作数组
		 */
		private var _playerBitArray:Array;
		
		/**
		 * 存放玩家位图
		 */
		private var _playerBitmap:Bitmap;
		
		/**
		 * 人物行走的路线数组
		 */
		private var _walkWays:Array;
		
		/**
		 * 人物行走的步数索引值
		 */
		private var _stepIndex:uint;
		
		/**
		 * 水平方向的速度
		 */
		private var _horizontalSpeed:Number;
		
		/**
		 * 垂直方向的速度
		 */
		private var _verticalSpeed:Number;
		
		/**
		 * 单元格宽度
		 */
		private var _cellWidth:Number;
		
		/**
		 * 单元格高度
		 */
		private var _cellHeight:Number;
		
		/**
		 * 已经移动的次数
		 */
	//	private var _flag:Number;
		
		/**
		 * 是否正在行走
		 */
		private var _walking:Boolean;
		
		/**
		 * 走动的次数
		 */
		private var _stepCount:uint;
		
		
		/**
		 * RPG人物
		 * @param	__nowX		人物现在位置 横坐标
		 * @param	__nowY		人物现在位置 纵坐标
		 * @param	__playerW	人物宽度
		 * @param	__playerH	人物高度
		 * @param	__imgURL	人物图片地址
		 */
		public function RPGPlayer(__nX:uint,__nY:uint,__pW:Number,__pH:Number,__imgURL:String)
		{
			_nowX = __nX;
			_nowY = __nY;
			_playerW = __pW;
			_playerH = __pH;
			_horizontalSpeed = GameConfig.horizontalSpeed;
			_verticalSpeed = GameConfig.verticalSpeed;
			_cellWidth = GameConfig.cellWidth;
			_cellHeight = GameConfig.cellHeight;
			_stepCount = GameConfig.stepCount;
			_walking = false;
			
			_playerLoader = new DinLoader();
			_playerLoader.url = __imgURL;
			_playerLoader.loadNormal();
			_playerLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, playerLoaderComplete, false, 0, true);
			
		//	
		}
		
		//============================================
		//===== Public Function =====
		//============================================
		/**
		 * 人物开始i行走
		 * @param	__ways	人物行走的路线数组
		 */
		public function  walking(__ways:Array):void 
		{
			_walkWays = __ways;
			_stepIndex = 1;
			//_flag = 0;
			if (!_walking) addEventListener(Event.ENTER_FRAME, playerMoveEnterFrame, false, 0, true);
		}
		
		
		//============================================
		//===== EventListener Function =====
		//============================================
		/**
		 * 人物图片加载完成时调度
		 * @param	event
		 */
		private function playerLoaderComplete(event:Event):void 
		{
			event.currentTarget.removeEventListener(Event.COMPLETE, playerLoaderComplete);
			var __bitmap:Bitmap = event.currentTarget.content as Bitmap;
			_playerBitArray = [];
			var i:uint,j:uint;
			for (i = 0; i < 8; i++)
			{
				//人物横向系列图数组
				var __playHSteps:Array=[];
				for (j = 0; j < PLAYER_STEP ; j++)
				{
					var	__bitmapData:BitmapData = new BitmapData(_playerW, _playerH);
					var	__matrix:Matrix = new Matrix();
							__matrix.tx = -j * _playerW;
							__matrix.ty = -i * _playerH;
							__bitmapData.draw(__bitmap, __matrix, null, null, new Rectangle(0, 0, _playerW, _playerH));
							__playHSteps[j] = __bitmapData;
				}
				_playerBitArray[i] = __playHSteps;
			}
			_playerBitmap = new Bitmap();
			_playerBitmap.bitmapData = _playerBitArray[0][0];
			addChild(_playerBitmap);
			
			x = _nowX * _cellWidth + (_cellWidth-_playerW>>1);
			y = _nowY * _cellHeight - _playerH + (_cellHeight >> 1);
			
			_startX = x % _cellWidth;
			_startY = y % _cellHeight;
			
			var __initedEvent:PlayerEvent = new PlayerEvent(PlayerEvent.PLAYER_INITED);
				//__initedEvent.standX = _nowX;
				//__initedEvent.standY = _nowY;
			dispatchEvent(__initedEvent);
		}
		
		/**
		 * 当开始行走时调度
		 * @param	event
		 */
		private function playerMoveEnterFrame(event:Event):void 
		{
			var __dirX:int = _walkWays[_stepIndex].x - _nowX;
			var __dirY:int = _walkWays[_stepIndex].y - _nowY;
			x += _horizontalSpeed * __dirX;
			y += _verticalSpeed * __dirY;
			var __modX:Number = (x - _startX) % _cellWidth;
			var __modY:Number = (y - _startY) % _cellHeight;
			trace("__modX",__modX);
			trace("__modY",__modY);
			trace("********************************");
		//	trace(x);
			if (__modX==0) 
			{
		//		trace("__modX==0");
			}
			if (__modY==0) 
			{
		//		trace("__modY==0");
			}
		//	_flag++;
			if (__modX == 0 && __modY==0)
			{
				_nowX = _walkWays[_stepIndex].x;
				_nowY = _walkWays[_stepIndex].y;
				//x = _horizontalSpeed * _nowX*10;
				//y = _verticalSpeed * _nowY*10;
				_stepIndex++;
			//	_flag = 0;
			}
			if (_stepIndex==_walkWays.length) 
			{
				removeEventListener(Event.ENTER_FRAME, playerMoveEnterFrame);
			}
		}
		
		
		
		//============================================
		//===== Getter && Setter =====
		//============================================
		/**
		 * [只读 readOnly] 人物现在横向坐标点
		 */
		public function get nowX():uint {	return _nowX;}
		
		/**
		 * [只读 readOnly] 人物现在纵向坐标点
		 */
		public function get nowY():uint {	return _nowY; }




	//============================================
	//===== Class[RPGPlayer] Has Finish ======
	//============================================
	}

}