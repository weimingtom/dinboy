package com.dinboy.display 
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author Dinboy.com
	 * @copy CopyRight © 2010 DinBoy
	 */
	public class BubbleTip extends Sprite
	{
		/**
		 * 创建一个静态的 本身实例
		 */
		private static var $instance:BubbleTip = null;
		
		/**
		* 背景渐变Matrix
		*/
		private var $matrix:Matrix;
		
		/**
		* 渐变色颜色数组
		*/
		private var $colorArray:Array;
		
		/**
		* 渐变色颜色透明度数组
		*/
		private var $alphaArray:Array;
		
		/**
		* 本实例即将添加进去的舞台
		*/
		private var $stage:Stage;
		
		/**
		* 渐变范围数组
		*/
		private var $ratiosArray:Array;
		
		/**
		* 提示框的最大宽度
		*/
		private var $maxWidth:Number = Number.MAX_VALUE;
		
		/**
		* 提示框的最大宽度拷贝
		*/
		private var $maxWidthCopy:Number = Number.MAX_VALUE;
		
		/**
		* 提示框的最大高度
		*/
		private var $maxHeight:Number = Number.MAX_VALUE;
				
		/**
		* 提示框的最大高度拷贝
		*/
		private var $maxHeightCopy:Number = Number.MAX_VALUE;
		
		/**
		 * 舞台的宽度
		 */
		private var $stageWidth:Number;
		
		/**
		 * 舞台的高度
		 */
		private var $stageHeight:Number;
		
		/**
		* 显示的文本
		*/
		private var $textField:TextField;
		
		/**
		 * 箭头指向的位置
		 */
		private var $point:Point;
		
		/**
		 * 是否已经显示了
		 */
		private var $showed:Boolean;
		
		/**
		 * 当有文本输入时是否自动显示
		 */
		private var $autoshow:Boolean;
		
		/**
		 * 延迟隐藏的秒数
		 */
		private var $delayhide:Number;
		
		/**
		 * 延迟ID
		 */
		private var $setTimeoutID:uint;
		
		/**
		 * 是否要有箭头
		 */
		private var $arrow:Boolean=true;
		
		public function BubbleTip() 
		{
			this.$matrix = new Matrix();
			
			this.$point = new Point();
			
			this.$textField = new TextField();
			this.$textField.selectable = false;
			this.$textField.autoSize = TextFieldAutoSize.LEFT;
		    this.addChild(this.$textField);
		  
		  
			this.$colorArray = [0xFFFFFF, 0xEEEEEE];
			
			this.$alphaArray = [0xFF, 0xFF];
			
			this.$ratiosArray = [0x00, 0xFF];
			
		}
		
		//==========================================================
		// #######  静态函数
		//==========================================================
		
		
		
		/**
		 * 初始化实例
		 * @param	$displayObjectContainer 需要被初始化的显示对象容器
		 */
		public static function init($displayObjectContainer:DisplayObjectContainer):void 
		{
			//如果被初始化的显示容器为空的话,扔出错误
			if ($displayObjectContainer == null) throw new Error("DisplayObjectContainer is Null!");  
			
			//如果 本实例为空则实例化
			if ($instance==null)
			{
				$instance = new BubbleTip();
				
								//如果显示容器是舞台的话,则容器等于$stage,否则为容器的舞台
								if ($displayObjectContainer is Stage)	$instance.$stage = $displayObjectContainer as Stage; 
									else $instance.$stage = $displayObjectContainer.stage;
									
								//如果舞台为空,则把显示对象加入到舞台上
								if ($instance.$stage) $instance.initstage();
									else $displayObjectContainer.addEventListener(Event.ADDED_TO_STAGE, $instance.initstage,false,0,true);
				
			}else 
				throw new Error("BubbleTip class is static container only!");  
		}
		
		/**
		 * 显示提示
		 * @param	$dealy 如果不为空,则 在$dealy秒后自动关闭
		 */
		public static function show($dealy:Number=NaN):void 
		{
			testinit();
			$instance.$delayhide = $dealy;
			if (!$instance.$showed) {		
				$instance.alpha = 0;			
				$instance.$stage.addChild($instance);	
			}
			
			if (!$instance.$stage.hasEventListener(Event.RESIZE))	$instance.$stage.addEventListener(Event.RESIZE, $instance.onResize, false, 0, true);
			
			$instance.reset();
			$instance.setTimeoutFun();
		}
		
		/**
		 * 隐藏本提示
		 */
		public static function  hide():void 
		{
			testinit();
			$instance.$showed = true;
			$instance.setTimeoutFun();
		//	if ($instance.$showed && $instance.stage.contains($instance)) $instance.$stage.removeChild($instance);
		}
		
		/**
		 * 移动到指定位置
		 * @param	$x
		 * @param	$y
		 */
		public static function pointAt($x:Number=0,$y:Number=0):void 
		{
			testinit();
			$instance.$point.x = $x;
			$instance.$point.y = $y;
			
			$instance.reset();
		}
		
		/**
		 * 测试是否有初始化
		 */
		private static function testinit():void 
		{
				if (instance==null) 
				{
					throw new Error("You have not yet initialized me -> BubbleTip , Please use it by BubbleTip.init(DisplayObjectcontainer)!");
					return;
				}
		}
		
		
		
		//==========================================================
		// #######  实例内部函数
		//==========================================================
		
		/**
		 * 把显示对象加入到舞台
		 * @param	evt
		 */
		private function  initstage(evt:Event=null):void 
		{
			if (evt)  evt.target.removeEventListener(Event.ADDED_TO_STAGE, this.initstage);
			this.$stage.align = StageAlign.TOP_LEFT;
			this.$stage.scaleMode =StageScaleMode.NO_SCALE;
		}	
		
		/**
		 * 当窗口大小有所改变时
		 * @param	evt
		 */
		private function onResize(evt:Event):void 
		{
			this.reset();
		}
		
		/**
		 * 实时侦听
		 * @param	evt
		 */
		private function  onEnterFrame(evt:Event):void 
		{
				if (this.$showed)
				{
					this.alpha -= 0.1;
						if (this.alpha <= 0.1)
						{
							this.alpha = 0;
							this.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
							this.$stage.removeEventListener(Event.RESIZE, this.onResize);
							if (this.stage.contains(this)) this.$stage.removeChild(this);
							this.$showed = false;
						}
				}else 
				{
					this.alpha += 0.1;
					if (this.alpha>=0.9)
					{
						this.$showed = true;
						this.alpha = 1;
						this.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
						if (this.$delayhide) 	this.$setTimeoutID = setTimeout($instance.setTimeoutFun,$instance.$delayhide * 1000);
					}
				}
		}
		
		/**
		 * 延迟隐藏
		 */
		private function setTimeoutFun():void 
		{
			clearTimeout(this.$setTimeoutID);
			this.addEventListener(Event.ENTER_FRAME, this.onEnterFrame, false, 0, true);
		}
		
		/**
		 * 重新计算并排列位置
		 */
		private function reset():void 
		{
			
			//舞台的宽度及高度
	//		var $stageWidth:Number = this.$stage.stageWidth;
	//		var $stageHeight:Number = this.$stage.stageHeight;
			
			this.$stageWidth = this.$stage.stageWidth;
			this.$stageHeight = this.$stage.stageHeight;
			
			//清除掉所有绘制
			this.graphics.clear();
	
			this.$textField.autoSize = TextFieldAutoSize.LEFT;
			this.$textField.wordWrap = false;
			
			//如果最大值 宽度大于 容器宽度 , 则 最大值拷贝 等于 容器宽度 高度也雷同
			if (this.$maxWidth > this.$stageWidth) this.$maxWidthCopy = this.$stageWidth else this.$maxWidthCopy =this.$maxWidth;
			if (this.$maxHeight > this.$stageHeight) this.$maxHeightCopy = this.$stageHeight else this.$maxHeightCopy =this.$maxHeight;
			
			//如果 文本 宽度 大于 最大值宽度拷贝减去10像素 则 文本宽度 等于 最大值宽度的拷贝减去 10像素
			if (this.$textField.width > this.$maxWidthCopy - 10)
			{
				this.$textField.wordWrap = true;
				this.$textField.width = this.$maxWidthCopy - 10;
			}
			if (this.$textField.height > this.$maxHeightCopy - 10)
			{
				this.$textField.autoSize = TextFieldAutoSize.NONE;
				this.$textField.wordWrap = true;
				this.$textField.height = this.$maxHeightCopy - 10;
			}
			var $pointclone:Point = this.$point.clone();
			
			if (this.$point.x > this.$stageWidth -8) {
					$pointclone.x = this.$stageWidth - 8;
					this.$textField.x = $pointclone.x - this.$textField.width+3;
			}else if (this.$point.x < 8)  {
				$pointclone.x = 8;
				this.$textField.x = $pointclone.x - 3
			}
			else this.$textField.x = this.$point.x -3;
				
			
			if (this.$point.y < this.$textField.height + 14 ) {
					if (this.$point.y < 0) $pointclone.y = 0;
						else $pointclone.y = this.$point.y;
						this.$textField.y = this.$arrow?$pointclone.y+9:$pointclone.y + 5; 
				}else if (this.$point.y > this.$stageHeight) {
					$pointclone.y = this.$stageHeight;
					this.$textField.y =  this.$arrow? $pointclone.y - this.$textField.height - 9:$pointclone.y  - this.$textField.height- 4;
				}
			else this.$textField.y =  this.$arrow? $pointclone.y - this.$textField.height - 9:$pointclone.y  - this.$textField.height- 4;
				
			if (this.$textField.x + this.$textField.width > this.$stageWidth - 6) this.$textField.x = this.$stageWidth - this.$textField.width - 5;
		//	else if (this.$textField.x  < 5) this.$textField.x = 5;
			if (this.$textField.y + this.$textField.height > this.$stageHeight - 6 && this.$stageHeight-1>+this.$textField.y+this.$textField.height) {
				this.$textField.y = this.$stageHeight - this.$textField.height - 5;
			}
		//	else if (this.$textField.y  < 5) this.$textField.y = 5;
			
			//创建渐变背景显示框
			this.$matrix.createGradientBox(this.$textField.width + 10, this.$textField.height+14, Math.PI / 2, this.$textField.x - 5, this.$textField.y - 5);
			this.graphics.beginGradientFill(GradientType.LINEAR, this.$colorArray, this.$alphaArray, this.$ratiosArray, this.$matrix);
			this.graphics.lineStyle(1, 0xDDDDDD, .8, true, LineScaleMode.NONE, CapsStyle.ROUND, JointStyle.ROUND);
			
		
			
			// 如果要绘制箭头,则绘制三角箭头
			if (this.$arrow)
			{
				if (this.$point.y < this.$textField.height + 14) {
					this.drawArrawUp($pointclone);
				}else {
					this.drawArrawDown($pointclone);
						}
			}
			else this.drawUnarraw();
			
			//结束绘制
			this.graphics.endFill();
			
		}
		
		/**
		 * 绘制没箭头的背景
		 */
		private function  drawUnarraw():void 
		{
			this.graphics.moveTo(this.$textField.x-5, this.$textField.y-5);
			this.graphics.drawRoundRect(this.$textField.x - 5, this.$textField.y - 5, this.$textField.width + 10, this.$textField.height + 10, 10, 10);
		}
		
		/**
		 * 绘制箭头朝上
		 */
		private function  drawArrawUp($pointclone:Point):void 
		{
				this.graphics.moveTo(this.$textField.x, this.$textField.y-5);
				this.graphics.curveTo(this.$textField.x - 5, this.$textField.y - 5, this.$textField.x - 5, this.$textField.y);
				this.graphics.lineTo(this.$textField.x - 5, this.$textField.y + this.$textField.height);
				this.graphics.curveTo(this.$textField.x - 5, this.$textField.y + this.$textField.height + 5, this.$textField.x, this.$textField.y + this.$textField.height + 5);

				this.graphics.lineTo(this.$textField.x + this.$textField.width, this.$textField.y + this.$textField.height + 5);
				this.graphics.curveTo(this.$textField.x + this.$textField.width + 5, this.$textField.y + this.$textField.height + 5, this.$textField.x + this.$textField.width + 5, this.$textField.y + this.$textField.height);
				this.graphics.lineTo(this.$textField.x + this.$textField.width + 5, this.$textField.y);
				this.graphics.curveTo(this.$textField.x + this.$textField.width + 5, this.$textField.y -5, this.$textField.x + this.$textField.width , this.$textField.y -5);
				
								
				this.graphics.lineTo($pointclone.x + 3, $pointclone.y + 4);
				this.graphics.lineTo($pointclone.x , $pointclone.y);
				this.graphics.lineTo($pointclone.x - 3, $pointclone.y +4);
				
		//		this.graphics.lineTo(this.$textField.x,this.$textField.y-5 );
		}
		
		/**
		 * 绘制箭头朝下
		 */
		private function  drawArrawDown($pointclone:Point):void 
		{
				this.graphics.moveTo(this.$textField.x, this.$textField.y-5);
				this.graphics.curveTo(this.$textField.x - 5, this.$textField.y - 5, this.$textField.x - 5, this.$textField.y);
				this.graphics.lineTo(this.$textField.x - 5, this.$textField.y + this.$textField.height);
				this.graphics.curveTo(this.$textField.x - 5, this.$textField.y + this.$textField.height + 5, this.$textField.x, this.$textField.y + this.$textField.height + 5);
				
				
				this.graphics.lineTo($pointclone.x - 3, $pointclone.y - 4);
				this.graphics.lineTo($pointclone.x , $pointclone.y);
				this.graphics.lineTo($pointclone.x + 3, $pointclone.y - 4 );
				
				this.graphics.lineTo(this.$textField.x + this.$textField.width, this.$textField.y + this.$textField.height + 5);
				this.graphics.curveTo(this.$textField.x + this.$textField.width + 5, this.$textField.y + this.$textField.height + 5, this.$textField.x + this.$textField.width + 5, this.$textField.y + this.$textField.height);
				this.graphics.lineTo(this.$textField.x + this.$textField.width + 5, this.$textField.y );
				this.graphics.curveTo(this.$textField.x + this.$textField.width + 5, this.$textField.y -5, this.$textField.x + this.$textField.width , this.$textField.y -5);
		//		this.graphics.lineTo(this.$textField.x,this.$textField.y-5 );
		}
		
		
		//==========================================================
		// #######  设置/获取 属性
		//==========================================================
		
		/**
		 * 获取 本实例
		 */
		public static function get instance():BubbleTip
		{
			return $instance;
		}
		
		/**
		 * 设置/获取 最大宽度  默认:Number.MAX_VALUE
		 */
		public static function get maxWidth():Number {
			testinit();
			return $instance.$maxWidth; 
		}
		
		public static function set maxWidth($value:Number):void 
		{
			testinit();
			$instance.$maxWidth = $value;
			$instance.reset();
		}
		
		/**
		 * 设置获取 最大高度  默认:Number.MAX_VALUE
		 */
		public static function get maxHeight():Number { 
			testinit();
			return $instance.$maxHeight;
			}
		
		public static function set maxHeight($value:Number):void 
		{
			testinit();
			$instance.$maxHeight = $value;
			$instance.reset();
		}
		
		/**
		 * 设置/获取  当有文本输入时是否自动显示
		 */
		public static function get autoshow():Boolean {
			testinit();
			return $instance.$autoshow;
			}
		
		public static function set autoshow($value:Boolean):void 
		{
			testinit();
			$instance.$autoshow = $value;
			$instance.reset();
		}
		
		/**
		 * 设置/获取 文本框的文本
		 */
		public static function get text():String { 
			testinit();
			return $instance.$textField.text ; 
		}
		public static function set text($value:String):void {
			testinit();
			$instance.$textField.text = $value ; 
			$instance.reset();
			if ($instance.$autoshow) show(); 
		}
		
		/**
		 * 设置/获取 文本框的htmlText文本
		 */
		public static function get htmlText():String { 
			testinit();
			return $instance.$textField.htmlText ; 
		}
		public static function set htmlText($value:String):void {
			testinit();
			$instance.$textField.htmlText = $value ; 
			$instance.reset();
			if ($instance.$autoshow) show();
		}
		
		/**
		 * 设置/获取 是否要有箭头
		 */
		public static function get arrow():Boolean { 
			testinit();
			return $instance.$arrow; 
		}
		
		public static function set arrow($value:Boolean):void 
		{
			testinit();
			$instance.$arrow = $value;
			$instance.reset();
		}
		
		/**
		 * 设置/获取 文本输入框
		 */
		public static function get textField():TextField {
			testinit();
			return $instance.$textField;
			}
		public static function set textField($value:TextField):void 
		{
			testinit();
			$instance.$textField =$value;
		}
		
		/********** [DINBOY] Say: Class The End  ************/	
	}

}