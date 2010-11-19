package com.dinboy.game.astar.ui 
{
	import com.dinboy.game.astar.core.GameConfig;
	import com.dinboy.game.astar.events.PlayerEvent;
	import com.dinboy.net.DinLoader;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	

	/**
	 * @author		DinBoy
	 * @copy		钉崽 © 2010
	 * @version		v1.0 [2010-11-15 22:32]
	 */
	public class RPGPlayer extends Sprite
	{
		
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
		 * 人物行走速度
		 */
		private var _speed:Number;
		
		/**
		 * 单元格大小
		 */
		private var _cellSide:Number;
		
		/**
		 * 每布行走的距离
		 */
		private var _distance:Number;
		
		/**
		 * 已经移动的次数
		 */
		private var _flag:Number;
		
		/**
		 * 是否正在行走
		 */
		private var _walking:Boolean;
		
		/**
		 * 走动的次数
		 */
		private var _stepCount:uint;
		
		/**
		 * 行走的时基
		 */
		private var _walkTimer:Timer;
		
		/**
		 * 
		 */
		private var _playStepIndex:uint;
		
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
			_speed = GameConfig.speed;
			_cellSide = GameConfig.cellSide;
			_distance = GameConfig.distance;
			_stepCount = _cellSide/_distance>>0;
			_walking = false;
			_flag = 0;
			_walkTimer = new Timer(_speed);
			
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
			_walkTimer.stop();
			_walkTimer.removeEventListener(TimerEvent.TIMER, playerMoveHandler);
			//_flag = 0;
			if (_flag==0) 
			{
				x = _nowX* _cellSide + (_cellSide-_playerW>>1);
				y = _nowY * _cellSide - _playerH + (_cellSide >> 1);
			}
			
			_walkTimer.addEventListener(TimerEvent.TIMER, playerMoveHandler, false, 0, true);
			if(!_walkTimer.running)_walkTimer.start();
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
					var	__bitmapData:BitmapData = new BitmapData(_playerW, _playerH,true,0);
					var	__matrix:Matrix = new Matrix();
							__matrix.tx = -j * _playerW;
							__matrix.ty = -i * _playerH;
							__bitmapData.draw(__bitmap, __matrix, null, null, new Rectangle(0, 0, _playerW, _playerH));
							__playHSteps[j] = __bitmapData;
				}
				_playerBitArray[i] = __playHSteps;
			}
			_playStepIndex = 0;
			_playerBitmap = new Bitmap();
			_playerBitmap.bitmapData = _playerBitArray[0][0];
			addChild(_playerBitmap);
			
			x = _nowX * _cellSide + (_cellSide-_playerW>>1);
			y = _nowY * _cellSide - _playerH + (_cellSide >> 1);
			
			var __initedEvent:PlayerEvent = new PlayerEvent(PlayerEvent.PLAYER_INITED);
				//__initedEvent.standX = _nowX;
				//__initedEvent.standY = _nowY;
			dispatchEvent(__initedEvent);
		}
		
		/**
		 * 当开始行走时调度
		 * @param	event
		 */
		private function playerMoveHandler(event:TimerEvent):void 
		{
			var __direct:uint;
			var __dirX:int = _walkWays[_stepIndex].x - _nowX;
			var __dirY:int = _walkWays[_stepIndex].y - _nowY;
			x += _distance * __dirX;
			y += _distance * __dirY;

			
				if (__dirX == 1 && __dirY == 1) {//右下
					__direct=5;
				} else if (__dirX==1&&__dirY==0) {//右
					__direct=2;
				} else if (__dirX==1&&__dirY==-1) {//右上
					__direct=7;
				} else if (__dirX==0&&__dirY==-1) {//上
					__direct=3;
				} else if (__dirX==-1&&__dirY==-1) {//左上
					__direct=6;
				} else if (__dirX==-1&&__dirY==0) {//左
					__direct = 1;
				} else if (__dirX==-1&&__dirY==1) {//左下
					__direct=4;
				} else if (__dirX==0&&__dirY==1) {//下
					__direct=0;
				}
			
			//	 1 	 1		 1	 	 1
			//	上	下	左	右
			//if (_heroAngle>157.5 && _heroAngle<=180 || _heroAngle>-180&&_heroAngle<-157.5) 
			//{
				//_keyCodeString = "0010";
			//}
			//else if (_heroAngle>-157.5&&_heroAngle<=-112.5) 
			//{
				//_keyCodeString = "1010";
			//}
			//else if (_heroAngle>-112.5&&_heroAngle<=-67.5) 
			//{
				//_keyCodeString = "1000";
			//}
			//else if (_heroAngle>-67.5&&_heroAngle<=-22.5) 
			//{
				//_keyCodeString = "1001";
			//}
			//else if (_heroAngle>-22.5&& _heroAngle<=22.5) 
			//{
				//_keyCodeString = "0001";
			//}
			//else if (_heroAngle>22.5&&_heroAngle<=67.5) 
			//{
				//_keyCodeString = "0101";
			//}
			//else if (_heroAngle>67.5&&_heroAngle<=112.5)
			//{
				//_keyCodeString = "0100";
				//}
			//else if (_heroAngle>112.5&&_heroAngle<=157.5) 
			//{
				//_keyCodeString = "0110";
			//}
			
			
			
			_flag++;
			_playStepIndex++;
			if (_playStepIndex>=4) 
			{
				_playStepIndex = 0;
			}
			_playerBitmap.bitmapData = _playerBitArray[__direct][_playStepIndex];
			if (_flag>=_stepCount)
			{
				_nowX = _walkWays[_stepIndex].x;
				_nowY = _walkWays[_stepIndex].y;
				x = _nowX * _cellSide + (_cellSide-_playerW>>1);
				y = _nowY * _cellSide - _playerH + (_cellSide >> 1);
				_stepIndex++;
				_flag = 0;
			}
			
			if (_stepIndex==_walkWays.length) 
			{
				_walkTimer.reset();
				_walkTimer.stop();
				_walkTimer.removeEventListener(TimerEvent.TIMER, playerMoveHandler);
				_playerBitmap.bitmapData = _playerBitArray[__direct][0];
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