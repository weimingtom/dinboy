package ui 
{
	import events.ScaleSliderEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	

	/**
	 * @author		钉崽[Dinboy]
	 * @copy		2010 © dinboy.com
	 * @version		v1.0 [2011-3-24 17:42]
	 */
	public class ScaleSlider extends Sprite
	{
		/**
		 * 滑动条拖拽按钮
		 */
		protected var _sliderDrager:Sprite;
		
		/**
		 * 滑动条背景
		 */
		protected var _sliderBackground:Sprite;
		
		/**
		 * 滑动条的值
		 */
		protected var _value:Number;
		
		/**
		 * 最大值
		 */
		protected var _maximum:Number
		
		/**
		 * 最小值
		 */
		protected var _minimum:Number;
		
		public function ScaleSlider() 
		{
			
			setupUI();
			
			setupEventListener();
		}

	//============================================
	//===== Protected Function ======
	//============================================
		/**
		 * 配置UI显示
		 */
		protected function setupUI():void 
		{
			_sliderDrager = sliderDrager;
			
			_sliderBackground = sliderBackground;
		}
		
		/**
		 * 配置事件侦听器
		 */
		protected function setupEventListener():void 
		{
			_sliderDrager.addEventListener(MouseEvent.MOUSE_DOWN, dragerMouseDownHandler, false, 0, true);
			_sliderDrager.addEventListener(MouseEvent.MOUSE_UP, dragerMouseUpHandler, false, 0, true);
		}
		
		/**
		 * 当拖动按钮按下时
		 * @param	event
		 */
		private function dragerMouseDownHandler(event:MouseEvent):void 
		{
			var _dragX:Number = _sliderBackground.x-3;
			var _dragY:Number = _sliderBackground.y+(_sliderBackground.height-_sliderDrager.height>>1);
			var _dragW:Number = _sliderBackground.width - _sliderDrager.width+6;
			var _dragH:Number = 0;
			_sliderDrager.startDrag(false, new Rectangle(_dragX, _dragY, _dragW, _dragH));
			addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler, false, 0, true);
		}
		
		/**
		 * 当进行拖拽时,进行实时监听
		 * @param	event
		 */
		private function enterFrameHandler(event:Event):void 
		{
			dispatchEvent(new ScaleSliderEvent(ScaleSliderEvent.DRAGE_PROGRESS));
		}
		
		/**
		 * 当进行拖拽时舞台监听鼠标弹起时调度
		 * @param	event
		 */
		private function stageMouseUpHandler(event:MouseEvent):void 
		{
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
			_sliderDrager.stopDrag();
			dispatchEvent(new ScaleSliderEvent(ScaleSliderEvent.DRAGE_COMPLETE));
		}
		
		/**
		 * 当拖动按钮弹起时
		 * @param	event
		 */
		private function dragerMouseUpHandler(event:MouseEvent):void 
		{
			stageMouseUpHandler(null);
		}
		
	//============================================
	//===== Getter && Setter ======
	//============================================
		/**
		 * 滑动条的值	[以小数计算]
		 */
		public function get value():Number 
		{
			return _value;
		}
		
		public function set value(value:Number):void 
		{
			_value = value;
		}
		
		/**
		 * 设置最大值
		 */
		public function get maximum():Number 
		{
			return _maximum;
		}
		
		public function set maximum(value:Number):void 
		{
			_maximum = value;
		}
		
		/**
		 * 设置最小值
		 */
		public function get minimum():Number 
		{
			return _minimum;
		}
		
		public function set minimum(value:Number):void 
		{
			_minimum = value;
		}






	//============================================
	//===== Class[ScaleSlider] Has Finish ======
	//============================================
	}

}