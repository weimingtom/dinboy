package 
{
	import com.dinboy.net.DinLoader;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
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
		
		public function Main():void 
		{
			_heroW = 68;
			_heroH = 96;
			_heroC = 4;
			_heroBitArray = new Array();
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
		}
		
		/**
		 * 当舞台按下键盘键时
		 * @param	evt
		 */
		private function keyDownHandler(evt:KeyboardEvent):void
		{
			trace(evt.keyCode);
		}
		
		/**
		 * 当图片加载完成时调度
		 * @param	evt
		 */
		private function heroLoadComplete(evt:Event):void
		{
				_heroBitmap = evt.currentTarget.content as Bitmap;
;
				var	__i:int, __j:int;
				for (__i = 0; __i < _heroC ; __i++) 
				{
					var __hArr:Array = [];
					for (__j = 0; __j <8 ; __j++) 
					{
						var __bit:BitmapData = new BitmapData(_heroW, _heroH);
						var __matrix:Matrix = new Matrix();
						__matrix.tx = -__i * _heroW;
						__matrix.ty = -__i * _heroH;
						__bit.draw(_heroBitmap, __matrix,null,null,new Rectangle(0,0,_heroW,_heroH));
						 __hArr[__j]= __bit;
					}
					_heroBitArray[__i] = __hArr;
				}
				_heroBitmap.bitmapData = null;
				addChild(_heroBitmap);
				
				_heroTimer = new Timer(50);
				_heroTimer.addEventListener(TimerEvent.TIMER, this.heroTimerHandler, false, 0, true);
				_heroTimer.start();
		}
		
		/**
		 * 运行人物动作
		 * @param	evt
		 */
		private function heroTimerHandler(evt:TimerEvent):void
		{
			_heroBitArray.push(_heroBitArray.shift());
			_heroBitmap.bitmapData = _heroBitArray[0][0];
		}
		
	}
	
}