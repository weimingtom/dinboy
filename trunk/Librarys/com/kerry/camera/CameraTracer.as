package com.kerry.camera {
	import flash.display.DisplayObject;
	/**
	 * CameraTracer 类用于加入追踪物体的镜头
	 * @author PhoenixKerry（http://blog.sina.com.cn/yyy98）
	 * @version 0.3
	 */
	public class CameraTracer {
		private var target:DisplayObject;
		
		private var containerWidth:Number;
		private var containerHeight:Number;
		private var stageWidth:Number;
		private var stageHeight:Number;
		
		private var topBorder:Number;
		private var leftBorder:Number;
		
		private var rightEdge:Number;
		private var leftEdge:Number;
		private var topEdge:Number;
		private var bottomEdge:Number;
		
		private var _containerX:Number;
		private var _containerY:Number;
		
		/**
		 * 设置 target 显示对象为镜头的追踪对象
		 * @param	target 追踪目标
		 * @param	containerWidth 追踪目标（target）容器的宽度
		 * @param	containerHeight 追踪目标（target）容器的高度
		 * @param	stageWidth 舞台宽度
		 * @param	stageHeight 舞台的高度
		 * @param	targetCenterX target 的X轴偏移量（针对注册点不在中心的显示对象）
		 * @param	targetCenterY target 的Y轴偏移量（针对注册点不在中心的显示对象）
		 * @param	leftBorder 追踪目标（target）容器的左边注册点（针对注册点不在左上的容器）
		 * @param	topBorder 追踪目标（target）容器的上边注册点（针对注册点不在左上的容器）
		 */
		public function CameraTracer(target:DisplayObject,
																 containerWidth:Number, containerHeight:Number,
																 stageWidth:Number, stageHeight:Number,
																 targetCenterX:Number = 0, targetCenterY:Number = 0,
																 leftBorder:Number = 0, topBorder:Number = 0
																 ) {
			this.target = target;
			
			this.containerWidth = containerWidth;
			this.containerHeight = containerHeight;
			
			this.stageWidth = stageWidth;
			this.stageHeight = stageHeight;
			
			this.leftBorder = leftBorder;
			this.topBorder = topBorder;
			
			leftEdge = stageWidth / 2;
			rightEdge = stageWidth - leftEdge;
			topEdge = stageHeight / 2;
			bottomEdge = stageHeight - topEdge;
			
			_containerX = targetCenterX;
			_containerY = targetCenterY;
		}
		
		/**
		 * 在 x 轴上追踪物体
		 */
		public function xTrace():void {
			var stagePositionX:Number = _containerX + target.x - leftBorder;
			if (stagePositionX > rightEdge) {
				_containerX -= (stagePositionX - rightEdge);
				if (_containerX < stageWidth - containerWidth) _containerX = stageWidth - containerWidth;
			} else if (stagePositionX < leftEdge) {
				_containerX += (leftEdge - stagePositionX);
				if (_containerX > 0) _containerX = 0;
			}
		}
		
		/**
		 * 在 y 轴上追踪物体
		 */
		public function yTrace():void {
			var stagePositionY:Number = _containerY + target.y - topBorder;
			if (stagePositionY > bottomEdge) {
				_containerY -= (stagePositionY - bottomEdge);
				if (_containerY < stageHeight - containerHeight) _containerY = stageHeight - containerHeight;
			} else if (stagePositionY < topEdge) {
				_containerY += (topEdge - stagePositionY);
				if (_containerY > 0) _containerY = 0;
			}
		}
		
		/**
		 * 用户可以设置与初始 target 同一级的显示对象为新的 target 从而让镜头追踪此物体
		 * @param	target 要追踪的新目标（要与初始 target 同级）
		 */
		public function setTarget(target:DisplayObject):void {
			this.target = target;
		}
		
		public function get containerX():Number { return _containerX - leftBorder; }
		public function get containerY():Number { return _containerY - topBorder; }
	}
}