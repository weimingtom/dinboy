package 
{
	import com.dinboy.net.DinLoader;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
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
		 * 地图的数据数组
		 */
		private var _mpaDataArray:Array;
		
		public function Main():void 
		{
			_heroW = 48;
			_heroH = 96;
			_heroC = 4;
			_heroBitArray = new Array();
			_keyCodeArray = [0, 0, 0, 0];
			_rotationUint = 0;
			_gotoPoint = new Point();
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			this._heroLoader = new DinLoader();
			this._heroLoader.loadNormal("hero.png");
			this._heroLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.heroLoadComplete, false, 0, true);
			
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
			var __rectangle:Rectangle = _heroBitmap.getBounds(this.parent);
			var __dx:Number , __dy:Number;
			
			_gotoPoint.x = stage.mouseX;
			_gotoPoint.y = stage.mouseY;
			if ((_gotoPoint.x>__rectangle.x && _gotoPoint.x<__rectangle.x+__rectangle.width) || (_gotoPoint.y>__rectangle.y && _gotoPoint.y<__rectangle.y+__rectangle.height))
			{
				_heroTimer.reset();
				_heroTimer.stop();
				return;
			}
			else 
			{
				if (!_heroTimer.running) 
				{
					_heroTimer.start();
				}
			}
			
			 __dx= stage.mouseX - __rectangle.x - (__rectangle.width >> 1);
			 __dy= stage.mouseY - __rectangle.y - (__rectangle.height >> 1);
			
			_heroAngle = Math.atan2(__dy, __dx) * 180 / Math.PI;
			
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
			
			if (!_heroTimer.running) 
			{
				_heroTimer.start();
			}
			
		}
		
		/**
		 * 当鼠标移动时
		 * @param	evt
		 */
		private function stageMousemoveHandler(evt:MouseEvent):void
		{
			var __rectangle:Rectangle = _heroBitmap.getBounds(this.parent);
			
			if ((stage.mouseX>__rectangle.x && stage.mouseX<__rectangle.x+__rectangle.width) || (stage.mouseY>__rectangle.y && stage.mouseY<__rectangle.y+__rectangle.height))
			{
				_heroTimer.reset();
				_heroTimer.stop();
			}
			else 
			{
				if (!_heroTimer.running) 
				{
					_heroTimer.start();
				}
			}
			
			var __dx:Number = stage.mouseX - __rectangle.x - (__rectangle.width >> 1);
			var __dy:Number = stage.mouseY - __rectangle.y - (__rectangle.height >> 1);
			
			
			_heroAngle = Math.atan2(__dy, __dx) * 180 / Math.PI;
			
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
			
			_heroTimer.start();
			
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
				addChild(_heroBitmap);
				
				_heroTimer = new Timer(50);
				_heroTimer.addEventListener(TimerEvent.TIMER, this.heroTimerHandler, false, 0, true);
				 _heroTimer.start();
				
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
			
			//	 1 	 1		 1	 	 1
			//	上	下	左	右
			_offsetX = 0;
			_offsetY = 0;
			
			 _motionUint > 2?_motionUint = 0:_motionUint++;

			switch (_keyCodeString) 
			{
				case "1000":						//上
					_rotationUint = 3;
					_offsetY = -STEPS;
				break;
				case "1010":						//左上
					_rotationUint = 6;
					_offsetX = -STEPS;
					_offsetY = -STEPS;
				break;
				case "1001":						//右上
					_rotationUint = 7;
					_offsetX = STEPS;
					_offsetY = -STEPS;
				break;
				case "0100":						//下
					_rotationUint = 0;
					_offsetY = STEPS;
				break;
				case "0110":
					_rotationUint = 4;			//左下
					_offsetX = -STEPS;
					_offsetY = STEPS;
				break;
				case "0101":
					_rotationUint = 5;			//右下
					_offsetX = STEPS;
					_offsetY = STEPS;
				break;
				case "0010":
					_rotationUint = 1;			//左
					_offsetX = -STEPS;
				break;
				case "0001":
					_rotationUint = 2;			//右
					_offsetX = STEPS;
				break;
				case "0000":
					_offsetX = 0;
					_offsetY = 0;
				break;
				default:
					_offsetX = 0;
					_offsetY = 0;
			}
			var	 __array:Array = _heroBitArray[_rotationUint];
					
					_heroBitmap.x += _offsetX;
					_heroBitmap.y += _offsetY;
					
					if (Math.abs(_heroBitmap.x+(_heroBitmap.width>>1)-_gotoPoint.x)<=STEPS && Math.abs(_heroBitmap.y+(_heroBitmap.height>>1)-_gotoPoint.y)<=STEPS) 
					{
						_motionUint = 0;
						_keyCodeString = "0000";
					}
					_heroBitmap.bitmapData = __array[_motionUint];
			
		}
		
		
	}
}