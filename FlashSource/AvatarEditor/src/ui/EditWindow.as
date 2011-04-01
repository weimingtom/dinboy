package ui
{
	import com.dinboy.util.DinTransfrom;
	import events.SnapEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.sampler.NewObjectSample;
	import util.BasicGemo;
	
	
	[Event(name = "snaped", type = "events.SnapEvent")] 
	
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
		 * 被紧贴的图片数据
		 */
		private var _snapSource:BitmapData;
		
		/**
		 * 数据源图片
		 */
		private var _bitMap:Bitmap;
		
		/**
		 * 图片数据
		 */
		private var _photoContainer:Sprite;
		
		/**
		 * 遮罩的容器
		 */
		private var _maskContainer:Sprite;
		
		/**
		 * 预览窗口
		 */
		private var _previewWindow:Sprite;
		
		/**
		 * 遮罩图层
		 */
		private var _masker:Sprite;
		
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
		 * 最大缩放比率
		 */
		private var _maximum:Number;
		
		/**
		 * 最小缩放比率
		 */
		private var _minimum:Number;
		
		/**
		 * 缩放时的注册点
		 */
		private var _scalePoint:Point;
		
		/**
		 * 创建可编辑图片的窗口
		 * @param	_source			图像数据
		 * @param	_width			窗口的宽度
		 * @param	_height			窗口的高度
		 * @param	_editWidth		窗口的编辑宽度
		 * @param	_editHeight	窗口的编辑高度
		 */
		public function EditWindow(_source:BitmapData=null,_width:Number=100,_height:Number=100,_editWidth:Number=50,_editHeight:Number=50)
		{
			this._source = _source;
			this._width = _width;
			this._height = _height;
			this._editWidth = _editWidth;
			this._editHeight = _editHeight;
			
			setupUI();
		}
	//============================================
	//===== Private Function ======
	//============================================
		/**
		 * 配置UI
		 */
		private function  setupUI():void 
		{
			scrollRect = new Rectangle(0, 0, _width, _height);
			
			_bitMap = new Bitmap(_source);
			
			_photoContainer = new Sprite();
			_photoContainer.addChild(_bitMap);
			
			_masker = new Sprite();
			_masker = BasicGemo.drawRectSprite(_width, _height,0,0.3);
			_masker.mouseChildren = false;
			_masker.mouseEnabled = false;
			
			_previewWindow = new Sprite();
			_previewWindow = BasicGemo.drawRectSprite(_editWidth, _editHeight, 0xFFFFFF, 0.3);
			_previewWindow.x = (_width - _editWidth )>>1;
			_previewWindow.y = (_height - _editHeight )>>1;
			_previewWindow.mouseChildren = false;
			_previewWindow.mouseEnabled = false;
			
			_scalePoint = new Point((_previewWindow.x + _editWidth)/2,(_previewWindow.y + _editHeight)/2);
			addChild(_photoContainer);
			addChild(_masker);
			addChild(_previewWindow);
		//_previewWindow.mask = _masker;
			
			setupEvent();
			
			setSource();
		}
		
		/**
		 * 配置事件
		 */
		private function setupEvent():void 
		{
			_photoContainer.addEventListener(MouseEvent.MOUSE_DOWN, bitMapContainerMouseDown, false, 0, true);
		}
		
		/**
		 * 当鼠标按下时调度
		 * @param	event
		 */
		private function bitMapContainerMouseDown(event:MouseEvent):void 
		{
			addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false, 0, true);
			addEventListener(MouseEvent.MOUSE_UP, windowMouseUp, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, windowRollOut, false, 0, true);
		}
		
		/**
		 * 当鼠标移动时调度
		 * @param	event
		 */
		private function mouseMoveHandler(event:MouseEvent):void 
		{
			var _dx:Number = _previewWindow.x + _editWidth - _photoContainer.width;
			var _dy:Number = _previewWindow.y + _editHeight - _photoContainer.height;
			var _dw:Number = _photoContainer.width-_editWidth;
			var _dh:Number = _photoContainer.height-_editHeight;
			var _bounds:Rectangle = new Rectangle(_dx,_dy,_dw,_dh);
			_photoContainer.startDrag(false,_bounds);
			scaleSnap();
		}
		
		/**
		 * 当鼠标弹起时调度
		 * @param	event
		 */
		private function windowMouseUp(event:MouseEvent):void 
		{
			_photoContainer.stopDrag();
			removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			removeEventListener(MouseEvent.MOUSE_UP, windowMouseUp);
			removeEventListener(MouseEvent.ROLL_OUT, windowRollOut);
			dispatchEvent(new SnapEvent(SnapEvent.SNAPED));
		}
		
		/**
		 * 当预览窗口移出时调度
		 * @param	event
		 */
		private function windowRollOut(event:MouseEvent):void 
		{
			_photoContainer.stopDrag();
			removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			removeEventListener(MouseEvent.MOUSE_UP, windowMouseUp);
			removeEventListener(MouseEvent.ROLL_OUT, windowRollOut);
			scaleSnap();
		}

		
		/**
		 * 紧贴图片缩放
		 */
		private function scaleSnap():void 
		{
			//对齐到预览窗口
			if (_photoContainer.x>_previewWindow.x) 
			{
				_photoContainer.x = _previewWindow.x;
			}else if(_photoContainer.x+_photoContainer.width<_previewWindow.x+_editWidth)
			{
				_photoContainer.x = _previewWindow.x + _editWidth - _photoContainer.width;
			}
			if (_photoContainer.y>_previewWindow.y) 
			{
				_photoContainer.y = _previewWindow.y;
			}else if(_photoContainer.y+_photoContainer.height<_previewWindow.y+_editHeight)
			{
				_photoContainer.y = _previewWindow.y + _editHeight - _photoContainer.height;
			}
			
				//复制像素
				copyPixsToPreview();
		}
		
		/**
		 * 设置图片数据
		 */
		private function setSource():void 
		{
			_photoContainer.scaleX = _photoContainer.scaleY = 1;
			_bitMap.bitmapData = _source;
			//如果宽度大于高度,则以高度和编辑窗口作为的最小比率,否则使用宽度和剪辑窗口的比率作为最小比率
			var _dScale:Number = Math.max(_editWidth / _photoContainer.width, _editHeight / _photoContainer.height);
			_size=_minimum = _dScale > 1?_dScale:_dScale < 1?_dScale:1;
			_maximum = _minimum + 1;
			setSize();
		}
		
		/**
		 * 拷贝像素
		 */
		private function copyPixsToPreview():void
		{
			if (_source == null) return;
			var   _drawMatrix:Matrix = new Matrix();
					_drawMatrix.scale(_size, _size);
					
			var	_drawBitmapData:BitmapData = new BitmapData(_photoContainer.width, _photoContainer.height,true,0);
					_drawBitmapData.draw(_photoContainer, _drawMatrix);
					
			var	_copyBitmapData:BitmapData = new BitmapData(_editWidth, _editHeight);
					_copyBitmapData.copyPixels(_drawBitmapData, new Rectangle(_previewWindow.x-_photoContainer.x ,  _previewWindow.y-_photoContainer.y, _editWidth, _editHeight),new Point(0,0));
					
					_previewWindow.graphics.clear();
					_previewWindow.graphics.beginBitmapFill(_copyBitmapData,null,false,true);
					_previewWindow.graphics.drawRect(0, 0, _editWidth, _editHeight);
					_previewWindow.graphics.endFill();
					
					_snapSource = _copyBitmapData;
		}
		
		/**
		 * 设置尺寸大小
		 */
		private function setSize():void 
		{
			DinTransfrom.transfromByPoint(_photoContainer, { scale:_size, point:_scalePoint } );
			scaleSnap();
		}
	
	
	//============================================
	//===== Public Function ======
	//============================================
		/**
		 * 设置最合适大小
		 */
		public function setSuitable():void 
		{
			setSize();
			
			_photoContainer.x = (_width - _photoContainer.width)/2;
			_photoContainer.y = (_height - _photoContainer.height) / 2;
			
			copyPixsToPreview();
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
			setSize();
		}
		
		/**
		 * 图片位图数据
		 */
		public function get source():BitmapData 
		{
			return _source;
		}
		public function set source(value:BitmapData):void 
		{
			_source = value;
			setSource();
			setSuitable();
		}
		
		/**
		 * 提取出来的图片数据
		 */
		public function get snapSource():BitmapData 
		{
			return _snapSource;
		}
		public function set snapSource(value:BitmapData):void 
		{
			_snapSource = value;
		}
		
		/**
		 * 最小缩放比率
		 */
		public function get minimum():Number 
		{
			return _minimum;
		}
		
		/**
		 * 最大缩放比率
		 */
		public function get maximum():Number 
		{
			return _maximum;
		}






	//============================================
	//===== Class[EditWindow] Has Finish ======
	//============================================
	}

}