package com.dinboy.controls.renders 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	

	/**
	 * @author		DinBoy
	 * @copy		钉崽 © 2010
	 * @version		v1.0 [2010-11-8 22:16]
	 */
	public class CloseButton extends Sprite
	{
		
		public function CloseButton() 
		{
			graphics.beginFill(0xFFFFFF);
			graphics.drawCircle(6, 6, 6);
		//graphics.drawRect(0, 0, 14, 14);
			graphics.beginFill(0x0A618F);
			graphics.drawCircle(6,6, 3);
		//graphics.drawRect(3,3, 8, 8);
			graphics.endFill();
			
			buttonMode = true;
			tabEnabled = false;
			
			addEventListener(Event.ADDED_TO_STAGE, addToStageHander, false, 0, true);
		}
		
		/**
		 * 添加到舞台时
		 * @param	event
		 */
		private function addToStageHander(event:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addToStageHander);
			addEventListener(Event.REMOVED_FROM_STAGE, removeFromStage, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler, false, 0, true);
		}
		
		/**
		 * 从舞台删除时
		 * @param	event
		 */
		private function removeFromStage(event:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removeFromStage);
			removeEventListener(MouseEvent.MOUSE_OUT,mouseOverHandler);
			removeEventListener(MouseEvent.MOUSE_UP, mouseOutHandler);
		}
		
		/**
		 * 鼠标移入时
		 * @param	event
		 */
		private function mouseOverHandler(event:MouseEvent):void 
		{
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler, false, 0, true);
			graphics.clear();
			graphics.beginFill(0xFFFFFF);
			graphics.drawCircle(6, 6, 6);
			graphics.beginFill(0x0A618F);
			graphics.drawCircle(6,6, 2);
			graphics.endFill();
		}
		
		/**
		 * 鼠标移出时
		 * @param	event
		 */
		private function mouseOutHandler(event:MouseEvent):void 
		{
			removeEventListener(MouseEvent.MOUSE_OUT,mouseOverHandler);
			removeEventListener(MouseEvent.MOUSE_UP, mouseOutHandler);
			graphics.clear();
			graphics.beginFill(0xFFFFFF);
			graphics.drawCircle(6, 6, 6);
			graphics.beginFill(0x0A618F);
			graphics.drawCircle(6,6, 3);
			graphics.endFill();
		}





	//============================================
	//===== Class[CloseButton] Has Finish ======
	//============================================
	}

}