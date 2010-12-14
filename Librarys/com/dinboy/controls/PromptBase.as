package com.dinboy.controls
{
	import com.dinboy.controls.renders.CloseButton;
	import com.dinboy.controls.renders.PromptContainer;
	import com.dinboy.controls.renders.PromptHeader;
	import com.dinboy.events.dinFunction;
	import com.dinboy.events.PromptEvent;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;

	
	[Style(name = "header", type = "Class")]
	
	[Style(name = "container", type = "Class")]
	
	[Style(name = "closeButton", type = "Class")]
	
	
	/**
	 * @author		钉崽[dinboy]
	 * @copy		dinboy © 2010
	 * @version		v1.0 [2010-11-5 14:52]
	 */
	public class PromptBase extends TipBase
	{
		/**
		 * 实例样式
		 */
		protected var instanceStyles:Object;
		
		/**
		 * 标题文本框
		 */
		protected var _titleTextField:TextField;
		
		/**
		 * 关闭按钮
		 */
		protected var _closeButton:DisplayObject;
		
		/**
		 * 头部
		 */
		protected var _header:DisplayObject;
		
		/**
		 * 容器背景
		 */
		protected var _container:DisplayObject;
		
		/**
		 * 文本容器高度
		 */
		protected var _containerHeight:Number;
		
		/**
		 * 文本信息宽度
		 */
		protected var _containerWidth:Number;
		
		/**
		 * 是否可以拖动
		 */
		protected var _dragEnabled:Boolean;
		
		/**
		 * 回调的参数
		 */
		private var _callBackFunction:Function;
		
		/**
		 * 默认皮肤样式
		 */
		public static var defaultStyles:Object = {
								header:PromptHeader,
								container:PromptContainer,
								closeButton:CloseButton,
								titleTextFormat:new  TextFormat("微软雅黑,宋体", 12, 0xFFFFFF),
								contentTextFormat:new  TextFormat("微软雅黑,宋体", 12, 0x000000)
		}
		
		/**
		 * 获取显示对象的实例
		 * @param	objectName	
		 * @return
		 */
		protected function getDisplayObjectInstance(skin:Object):DisplayObject 
		{
			var classDef:Object = null;
			if (skin is Class) { 
				return (new skin()) as DisplayObject; 
			} else if (skin is DisplayObject) {
				(skin as DisplayObject).x = 0;
				(skin as DisplayObject).y = 0;
				return skin as DisplayObject;
			}
			try {
				classDef = getDefinitionByName(skin.toString());
			} catch(e:Error) {
				try {
					classDef = loaderInfo.applicationDomain.getDefinition(skin.toString()) as Object;
				} catch (e:Error) {
					// Nothing
				}
			}
			if (classDef == null) {
				return null;
			}
			return (new classDef()) as DisplayObject;
		}
		
		/**
		 * 设置样式
		 * @param	style
		 * @param	value
		 */
		public function setStyle(style:String, value:Object):void {
			if (instanceStyles[style] === value && !(value is TextFormat)) { return; }
			instanceStyles[style] = value;
			
			//改变样式
			changeStyles();
			
		}
		
		/**
		 * 以文本获取对象
		 * @param	name
		 * @return
		 */
		protected function getStyleValue(name:String):Object {
			return instanceStyles[name];
		}
		
		/**
		 * 获取基本类
		 * @return
		 */
		public static function getStyleDefinition():Object {			
			return defaultStyles ;
		}
		
		public function PromptBase() 
		{
			instanceStyles = getStyleDefinition();
			super();
			
			//改变样式
			changeStyles();
		}
		
	//============================================
	//===== Protected Function ======
	//============================================		
		/**
		 * [重写 override] 初始化UI界面
		 */
		override protected function initUI():void 
		{
			_titleTextField = new TextField();
			_titleTextField.autoSize = "left";
			_titleTextField.selectable = false;
			_titleTextField.mouseEnabled = false;
			addChild(_titleTextField);
			
			_contantTextField = new TextField();
			_contantTextField.autoSize = "left";
			_contantTextField.selectable = false;
			addChild(_contantTextField);
			
			//addEventListener(Event.RENDER, renderHandler, false, 0, true);
			//addEventListener(Event.CHANGE, changeHandler, false, 0, true);
			//addEventListener(Event.ADDED, addedHandler, false, 0, true);
			super.initUI();
		}
		
		/**
		 * [重写 override] 添加提示信息
		 * @param	__message	需要添加的提示信息
		 */
		override protected  function setMessage(__message:*,...rest):void 
		{
			_contantTextField.wordWrap = false;
			super.setMessage(__message, rest);
			_titleTextField.text = rest[0].toString();
			if (rest[1] is Function) _callBackFunction=rest[1];
			if (!hasEventListener(Event.ENTER_FRAME)) addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
			//addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
		//	if (!hasEventListener(Event.ADDED)) addEventListener(Event.ADDED, addedHandler, false, 0, true);
			draw();
		}
		
		/**
		 * 绘制背景及摆放位置
		 */
		protected function  draw():void 
		{
			//设置位置
			setPosition();
			
			x = _stage.stageWidth - width >> 1;
			y = _stage.stageHeight - height >> 1;
			filters = [_dropShadowFilter];
		}
		
		
		/**
		 * 设置位置
		 */
		protected function setPosition():void 
		{
			_containerWidth =  (_contantTextField.width > 120?Math.min(200, _contantTextField.width):120) + 20 ;
			if (_contantTextField.width>=200)
			{
				_contantTextField.wordWrap = true;
				_contantTextField.width = 200;
			}
			_containerHeight = _contantTextField.height + 40 + _header.height;
			
			_header.width = _containerWidth;
			_container.width = _containerWidth;
			_container.height = _containerHeight - _header.height;
			
			_titleTextField.x = 5;
			_titleTextField.y = _header.height -_titleTextField.height >> 1;
			
			_container.y = _header.height;
			
			_contantTextField.x = _containerWidth - _contantTextField.width >> 1;
			_contantTextField.y = _container.y + 6;
			
			_closeButton.x = _containerWidth -_closeButton.width - 3;
			_closeButton.y = _header.height - _closeButton.height >> 1;
		}
		
		/**
		 * 改变样式
		 */
		override protected function changeStyles():void 
		{
			var hd:DisplayObject = _header;
			_header = getDisplayObjectInstance(getStyleValue("header"));
			if (_header == null)  return;
			addChildAt(_header, 0);
			if (hd != null && hd != _header && contains(hd)) { 
				hd.removeEventListener(MouseEvent.MOUSE_DOWN, headerMouseDownHandler);
				removeChild(hd); 
			}
			
			var ct:DisplayObject = _container;
			_container = getDisplayObjectInstance(getStyleValue("container"));
			if (_container == null) return;
			addChildAt(_container, 1);
			if (ct != null && ct != _container && contains(ct))
			{
				removeChild(ct);
			}
			
			var cb:DisplayObject = _closeButton;
			_closeButton = getDisplayObjectInstance(getStyleValue("closeButton"));
			if (_closeButton == null) return;
			addChildAt(_closeButton, 2);
			if (cb != null && cb != _closeButton && contains(cb))
			{
				removeChild(cb);
				cb.removeEventListener(MouseEvent.CLICK, closeHandler);
			}
			//titleTextFormat:new  TextFormat("微软雅黑,宋体", 12, 0xFFFFFF),
			//contentTextFormat:new  TextFormat("微软雅黑,宋体", 12, 0x000000)
			var  uiStyles:Object = PromptBase.getStyleDefinition() ;
			var defaultTitleTF:TextFormat = uiStyles.titleTextFormat as TextFormat;
			var defaultContantTF:TextFormat = uiStyles.contentTextFormat as TextFormat;
			 _titleTextField.setTextFormat(defaultTitleTF);
			 _contantTextField.setTextFormat(defaultContantTF);
			var titleTF:TextFormat= getStyleValue("titleTextFormat")  as TextFormat;
			var contantTF:TextFormat= getStyleValue("contentTextFormat") as TextFormat;
			if (titleTF != null) { _titleTextField.setTextFormat(titleTF); 	}
			else {		titleTF = defaultTitleTF;		}			
			if (contantTF != null) {		_contantTextField.setTextFormat(contantTF); 		}
			else {	contantTF=defaultContantTF; 	}
			_titleTextField.defaultTextFormat = titleTF;
			_contantTextField.defaultTextFormat =defaultContantTF;
			
			_closeButton.addEventListener(MouseEvent.CLICK, closeHandler, false, 0, true);
			//检测是否可以拖动
			checkDragEnable();
			
			super.changeStyles();
		}
		
		/**
		 * [重写 override] 处置掉显示
		 */
		override protected function dispo():void 
		{
			super.dispo();
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
	//		removeEventListener(Event.ADDED,addedHandler);
//			if (_callBackFunction!=null) _callBackApply(_callBackFunction,...rest);
			dispatchEvent(new PromptEvent(PromptEvent.PROMPT_ClOSE));
		}
		
		//============================================
		//===== Private Function =====
		//============================================
		/**
		 * 检测是否可以拖动
		 */
		private function checkDragEnable():void 
		{
			if (_dragEnabled) _header.addEventListener(MouseEvent.MOUSE_DOWN, headerMouseDownHandler, false, 0, true);
			else  _header.removeEventListener(MouseEvent.MOUSE_DOWN, headerMouseDownHandler);
		}
		
		/**
		 * 回调函数
		 * @param	f
		 * @param	...rest
		 */
		private function _callBackApply(f:Function,...rest):void 
		{
			
			f.apply(null,rest);
		}
		
		
		
		//============================================
		//===== EventListener Function ======
		//============================================	
		/**
		 * 关闭按钮时调度
		 * @param	event
		 */
		protected function closeHandler(event:MouseEvent):void 
		{
			event.stopPropagation();
			dispo();
		}
		
		/**
		 * 头部鼠标按下时
		 * @param	event
		 */
		private function headerMouseDownHandler(event:MouseEvent):void 
		{
			event.stopPropagation();
			startDrag();
			_header.addEventListener(MouseEvent.MOUSE_UP, headerMouseUpHandler, false, 0, true);
		}
		
		/**
		 * 头部数遍弹起时
		 * @param	event
		 */
		private function headerMouseUpHandler(event:MouseEvent):void 
		{
			stopDrag();
			if(!_dragEnabled)	_header.removeEventListener(MouseEvent.MOUSE_DOWN, headerMouseDownHandler);
			_header.removeEventListener(MouseEvent.MOUSE_UP, headerMouseUpHandler);
		}
		
		/**
		 * 当有更新时调度
		 * @param	event
		 */
		protected function renderHandler(event:Event):void 
		{
			trace(this,event.type);
			setPosition();
		}
		
		/**
		 * 当有改变时调度
		 * @param	event
		 */
		protected function changeHandler(event:Event):void 
		{
			trace(this,event.type);
			setPosition();
		}		
		
		/**
		 * 将显示对象添加到显示列表中时调度。
		 * @param	event
		 */
		protected	function addedHandler(event:Event):void 
		{
			trace(this,event.type);
			setPosition();
		}
		/**
		 * 实时调度根性
		 * @param	event
		 */
		protected function enterFrameHandler(event:Event):void 
		{
				setPosition();
		}

		
		//============================================
		//===== Getter && Setter ======
		//============================================
		public function set dragEnabled(value:Boolean):void 
		{
			_dragEnabled = value;
			checkDragEnable();
		}
		
		


	//============================================
	//===== Class[PromptBase] Has Finish ======
	//============================================
	}

}