package  
{
	import fl.controls.Button;
	import fl.controls.ComboBox;
	import fl.controls.TextArea;
	import fl.controls.TextInput;
	import fl.events.DataChangeEvent;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.net.XMLSocket;
	import flash.system.System;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	

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
		 * Socket对象
		 */
		private var _socket:Socket;
		
		/**
		 * 连接对象IP地址
		 */
		private const HOST:String = "127.0.0.1";
		
		/**
		 * 端口
		 */
		private const PORT:Number = 8858;
		
		/**
		 * 链接属性
		 */
		private var _connetID:int;
		public function XMLSocketExample()
		{
			System.useCodePage = true;
			_connetID = 0;
			
			_conneterCombobox = new ComboBox();
			_conneterCombobox.addItem( { label:"XMLSocket", data:0 } );
			_conneterCombobox.addItem( { label:"Socket", data:1 } );
			_conneterCombobox.selectedIndex = 0;
			_conneterCombobox.y = 3;
			addChild(_conneterCombobox );
			_conneterCombobox.addEventListener(Event.CHANGE, changeHandler, false, 0, true);
			
			
			_sendButton = new Button();
			_sendButton.label = "发送";
			_sendButton.width = 60;
			_sendButton.x = 105;
			_sendButton.y = 3;
			_sendButton.enabled = false;
			addChild(_sendButton);
			_sendButton.addEventListener(MouseEvent.CLICK, sendButtonClickHandler, false, 0, true);
			
			_connectButton = new Button();
			_connectButton.label = "连接";
			_connectButton.width = 60;
			_connectButton.x = 170;
			_connectButton.y = 3;
			addChild(_connectButton);
			_connectButton.addEventListener(MouseEvent.CLICK, connectButtonClickHandler, false, 0, true);
			
			_sendInput = new TextInput();
			_sendInput.x = 235;
			_sendInput.y = 3;
			_sendInput.enabled = false;
			addChild(_sendInput);
			
			_detailTextArea = new TextArea();
			//_detailTextArea.editable = false;
			_detailTextArea.y = 30;
			addChild(_detailTextArea);
			_detailTextArea.addEventListener(Event.ENTER_FRAME, detailEnterFrameHandler,false, 0, true);
			
			stage.align = "TL";
			stage.scaleMode = "noScale";
			stage.addEventListener(Event.RESIZE, resizeHandler, false, 0, true);
			stage.dispatchEvent(new Event(Event.RESIZE));
			
			xmlSocket = new XMLSocket();
			_socket = new Socket();
			configSocket(_socket);
			configXMLSocket(xmlSocket);
		}
		
		/**
		 * 配置对象监听
		 * @param	dispatcher
		 */
		private function configSocket(dispatcher:IEventDispatcher):void 
		{
			dispatcher.addEventListener(Event.CONNECT, connectHandler, false, 0, true);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler, false, 0, true);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true);
			dispatcher.addEventListener(Event.CLOSE, closeHandler, false, 0, true);
			dispatcher.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler, false, 0, true);
		}
		
		/**
		 * 配置对象监听
		 * @param	dispatcher
		 */
		private function configXMLSocket(dispatcher:IEventDispatcher):void 
		{
			dispatcher.addEventListener(Event.CONNECT, connectHandler, false, 0, true);
			dispatcher.addEventListener(DataEvent.DATA, xmlSocketDataHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler, false, 0, true);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true);
			dispatcher.addEventListener(Event.CLOSE, closeHandler, false, 0, true);
		}
	
	//============================================
	//===== EventListener Methods ======
	//============================================
		/**
		 * 当下拉框数据改变时调度
		 * @param	event
		 */
		private function changeHandler(event:Event):void 
		{
			if (xmlSocket.connected) {
				xmlSocket.close();
				xmlSocket.dispatchEvent(new Event(Event.CLOSE));
			}
			if (_socket.connected) {
				_socket.close();
				_socket.dispatchEvent(new Event(Event.CLOSE));
			}
			_connetID = _conneterCombobox.selectedItem.data;
		}
		
		/**
		 * 点击发送时调度
		 * @param	event
		 */
		private function sendButtonClickHandler(event:MouseEvent):void 
		{
			if (_sendInput.text=="") 
			{
				_detailTextArea.text += "[系统提示]->:不能发送空字符\r";
				return;
			}
			switch (_connetID) 
			{
				case 0:
					xmlSocket.send(_sendInput.text);
				break;
				case 1:
					var _byteArray:ByteArray = new ByteArray();
							_byteArray.writeMultiByte(_sendInput.text, "utf8");
							_socket.writeBytes(_byteArray);
							_socket.flush();
							_byteArray = null;
				break;
				default:
					
				break;
			}
				_detailTextArea.text += "[本机]->:" + _sendInput.text + "\r";
				_sendInput.text = "";
		}
		
		/**
		 * 点击链接按钮是调度
		 * @param	event
		 */
		private function connectButtonClickHandler(event:MouseEvent):void 
		{
			switch (_connetID) 
			{
				case 0:
						if (!xmlSocket.connected) xmlSocket.connect(HOST, PORT);
						else _detailTextArea.text += "您已经连接到服务器,不能再次连接\r";
				break ;
				case 1:
						if (!_socket.connected) _socket.connect(HOST, PORT);
						else _detailTextArea.text += "您已经连接到服务器,不能再次连接\r";
				break;
				default:
					
				break;
			}
		}
		
		/**
		 * 当详细列表框有文本数据改变时调度
		 * @param	event
		 */
		private function detailEnterFrameHandler(event:Event):void 
		{
			_detailTextArea.verticalScrollPosition = _detailTextArea.maxVerticalScrollPosition;
		}
		
		/**
		 * 与服务器断开连接时调度
		 * @param	event
		 */
		private function closeHandler(event:Event):void 
		{
			_detailTextArea.text += "与服务器断开连接\r";
			_sendInput.enabled = false;
			_sendButton.enabled = false;
			_connectButton.enabled = true;
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
		 * 当Socket接收到数据时调度
		 * @param	event
		 */
		private function socketDataHandler(event:ProgressEvent):void 
		{
			var _n:uint = _socket.bytesAvailable;
			var _text:String = "";
			while (--_n>=0) 
			{
				_text += _socket.readMultiByte(_socket.bytesAvailable, "utf8");
			}
			_detailTextArea.text += "[服务器]->:" + _text + "\r";
			_text = null;
		}

		/**
		 * 当遇到安全沙箱问题时调度
		 * @param	event
		 */
		private function securityErrorHandler(event:SecurityErrorEvent):void 
		{
			_detailTextArea.text += "连接服务器失败,安全沙箱错误\r";
		}
		
		/**
		 * 链接找不到时调度
		 * @param	event
		 */
		private function IOErrorHandler(event:IOErrorEvent):void 
		{
			_detailTextArea.text += "连接服务器失败,找不到服务器\r";
		}
		
		/**
		 * 当socket连接时调度
		 * @param	event
		 */
		private function connectHandler(event:Event):void 
		{
			_sendInput.enabled = true;
			_detailTextArea.text = "以["+_conneterCombobox.selectedItem.label+"]方式链接到服务器 :" + HOST + ",端口:" + PORT + "\r";
			_sendButton.enabled = true;
			_connectButton.enabled = false;
		}
		
		/**
		 * 缩放时调度
		 * @param	event
		 */
		private function resizeHandler(event:Event):void 
		{
			_sendInput.width = stage.stageWidth - 40;
			_detailTextArea.x = 5;
			_detailTextArea.width = stage.stageWidth-10;
			_detailTextArea.height = stage.stageHeight-35;
		}






	//============================================
	//===== Class[XMLSocketExample] Has Finish ======
	//============================================
	}

}