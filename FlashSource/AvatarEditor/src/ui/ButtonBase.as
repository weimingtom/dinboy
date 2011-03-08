package ui 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	

	/**
	 * @author		钉崽[Dinboy]
	 * @copy		2010 © dinboy.com
	 * @version		v1.0 [2011-3-5 10:21]
	 */
	public class ButtonBase extends Sprite implements IFocusComponent
	{
		/**
		 * 按钮的文本字符串
		 */
		private var	 _label:String = "";
		
		/**
		 * 按钮的文本框
		 */
		private var _textField:TextField;
		
		public function ButtonBase()
		{
			
		}
		
	//============================================
	//===== protected function ======
	//============================================
		/**
		 * 配置鼠标事件
		 */
		protected function setupMouseEvent():void 
		{
			addEventListener(MouseEvent.MOUSE_DOWN, mouseEventHandler, false, 0, true);
			addEventListener(MouseEvent.MOUSE_UP, mouseEventHandler, false, 0, true);
			addEventListener(MouseEvent.ROLL_OVER, mouseEventHandler, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, mouseEventHandler, false, 0, true);
		}
		
		/**
		 * 当鼠标出发事件时调度
		 * @param	event
		 */
		protected function mouseEventHandler(event:MouseEvent):void
		{
			
		}
		
		/**
		 * 设置鼠标状态
		 * @param	state
		 */
		protected function setMouseState(state:String):void 
		{
			
		}
	//============================================
	//===== Getter && Setter ======
	//============================================
	
		/**
		 * 设置文本
		 */
		public function get label():String 
		{
			return _label;
		}
		public function set label(value:String):void 
		{
			_label = value;
		}



		


	//============================================
	//===== Class[ButtonBase] Has Finish ======
	//============================================
	}
}