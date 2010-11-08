package com.dinboy.controls.livePreview
{
	import flash.display.DisplayObject;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import fl.core.UIComponent
	import fl.managers.IFocusManagerComponent
	import fl.core.InvalidationType;

	[Style(name = "background", type = "Class")]
	
	[Style(name = "progressBar", type = "Class")]
	
	[Style(name = "underProgressBar", type = "Class")]
	
	[Style(name = "progressTextFormat", type = "flash.text.TextFormat")]
	
	[Style(name = "annotateTextFormat", type = "flash.text.TextFormat")]
	
	[Style(name = "defaultTextFormat", type = "flash.text.TextFormat")]
	

	/**
	 * @author		钉崽[dinboy]
	 * @copy		dinboy © 2010
	 * @version		v1.0 [2010-11-3 15:03]
	 */
	public class Loading_LivePreview extends UIComponent 
	{		
		[Embed(source="../../../../lib/04B_08__.TTF", fontName="FONT04B_08", unicodeRange="U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E",mimeType = "application/x-font")]
		public static var FONT04B_08:Class; 
		
		/**
		 * 用户文本
		 */
		private var annotateTextField:TextField;
		
		/**
		 * 百分比
		 */
		private var percentTextField:TextField;
		
		/**
		 * 滚动条
		 */
		private var progressBar:DisplayObject;
		
		/**
		 * 不可使用的滚动条
		 */
		private var underProgressBar:DisplayObject;
		
		/**
		 * 背景
		 */
		private var background:DisplayObject;
		
		/**
		 * 原始宽度
		 */
		private var _progressBarWidth:Number;
		
		/**
		 * 百分一宽度
		 */
		private var _percentageWidth:Number;
		
		/**
		 * 百分比
		 */
		private var _percent:Number=0;
		
		/**
		 * 注释
		 */
		private var _annotate:String="Loading By <a href=\"http://www.dinboy.com\">dinboy</a>";
		
		public function Loading_LivePreview() 
		{
			super();
			height = 50;
	//		initUI();
		}

		/**
		 * 默认的类样式 因为是static的,所以不会与父类的样式冲突
		 */
		private static var defaultStyles:Object = {
										background:"loading_Background",
										progressBar:"loading_Progress",
										underProgressBar:"loading_underProgress",
										progressTextFormat:null,
										annotateTextFormat:null,
										defaultProgressTextFormat:new TextFormat("FONT04B_08", 8, 0xFFFFFF),
										defaultAnnotateTextFormat:new TextFormat("FONT04B_08", 8, 0x333333)
		}
		
		/**
		 *	[重写 override ] 配置UI
		 */
		override protected function configUI():void {
			
			
			 annotateTextField = new TextField();
			 annotateTextField.selectable = false;
		//annotateTextField.antiAliasType = AntiAliasType.ADVANCED;
			annotateTextField.autoSize = TextFieldAutoSize.LEFT;
			 
			 
			 percentTextField = new TextField();
			 percentTextField.selectable = false;
		//percentTextField.antiAliasType = AntiAliasType.ADVANCED;
			percentTextField.autoSize = TextFieldAutoSize.LEFT;
			
			 
			background = getDisplayObjectInstance(getStyleValue("background"));
			underProgressBar =	getDisplayObjectInstance(getStyleValue("underProgressBar"));
			progressBar = getDisplayObjectInstance(getStyleValue("progressBar"));
			

			
			//progressBar.width = 0;
			
			addChild(background);
			 addChild(underProgressBar);
			 addChild(progressBar);
			 addChild(annotateTextField);
			 addChild(percentTextField);
			 
			 super.configUI();
			}
		
		/**
		 *	[重写 override ] 绘制
		 */
		override protected function draw():void {
			if (isInvalid(InvalidationType.STATE)) {
					drawState();
				}
				
			if (isInvalid(InvalidationType.STYLES,InvalidationType.STATE)) {
				//绘制背景
				drawStyles();
			}				
			
			 //数据改变时
			//if (isInvalid(InvalidationType.DATA) )
			//{
				//drawContent();
			//}		
			
			if (isInvalid(InvalidationType.SIZE,InvalidationType.DATA)) {
				//重新排列
				drawLayout();
			}				
			
			super.draw();
			}
			
		/**
		 * 绘制状态
		 */
		protected function drawState():void {
			percentTextField.text = "100	%";
			annotateTextField.htmlText = "Loading By <a href=\"http://www.dinboy.com\">dinboy</a>";
		}			
		
		
		/**
		 * 绘制UI显示对象
		 */
		protected function  drawStyles():void 
		{
			//background = getDisplayObjectInstance(getStyleValue("background"));
			//underProgressBar =	getDisplayObjectInstance(getStyleValue("underProgressBar"));
			//progressBar = getDisplayObjectInstance(getStyleValue("progressBar"));
			//

			//annotateTextField.setTextFormat(_annotateTextFormat);
			 //percentTextField.setTextFormat( _progressTextFormat);
			 
 			var  uiStyles:Object = Loading_LivePreview.getStyleDefinition() ;
			var defaultATF:TextFormat = uiStyles.defaultAnnotateTextFormat as TextFormat;
			var defaultPTF:TextFormat = uiStyles.defaultProgressTextFormat as TextFormat;
			 annotateTextField.setTextFormat(defaultATF); 
			 percentTextField.setTextFormat(defaultPTF); 
			
			var aTF:TextFormat= getStyleValue("annotateTextFormat")  as TextFormat;
			var pTF:TextFormat= getStyleValue("progressTextFormat") as TextFormat;

			if (aTF != null) { annotateTextField.setTextFormat(aTF);	}
			else {aTF = defaultATF;	}
			if (pTF != null) {	percentTextField.setTextFormat(pTF); }
			else {pTF=defaultPTF; }
			
			annotateTextField.defaultTextFormat = aTF;
			percentTextField.defaultTextFormat = pTF;
		}

		///**
		 //* 绘制内容
		 //*/
		//protected function drawContent():void 
		//{
			//percentTextField.text = _percent + "%";
			//annotateTextField.htmlText = _annotate;
		//}
		
		/**
		 * 重新排列位置
		 */
		protected function drawLayout():void 
		{
			height = 50;
			scaleY = 1;
			
			background.width = width;
			background.height = 50;
			progressBar.x = underProgressBar.x = 20;
			progressBar.y = underProgressBar.y = 10;
			progressBar.height = underProgressBar.height = 10;
			
            _progressBarWidth=underProgressBar.width = width - 40;
			_percentageWidth = _progressBarWidth / 100;
			progressBar.width = _percent * _percentageWidth;
			
			percentTextField.text = _percent + "%";
			annotateTextField.htmlText = _annotate;
			
			 annotateTextField.x = width-annotateTextField.width>>1;
			 annotateTextField.y = 36;
			 percentTextField.x = width-percentTextField.width>>1;
			 percentTextField.y = 22;
			 
			 
		}
		
	//============================================
	//===== Public static function ======
	//============================================
		public static function getStyleDefinition():Object {
			//利用mergeStyles()把两个类的样式合并
			return mergeStyles(defaultStyles, UIComponent.getStyleDefinition());
		}
		
		[Inspectable(name="percent",defaultValue="0",type="Number",format="Length")]
		/**
		 * 百分比
		 */
		public function set percent(value:Number):void 
		{
			_percent = value > 100?100:value;
		}
		//public function get percent():Number 
		//{
			//return _percent;
		//}
		
		[Inspectable(type="String",name="annotate", defaultValue="Loading By <a href=\"http://www.dinboy.com\">dinboy</a>")]
		/**
		 * 设置注释
		 */
		public function set annotate(value:String):void 
		{
			_annotate = value;
		}

		





	//============================================
	//===== Class[loading] Has Finish ======
	//============================================
	}

}