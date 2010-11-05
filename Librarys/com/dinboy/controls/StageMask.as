package com.dinboy.controls 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Dinboy.com
	 * @copy CopyRight © 2010 DinBoy
	 */
	public class StageMask
	{
		/**
		 * 本身实例
		 */
		private static var $Instance:StageMask = null;
		
		/**
		 * 遮罩精灵
		 */
		private var $sprite:Sprite;
		
		/**
		 * 提示文本
		 */
		private var $textField:TextField;
		
		/**
		 * 舞台
		 */
		private var $Stage:Stage;
		
		/**
		 * 定量颜色值
		 */
		private const COLOR:uint = 0xFFFFFF;
		
		/**
		 * 显示对象的颜色
		 */
		private var $color:uint =COLOR ;
		
		/**
		 * 定量透明值
		 */
		private const ALPHA:Number = 0.5;
		
		/**
		 * 显示对象的透明度
		 */
		private var $alpha:Number = ALPHA;
		
		/**
		 * 如果需要提示的文本
		 */
		private var $text:String;
		
		/**
		 * 添加网页文本
		 */
		private var $htmlText:String;
		
		/**
		 * 是否添加了文本
		 */
		private var $hasText:Boolean;
		
		/**
		 * 是否添加了HtmlText
		 */
		private var $hasHtmlText:Boolean;
		
		/**
		 * 是否已经显示了
		 */
		private var $showed:Boolean;
		
		public function StageMask()
		{
			
		}
		
		
		//=============================================
		//=================     静态方法     ==================
		//=============================================
		
		/**
		 * 初始化工具,当$DisplayObjectContainer为null是 扔出错误
		 * @param	$DisplayObjectContainer 显示对象容器
		 */
		public static function init($DisplayObjectContainer:DisplayObjectContainer=null):void 
		{
				if ($DisplayObjectContainer == null) throw new Error("对不起,您没初始化我呢.");
			
				if ($Instance == null) $Instance = new StageMask();
				
				if ($DisplayObjectContainer is Stage) $Instance.$Stage = $DisplayObjectContainer as Stage;
				else	$Instance.$Stage = $DisplayObjectContainer.stage;
				
				if (!$Instance.$Stage) $DisplayObjectContainer.addEventListener(Event.ADDED_TO_STAGE, $Instance.addStage, false, 0, true);
				else	$Instance.addStage();
		}
		
		
		/**
		 * 当提交显示时
		 */
		public static function show():void 
		{
			testinit();
			if (!$Instance.$showed)
			{
				$Instance.$showed = true;
				$Instance.$sprite = new Sprite();
				$Instance.$Stage.addChild($Instance.$sprite);
				$Instance.resize();
				$Instance.$Stage.addEventListener(Event.RESIZE, $Instance.ResizeHandler, false, 0, true);
			}
		}
		
		
		/**
		 * 提交隐藏
		 */
		public static function hiden():void 
		{
			testinit();
			if ($Instance.$sprite.contains($Instance.$textField)) {
					$Instance.$textField.htmlText = "";
					$Instance.$hasHtmlText = false;
					$Instance.$hasText = false;
					$Instance.$sprite.removeChild($Instance.$textField); 
					$Instance.$textField = null;
				}
			if ($Instance.$Stage.contains($Instance.$sprite)) {
				$Instance.$Stage.removeChild($Instance.$sprite);
			}
			$Instance.$showed = false;
		}
		
		//=============================================
		//=================     内部方法     ==================
		//=============================================
		
		/**
		 * 测试是否有初始化
		 */
		private static function testinit():void 
		{
			if ($Instance==null) 
				{
					throw new Error("You have not yet initialized me -> StageMask , Please use it by StageMask.init(DisplayObjectcontainer)!");
					return;
				}
		}
		
		/**
		 * 把显示对象添加到舞台上去
		 * @param	evt
		 */
		private function addStage(evt:Event=null):void 
		{
			if (evt!=null) {
				evt.currentTarget.removeEventListener(Event.ADDED_TO_STAGE, $Instance.addStage);
				this.$Stage = DisplayObjectContainer(evt.currentTarget).stage;
			}
		}
		
		/**
		 * 当舞台有缩放时
		 * @param	evt
		 */
		private function ResizeHandler(evt:Event):void 
		{
			this.resize();
		}
		
		/**
		 * 重新调整界面
		 */
		private function  resize():void 
		{
			if (this.$sprite) 
			{
					this.$sprite.x = 0;
					this.$sprite.y = 0;
					this.$sprite.graphics.clear();
					this.$sprite.graphics.beginFill(this.$color, this.$alpha);
					this.$sprite.graphics.drawRect(0, 0, this.$Stage.stageWidth, this.$Stage.stageHeight)
					this.$sprite.graphics.endFill();
					if (this.$hasText || this.$hasHtmlText) 
					{
							if(!this.$textField) this.$textField = new TextField();
							this.$textField.autoSize = TextFieldAutoSize.LEFT;
							if(!this.$sprite.contains(this.$textField))this.$sprite.addChild(this.$textField);
							if (this.$hasText) this.$textField.text = this.$text;
							if (this.$hasHtmlText) this.$textField.htmlText = this.$htmlText;
							this.$textField.x = this.$Stage.stageWidth - this.$textField.width >> 1;
							this.$textField.y = this.$Stage.stageHeight - this.$textField.height >> 1;
					}
			}
		}
		
		
		//=============================================
		//===============     Getter/Setter     ==================
		//=============================================
		/**
		 * 设置/获取 颜色
		 */
		public static function get color():uint { 
			testinit();
			return $Instance.$color; 
			}
		
		public static function set color($value:uint):void 
		{
			testinit();
			$Instance.$color = $value;
			$Instance.resize();
		}
		
		/**
		 * 设置/获取 透明度
		 */
		public static function get alpha():Number {
			testinit();
			return $Instance.$alpha; 
		}
		
		public static function set alpha($value:Number):void 
		{
			testinit();
			$Instance.$alpha = $value;
			$Instance.resize();
		}
		
		/**
		 * 设置/获取 文本
		 */
		public static function get text():String { 
			testinit();
			return $Instance.$text; 
		}
		
		public static function set text($value:String):void 
		{
			testinit();
			if ($value != "" && $value != null) $Instance.$hasText = true;
			else $Instance.$hasText = false;
			$Instance.$text = $value;
			$Instance.resize();
		}
		
		/**
		 * 设置/获取 网页文本
		 */
		public static function get htmlText():String { 
			testinit();
			return $Instance.$htmlText; 
		}
		
		public static function set htmlText($value:String):void 
		{
			testinit();
			if ($value != ""  &&  $value != null) $Instance.$hasHtmlText = true;
			else $Instance.$hasHtmlText = false;
			$Instance.$htmlText = $value;
			$Instance.resize();
		}
		/********** [DINBOY] Say: Class The End  ************/	
	}

}