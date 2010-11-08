package com.dinboy.controls
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * @author		钉崽[dinboy]
	 * @copy		dinboy © 2010
	 * @version		v1.0 [2010-11-5 14:52]
	 */
	public class PromptBase extends TipBase
	{
		/**
		 * 标题文本框
		 */
		protected var _titleTxt:TextField;
		
		/**
		 * 关闭按钮
		 */
		protected var _close:Sprite;
		
		/**
		 * 文本容器高度
		 */
		protected var _containerHeight:Number;
		
		/**
		 * 文本信息宽度
		 */
		private var _containerWidth:Number;
		
		public function PromptBase() 
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
			super.initUI();
			_messageTxt.autoSize = "left";
			_messageTxt.wordWrap = false;
			_messageTxt.selectable = false;
			addChild(_messageTxt);
			
			_titleTxt = new TextField();
			_titleTxt.autoSize = "left";
			_titleTxt.wordWrap = false;
			_titleTxt.textColor = 0xFFFFFF;
			
			_titleTxt.selectable = false;
			addChild(_titleTxt).x = 4;
			
			_close = new Sprite();
			_close.graphics.beginFill(0xFFFFFF);
			_close.graphics.drawRoundRect(0, 0, 14, 14, 5, 5);
			_close.graphics.beginFill(0x0A618F);
			_close.graphics.drawRoundRect(3, 3, 8,8, 2, 2);
			_close.graphics.endFill();
			addChild(_close);
			_close.buttonMode = true;
			
			_close.addEventListener(MouseEvent.CLICK, closeHandler, false, 0, true);
			_close.addEventListener(MouseEvent.MOUSE_OVER, closeOverHandler, false, 0, true);
		}

		/**
		 * [重写 override] 添加提示信息
		 * @param	__message	需要添加的提示信息
		 */
		override protected  function setMessage(__message:String,...rest):void 
		{
			super.setMessage(__message, rest);
			_titleTxt.text = rest[0];
			
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
		 * 鼠标移出时
		 * @param	event
		 */
		private function closeOutHandler(event:MouseEvent):void 
		{
			_close.removeEventListener(MouseEvent.MOUSE_OUT,closeOverHandler);
			_close.removeEventListener(MouseEvent.MOUSE_UP, closeOutHandler);
			_close.graphics.clear();
			_close.graphics.beginFill(0xFFFFFF);
			_close.graphics.drawRoundRect(0, 0, 14, 14, 5, 5);
			_close.graphics.beginFill(0x0A618F);
			_close.graphics.drawRoundRect(3,3, 8, 8, 2, 2);
			_close.graphics.endFill();
		}
		
		/**
		 * 鼠标移入时
		 * @param	event
		 */
		private function closeOverHandler(event:MouseEvent):void 
		{
			_close.addEventListener(MouseEvent.MOUSE_OUT, closeOutHandler, false, 0, true);
			
			_close.graphics.clear();
			_close.graphics.beginFill(0xFFFFFF);
			_close.graphics.drawRoundRect(0, 0, 14, 14, 5, 5);
			_close.graphics.beginFill(0x0A618F);
			_close.graphics.drawRoundRect(4, 4, 6, 6, 4, 4);
			_close.graphics.endFill();
		}
	
		/**
		 * 绘制背景及摆放位置
		 */
		protected function  draw():void 
		{

			graphics.clear();
			graphics.beginFill(0x50B9F1);
			graphics.drawRect(0, 0, _containerWidth, 20);
			graphics.beginFill(0xE1F3FD);
			graphics.drawRect(0, 20, _containerWidth, _containerHeight );
			graphics.endFill();
			
			_messageTxt.x = 10;
			_messageTxt.y = 34;
			
			_close.x = _containerWidth -_close.width-3;
			_close.y = 3;
			
			x = _stage.stageWidth - width >> 1;
			y = _stage.stageHeight - height >> 1;
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
			_close.removeEventListener(MouseEvent.CLICK, closeHandler);
			_close.removeEventListener(MouseEvent.MOUSE_OUT,closeOverHandler);
			_close.removeEventListener(MouseEvent.MOUSE_UP, closeOutHandler);
			event.stopPropagation();
			super.dispo();
		}


	//============================================
	//===== Class[PromptBase] Has Finish ======
	//============================================
	}

}