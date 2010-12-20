package com.dinboy.controls 
{
	import com.dinboy.events.PromptEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	

	/**
	 * @author		钉崽[dinboy]
	 * @copy		dinboy © 2010
	 * @version		v1.0 [2010-11-5 13:50]
	 */
	public class Alert extends PromptBase
	{
		/**
		 * 实例本身
		 */
		private static var _instance:Alert = null;
		
		/**
		 * 确定按钮
		 */
		private var _OKButton:DisplayObject;
		
		/**
		 * 点击确认按钮
		 */
		public static const OK:uint = 0x0004;
		
		/**
		 * 默认皮肤样式
		 */
		public static var defaultStyles:Object = {
						okButton:PromptButton
		}

		/**
		 * 获取基本类
		 * @return
		 */
		public static function getStyleDefinition():Object {
			return mergeStyles(defaultStyles, PromptBase.getStyleDefinition());
		}
		
		public function Alert()
		{
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
			instanceStyles = getStyleDefinition();
			_maskEnabled= true;
			_dragEnabled = true;
			super.initUI();
			
		}
		
		/**
		 * 确定按钮点击时
		 * @param	event
		 */
		private function okbuttnClickHandler(event:MouseEvent):void 
		{
			event.stopPropagation();
			dispo();
		}
		
		/**
		 * 改变样式
		 */
		override protected function changeStyles():void 
		{
			var ob:DisplayObject = _OKButton;
			_OKButton = getDisplayObjectInstance(getStyleValue("okButton"));
			if (_OKButton == null) return
			addChildAt(_OKButton, 0);
			Object(_OKButton).label = "确认";
			Object(_OKButton).buttonMode = true;
			Object(_OKButton).tabEnabled = false;
			_OKButton.width = 60;
			_OKButton.addEventListener(MouseEvent.CLICK, okbuttnClickHandler, false, 0, true);
			if (ob != null&& ob!=_OKButton&&contains(ob) )
			{
				removeChild(ob);
				ob.removeEventListener(MouseEvent.CLICK, okbuttnClickHandler);
			}
			super.changeStyles();
			
		}
		
		/**
		 * [重写 override] 绘制背景及摆放位置
		 */
		override protected function  draw():void 
		{
			super.draw();

		}
		
		/**
		 * [重写 override] 设置位置
		 */
		override protected function setPosition():void 
		{
			super.setPosition();
						_OKButton.x =  _containerWidth - _OKButton.width >> 1;
			_OKButton.y =  _containerHeight - _OKButton.height - 4;
		}
		
		
	//============================================
	//===== Public Static Function ======
	//============================================
		/**
		 * 初始化
		 * @param	__stage 显示舞台
		 */
		public static function init(__stage:DisplayObjectContainer):void 
		{
			if (!_instance) _instance = new Alert();
			_instance._stage = (__stage is Stage)?__stage as Stage : __stage.stage;
		}
		
		/**
		 * [重写 override] 设置文本消息
		 * @param	__message
		 * @param	..rest
		 */
		public static function message(__message:*,__title:String="提示",callBack:Function=null):Alert 
		{
			_instance.setMessage(__message, __title,callBack);
			_instance.show();
			return _instance;
		}
		
		/**
		 * 设置样式
		 * @param	style
		 * @param	value
		 */
		public static function setStyle(style:String, value:Object):void 
		{
			_instance.setStyle(style, value);
		}
		
		/**
		 * 是否遮罩 (默认:true)
		 */
		public static  function set maskEnabled(value:Boolean):void 
		{
			_instance._maskEnabled = value;
		}
		public static  function get maskEnabled():Boolean 
		{
			return _instance._maskEnabled;
		}
		/**
		 * 设置是否可以拖动.(默认:true)
		 */
		public static function set dragEnabled(value:Boolean):void 
		{
			_instance.dragEnabled = value;
		}
		public static function get dragEnabled():Boolean 
		{
			return _instance._dragEnabled;
		}
		
		

		
	
		//============================================
		//===== Private Function ======
		//============================================


	//============================================
	//===== Class[Alert] Has Finish ======
	//============================================
	}

}