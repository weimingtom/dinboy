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
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author 钉崽 [Dinboy.com]
	 */
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
		
		public function Main():void 
		{
			_heroW = 48;
			_heroH = 96;
			_heroC = 4;
			_heroBitArray = new Array();
			_keyCodeArray = [0, 0, 0, 0];
			_rotationUint = 0;
			
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
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, this.keyDownHandler, false, 0, true);
			stage.addEventListener(KeyboardEvent.KEY_UP, this.keyUpHandler, false, 0, true);
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
			
			if (!_heroTimer.running) _heroTimer.start();
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
				
				_heroBitmap.bitmapData = null;
				addChild(_heroBitmap);
				
				_heroTimer = new Timer(50);
				_heroTimer.addEventListener(TimerEvent.TIMER, this.heroTimerHandler, false, 0, true);
		}
		
		/**
		 * 运行人物动作
		 * @param	evt
		 */
		private function heroTimerHandler(evt:TimerEvent):void
		{
			//_heroBitArray.push(_heroBitArray.shift());
			//_heroBitmap.bitmapData = _heroBitArray[0][0];
			
			//	 1 	 1		 1	 	 1
			//	上	下	左	右
			_offsetX = 0;
			_offsetY = 0;
			
			switch (_keyCodeString) 
			{
				case "1000":						//上
					_rotationUint = 3;
					_offsetY = -5;
				break;
				case "1010":						//左上
					_rotationUint = 6;
					_offsetX = -5;
					_offsetY = -5;
				break;
				case "1001":						//右上
					_rotationUint = 7;
					_offsetX = 5;
					_offsetY = -5;
				break;
				case "0100":						//下
					_rotationUint = 0;
					_offsetY = 5;
				break;
				case "0110":
					_rotationUint = 4;			//左下
					_offsetX = -5;
					_offsetY = 5;
				break;
				case "0101":
					_rotationUint = 5;			//右下
					_offsetX = 5;
					_offsetY = 5;
				break;
				case "0010":
					_rotationUint = 1;			//左
					_offsetX = -5;
				break;
				case "0001":
					_rotationUint = 2;			//右
					_offsetX = 5;
				break;
				case "0000":
					_heroTimer.reset();
					_heroTimer.stop();
				break;
			}
		//	trace("_keyCodeString:", _keyCodeString, "_rotationUint:", _rotationUint, "_heroBitArray.length:", _heroBitArray.length);
				var __array:Array = _heroBitArray[_rotationUint];
			//_heroBitArray[_rotationUint].push(_heroBitArray[_rotationUint].shift());
				 __array.push(__array.shift());
			//_heroBitmap.bitmapData = _heroBitArray[_rotationUint][0];
			_heroBitmap.bitmapData = __array[0];
			_heroBitmap.x += _offsetX;
			_heroBitmap.y += _offsetY;
			
			//trace(__array);
		}
		
		
	}
}