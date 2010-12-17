package  
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	

	/**
	 * @author		钉崽[dinboy]
	 * @copy		dinboy © 2010
	 * @version		v1.0 [2010-11-22 16:55]
	 */
	public class AstarClickNode extends Sprite
	{
		private var _tileWidth:Number = 64;
		private var _tileHeight:Number = 32;
		public function AstarClickNode() 
		{
			stage.align = "LT";
			stage.scaleMode = "noScale";
			stage.addEventListener(MouseEvent.CLICK, stageClickHandler, false, 0, true);
		}
		
		/**
		 * 点击事件调度
		 * @param	event
		 */
		private function stageClickHandler(event:MouseEvent):void 
		{
			var _clickX:Number = event.localX;
			var _clickY:Number = event.localY;
			
			trace("_clickX:",_clickX,"_clickY:",_clickY);
			trace("---------------------优美的分割线---------------------");
			
		}






	//============================================
	//===== Class[AstarClickNode] Has Finish ======
	//============================================
	}

}