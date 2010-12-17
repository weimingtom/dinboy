package  
{
	import fl.controls.Button;
	import fl.controls.ComboBox;
	import fl.controls.TextArea;
	import fl.controls.TextInput;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.XMLSocket;
	import flash.text.TextField;
	

	/**
	 * @author		钉崽[Dinboy]
	 * @copy		2010 © Dinboy.com
	 * @version		v1.0 [2010-12-17 16:39]
	 */
	public class XMLSocketExample extends Sprite
	{
		/**
		 * 发送按钮
		 */
		private var _sendButton:Button;
		
		/**
		 * 连接服务器按钮
		 */
		private var _connectButton:Button;
		
		/**
		 * 连接方式列表
		 */
		private var _conneterCombobox:ComboBox;
		
		/**
		 * 发送消息输入框
		 */
		private var _sendInput:TextInput;
		
		/**
		 * 详细信息文本框
		 */
		private var _detailTextArea:TextArea;
		
		/**
		 * xmlScket对象
		 */
		private var xmlSocket:XMLSocket;
		
		/**
		 * 连接对象IP地址
		 */
		private const HOST:String = "127.0.0.1";
		
		/**
		 * 端口
		 */
		private const PORT:Number = 8858;
		public function XMLSocketExample()
		{
			_sendButton = new Button();
			_sendButton.label = "发送";
			_sendButton.width = 60;
			_sendButton.x = 5;
			_sendButton.y = 3;
			_sendButton.enabled = false;
			addChild(_sendButton);
			_sendButton.addEventListener(MouseEvent.CLICK, sendButtonClickHandler, false, 0, true);
			
			_connectButton = new Button();
			_connectButton.label = "连接";
			_connectButton.width = 60;
			_connectButton.x = 70;
			_connectButton.y = 3;
			addChild(_connectButton);
			_connectButton.addEventListener(MouseEvent.CLICK, connectButtonClickHandler, false, 0, true);
			
			_sendInput = new TextInput();
			_sendInput.x = 135;
			_sendInput.y = 3;
			_sendInput.enabled = false;
			addChild(_sendInput);
			
			_detailTextArea = new TextArea();
			//_detailTextArea.editable = false;
			_detailTextArea.y = 30;
			addChild(_detailTextArea);
			
			stage.align = "TL";
			stage.scaleMode = "noScale";
			stage.addEventListener(Event.RESIZE, resizeHandler, false, 0, true);
			stage.dispatchEvent(new Event(Event.RESIZE));
			
			xmlSocket = new XMLSocket();
			configSocket(xmlSocket);
		}
		
		/**
		 * 配置对象监听
		 * @param	dispatcher
		 */
		private function configSocket(dispatcher:IEventDispatcher):void 
		{
			dispatcher.addEventListener(Event.CONNECT, xmlSocketConnectHandler, false, 0, true);
			dispatcher.addEventListener(DataEvent.DATA, xmlSocketDataHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, xmlSocketIOErrorHandler, false, 0, true);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, xmlSocketSecurityErrorHandler, false, 0, true);
			dispatcher.addEventListener(Event.CLOSE, xmlSocketCloseHandler, false, 0, true);
		}
	
	//============================================
	//===== EventListener Methods ======
	//============================================
		/**
		 * 点击发送时调度
		 * @param	event
		 */
		private function sendButtonClickHandler(event:MouseEvent):void 
		{
				xmlSocket.send(_sendInput.text);
				_detailTextArea.text += "[本机]->:" + _sendInput.text;
		}
		
		/**
		 * 点击链接按钮是调度
		 * @param	event
		 */
		private function connectButtonClickHandler(event:MouseEvent):void 
		{
			if (!xmlSocket.connected) xmlSocket.connect(HOST, PORT);
			else _detailTextArea.text += "您已经连接到服务器,不能再次连接\r";
		}
		
		/**
		 * 与服务器断开连接时调度
		 * @param	event
		 */
		private function xmlSocketCloseHandler(event:Event):void 
		{
			_detailTextArea.text += "与服务器断开连接\r";
			_sendInput.enabled = false;
			_sendButton.enabled = false;
		}
		
		/**
		 * 在发送或接收原始数据后调度
		 * @param	event
		 */
		private function xmlSocketDataHandler(event:DataEvent):void 
		{
			_detailTextArea.text += "[服务器]->:"+event.data+"\r";
		}

		/**
		 * 当遇到安全沙箱问题时调度
		 * @param	event
		 */
		private function xmlSocketSecurityErrorHandler(event:SecurityErrorEvent):void 
		{
			_detailTextArea.text += "连接服务器失败,安全沙箱错误\r";
		}
		
		/**
		 * 链接找不到时调度
		 * @param	event
		 */
		private function xmlSocketIOErrorHandler(event:IOErrorEvent):void 
		{
			_detailTextArea.text += "连接服务器失败,找不到服务器\r";
		}
		
		/**
		 * 当socket连接时调度
		 * @param	event
		 */
		private function xmlSocketConnectHandler(event:Event):void 
		{
			_sendInput.enabled = true;
			_detailTextArea.text = "连接到服务器 :" + HOST + ",端口:" + PORT + "\r";
			_sendButton.enabled = true;
		}
		
		/**
		 * 缩放时调度
		 * @param	event
		 */
		private function resizeHandler(event:Event):void 
		{
			_sendInput.width = stage.stageWidth - 140;
			_detailTextArea.x = 5;
			_detailTextArea.width = stage.stageWidth-10;
			_detailTextArea.height = stage.stageHeight-35;
		}






	//============================================
	//===== Class[XMLSocketExample] Has Finish ======
	//============================================
	}

}