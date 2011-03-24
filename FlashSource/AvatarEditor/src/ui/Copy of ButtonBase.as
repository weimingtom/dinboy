package ui 
{
	import adobe.utils.CustomActions;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	

	/**
	 * @author		钉崽[Dinboy]
	 * @copy		2010 © dinboy.com
	 * @version		v1.0 [2011-3-5 10:21]
	 */
	public class ButtonBase extends Sprite implements IFocusComponent
	{
		/**
		 * 按钮的文本字符串
		 */
		private var	 _label:String = "";
		
		/**
		 * 按钮的文本框
		 */
		private var _textField:TextField;
		
		/**
		 * 按钮是否可用
		 */
		private var _enabled:Boolean;
		
		/**
		 * 鼠标的状态
		 */
		private var _mouseStatus:String = "mouseUp";
		
		/**
		 * 背景
		 */
		private var background:DisplayObject;
		
		/**
		 * 默认样式对象
		 */
		protected static var _defaultStyleObject:Object = { default_Skin:Button_Style_Default, down_Skin:Button_Style_Down, over_Skin:Button_Style_Over };
		
		public function ButtonBase()
		{
			setupUI();
		}
		
	//============================================
	//===== protected function ======
	//============================================
		/**
		 * 配置UI
		 */
		protected  function setupUI():void 
		{
			var _defaultSkin:Object = _defaultStyleObject["default_Skin"];
			background = new _defaultSkin() as DisplayObject;
			addChild(background);
			
			_textField = new TextField();
			addChild(_textField);
		}
	
		/**
		 * 配置鼠标事件
		 */
		protected function setupMouseEvent():void 
		{
			addEventListener(MouseEvent.MOUSE_DOWN, mouseEventHandler, false, 0, true);
			addEventListener(MouseEvent.MOUSE_UP, mouseEventHandler, false, 0, true);
			addEventListener(MouseEvent.ROLL_OVER, mouseEventHandler, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, mouseEventHandler, false, 0, true);
		}
		
		/**
		 * 当鼠标出发事件时调度
		 * @param	event
		 */
		protected function mouseEventHandler(event:MouseEvent):void
		{
			switch (event.type) 
			{
				case MouseEvent.MOUSE_DOWN:
					
				break;
				case MouseEvent.MOUSE_UP:
					
				break;
				case MouseEvent.ROLL_OVER:
					
				break;
				case  MouseEvent.ROLL_OUT:
					
				break;
				default:
					
				break;
			}
		}
		
		/**
		 * 设置鼠标状态
		 * @param	state
		 */
		protected function setMouseState(state:String):void 
		{
			
		}
		
		/**
		 * 设置样式
		 * @param	styleName
		 * @param	value
		 */
		public function setStyle(styleName:String,value:Object):void 
		{
			
		}
	//============================================
	//===== Getter && Setter ======
	//============================================
	
		/**
		 * 设置文本
		 */
		public function get label():String 
		{
			return _label;
		}
		public function set label(value:String):void 
		{
			_label = value;
			_textField.text = _label;
		}
		
		
		/**
		 * 按钮是否禁用
		 */
		public function get enabled():Boolean 
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void 
		{
			_enabled = value;
			if (_enabled)
			{
				mouseEnabled = true;
				mouseChildren = true;
			}else 
			{
				mouseEnabled = false;
				mouseChildren = false;
			}
		}
		



		


	//============================================
	//===== Class[ButtonBase] Has Finish ======
	//============================================
	}
}