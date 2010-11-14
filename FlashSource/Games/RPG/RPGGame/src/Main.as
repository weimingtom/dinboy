package 
{
	import com.dinboy.game.astar.Astar;
	import com.dinboy.game.astar.AstarGrid;
	import com.dinboy.net.DinLoader;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	
	/**
	 * ...
	 * @author 钉崽 [Dinboy.com]
	 */
	[SWF(width="800",height="600")]
	public class Main extends Sprite 
	{
		/**
		 * 单元格大小
		 */
		private static const SIDE:uint = 48;
		
		/**
		 * 水平个数
		 */
		private static const HCOUNT:uint = 50;
		
		/**
		 * 垂直个数
		 */
		private static const VCOUNT:uint = 50;
		
		/**
		 * 游戏人物加载器
		 */
		private var _heroLoader:DinLoader;
		
		/**
		 * 人物的动画间隔时间器
		 */
		private var _heroTimer:Timer;
		
		/**
		 * 人物的图片
		 */
		private var _heroBitmap:Bitmap;
		
		/**
		 *人物宽度
		 */
		private var _heroW:int;
		
		/**
		 * 人物高度
		 */
		private var _heroH:int;
		
		/**
		 * 人物的动作数
		 */
		private var _heroC:int;
		
		/**
		 * 存放人物
		 */
		private var _heroBitArray:Array;
		
		/**
		 * 键盘存放值
		 */
		private var _keyCodeString:String;
		
		/**
		 * 存放按下的键盘值数组
		 */
		private var _keyCodeArray:Array;
		
		/**
		 * 方向坐标点
		 */
		private var _rotationUint:uint;
		
		/**
		 * 人物横坐标偏移量
		 */
		private var _offsetX:int;
		
		/**
		 * 人物纵坐标偏移量
		 */
		private var _offsetY:int;
		
		/**
		 * 人物的面向角度
		 */
		private var _heroAngle:Number;
		
		/**
		 * 人物移动到的point
		 */
		private var _gotoPoint:Point;
		
		/**
		 * 人物的动作
		 */
		private var _motionUint:uint;
		
		/**
		 * 每次偏移步数
		 */
		private const STEPS:uint = 10;
		
		/**
		 * 地图的数据表格
		 */
		private var _mapDataGrid:AstarGrid;
		
		/**
		 * 地图背景
		 */
		private var _mapBackground:Sprite;
		
		/**
		 * 寻找到的路径数组
		 */
		private var _mapPath:Array;
		
		/**
		 * 路径索引值
		 */
		private var _pathIndex:uint;
		
		/**
		 * 行走的速度
		 */
		private var _speed:Number;
		
		
		
		public function Main():void 
		{
			_heroW = 48;
			_heroH = 96;
			_heroC = 4;
			_heroBitArray = new Array();
			_keyCodeArray = [0, 0, 0, 0];
			_rotationUint = 0;
			_gotoPoint = new Point();
			_mapPath = [];
			_speed = 0.5;
			
			_mapDataGrid = new AstarGrid(HCOUNT, VCOUNT);
			_mapBackground = new Sprite();
			addChild(_mapBackground);
			drawBackground();
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/**
		 * 初始化
		 * @param	e
		 */
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			this._heroLoader = new DinLoader();
			this._heroLoader.loadNormal("hero.png");
			this._heroLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.heroLoadComplete, false, 0, true);
		}
		
		/**
		 * 绘制背景表格
		 */
		private function  drawBackground():void 
		{
			_mapBackground.graphics.clear();
			_mapBackground.graphics.lineStyle(1);
			var i:int;
			for (i = 0; i < HCOUNT ; i++) 
			{
				var j:int;
				for (j = 0; j < VCOUNT; j++) 
				{
					_mapBackground.graphics.drawRect(i*SIDE, j*SIDE, SIDE, SIDE);
				}
			}
			_mapBackground.graphics.endFill();
			if (_mapPath.length>=0) 
			{
				_mapBackground.graphics.beginFill(0);
				for ( i = 0; i< _mapPath.length ;i++ ) 
				{
			//		trace(_mapPath[i].x,_mapPath[i].y);
					_mapBackground.graphics.drawRect(_mapPath[i].x*SIDE, _mapPath[i].y*SIDE, SIDE, SIDE);
				}
			}
			_mapBackground.graphics.endFill();

		}
		
		/**
		 * 当舞台弹起鼠标时
		 * @param	evt
		 */
		private function keyUpHandler(evt:KeyboardEvent):void
		{
			switch (evt.keyCode) 
			{
				case Keyboard.UP:
					_keyCodeArray[0] = 0;
				break;
				case  Keyboard.DOWN:
					_keyCodeArray[1] = 0;
				break;
				case Keyboard.LEFT:
					_keyCodeArray[2] = 0;
				break;
				case Keyboard.RIGHT:
					_keyCodeArray[3] = 0;
				break;
			}
			_keyCodeString = _keyCodeArray.join("");
		}
		
		/**
		 * 当舞台按下键盘键时
		 * @param	evt
		 */
		private function keyDownHandler(evt:KeyboardEvent):void
		{
			switch (evt.keyCode) 
			{
				case Keyboard.UP:
					_keyCodeArray[0] = 1;
				break;
				case  Keyboard.DOWN:
					_keyCodeArray[1] = 1;
				break;
				case Keyboard.LEFT:
					_keyCodeArray[2] = 1;
				break;
				case Keyboard.RIGHT:
					_keyCodeArray[3] = 1;
				break;
			}
			_keyCodeString = _keyCodeArray.join("");
		}
		
		/**
		 * 当鼠标点击时
		 * @param	evt
		 */
		private function stageClickHandler(evt:MouseEvent):void
		{
			_mapDataGrid.setStartNode(_heroBitmap.x / SIDE >> 0, _heroBitmap.y / SIDE >> 0);
			_mapDataGrid.setEndNode(evt.stageX / SIDE >> 0, evt.stageY / SIDE >> 0);
			
			//trace("start:", _mapDataGrid.startNode.x, _mapDataGrid.startNode.y);
			//trace("end:",_mapDataGrid.endNode.x,_mapDataGrid.endNode.y);
			
			//	 1 	 1		 1	 	 1
			//	上	下	左	右
			if (_heroAngle>157.5 && _heroAngle<=180 || _heroAngle>-180&&_heroAngle<-157.5) 
			{
				_keyCodeString = "0010";
			}
			else if (_heroAngle>-157.5&&_heroAngle<=-112.5) 
			{
				_keyCodeString = "1010";
			}
			else if (_heroAngle>-112.5&&_heroAngle<=-67.5) 
			{
				_keyCodeString = "1000";
			}
			else if (_heroAngle>-67.5&&_heroAngle<=-22.5) 
			{
				_keyCodeString = "1001";
			}
			else if (_heroAngle>-22.5&& _heroAngle<=22.5) 
			{
				_keyCodeString = "0001";
			}
			else if (_heroAngle>22.5&&_heroAngle<=67.5) 
			{
				_keyCodeString = "0101";
			}
			else if (_heroAngle>67.5&&_heroAngle<=112.5)
			{
				_keyCodeString = "0100";
				}
			else if (_heroAngle>112.5&&_heroAngle<=157.5) 
			{
				_keyCodeString = "0110";
			}
			findPath();
			/*
			if (!_heroTimer.running) 	{_heroTimer.start();}
			else{_heroTimer.reset();}
			*/
		}
		
		/**
		 * 开始寻路
		 */
		private function findPath():void
		{
			var __astar:Astar = new Astar();
				//trace(__astar.findPath(_mapDataGrid));
					if (__astar.findPath(_mapDataGrid)) 
					{
						_mapPath = __astar.path ;
						
						_pathIndex = 1;
						_heroTimer.addEventListener(TimerEvent.TIMER, heroTimerHandler, false, 0, true);
						_heroTimer.start();
						drawBackground();
					}else 
					{
						_heroTimer.removeEventListener(TimerEvent.TIMER, heroTimerHandler);
						_heroTimer.reset();
						_heroTimer.stop();
						trace("Path Can't Found!");
						//return ;
					}
		}
		
		/**
		 * 当图片加载完成时调度
		 * @param	evt
		 */
		private function heroLoadComplete(evt:Event):void
		{
				_heroBitmap = evt.currentTarget.content as Bitmap;
				
				var	__i:int, __j:int;
				for (__i = 0; __i < 8 ; __i++)
				{
					var __hArr:Array = [];
					for (__j = 0; __j <_heroC; __j++)
					{
						var __bit:BitmapData = new BitmapData(_heroW, _heroH);
						var __matrix:Matrix = new Matrix();
						__matrix.tx = -__j * _heroW;
						__matrix.ty = -__i * _heroH;
						__bit.draw(_heroBitmap, __matrix, null, null, new Rectangle(0, 0, _heroW, _heroH));
						 __hArr[__j] = __bit;
					}
					_heroBitArray[__i] = __hArr;
				}
				
				_heroBitmap.bitmapData = _heroBitArray[3][0];
			//	_heroBitmap.x = SIDE-_heroBitmap.width >> 1;
			//	_heroBitmap.y = SIDE-_heroBitmap.height >> 0;
				addChild(_heroBitmap);
				
				
				_heroTimer = new Timer(100);
			//	_heroTimer.addEventListener(TimerEvent.TIMER, this.heroTimerHandler, false, 0, true);
			//	 _heroTimer.start();
				
				stage.addEventListener(KeyboardEvent.KEY_DOWN, this.keyDownHandler, false, 0, true);
				stage.addEventListener(KeyboardEvent.KEY_UP, this.keyUpHandler, false, 0, true);
				
		//		stage.addEventListener(MouseEvent.MOUSE_MOVE, this.stageMousemoveHandler, false, 0, true);
				stage.addEventListener(MouseEvent.CLICK, this.stageClickHandler, false, 0, true);
		}
		
	
		/**
		 * 运行人物动作
		 * @param	evt
		 */
		private function heroTimerHandler(evt:TimerEvent):void
		{
			_pathIndex++;
						if (_pathIndex==_mapPath.length) 
						{
							_heroTimer.removeEventListener(TimerEvent.TIMER, heroTimerHandler);
							_heroTimer.stop();
						}
			//	 1 	 1		 1	 	 1
			//	上	下	左	右
			//_offsetX = 0;
			//_offsetY = 0;
			
		//	 _motionUint > 2?_motionUint = 0:_motionUint++;
			//var	 __array:Array = _heroBitArray[_rotationUint];
					//
					//_heroBitmap.x += _offsetX;
					//_heroBitmap.y += _offsetY;
					//
					//if (Math.abs(_heroBitmap.x+(_heroBitmap.width>>1)-_gotoPoint.x)<=STEPS && Math.abs(_heroBitmap.y+(_heroBitmap.height>>1)-_gotoPoint.y)<=STEPS) 
					//{
						//_motionUint = 0;
						//_keyCodeString = "0000";
					//}
					//_heroBitmap.bitmapData = __array[_motionUint];
					
					var __pathX:Number = _mapPath[_pathIndex].x  ;
					var __pathY:Number = _mapPath[_pathIndex].y  ;
					
					var __dx:Number = (__pathX - (_heroBitmap.x/SIDE>>0))*SIDE;
					var __dy:Number = (__pathY - (_heroBitmap.y/SIDE>>0))*SIDE;
					
				//	trace(__pathX,__dx);
					var __temp:Number = Math.sqrt(__dx * __dx + __dy * __dy);
				//	trace(__temp);
	//				if (__temp<1) 
	//				{

						//	_heroBitmap.x += __dx;
						//	_heroBitmap.y += __dy;
							_heroBitmap.x += 2.4 * (__dx - __dy);
							_heroBitmap.y +=  2.4 * (__dx + __dy);
					
//					}
			
		}
		
		
	}
}
