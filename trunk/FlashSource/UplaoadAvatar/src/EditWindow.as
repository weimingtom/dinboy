package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	

	/**
	 * @author		钉崽[Dinboy]
	 * @copy		2010 © dinboy.com
	 * @version		v1.0 [2011-3-8 15:58]
	 */
	public class EditWindow extends Sprite
	{
		
		/**
		 * 图片的缩放大小 以小数点表示 百分比
		 */
		private var _size:Number;
		
		/**
		 * 数据源(图片数据)
		 */
		private var _source:BitmapData;
		
		/**
		 * 数据源图片
		 */
		private var _bitMap:Bitmap;
		
		/**
		 * 预览窗口
		 */
		private var _previewWindow:Sprite;
		
		/**
		 * 编辑宽度
		 */
		private var _editWidth:Number;
		
		/**
		 * 编辑窗口的高度
		 */
		private var _editHeight:Number;
		
		/**
		 * 宽度
		 */
		private var _width:Number;
		
		/**
		 * 高度
		 */
		private var _height:Number;
		
		/**
		 * 创建可编辑图片的窗口
		 * @param	_source			图像数据
		 * @param	_width			窗口的宽度
		 * @param	_height			窗口的高度
		 * @param	_editWidth		窗口的编辑宽度
		 * @param	_editHeight	窗口的编辑高度
		 */
		public function EditWindow(_source:BitmapData,_width:Number=100,_height:Number=100,_editWidth:Number=50,_editHeight:Number=50)
		{
			this._source = _source;
		}
	//============================================
	//===== Private Function ======
	//============================================
		/**
		 * 配置UI
		 */
		private function  setupUI():void 
		{
			_bitMap = new Bitmap(_source);
			
		}
	
	
	//============================================
	//===== Public Function ======
	//============================================
		/**
		 * 设置最合适大小
		 */
		public function setSuitable():void 
		{
			
		}
		
		
		
	//============================================
	//===== Getter&Setter ======
	//============================================
		/**
		 * 图片的缩放大小 以小数点表示 百分比
		 */
		public function get size():Number 
		{
			return _size;
		}
		
		public function set size(value:Number):void 
		{
			_size = value;
		}






	//============================================
	//===== Class[EditWindow] Has Finish ======
	//============================================
	}

}