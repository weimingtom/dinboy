package com.dinboy.controls 
{
	import com.dinboy.net.DinLoader;
	import com.dinboy.util.DinDisplayUtil;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @copy Dinboy.com © 2010
	 * @author 钉崽
	 * 我的约定:
	 * public(公有属性)            定义名称无前缀,并使用驼峰写法;
	 * private(私有属性)           函数名称无前缀,并使用驼峰写法; 变量名称使用下划线前缀"_",并使用驼峰写法;
	 * const(定义常量)             函数名称无前缀,并使用驼峰写法; 常量名称使用大写字母,必要时使用下划线"_";
	 * function(函数内部定义)  函数内部变量使用美元符号前缀"_",并使用驼峰写法;
	 */
  
		//==============================
		//#### This Is A Interpretation Template ####
		//==============================
	
		
		
	public class DinTipBase extends Sprite
	{
		/**
		 * 提示框的图标
		 */
		private var _icon:DinLoader;
		
		/**
		 * 提示框的最大宽度
		 */
		private var _tipWidth:Number;
		
		/**
		 * 提示的文本
		 */
		private var _message:String;
		
		/**
		 * 提示文本框
		 */
		private var _msgTextField:TextField;
		
		/**
		 * 显示区域的宽度
		 */
		private var _areaWidth:Number;
		
		/**
		 * 显示区域的高度
		 */
		private var _areaHeight:Number;
		
		/**
		 * 提示框图标地址
		 */
		private var _iconSrc:String;
		
		/**
		 * 添加本提示框的容器
		 */
		private var _container:DisplayObjectContainer;
		
		/**
		 * 判断是否是渐进
		 */
		private var _fadeOut:Boolean;
		
		/**
		 * 提示框需要偏于的Y坐标
		 */
		private var _offsetY:Number;
		
		/**
		 * 显示提示框
		 * @param	_message			提示文本
		 * @param	_areaWidth		提示框的显示区域宽度
		 * @param	_areaHeight		提示框的显示区域高度
		 * @param	_iconSrc				提示框图标地址
		 */
		public function DinTipBase(_message:String = "Message", _areaWidth:Number = 0, _areaHeight:Number=0,_iconSrc:String = null) 
		{
			this._message = _message;
			this._areaWidth = _areaWidth;
			this._areaHeight = _areaHeight;
			this._iconSrc = _iconSrc;
			
			this.addEventListener(Event.ADDED, this.addedHandler, false, 0, true);
		}

		
		//==============================
		//#### 公用方法 ####
		//==============================
		/**
		 * 显示本提示框
		 * @param	_container 本提示框需要添加到的容器
		 */
		public function show(_container:DisplayObjectContainer):void 
		{
			_container.addChild(this);
			this._container = _container;
		}
		
		/**
		 * 处置掉本实例
		 */
		public function disposal():void 
		{
			if (this._container.contains(this)) this._container.removeChild(this);
		}
		
		
		//==============================
		//#### 事件侦听 ####
		//==============================
		/**
		 * 侦听图标文件是否已经加载完毕
		 * @param	evt
		 */
		private function iconCompleteHandler(evt:Event):void 
		{
			this._icon.removeEventListener(Event.COMPLETE, this.iconCompleteHandler);
			DinDisplayUtil.directRatio(this._icon, 64, 64);
		}
		
		/**
		 * 当提示框被添加到显示队列时
		 * @param	evt
		 */
		private function addedHandler(evt:Event):void 
		{
			this.removeEventListener(Event.ADDED, this.addedHandler);
			this.initUI();
			
			this.addEventListener(Event.ENTER_FRAME, this.enterFrameHandler, false, 0, true);
		}
		
		/**
		 * 当被添加到显示队列是,实时侦听以判断位置
		 */
		private function enterFrameHandler(evt:Event):void 
		{
					this._fadeOut?(this.alpha >= 0?this.alpha -= .2:0):(this.alpha < 1?this.alpha += .2:1);
					this.y > this._offsetY ?this.y -= 10:this._fadeOut?this.fadeOuted():this.fadeOut();
		}
		
		//==============================
		//#### 私有方法 ####
		//==============================	
		/**
		 * 初始化UI界面
		 */
		private function initUI():void 
		{
			this._tipWidth = 260;
			
			this._icon = new DinLoader();
			this._icon.loadNormal(this._iconSrc);
			this._icon.ignoreError = true;
			this._icon.x = 10;
			this._icon.y = 10;
			this._icon.addEventListener(Event.COMPLETE, this.iconCompleteHandler, false, 0, true);
			this.addChild(this._icon);
			
			this._msgTextField = new TextField();
			this._msgTextField.selectable = false;
			this._msgTextField.autoSize = "left";
			this._msgTextField.x = this._iconSrc?80:10;
			this._msgTextField.y = 10;
			this._msgTextField.wordWrap = true;
			this._msgTextField.htmlText = this._message;
			this._msgTextField.width = this._tipWidth - this._msgTextField.x-10;
			this.addChild(_msgTextField);
			
			this.graphics.beginFill(0x000000, .1);
			this.graphics.drawRoundRect(0, 0, this._tipWidth	, this._msgTextField.height + this._msgTextField.y+10, 20, 20);
			this.graphics.beginFill(0xFFFFFF);
			this.graphics.drawRoundRect(4, 4, this._tipWidth-8, this._msgTextField.height-4  + 16, 15, 15);
			this.graphics.endFill();
			
			this._offsetY = this._areaHeight - this.height >> 1;
			this.x = this._areaWidth - this.width >> 1;
			this.y = (this._areaHeight - this.height >> 1) + 60;
			
			this.alpha = 0;
			
			var _glowFiter:GlowFilter = new GlowFilter(0x000000, .6, 12, 12,1,3);	
			this.filters = [_glowFiter];
		}
		
		/**
		 * 渐变而出
		 */
		private function fadeOut():void 
		{
				this._offsetY = (this._areaHeight - this.height >> 1) - 60;
				this.alpha = 1;
				this.removeEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
		var 	_timer:Timer = new Timer(3000,1);
				_timer.start();
				_timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.timerCompleteHandler, false, 0, true);
		}
		
		/**
		 * 已经渐变
		 */
		private function  fadeOuted():void 
		{
			this.alpha = 0;
			this.removeEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
			this.disposal();
		}
		
		/**
		 * 当计时器执行完毕时调度
		 * @param	evt
		 */
		private function timerCompleteHandler(evt:TimerEvent):void 
		{
			evt.currentTarget.removeEventListener(TimerEvent.TIMER_COMPLETE, this.timerCompleteHandler);
			evt.currentTarget.reset();
			evt.currentTarget.stop();
			
			this._fadeOut = true;
			this.addEventListener(Event.ENTER_FRAME, this.enterFrameHandler, false, 0, true);
		}
		
		
		//==============================
		//#### 设置/获取 共有属性 ####
		//==============================
		/**
		* 提示框的文本
		 */
		public function get message():String { return this._message; }
		public function set message(_value:String):void 
		{
			this._message = _value;
		}
		
		/**
		 * 显示区域宽度
		 */
		public function get areaWidth():Number { return this._areaWidth; }
		public function set areaWidth(_value:Number):void 
		{
			this._areaWidth = _value;
		}
		
		/**
		 * 显示区域高度
		 */
		public function get areaHeight():Number { return this._areaHeight; }
		public function set areaHeight(_value:Number):void 
		{
			this._areaHeight = _value;
		}
		
		/**
		 * 图标地址
		 */
		public function get iconSrc():String { return this._iconSrc; }
		public function set iconSrc(_value:String):void 
		{
			this._iconSrc = _value;
		}
		
		
		//==============================
		//#### DinBoy Say : This Class["DinTip"] Is Finish ####
		//==============================
	}

}