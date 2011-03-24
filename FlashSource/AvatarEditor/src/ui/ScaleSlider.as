package ui 
{
	import flash.display.Sprite;
	

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
		private var _sliderDrager:Sprite;
		
		/**
		 * 滑动条背景
		 */
		private var _sliderBackground:Sprite;
		
		/**
		 * 滑动条的值
		 */
		private var _value:Number;
		
		public function ScaleSlider() 
		{
			
		}
		
		
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






	//============================================
	//===== Class[ScaleSlider] Has Finish ======
	//============================================
	}

}