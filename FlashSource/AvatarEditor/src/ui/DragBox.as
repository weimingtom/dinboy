package ui 
{
	import adobe.utils.CustomActions;
	import events.DragEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import util.BasicGemo;
	

	/**
	 * @author		钉崽[Dinboy]
	 * @copy		2010 © dinboy.com
	 * @version		v1.0 [2011-3-28 10:15]
	 */
	public class DragBox extends Sprite
	{
		/**
		 * 灰色可填充.放在拖放窗口右下角
		 */
		[Embed(source = '../../lib/swf/Gripper.swf', mimeType = 'application/octet-stream')]
		private var Gripper:Class;
		
		/**
		 * 把手
		 */
		private var _gripper:Object;
		
		/**
		 * 背景
		 */
		private var _background:Sprite;
		
		/**
		 * 最初的缩放比例
		 */
		private var _originalScale:Number;
		
		/**
		 * 本窗口宽度
		 */
		private var _selfWidth:Number;
		
		/**
		 * 本窗口的高度
		 */
		private var _selfHeight:Number;
		
		/**
		 * 初始值宽度
		 */
		private var _initWidth:Number;
		
		/**
		 * 初始值高度
		 */
		private var _initHeight:Number;
		
		/**
		 * 拖动范围
		 */
		private var _dragBoundary:Rectangle;
		
		
		
		
		public function DragBox(dragBoundary:Rectangle,startWidth:Number=100,startHeight:Number=100) 
		{
			_background = new Sprite();
			_initWidth = _selfWidth = startWidth;
			_initHeight = _selfHeight = startHeight;
			this._dragBoundary = _dragBoundary;
			addChild(_background);
			addEventListener(Event.ADDED_TO_STAGE, addToSatgeHandler, false, 0, trace);
		}

		//============================================
		//===== Private Function ======
		//============================================
		/**
		 * 绘制背景
		 */
		private function drawBox():void 
		{
			BasicGemo.drawRect(_background,0,0,_selfWidth,_selfHeight,0,0,1,0xEEEEEE);
		}
		
		/**
		 * 配置监听
		 */
		private function setupEventListener():void 
		{
			_background.addEventListener(MouseEvent.MOUSE_OVER, backgroundMouseOverHandler, false, 0, true);
			_background.addEventListener(MouseEvent.MOUSE_OUT, backgroundMouseOutHandler, false, 0, true);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
			addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false, 0, true);
			_gripper.addEventListener(MouseEvent.MOUSE_OVER, gripperMouseOverHandler, false, 0, true);
			_gripper.addEventListener(MouseEvent.MOUSE_OUT, gripperMouseOutHandler, false, 0, true);
			_gripper.addEventListener(MouseEvent.MOUSE_DOWN, gripperMouseDownHandler, false, 0, true);
			_gripper.addEventListener(MouseEvent.MOUSE_UP, gripperMouseUpHandler, false, 0, true);
		}
		
		/**
		 * 缩放窗口
		 * @param	moveX	横坐标
		 * @param	moveY	纵坐标
		 * @param	offsetX	横向偏移量
		 * @param	offsetY	纵向偏移量
		 */
		private function resizeBox(moveX:Number,moveY:Number,offsetX:Number=0,offsetY:Number=0):void 
		{
			var _offsetX:Number = offsetX;
			var _offsetY:Number = offsetY;
			var _moveX:Number = moveX;
			var _moveY:Number = moveY;
			var _right:Number = _dragBoundary.width + _dragBoundary.x;
			var _bottom:Number = _dragBoundary.height + _dragBoundary.y;
			_selfWidth = _moveX + _offsetX;
			_selfHeight = _moveY + _offsetY;
			
			if (_selfWidth<=50+_offsetX) 
			{
				_selfWidth = 50 + _offsetX;
			}
			if (_selfHeight<=50+_offsetY) 
			{
				_selfHeight = 50 + _offsetY;
			}
			if (_selfWidth>_right-x) 
			{
				_selfWidth - _right - x;
			}
			if (_selfHeight>_bottom-y) 
			{
				_selfHeight = _bottom - y;
			}
			if (_selfWidth < _selfHeight * _originalScale)
			{
				_selfHeight = _selfWidth / _originalScale;
			}else 
			{
				_selfWidth = _selfHeight * _originalScale;
			}
			drawBox();
			_gripper.x = _selfWidth - _gripper.width;
			_gripper.y = _selfHeight - _gripper.height;
		}
		

		
		//============================================
		//===== EventListener Hnadler ======
		//============================================
		/**
		 * 当被添加到舞台时调度
		 * @param	event
		 */
		private function addToSatgeHandler(event:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addToSatgeHandler);
			
			drawBox();
			_gripper = new Gripper();
			_gripper.x = width - _gripper.width - 1;
			_gripper.y = height - _gripper.height - 1;
			addChild(_gripper);
			
			setupEventListener();
		}
		
		/**
		 * 当鼠标按下时调度
		 * @param	event
		 */
		private function mouseDownHandler(event:MouseEvent):void 
		{
			var _dragRect:Rectangle = new Rectangle(_dragBoundary.x, _dragBoundary.y, _dragBoundary.width - width, _dragBoundary.height - height);
			startDrag(false, _dragRect);
			stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandler, false, 0, true);
		}
		
		/**
		 * 当鼠标弹起时调度
		 * @param	event
		 */
		private function mouseUpHandler(event:MouseEvent):void 
		{
			dispatchEvent(new DragEvent(DragEvent.START_MOVE));
		}
		
		/**
		 * 当把手弹起时调度
		 * @param	event
		 */
		private function gripperMouseUpHandler(event:MouseEvent):void 
		{
			dispatchEvent(new DragEvent(DragEvent.STOP_RESIZE));
		}
		
		/**
		 * 当把手按下时调度
		 * @param	event
		 */
		private function gripperMouseDownHandler(event:MouseEvent):void 
		{
			dispatchEvent(new DragEvent(DragEvent.STOP_RESIZE));
		}
		
		/**
		 * 当移开把手时调度
		 * @param	event
		 */
		private function gripperMouseOutHandler(event:MouseEvent):void 
		{
			
		}
		
		/**
		 * 当移入把手时调度
		 * @param	event
		 */
		private function gripperMouseOverHandler(event:MouseEvent):void 
		{
			
		}
		
		/**
		 * 当鼠标移入背景时调度
		 * @param	event
		 */
		private function backgroundMouseOverHandler(event:MouseEvent):void 
		{
			
		}
		
		/**
		 * 当鼠标移出背景时调度
		 * @param	event
		 */
		private function backgroundMouseOutHandler(event:MouseEvent):void 
		{
			
		}
		
		/**
		 * 当鼠标在舞台移动时调度
		 * @param	event
		 */
		private function stageMouseMoveHandler(event:MouseEvent):void 
		{
			
			
		}
		
		/**
		 * 当鼠标在舞台弹起时调度
		 * @param	event
		 */
		private function stageMouseUpHandler(event:MouseEvent):void 
		{
			stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandler);
			dispatchEvent(new DragEvent(DragEvent.STOP_MOVE));
		}
		
		//============================================
		//===== Public Function ======
		//============================================		
		/**
		 * 回到最初状态
		 * @param	moveX		鼠标移动X轴
		 * @param	moveY		仪表移动Y轴
		 */
		public function resume(moveX:Number,moveY:Number):void 
		{
			
		}






	//============================================
	//===== Class[DragBox] Has Finish ======
	//============================================
	}

}