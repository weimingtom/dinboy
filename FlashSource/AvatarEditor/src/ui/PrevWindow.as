package ui 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	

	/**
	 * @author		钉崽[Dinboy]
	 * @copy		2010 © dinboy.com
	 * @version		v1.0 [2011-3-25 11:09]
	 */
	public class PrevWindow extends Sprite
	{
		/**
		 * 预览宽度
		 */
		private var _prevWidth:Number;
		
		/**
		 * 预览高度
		 */
		private var _prevHeight:Number;
		
		/**
		 * 图像数据源
		 */
		private var _source:BitmapData;
		
		/**
		 * 缩放矩阵
		 */
		private var _snapScaleMatrix:Matrix;
		
		public function PrevWindow(_width:Number,_height:Number) 
		{
			_prevWidth = _width;
			_prevHeight = _height;
			
			_snapScaleMatrix = new Matrix();
		}
		
		/**
		 * 锁定缩放
		 */
		private function snapView():void 
		{
			//trace(_snapScaleMatrix.);
			
			var _scale:Number = _prevWidth / _source.width;
			//trace(_prevWidth,_source.width);
			_snapScaleMatrix.a = _scale;
			_snapScaleMatrix.d = _scale;
			//_snapScaleMatrix.scale(_scale, _scale);
			//trace(_snapScaleMatrix.a)
			graphics.clear();
			graphics.beginBitmapFill(_source, _snapScaleMatrix,false,true);
			graphics.drawRect(0, 0, _prevWidth, _prevHeight);
			graphics.endFill();
			
		}
		
		
		/**
		 * 设置/获取 图像数据源
		 */
		public function get source():BitmapData 
		{
			return _source;
		}
		
		public function set source(value:BitmapData):void 
		{
			_source = value;
			if (_source) snapView();
		}






	//============================================
	//===== Class[PrevWindow] Has Finish ======
	//============================================
	}

}