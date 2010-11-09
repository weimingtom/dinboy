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
		protected var _contantTextField:TextField;
		
		/**
		 * 显示舞台
		 */
		protected var _stage:Stage;
		
		/**
		 * 遮罩图形
		 */
		protected var _masker:Sprite;
		
		/**
		 * 是否遮罩背景
		 */
		protected var _maskEnabled:Boolean;
		
		/**
		 * 阴影滤镜
		 */
		protected var _dropShadowFilter:DropShadowFilter;
		
		public static var defaultStyles:Object = {		}
		
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
			_dropShadowFilter = new DropShadowFilter(2, 45, 0, 0.5, 6, 6, 1, 3);
		}
		
		/**
		 * 添加提示信息
		 * @param	__message	需要添加的提示信息
		 */
		protected  function setMessage(__message:String,...rest):void 
		{
			_contantTextField.htmlText = __message;
		}
		
		/**
		 * 显示对象
		 */
		protected function show():void 
		{
			_stage.addChild(this);
			if (_maskEnabled) createMasker();
		}
		
		/**
		 * 改变样式
		 */
		protected function changeStyles():void 
		{
			
		}
		
		/**
		 * 处置掉显示
		 */
		protected function dispo():void 
		{
			filters = [];
			parent.removeChild(this);
			if(_maskEnabled) dispoMasker();
		}
		


		//============================================
		//===== Public Static Function ======
		//============================================
		/**
		 * 合并皮肤
		 * @param	...list	合并的类
		 * @return	新的类
		 */
		public static function mergeStyles(...list:Array):Object {
			var styles:Object = {};
			var l:uint = list.length;
			for (var i:uint=0; i<l; i++) {
				var styleList:Object = list[i];
				for (var n:String in styleList) {
					if (styles[n] != null) { continue; }
					styles[n] = list[i][n];
				}
			}
			return styles;
		}
		
		/**
		 * 获取基本类
		 * @return
		 */
		public static function getStyleDefinition():Object {			
			return defaultStyles;
		}
		
		
		
		
		
		//============================================
		//===== Private Function ======
		//============================================	
		/**
		 * 创建屏蔽背景
		 */
		protected function createMasker():void 
		{
			if (!_masker) _masker = new Sprite();
			_masker.graphics.clear();
			_masker.graphics.beginFill(0xFFFFFF, 0);
			_masker.graphics.drawRect(0, 0, _stage.stageWidth, _stage.stageHeight);
			_masker.graphics.endFill();
			if (!_masker.parent) _stage.addChild(_masker);
			_stage.setChildIndex(_masker, _stage.getChildIndex(this));
		}
		
		/**
		 * 处置掉遮罩
		 */
		protected function dispoMasker():void 
		{
			if(_masker.parent) _stage.removeChild(_masker);
		}



	//============================================
	//===== Class[TipBase] Has Finish ======
	//============================================
	}

}