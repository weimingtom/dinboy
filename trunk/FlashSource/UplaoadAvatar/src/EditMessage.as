package  
{
	import fl.controls.Button;
	import fl.controls.Label;
	import fl.controls.TextInput;
	import flash.display.Sprite;
	import flash.text.TextFormat;
	

	/**
	 * @author		钉崽[Dinboy]
	 * @copy		2010 © dinboy.com
	 * @version		v1.0 [2011-3-10 14:51]
	 */
	public class EditMessage extends Sprite
	{
		/**
		 * 即将发送的对象
		 */
		private var _sendObject:Object;
		
		/**
		 * 用户输入框
		 */
		private var _deadInput:TextInput;
		
		/**
		 * 时间输入
		 */
		private var _timeInput:TextInput;
		
		/**
		 * 地址输入
		 */
		private var _addressInput:TextInput;
		
		/**
		 * 错误提示标签
		 */
		private var _errorTip:Label;
		
		/**
		 * 是否通过验证
		 */
		private var _passed:Boolean;
		
		
		public function EditMessage() 
		{
			setupUI();
		}
		
		/**
		 * 配置UI
		 */
		private function setupUI():void 
		{
				_deadInput = new TextInput();
				_deadInput.x = 60;
				_deadInput.y = 0;
				_deadInput.width = 180;
				
		var	_userLabel:Label = new Label();
				_userLabel.text = "逝者姓名:";
			
				_timeInput = new TextInput();
				_timeInput.x = 60;
				_timeInput.y = 30;
				_timeInput.width = 180;
				
		var 	_timrLabel:Label = new Label();	
				_timrLabel.text = "死亡时间:";
				_timrLabel.y = 30;
			
				_addressInput = new TextInput();
				_addressInput.x = 60;
				_addressInput.y = 60;
				_addressInput.width = 180;
				
		var	_addLabel:Label = new Label();
				_addLabel.text = "死亡地点:";
				_addLabel.y = 60;
				
		var  _errorTextFormat:TextFormat = new TextFormat();
				_errorTextFormat.color = 0xFF0000;
				
				_errorTip = new Label();
				_errorTip.x = 250;
				_errorTip.setStyle("textFormat", _errorTextFormat);
			
				addChild(_userLabel);
				addChild(_deadInput);
				addChild(_timrLabel);
				addChild(_timeInput);
				addChild(_addLabel);
				addChild(_addressInput);
		}
		
		
		/**
		 * 获取合并的信息
		 * @return
		 */
		private function merger():Object 
		{
			var 	_mergerObject:Object = new Object();
					_mergerObject.dead = _deadInput.text;
					_mergerObject.time = _timeInput.text;
					_mergerObject.address = _addressInput.text;
			return _mergerObject;
		}
		
		/**
		 * 检测输入是否通过
		 */
		public function testPast():void 
		{
			if (_deadInput.text == "") 
			{
				_errorTip.y = _deadInput.y;
				_errorTip.text = "未填写!";
				_passed = false;
				addChild(_errorTip);
				return;
			}
			if (_timeInput.text == "") 
			{
				_errorTip.y = _timeInput.y;
				_errorTip.text = "未填写!";
				_passed = false;
				addChild(_errorTip);
				return;
			}
			if (_addressInput.text == "") 
			{
				_errorTip.y = _addressInput.y;
				_errorTip.text = "未填写!";
				_passed = false;
				addChild(_errorTip);
				return;
			}
			if (contains(_errorTip))	removeChild(_errorTip);
			_passed = true;
			_sendObject=merger();
		}

		
		/**
		 * 即将发送的对象
		 */
		public function get sendObject():Object 
		{
			return _sendObject;
		}
		
		public function set sendObject(value:Object):void 
		{
			_sendObject = value;
		}
		
		/**
		 * 消息是否通过验证
		 */
		public function get passed():Boolean 
		{
			return _passed;
		}






	//============================================
	//===== Class[EditMessage] Has Finish ======
	//============================================
	}
}