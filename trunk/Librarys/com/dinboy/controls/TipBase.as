package com.dinboy.controls
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	

	/**
	 * @author		钉崽[dinboy]
	 * @copy		dinboy © 2010
	 * @version		v1.0 [2010-11-5 13:51]
	 */
	public class TipBase extends Sprite
	{
		/**
		 *	信息文本框
		 */
		protected var _messageTxt:TextField;
		
		/**
		 * 显示舞台
		 */
		protected var _stage:Stage;
		
		/**
		 * 遮罩图形
		 */
		protected var _masker:Shape;
		
		/**
		 * 是否已经遮罩着
		 */
		protected var _masked:Boolean;
		
		/**
		 * 阴影滤镜
		 */
		protected var _dropShadowFilter:DropShadowFilter;
		public function TipBase() 
		{
			super();
			//初始化UI
			initUI();
		}
		
		//============================================
		//===== Protected Function ======
		//============================================		
		/**
		 * 初始化UI界面
		 */
		protected function initUI():void 
		{
			_messageTxt = new TextField();
			
			_dropShadowFilter = new DropShadowFilter(2, 45, 0, 0.5, 6, 6, 1, 3);
		}
		
		/**
		 * 添加提示信息
		 * @param	__message	需要添加的提示信息
		 */
		protected  function setMessage(__message:String,...rest):void 
		{
			_messageTxt.htmlText = __message;
			
			createMasker();
		}
		
		/**
		 * 处置掉显示
		 */
		protected function dispo():void 
		{
			filters = [];
			parent.removeChild(this);
			dispoMasker();
		}
		


		//============================================
		//===== Public Static Function ======
		//============================================
	
		
		
		
		
		
		//============================================
		//===== Private Function ======
		//============================================	
		/**
		 * 创建屏蔽背景
		 */
		private function createMasker():void 
		{
			if (!_masker) _masker = new Shape();
			_masker.graphics.clear();
			_masker.graphics.beginFill(0xFFFFFF, 0);
			_masker.graphics.drawRect(0, 0, _stage.stageWidth, _stage.stageHeight);
			_masker.graphics.endFill();
			_stage.addChild(_masker);
			_masked = true;
		}
		
		/**
		 * 处置掉遮罩
		 */
		private function dispoMasker():void 
		{
			_stage.removeChild(_masker);
			_masked = false;
		}



	//============================================
	//===== Class[TipBase] Has Finish ======
	//============================================
	}

}