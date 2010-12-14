package com.dinboy.controls 
{
	import flash.display.CapsStyle;
	import flash.display.DisplayObjectContainer;
	import flash.display.GradientType;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @data $_DATA
	 * @author Dinboy.com
	 */
	public class AlertTip extends Sprite
	{
		
		/**
		 * 获取本实例的静态实例对象
		 */
		private static var $instance:AlertTip = null;
		
		/**
		 * 存放本实例的显示容器
		 */
		private var $displayObjectContainer:DisplayObjectContainer;
		
		/**
		 * 背景渐变Matrix
		 */
		private var $matrix:Matrix;
		
		/**
		 * 渐变颜色数组
		 */
		private var $colorArray:Array;
		
		/**
		 * 透明度对应颜色数组
		 */
		private var $alphasArray:Array;
		
		/**
		 * 渐变范围
		 */
		private var $ratiosArray:Array;
		
		/**
		 * 显示提示窗口的文本框
		 */
		private var $textField:TextField;
		
		/**
		 * 是否已经显示
		 */
		private var $showed:Boolean;
		
		/**
		 * 延迟执行函数的ID
		 */
		private var $setTimeoutID:uint;
		
		/**
		 * 设置延迟隐藏时间 默认 2 秒
		 */
		private var $delay:Number = 3;
		
		/**
		 * 显示对象最大宽度
		 */
		private var $maxWidth:Number = Number.MAX_VALUE;
		
		/**
		 * 显示对象最大宽度的复制
		 */
		private var $maxWidthCopy:Number=Number.MAX_VALUE;
		
		/**
		 * 显示对象最大宽度
		 */
		private var $maxHeight:Number = Number.MAX_VALUE;
		
		/**
		 * 显示对象最大高度的复制
		 */
		private var $maxHeightCopy:Number = Number.MAX_VALUE;
		
		/**
		 * 当设置text或者htmlText的时候自动显示
		 */
		private var $autoShow:Boolean;
		
		/**
		 * 是否自动显示提示位置
		 */
		private var $autoSize:Boolean=true;
		
		/**
		 * 横坐标
		 */
		private var $x:Number;
		
		/**
		 * 纵坐标
		 */
		private var $y:Number;
		
		/**
		 * 是否使用背景
		 */
		private var $background:Boolean;
		
		/**
		 * 背景透明度
		 */
		private var $backgroundAlpha:Number=0.5;
		
		/**
		 * 背景颜色
		 */
		private var $backgroundColor:uint=0xFFFFFF;
		
		/**
		 * 容器宽度
		 */
		private var $ContainerWidth:Number;
		
		/**
		 * 容器高度
		 */
		private var $ContainerHeight:Number;
		
		/**
		 * 是否点击自动关闭
		 */
		private var $clickClose:Boolean;
		
		/**
		 * 是否自动关闭
		 */
		private var $autoClose:Boolean=true;
		
		/**
		 * 实例的最终舞台
		 */
		private var $Stage:DisplayObjectContainer;
		
		/**
		 * 舞台的对齐方式
		 */
		private var $align:String = StageAlign.TOP_LEFT;
		
		/**
		 * 舞台的缩放方式
		 */
		private var $scaleMode:String = StageScaleMode.NO_SCALE;
		
		/**
		 * 弹出提示窗口
		 * 
		 *				  使用方法: 先 AlertTip.init(显示对象容器);
		 * 			  然后使用参数 AlertTip.autoShow=false ;    默认为 false, 为true的话 添加text或者htmlText的时候自动显示
		 *				  然后使用参数 AlertTip.text="编写者dinboy [钉崽] 请不要随意复制+粘贴 , 如果非要复制+粘贴的话请 不要涂改本本子,违者 没收你们的作案工具!"
		 * 			  然后使用参数 AlertTip.htmlText="编写者<a href=\"http://www.dinboy.com\">dinboy [钉崽]</a> 请不要随意复制+粘贴 , 如果非要复制+粘贴的话请 不要涂改本本子,违者 没收你们的作案工具!"
		 * 			  然后使用参数 AlertTip.delay=3;								延迟消失 默认3秒消失;
		 * 			  然后使用参数 AlertTip.maxWidth=300;						最大宽度;
		 *				  然后使用参数 AlertTip.maxHeight=300;					最大高度;
		 *				  然后使用参数 AlertTip.show();									显示该提示;
		 *				  然后使用参数 AlertTip.setSize(200,200);					显示该提示的坐标,不会自动中间显示;
		 */
		
		public function AlertTip() 
		{
				this.$matrix = new Matrix();
				this.$textField = new TextField();
				this.$textField.autoSize = TextFieldAutoSize.LEFT;
				this.$textField.selectable = false;
				
				this.$colorArray = [0xFFFFFF, 0xEAEAEA];
				this.$alphasArray = [255, 255];
				this.$ratiosArray = [0, 0xFF];
				this.alpha = 0;
		}
		
		/**
		 * 初始化显示存放位置
		 * @param	$displayObjectContainer
		 */
		public static function  init($displayObjectContainer:DisplayObjectContainer):void 
		{
			if ($displayObjectContainer==null) throw new Error("DisplayObjectContainer is Null!");  
			if ($instance==null)
			{
				$instance = new AlertTip();
				$instance.initStage($displayObjectContainer);
			}else 
				throw new Error("AlertTip class is static container only!");  
		}
		
		/**
		 * 实例化舞台
		 * @param	evt
		 */
		private function  initStage($displayObjectContainer:DisplayObjectContainer):void 
		{
			if ($displayObjectContainer is Stage)
				this.$Stage = $displayObjectContainer;
			else 
				this.$Stage = $displayObjectContainer.stage;
			if (this.$Stage) this.stageEventListener();
				else $displayObjectContainer.addEventListener(Event.ADDED_TO_STAGE, this.stageEventListener,false,0,true);
		}
		
		/**
		 * 初始化stage
		 * @param	evt
		 */
		private function  stageEventListener(evt:Event=null):void 
		{
			if (evt) {
				evt.currentTarget.removeEventListener(Event.ADDED_TO_STAGE, this.stageEventListener);
				this.$Stage = evt.currentTarget.stage;
			}
				this.$displayObjectContainer = this.$Stage;
				Stage(this.$displayObjectContainer).align =this.$align;
				Stage(this.$displayObjectContainer).scaleMode = this.$scaleMode;
		}
		
		/**
		 * 获取 显示对象的文本
		 */
		public static function get textField():TextField {
			testAlertTipInit.testInit();
			return $instance.$textField;
		}
		
		/**
		 * 设置显示文本
		 */
		public static function  set text($value:String):void 
		{
			testAlertTipInit.testInit();
			$instance.$textField.text = $value;
			$instance.reset();
			if ($instance.$autoShow) 
			               AlertTip.show();
		}
		
		/**
		 * 设置 显示HTML格式文本
		 */
		public static function  set htmlText($value:String):void 
		{
			testAlertTipInit.testInit();
			$instance.$textField.htmlText = $value;
			$instance.reset();
			if ($instance.$autoShow) 
						  AlertTip.show();
		}
		
		/**
		 * 设置/获取 延迟时间
		 */
		public static function get delay():Number {
			testAlertTipInit.testInit();
			return $instance.$delay; 
		}
		
		public static function set delay($value:Number):void 
		{
			testAlertTipInit.testInit();
			$instance.$delay = $value;
		}
		
		/**
		 * 设置/获取 显示对象最大宽度
		 */
		public static function get maxWidth():Number {
			testAlertTipInit.testInit(); 
			return $instance.$maxWidth;
		}
		public static function set maxWidth($value:Number):void 
		{
			testAlertTipInit.testInit();
			$instance.$maxWidth = $value;
			$instance.reset();
		}
		
		/**
		 * 设置/获取 显示对象最大高度
		 */
		public static function get maxHeight():Number { 
			testAlertTipInit.testInit();
			return $instance.$maxHeight; 
			}
		public static function set maxHeight($value:Number):void 
		{
			testAlertTipInit.testInit();
			$instance.$maxHeight = $value;
			$instance.reset();
		}
		
		/**
		 * 设置摆放位置
		 * @param	$x				横坐标
		 * @param	$y				纵坐标
		 */
		public static function setSize($x:Number=0,$y:Number=0):void 
		{
			testAlertTipInit.testInit();
			$instance.$autoSize = false;
			$instance.$x = $x;
			$instance.$y = $y;
			$instance.reset();
		}
		
		/**
		 * 重新设置本实例
		 */
		private function reset():void 
		{
			/*
			//this.alpha = 0;
		if ($instance.$displayObjectContainer is Stage) 	{
					$instance.$isStage = true;
					$instance.$ContainerWidth = Stage($instance.$displayObjectContainer).stageWidth;
					$instance.$ContainerHeight = Stage($instance.$displayObjectContainer).stageHeight;
				}
			else 
				{
					$instance.$ContainerWidth = $instance.$displayObjectContainer.width;
					$instance.$ContainerHeight = $instance.$displayObjectContainer.height;
				}	
			*/	
			this.$ContainerWidth = Stage(this.$displayObjectContainer).stageWidth;
			this.$ContainerHeight = Stage(this.$displayObjectContainer).stageHeight;
			
			this.graphics.clear();
			this.$textField.wordWrap = false;
			this.$textField.multiline = false;
			
			//=============================================
			//	开始做判断 宽度高度
			//=============================================
			
			//如果 最大值(宽) 大于 [舞台宽度],则把 [舞台宽度] 赋值给 最大值(宽[拷贝])
			if (this.$maxWidth > this.$ContainerWidth)  {
					this.$maxWidthCopy = this.$ContainerWidth;
			}
			//如果 [舞台宽度] 大于 最大值(宽[拷贝]),则把 [舞台宽度] 赋值给  最大值(宽[拷贝])
			 if(this.$ContainerWidth>this.$maxWidthCopy)
			{
				this.$maxWidthCopy=this.$ContainerWidth;
			}
			//如果 最大值(高) 大于 [舞台高度],则把 [舞台高度] 赋值给 最大值(高[拷贝])
			if (this.$maxHeight > this.$ContainerHeight) {
					this.$maxHeightCopy = this.$ContainerHeight;
			}
			//如果 [舞台高度] 大于 最大值(高[拷贝]), 则把 [舞台高度] 赋值给  最大值(高[拷贝])
			if(this.$ContainerHeight>this.$maxHeightCopy)
			{
				this.$maxHeightCopy =this.$ContainerHeight;
			}
			
			//如果 文本宽度  大于 最大值(宽[拷贝])减10像素 则 把文本设置为多行 ,并把文本的宽 设置成 最大值(宽[拷贝])减10像素
			if (this.$textField.width > this.$maxWidthCopy-10)
			{
						this.$textField.wordWrap = true;
						this.$textField.width = this.$maxWidthCopy - 10;
			}
			
			//如果 文本宽度  大于 最大值(宽[拷贝])减20像素 则 把文本设置为多行 ,并把文本的宽 设置成 最大值(宽[拷贝])减20像素
			if (this.$textField.height > this.$maxHeightCopy - 20) this.$textField.height = this.$maxHeightCopy - 20;
					
			//如果 需要背景 则绘制背景
			if (this.$background)
			{
				this.graphics.beginFill(this.$backgroundColor,this.$backgroundAlpha);
				this.graphics.drawRect(0, 0, this.$ContainerWidth, this.$ContainerHeight);
				this.graphics.endFill();
			}
			
			//如果 是自动排列位置 则,对话框居中, 否则 按所给的坐标进行填充渐变
			if (this.$autoSize) this.$matrix.createGradientBox(this.$textField.width + 10, this.$textField.height + 20, Math.PI / 2,this.$ContainerWidth-(this.$textField.width + 10)>>1,this.$ContainerHeight-(this.$textField.height + 20)>>1);
			else this.$matrix.createGradientBox(this.$textField.width + 10, this.$textField.height + 20, Math.PI / 2,this.$x,this.$y);
			
			this.graphics.beginGradientFill(GradientType.LINEAR, this.$colorArray, this.$alphasArray, this.$ratiosArray, this.$matrix);
			this.graphics.lineStyle(1, 0xDDDDDD, .8, true, LineScaleMode.NONE, CapsStyle.ROUND, JointStyle.ROUND);
			
			//如果 是自动排列位置 则,对话框居中, 否则 按所给的坐标排列
			if (this.$autoSize) 	this.graphics.drawRoundRect(this.$ContainerWidth-(this.$textField.width + 10)>>1, this.$ContainerHeight-(this.$textField.height + 20)>>1, this.$textField.width + 10, this.$textField.height + 20,10,10);
			else this.graphics.drawRoundRect(this.$x, this.$y, this.$textField.width + 10, this.$textField.height + 20,10,10);
			this.graphics.endFill();
			
			//如果本实例未含有文本框,则添加文本框
			if (!this.contains(this.$textField)) 
				  this.addChild(this.$textField);
			
			//是否是自动摆放文本位置,否则根据坐标摆放
			if (this.$autoSize)
			{
				this.$textField.x = this.$ContainerWidth - this.$textField.width >> 1;
				this.$textField.y = this.$ContainerHeight - this.$textField.height >> 1;
			}else 
			{
				this.$textField.x = this.$x + 5;
				this.$textField.y = this.$y + 10;
			}
			
		}
		
		/**
		 * 显示本实例
		 */
		public static function show():void 
		{
			testAlertTipInit.testInit();
			$instance.reset();
			clearTimeout($instance.$setTimeoutID);
			$instance.$showed = false;
			if ($instance.$displayObjectContainer.contains($instance))
				$instance.$displayObjectContainer.setChildIndex($instance, $instance.$displayObjectContainer.numChildren - 1);
			else $instance.$displayObjectContainer.addChild($instance);
			
			// 如果实例是自动关闭,则运行延迟关闭函数
			$instance.setTimeoutFun();
			
			//	  当窗口重新拉伸时重新排列
			if (!Stage($instance.$displayObjectContainer).hasEventListener(Event.RESIZE)) Stage($instance.$displayObjectContainer).addEventListener(Event.RESIZE, $instance.onResize, false, 0, true);
			
		}
		
		/**
		 * 当舞台有尺寸变化时
		 * @param	evt
		 */
		private function onResize(evt:Event):void 
		{
			this.reset();
		}
		
		/**
		 * 当鼠标点击我时,我自动关闭
		 * @param	evt
		 */
		private function  onClick(evt:MouseEvent):void 
		{
			this.$showed = true;
			this.removeEventListener(MouseEvent.CLICK, this.onClick);
			this.setTimeoutFun();
		}
		
		
		/**
		 * 延迟显示
		 */
		private function setTimeoutFun():void 
		{
			clearTimeout(this.$setTimeoutID);
			this.addEventListener(Event.ENTER_FRAME, this.enterFrame, false, 0, true);
		}
		
		/**
		 * 实时监听
		 */
		private function  enterFrame(evt:Event):void
		{
				if (this.$showed)
				{
					this.alpha -= 0.1;
						if (this.alpha <= 0.1)
						{
							this.alpha = 0;
							this.removeEventListener(Event.ENTER_FRAME, this.enterFrame);
							this.$displayObjectContainer.removeChild(this);
							this.$showed = false;
							Stage(this.$displayObjectContainer).removeEventListener(Event.RESIZE, this.onResize);
						}
				}else 
				{
					this.alpha += 0.1;
					if (this.alpha>=0.9)
					{
						this.alpha = 1;
						this.$showed = true;
						this.removeEventListener(Event.ENTER_FRAME, this.enterFrame);
						if(this.$clickClose)	this.addEventListener(MouseEvent.CLICK, this.onClick, false, 0, true);
						if (this.$autoClose) 	this.$setTimeoutID = setTimeout($instance.setTimeoutFun,$instance.$delay * 1000);
					}
				}
		}
		
		/**
		 * 返回本实例的实例对象
		 */
		public static function get instance():AlertTip 
		{
				return $instance;
		}
		
		/**
		 * 设置/获取 当设置text或者htmlText的时候自动显示
		 */
		public static function get autoShow():Boolean {
			testAlertTipInit.testInit();
			return $instance.$autoShow;
		}
		public static function set autoShow($value:Boolean):void 
		{
			testAlertTipInit.testInit();
			$instance.$autoShow = $value;
		}
		
		/**
		 * 设置 是否设置背景
		 */
		public static function set  background($value:Boolean):void 
		{
			testAlertTipInit.testInit(); 
			$instance.$background = $value;
		}
		
		/**
		 * 设置 背景透明度
		 */
		public static function set backgroundAlpha($value:Number):void 
		{
			testAlertTipInit.testInit(); 
			$instance.$backgroundAlpha = $value;
		}
		
		/**
		 * 设置 背景颜色值
		 */
		public static function set backgroundColor($value:uint):void 
		{
			testAlertTipInit.testInit(); 
			$instance.$backgroundColor = $value;
		}
		
		/**
		 * 设置/获取 是否点击自动关闭
		 */
		public static function get clickClose():Boolean {
			testAlertTipInit.testInit(); 
			return $instance.$clickClose; 
			}
		
		public static function set clickClose($value:Boolean):void 
		{
			testAlertTipInit.testInit(); 
			$instance.$clickClose = $value;
		}
		
		
		/**
		 * 设置/获取 舞台的对齐方式 默认为 StageAlign.TOP_LEFT
		 */
		public static function get align():String {
			testAlertTipInit.testInit(); 
			return $instance.$align; 
		}
		public static function set align($value:String):void 
		{
			testAlertTipInit.testInit(); 
			$instance.$align = $value;
		}
		
		/**
		 * 设置/获取 舞台的缩放方式 默认: StageScaleMode.NO_SCALE
		 */
		public static function get scaleMode():String {
			testAlertTipInit.testInit(); 
			return $instance.$scaleMode; 
		}
		public static function set scaleMode($value:String):void 
		{
			testAlertTipInit.testInit(); 
			$instance.$scaleMode = $value;
		}
		
		/**
		 * 设置/获取 是否自动关闭  默认: true
		 */
		public static function get autoClose():Boolean { 
			testAlertTipInit.testInit(); 
			return $instance.$autoClose; 
		}
		
		public static function set autoClose($value:Boolean):void 
		{
			testAlertTipInit.testInit(); 
			$instance.$autoClose = $value;
		}
		
		/********** [DINBOY] Say: Class The End  ************/	
	}
}


/**
 * 测试是否为空 (包外类 CS3 版本,如果是CS4就直接将这个新建一个新的类文件);
 */
import com.dinboy.controls.AlertTip;
class testAlertTipInit {
	public static function testInit():void 
	{
		if (AlertTip.instance==null) 
		{
			throw new Error("You have not yet initialized me -> AlertTip , Please use it by AlertTip.init(DisplayObjectcontainer)!");
			return;
		}
	}
	
	/********** [DINBOY] Say: Class The End  ************/	
	
}