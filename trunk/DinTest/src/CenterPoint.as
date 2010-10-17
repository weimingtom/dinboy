package  
{
	import adobe.utils.CustomActions;
	import com.dinboy.ui.DinRect;
	import com.dinboy.util.dinTransfrom;
	import com.dinboy.util.Rotator;
	import fl.controls.BaseButton;
	import fl.controls.Slider;
	import fl.events.InteractionInputType;
	import fl.events.SliderEvent;
	import fl.events.SliderEventClickTarget;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import com.dinboy.util.DinDisplayUtil
	import flash.geom.Rectangle;
	

	/**
	 * @author		DinBoy
	 * @copy			钉崽 © 2010
	 * @version		v1.0 [2010-10-16 13:50]
	 */
	public class CenterPoint extends Sprite
	{
		/**
		 * 缩放的滚动条
		 */
		private var _scaleSlider:Slider;
		
		/**
		 * 旋转的滚动条
		 */
		private var _rotationSlider:Slider;
		
		/**
		 * 需要被旋转的长方体
		 */
		private var _rect:DinRect;
		
		/**
		 * 全局坐标
		 */
		private var _gobalPoint:Point;
		
		
		public function CenterPoint() 
		{
			this._rotationSlider = new Slider();
			this._rotationSlider.tickInterval = 60;
			this._rotationSlider.snapInterval = 1;
			this._rotationSlider.maximum = 360;
			this._rotationSlider.minimum = -360;
			this._rotationSlider.move(10, 10);
			this._rotationSlider.width = 200;
			this._rotationSlider.liveDragging = true;
			this.addChild(this._rotationSlider);
			this._rotationSlider.addEventListener(SliderEvent.THUMB_DRAG, this.ratationThumbDragHandler, false, 0, true);
			this._rotationSlider.addEventListener(SliderEvent.CHANGE, this.ratationThumbDragHandler, false, 0, true);

			
			this._scaleSlider = new Slider();
			this._scaleSlider.move(240, 10);
			this._scaleSlider.tickInterval = 0.1;
			this._scaleSlider.snapInterval = 0.01;
			this._scaleSlider.maximum = 2;
			this._scaleSlider.minimum = 0.5;
			this._scaleSlider.width = 200;
			this._scaleSlider.liveDragging = true;	
			this.addChild(this._scaleSlider);
			this._scaleSlider.addEventListener(SliderEvent.THUMB_DRAG, this.scaleSliderThumbDragHandler, false, 0, true);
			this._scaleSlider.addEventListener(SliderEvent.CHANGE, this.scaleSliderThumbDragHandler, false, 0, true);
			
			this._rect = new DinRect(0xFF0000, 100, 100);
			this._rect.x = 100;
			this._rect.y = 100;
			this.addChild(this._rect);
			this._rotationSlider.value = this._rect.rotation;
			this._scaleSlider.value = this._rect.scaleX;
			
			this._gobalPoint = new Point();
			addEventListener(MouseEvent.CLICK, this.ClickHandler, false, 0, true);
		}
		
		/**
		 * 舞台点击,获取到需要旋转的坐标点
		 * @param	evt
		 */
		private function ClickHandler(evt:MouseEvent):void
		{
				if (evt.target is BaseButton || evt.target is BaseButton) return;
		
				
				this._gobalPoint = new Point(stage.mouseX, stage.mouseY);

				this.graphics.clear();
				this.graphics.beginFill(0x000000);
				this.graphics.drawRect(stage.mouseX, stage.mouseY, 1, 1);
				this.graphics.endFill();
		}
		
		/**
		 * 当缩放滚动条移动时
		 * @param	evt
		 */
		private function scaleSliderThumbDragHandler(evt:SliderEvent):void
		{
			dinTransfrom.transfromByPoint(this._rect, { point:this._gobalPoint,scale:this._scaleSlider.value });
			//var $b:Rectangle = this._rect.getBounds(this._rect.parent);
			//var $point:Point = new Point($b.x+$b.width / 2,$b.y+ $b.height / 2);
			//var $aPoint:Point = this._rect.parent.globalToLocal(this._rect.parent.localToGlobal($point));
					//this._rect.scaleX = this._rect.scaleY = this._scaleSlider.value;
					//$b=this._rect.getBounds(this._rect);
					//$point = new Point($b.x+$b.width / 2,$b.y+ $b.height / 2);
			//var $bPoint:Point = this._rect.parent.globalToLocal(this._rect.localToGlobal($point));
			//this._rect.x	+= $aPoint.x -$bPoint.x;
			//this._rect.y	+= $aPoint.y -$bPoint.y;
		}
		
		/**
		 * 当旋转的刻度改变时
		 * @param	evt
		 */
		private function ratationThumbDragHandler(evt:SliderEvent):void
		{
			dinTransfrom.transfromByPoint(this._rect, { point:this._gobalPoint,rotation:this._rotationSlider.value });
			//var $b:Rectangle = this._rect.getBounds(this._rect.parent);
			//var $point:Point = new Point($b.x+$b.width / 2,$b.y+ $b.height / 2);
			//var $aPoint:Point = this._rect.parent.globalToLocal(this._rect.parent.localToGlobal($point));
					//this._rect.rotation= this._rotationSlider.value;
					//$b=this._rect.getBounds(this._rect);
					//$point = new Point($b.x+$b.width / 2,$b.y+ $b.height / 2);
			//var $bPoint:Point = this._rect.parent.globalToLocal(this._rect.localToGlobal($point));
			//this._rect.x	+= $aPoint.x -$bPoint.x;
			//this._rect.y	+= $aPoint.y -$bPoint.y;
		}







	//============================================
	//===== Class[CenterPoint] Has Finish ======
	//============================================
	}

}