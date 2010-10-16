package  
{
	import com.dinboy.client.clientInvockObj;
	import fl.controls.Button;
	import fl.controls.List;
	import fl.controls.TextArea;
	import fl.controls.TextInput;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.StyleSheet;
	import flash.ui.Keyboard;
	import flash.net.SharedObject;
	/**
	 * ...
	 * @author ...
	 */
	public class liveChat extends Sprite
	{
		
		/**
		 * 连接对象
		 */
		private var  $netConnection:NetConnection ;
		
		
		/**
		 * 发送按钮
		 */
		private var $sendBtn:Button;
		
		
		/**
		 * 消息输入框
		 */
		private var $inputText:TextInput;
		
		
		/**
		 * 消息显示框
		 */
		private var $msgArea:TextArea;
		
		
		/**
		 * 用户列表
		 */
		private var $userList:List ;
		
		
		/**
		 * 用户输入框
		 */
		private var $userInput:TextInput ;
		
		
		/**
		 * 用户登录按钮
		 */
		private var $loginBtn:Button;
		
		
		/**
		 * 输入框默认文本
		 */
		private static const DEFAULT_TEXT:String = "在此输入聊天信息";
		
		
		/**
		 * 默认显示的账号名称
		 */
		private static const DEFAULT_USER:String = "在此输入账号";
		
		
		/**
		 * $netConnection的URI地址
		 */
		private static const RTMP_RUI:String = "rtmp://localhost/dinboy";
		
		
		/**
		 * 客户端的用户名称
		 */
		private var $userName:String = "DinBoy";
		
		
		/**
		 * 用于绑定到客户端NetConnection的client类,供FMS调用
		 */
		private var $CLIObject:clientInvockObj;
		
		
		/**
		 * 判断是否连接了
		 */
		private var $Connect:Boolean = false;
		
		
		/**
		 * 选择到的用户
		 */
		private var $selectUser:String;
		
		
		/**
		 * 设置共享对象
		 */
		private var $sharedObject:SharedObject;
		
		/**
		 * 样式表
		 */
		private var $styleSheet :StyleSheet;
		
		
		/**
		 * CSS的加载URLLoader
		 */
		private var $CSSURLLoader:URLLoader;
		
		
		/**
		 * CSS的加载URLRequest
		 */
		private var $CSSURLRequest:URLRequest;
		
		
		/**
		 * CSS的加载路径
		 */
		private static const CSSURL:String="StyleSheet.css";
		
		/*********************/
		public function liveChat() 
		{
				this.$inputText = new TextInput();
				this.$msgArea = new TextArea();
				this.$sendBtn = new Button();
				this.$userInput = new TextInput();
				this.$loginBtn = new Button(); 
				this.$userList = new List();
				this.$netConnection = new NetConnection();
				this.$CSSURLRequest = new URLRequest();
				this.$CSSURLLoader = new URLLoader();
				this.$styleSheet = new StyleSheet();
				
				this.initUI();
				this.initEventListener();
				
			//	this.initApp();
				
		}
		
		/**
		 * 初始化UI位置
		 */
		private function  initUI():void 
		{
			this.$msgArea.width = 400;
			this.$msgArea.height = 200;
			this.$msgArea.x = 5;
			this.$msgArea.y = 5;
			this.$msgArea.editable = false;

			
			this.$inputText.width = 200;
			this.$inputText.text = DEFAULT_TEXT;
			this.$inputText.x = 5;
			this.$inputText.y = 220;
			
			
			this.$sendBtn.width = 80;
			this.$sendBtn.label = "发送消息";
			this.$sendBtn.x = 220;
			this.$sendBtn.y = 220;
			
			this.$userList.x = 420;
			this.$userList.y = 5;
			
			
			this.$userInput.x = 420;
			this.$userInput.y = 150;
			this.$userInput.width = 100;
			this.$userInput.text = DEFAULT_USER;
			
			this.$loginBtn.x = 420;
			this.$loginBtn.y = 180;
			this.$loginBtn.width = 100;
			this.$loginBtn.label = "登录";
			
			
			this.addChild(this.$msgArea);
			this.addChild(this.$inputText);
			this.addChild(this.$sendBtn);
			this.addChild(this.$userList);
			this.addChild(this.$userInput);
			this.addChild(this.$loginBtn);
			
			
			this.$styleSheet.setStyle("a", { color:'#990000' } );
			this.$styleSheet.setStyle("a:hover", { color:'#EE0000'} );
			this.$styleSheet.setStyle("a:link", { color:'#FF0000'} );
			
			this.$msgArea.textField.styleSheet = this.$styleSheet;
			/*
			this.$CSSURLRequest.url = CSSURL;
			this.$CSSURLLoader.load(this.$CSSURLRequest);
			*/
		}
		
		
		/**
		 * 初始化所需要添加的侦听
		 */
		private function  initEventListener():void 
		{
			this.$inputText.addEventListener(FocusEvent.FOCUS_IN, this.onInputTextFocus, false, 0, true);
			this.$inputText.addEventListener(FocusEvent.FOCUS_OUT, this.onInputTextFocus, false, 0, true);
			
			this.$userInput.addEventListener(FocusEvent.FOCUS_IN, this.onInputTextFocus, false, 0, true);
			this.$userInput.addEventListener(FocusEvent.FOCUS_OUT, this.onInputTextFocus, false, 0, true);
			
			this.$inputText.addEventListener(KeyboardEvent.KEY_DOWN, this.onInputTextKeyDown, false, 0, true);
		
			this.$sendBtn.addEventListener(MouseEvent.CLICK, this.onSendButtonClick, false, 0, true);
			
			this.$loginBtn.addEventListener(MouseEvent.CLICK, this.onLoginButtonClick, false, 0, true);
			
			this.$netConnection.addEventListener(NetStatusEvent.NET_STATUS, this.onNetStatus, false, 0, true);
			
			this.$CSSURLLoader.addEventListener(Event.COMPLETE, onLoaerCSSComplete, false, 0, true);
			this.$CSSURLLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onLoaderCSSIOError, false, 0, true);
		}
		
		
		/**
		 * 初始化程序变量
		 */
		private function  initApp():void 
		{
			this.$CLIObject = null;
			this.$CLIObject = new clientInvockObj(this.$userName,this.$userList, this.$msgArea);
			this.$netConnection.client = this.$CLIObject;
			this.$netConnection.connect(RTMP_RUI, this.$userName);
		}
		
		
		/**
		 * 连接FMS并返回消息
		 * @param	evt
		 */
		private function  onNetStatus(evt:NetStatusEvent):void 
		{
			switch (evt.info.code) 
			{
				case "NetConnection.Connect.Success" :
					 this.$msgArea.htmlText += "<b>恭喜你,已经连接上了服务器...</b>\n";
					 this.$userInput.enabled = false;
					 this.$loginBtn.enabled = false;
					 this.$netConnection.call("getMsg", new Responder(this.getMsgResult, this.getMsgFault));  
					 this.$Connect = true;
				break;
				case "NetConnection.Connect.Rejected" :
					this.$msgArea.htmlText += "<b>对不起,服务器拒绝了您的登录请求...</b>\n";
				break;
				case "NetConnection.Connect.Failed" :
					this.$msgArea.htmlText += "<b>对不起,未能连接上服务器...</b>\n";
				break;
				case "NetConnection.Connect.Closed":
					this.$msgArea.htmlText += "<b>服务器已经关闭...</b>\n";
					this.$Connect = false;
				break;
			}
		}
		
		/**
		 * 当选择输入框时
		 * @param	evt
		 */
		private function  onInputTextFocus(evt:FocusEvent):void 
		{
			switch (evt.type) 
			{
				case FocusEvent.FOCUS_IN:
								if (evt.currentTarget==this.$userInput) 
								{
										if (evt.currentTarget.text==DEFAULT_USER) 
										evt.currentTarget.text = "";
								}
								else if(evt.currentTarget==this.$inputText)
								{
										if (evt.currentTarget.text==DEFAULT_TEXT) 
										evt.currentTarget.text = "";
								}
								
				break;
				case FocusEvent.FOCUS_OUT:
						if (evt.currentTarget==this.$userInput) 
								{
										if (evt.currentTarget.text=="") 
										evt.currentTarget.text = DEFAULT_USER;
								}
								else if(evt.currentTarget==this.$inputText)
								{
										if (evt.currentTarget.text=="") 
										evt.currentTarget.text = DEFAULT_TEXT;
								}
				break;
			}
		}
		
		/**
		 * 按下键盘是
		 * @param	evt
		 */
		private function  onInputTextKeyDown(evt:KeyboardEvent):void 
		{
			if (evt.keyCode==Keyboard.ENTER) 
			{
				this.sendMessage();
				this.$sendBtn.setFocus();
			}
		}
		
		/**
		 * 当点击发送按钮时
		 * @param	evt
		 */
		private function onSendButtonClick(evt:MouseEvent):void 
		{
				this.sendMessage();
		}
		
		
		/**
		 * 当点击登录按钮时
		 * @param	evt
		 */
		private function  onLoginButtonClick(evt:MouseEvent):void 
		{
			if (this.$userInput.text==DEFAULT_USER) 
				return;
			this.$userName = this.$userInput.text;
			this.$msgArea.htmlText = "<font color=\"#990000\" >正在尝试连接服务器...</font>";
			this.initApp();
		}
		
		/**
		 * 开始发送消息
		 */
		private function  sendMessage():void 
		{
			if (this.$inputText.text!=DEFAULT_TEXT && this.$Connect) 
			{
				this.$selectUser = this.$userList.selectedItem.label;
				if (this.$userName==this.$selectUser)
				{
					this.$msgArea.htmlText += "<font color=\"#990000\">不能和自己聊天</font>";
					this.$msgArea.verticalScrollPosition = this.$msgArea.maxVerticalScrollPosition;
					return;
				}
				this.$netConnection.call("sendMsg", null, this.$userName, this.$selectUser, this.$inputText.text);
				this.$inputText.text = DEFAULT_TEXT;
			}
		}
		
		/**
		 * 当毁掉成功是
		 * @param	$chatArray
		 */
		private function  getMsgResult($chatArray:Array):void 
		{
			for(var i:uint=0;i<$chatArray.length;i++){   
                 this.$msgArea.htmlText+=$chatArray[i]+"\n";   
             }
			 this.$msgArea.verticalScrollPosition = this.$msgArea.maxVerticalScrollPosition;
		}
		
		/**
		 * 当返回失败的时候
		 */
		private function getMsgFault():void 
		{
			
		}
		
		
		/**
		 * 当加载CSS样式表完成时
		 * @param	evt
		 */
		private function  onLoaerCSSComplete(evt:Event):void 
		{
			trace(this.$CSSURLLoader.data);
			//this.$styleSheet.parseCSS(this.$CSSURLLoader.data as String);
			/*
			try 
			{
				this.$msgArea.textField.styleSheet= this.$styleSheet;
			}
			catch (err:Error)
			{
				
			}*/
			
		//	trace(this.$msgArea.textField.styleSheet.parseCSS(this.$styleSheet as String));
		
		}
		
		
		/**
		 * 当加载样式表错误时
		 * @param	evt
		 */
		private function  onLoaderCSSIOError(evt:IOErrorEvent):void 
		{
			
		}
		
		/********* Class The End ********/
	}

}