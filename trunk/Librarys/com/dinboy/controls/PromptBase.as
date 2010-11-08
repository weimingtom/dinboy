package com.dinboy.controls
{
	import com.dinboy.controls.renders.CloseButton;
	import com.dinboy.controls.renders.PromptContainer;
	import com.dinboy.controls.renders.PromptHeader;
	import com.dinboy.events.PromptEvent;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
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
		protected var _titleTxt:TextField;
		
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
		private var _containerWidth:Number;
		
		/**
		 * 是否可以拖动
		 */
		protected var _dragEnabled:Boolean;
		
		public static var defaultStyles:Object = {
								header:PromptHeader,
								container:PromptContainer,
								closeButton:CloseButton
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
		}
		
		/**
		 * 以文本获取对象
		 * @param	name
		 * @return
		 */
		protected function getStyleValue(name:String):Object {
			return instanceStyles[name];
		}
		
		public function PromptBase() 
		{
			instanceStyles = PromptBase.defaultStyles;
			super();
			
		}
		
	//============================================
	//===== Protected Function ======
	//============================================		
		/**
		 * [重写 override] 初始化UI界面
		 */
		override protected function initUI():void 
		{
			super.initUI();
			_header=addChildAt(getDisplayObjectInstance(getStyleValue("header")),0);
			_closeButton=addChildAt(getDisplayObjectInstance(getStyleValue("closeButton")),1);
			_container=addChildAt(getDisplayObjectInstance(getStyleValue("container")),2);
			addChild(_messageTxt);
			
			_closeButton.addEventListener(MouseEvent.CLICK, closeHandler, false, 0, true);
		}

		/**
		 * [重写 override] 添加提示信息
		 * @param	__message	需要添加的提示信息
		 */
		override protected  function setMessage(__message:String,...rest):void 
		{
			super.setMessage(__message, rest);
		//	_header.label = rest[0];
			_messageTxt.autoSize = "left";
			_messageTxt.wordWrap = false;
			_messageTxt.selectable = false;
			_containerWidth = (_messageTxt.width > 180?180:100) + 20;
			if (_containerWidth>=200) 
			{
				_messageTxt.wordWrap = true;
				_messageTxt.width = 180;
			}
			_containerHeight = _messageTxt.height + 20;
			
			draw();
		}
		
		/**
		 * 绘制背景及摆放位置
		 */
		protected function  draw():void 
		{
			_header.width = _containerWidth;
			_container.y = _header.height;
			_container.width = _containerWidth;
			_container.height = _containerHeight;
			
			_messageTxt.x = 10;
			_messageTxt.y = _container.y+14;
			
			_closeButton.x = _containerWidth -_closeButton.width - 3;
			_closeButton.y = _header.height-_closeButton.height>>1;
			
			x = _stage.stageWidth - width >> 1;
			y = _stage.stageHeight - height >> 1;
			
			filters = [_dropShadowFilter];
		}
		
		/**
		 * [重写 override] 处置掉显示
		 */
		override protected function dispo():void 
		{
			super.dispo();
			dispatchEvent(new PromptEvent(PromptEvent.PROMPT_ClOSE));
		}
		
		
		
		
		//============================================
		//===== EventListener Function ======
		//============================================	
		/**
		 * 关闭按钮时调度
		 * @param	event
		 */
		private function closeHandler(event:MouseEvent):void 
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
		
		
		//============================================
		//===== Getter && Setter ======
		//============================================
		public function set dragEnabled(value:Boolean):void 
		{
			if (_dragEnabled=value) _header.addEventListener(MouseEvent.MOUSE_DOWN, headerMouseDownHandler, false, 0, true);
		}
		
		


	//============================================
	//===== Class[PromptBase] Has Finish ======
	//============================================
	}

}