package com.dinboy.controls 
{
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
		private var _OKButton:PromptButton;
		
		public function Alert() 
		{
			super();
			_OKButton = new PromptButton();
			_OKButton.label = "确认确认确认";
			addChild(_OKButton);
			_OKButton.width = 40;
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
		}
		
		/**
		 * [重写 override] 绘制背景及摆放位置
		 */
		override protected function  draw():void 
		{
			_containerHeight += 20;
			super.draw();
			_OKButton.x = width -_OKButton.width >> 1;
			_OKButton.y = height - _OKButton.height - 4;
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
		public static function message(__message:String,__title:String="提示"):void 
		{
			_instance.setMessage(__message, __title);
			_instance._stage.addChild(_instance);
		}
		

		
	
		//============================================
		//===== Private Function ======
		//============================================


	//============================================
	//===== Class[Alert] Has Finish ======
	//============================================
	}

}