package ruby.ClientSFSapi
{
	import com.adobe.crypto.MD5;
	
	import flash.events.EventDispatcher;
	
	import it.gotoandplay.smartfoxserver.SFSEvent;
	import it.gotoandplay.smartfoxserver.SmartFoxClient;
	
	import mx.controls.Alert;
	import mx.core.Application;
	
	import ruby.Event.EventCMD;
	import ruby.Event.PlayEvent;
	import ruby.Model.ModelLocator;

	
	public class conn extends EventDispatcher
	{
		public var _SFS:SmartFoxClient;
		private var m_zoom:String;
		private var force:Boolean=false;
		[Bindable]
		private var TheModel:ModelLocator;
		public function conn()
		{
			TheModel = ModelLocator.getInstance();
			// client
			TheModel.addEventListener(EventCMD.LOGIN,Gologin);
			TheModel.addEventListener(EventCMD.ConfigTable,ConfigTable);
			TheModel.addEventListener(EventCMD.questPai,ConfigPai);
			TheModel.addEventListener(EventCMD.OutPai,OutPaiHandler);
			TheModel.addEventListener(EventCMD.Begin,BeginHandler);
			TheModel.addEventListener(EventCMD.CHI,CHI);
			TheModel.addEventListener(EventCMD.PEN,PEN);
//			TheModel.addEventListener(EventCMD.repairFlower,repairFlower);
			TheModel.addEventListener(EventCMD.GANG,GANG);
			TheModel.addEventListener(EventCMD.Cancel,Cancel);
			TheModel.addEventListener(EventCMD.again,newGAME);
			TheModel.addEventListener(EventCMD.Eye,EyeHandler);
			TheModel.addEventListener(EventCMD.SysDelay,SysDelayHandler);
			TheModel.addEventListener(EventCMD.sendMsg,sendMsg);	//发送聊天信息

			// server
			_SFS = new SmartFoxClient(true);
			_SFS.addEventListener(SFSEvent.onLogin,onLogin);
			_SFS.addEventListener(SFSEvent.onConnection,onConnection);
			_SFS.addEventListener(SFSEvent.onConnectionLost,onConnectionLost);
			_SFS.addEventListener(SFSEvent.onRoomListUpdate,onRoomListUpdate);
			_SFS.addEventListener(SFSEvent.onJoinRoom,onJoinRoom);
			_SFS.addEventListener(SFSEvent.onJoinRoomError,onJoinRoomError);
			
			_SFS.addEventListener(SFSEvent.onLogout,onLogout);
			_SFS.addEventListener(SFSEvent.onExtensionResponse,onExtensionResponse);
			loadConfigData();	// 登录信息
		}
		
		private function onExtensionResponse(evt:SFSEvent):void
		{
			var data:Object = evt.params.dataObj;
			switch(data.cmd)
			{
				case "chat":
					TheModel.dispatchEvent(new PlayEvent(EventCMD.receiveMsg,data));
					break;
				case "login": ////登录
					if(data.message == 0)
					{
						Application.application.vs.selectedIndex=1;	// 登录成功，切换选注大厅
					}
					else if(data.messeage == 1)/////用户名密码错误
					{
						Alert.show("用户名密码错误！");
						_SFS.logout();
						force = true;
					}
					else if(data.messeage == 2)////用户已登录
					{
						Alert.show("用户已登录");
						_SFS.logout();
						force = true;
					}
					else if(data.messeage == 22)////已在其他游戏中
					{
						Alert.show("已在其他游戏中");
						_SFS.logout();
						force = true;
					}else if(data.messeage == 3)////游戏未开放
					{
						Alert.show("游戏未开放");
						_SFS.logout();
						force = true;
					}
					else if(data.messeage  ==  4)
					{
						Alert.show("用户被停用");
						_SFS.logout();
						force = true;
					}
					else if(data.messeage == 5)
					{
						Alert.show("系统维护中");
						_SFS.logout();
						force = true;
					}
					else if(data.messeage == 7)
					{
						Alert.show("该用户不是会员");
						_SFS.logout();
						force = true;
					}
					else if(data.messeage == 8)
					{
						Alert.show("该用户被锁定");
						_SFS.logout();
						force = true;
					}
					else
					{
						_SFS.logout();
						force = true;
					}
					break;
				case "configTable":
					if(data.messeage == "success")////配桌成功
					{
						Application.application.callLater(ConfigPai,null);
					}
					else
					{
						Alert.show("配桌失败");
					}
					break;
				case "configPai":	// 配牌成功
					Application.application.vs.selectedIndex=2;
					Application.application.width=800;
					Application.application.height=600;
					TheModel.dispatchEvent(new PlayEvent(EventCMD.ConfigPai,data));
					break;
				case "handle":
					var obj:Object;
					var bid:int;	//被操作者
					var cid:int;	//操作者
					var cmdSC:Array = data.sc;
					
					cid=(parseInt(data.cid)+4-TheModel.m_ID)%4;
					bid=(parseInt(data.bid)+4-TheModel.m_ID)%4;
					TheModel.m_hand = cid;	// 保存操作者
					
					if(Application.application.v3.m_clock.visible  ==  false)
				   		Application.application.v3.m_clock.visible = true;
				   		
					for(var i:int = 0;i<cmdSC.length;i++)
					{
						switch(cmdSC[i])
						{
							case -2:///打牌
								obj = new Object();
								obj.bid = -1;
								obj.cid = cid;
								obj.pai = data.pai;
								TheModel.m_hand = (cid+1+4)%4;
								TheModel.dispatchEvent(new PlayEvent(EventCMD.otherOutPai,obj));
								break;
							case -1:////后摸
								obj = new Object();
								obj.type=-1;
								obj.cid=cid;
								obj.pai=data.pai;
								TheModel.dispatchEvent(new PlayEvent(EventCMD.otherMoPai,obj));
								break;
							case 1:///前摸
								obj = new Object();
								obj.type=1;
								obj.cid=cid;
								obj.pai=data.pai;
								TheModel.dispatchEvent(new PlayEvent(EventCMD.otherMoPai,obj));
								break;
							case 2:///////补花
								obj = new Object();
								obj.cid=cid;
								obj.pai=data.pai;
								TheModel.dispatchEvent(new PlayEvent(EventCMD.otherBuHua,obj));
								break;
							case 3:////眼牌
								obj = new Object();
								break;
							case 4://////吃牌
								obj = new Object();
								obj.bid=bid;
								obj.cid=cid;
								obj.pai=data.pai;
								TheModel.dispatchEvent(new PlayEvent(EventCMD.otherCHI,obj));
								break;
							case 5:////碰牌
								obj = new Object();
								obj.bid=bid;
								obj.cid=cid;
								obj.pai = data.pai;
								TheModel.dispatchEvent(new PlayEvent(EventCMD.otherPEN,obj));
								break;
							case 6:////加杠
								obj = new Object();
								obj.bid=bid;
								obj.cid=cid;
								obj.pai=data.pai;
								obj.type=6;
								TheModel.dispatchEvent(new PlayEvent(EventCMD.otherGANG,obj));
								break;
							case 7:////明杠
								obj = new Object();
								obj.bid=bid;
								obj.cid=cid;
								obj.pai=data.pai;
								obj.type=7;
								TheModel.dispatchEvent(new PlayEvent(EventCMD.otherGANG,obj));
								break;
							case 8://///暗杠
								obj = new Object();
								obj.bid=bid;
								obj.cid=cid;
								obj.pai=data.pai;
								obj.type=8;
								TheModel.dispatchEvent(new PlayEvent(EventCMD.otherGANG,obj));
								break;
							case -8:////暗杠
								obj = new Object();
								obj.bid=bid;
								obj.cid=cid;
								obj.pai=data.pai;
								obj.type=8;
								TheModel.dispatchEvent(new PlayEvent(EventCMD.otherGANG,obj));
								break;
							default:
								break;
						}
					}
					break;
				case "winTable"://///赢计表信息
					TheModel.dispatchEvent(new PlayEvent(EventCMD.WinTabel,data));
					break;
				case "again":
//					var obj:Object=new Object();
					obj = new Object();
					obj.uid=(parseInt(data.uid)+4-TheModel.m_ID)%4;
					TheModel.dispatchEvent(new PlayEvent(EventCMD.otherAgain,obj));
					break;
				case "next":
					TheModel.dispatchEvent(new PlayEvent(EventCMD.nest,new Object()));
					break;
				case "eye":
					trace("服务器发送眼牌");
					TheModel.dispatchEvent(new PlayEvent(EventCMD.MyEye,data));
					break;
				default :
					break;
			}
		
		}
		
		private function loadConfigData():void
		{
			/**测试**/
			/*
			var url:URLRequest=new URLRequest("config.xml");
			var load:URLLoader=new URLLoader();
			load.addEventListener(Event.COMPLETE,completeHandler);
			load.load(url);
			*/
			/**192.168.58.235   内网**/
			/**192,168,58,17  王露**/
			_SFS.connect("192.168.58.235",9560);
		}
		
//		private function completeHandler(event:Event):void
//		{
//			var xml:XML = new XML(event.target.data);
//			_SFS.ipAddress = xml.ip;
//			_SFS.port = parseInt(xml.port);
//			m_zoom = xml.zone;
//			_SFS.connect(_SFS.ipAddress,_SFS.port);
//		}
		private function onConnection(evt:SFSEvent):void
		{
			if (evt.params.success)
			{
               trace("Great, successfully connected!");
           //     _SFS.login(m_zoom,"wangtao","123");
           //   _SFS.login("twmj",TheModel.m_userName,TheModel.m_userPwd);
            }
           else
           {
           		trace("connection value :--->",evt.params.success);
				trace("connection failed!");
				Alert.show("登录失败");
           }

			
		}
		private function onConnectionLost(evt:SFSEvent):void
		{
			
		}
		
		private function onLogin(evt:SFSEvent):void
		{
			if(evt.params.success)
			{
				trace("login success !");
			}
			else
			{
				trace("login faile!");
				Alert.show("登录失败!");
				Application.application.v1.btn_login.enabled = true;
			}
		}
		private function onRoomListUpdate(evt:SFSEvent):void
		{
			_SFS.autoJoin();
		}
		private function onLogout(evt:SFSEvent):void
		{
			trace("&&&&&&&&");
		

			
		}
		private function onJoinRoom(evt:SFSEvent):void
		{
	//		var joinedRoom:Room = evt.params.room;
     //       trace("Room " + joinedRoom.getName() + " joined successfully")
			/**登录扩展**/
			var obj:Object=new Object();
		//	TheModel.m_userName="x7testwl";
		//	TheModel.m_userPwd="a11111";
			obj.nick=TheModel.m_userName;
		//	obj.pass=MD5.hash(TheModel.m_userPwd);
		    obj.pass = TheModel.m_userPwd;
			obj.force = force;

			_SFS.sendXtMessage("CommonExtension","login",obj,"json");
		}
		private function onJoinRoomError(evt:SFSEvent):void
		{
			trace("加入房间失败！");
		}
		private function Gologin(evt:PlayEvent):void
		{
			TheModel.m_userName=evt.m_data.name.toString();
			TheModel.m_userPwd=MD5.hash(evt.m_data.pwd);
			_SFS.login("twmj",TheModel.m_userName,TheModel.m_userPwd);
		}
		private function ConfigTable(evt:PlayEvent):void
		{
			trace(evt.m_data.bet);
			_SFS.sendXtMessage("CommonExtension","configTable",evt.m_data,"json");
		}
		private function ConfigPai(evt:PlayEvent=null):void
		{
			trace("请求牌！");
			_SFS.sendXtMessage("CommonExtension","configPai",new Object(),"json");
		}
		private function OutPaiHandler(evt:PlayEvent):void
		{   
		     trace("打出牌");
			_SFS.sendXtMessage("CommonExtension","daPai",evt.m_data,"json");
			TheModel.m_hand=1;
			
		}
		private function BeginHandler(evt:PlayEvent):void
		{
			_SFS.sendXtMessage("CommonExtension","begin",evt.m_data,"json");
		}
		private function CHI(evt:PlayEvent):void
		{
			_SFS.sendXtMessage("CommonExtension","chiPai",evt.m_data,"json");
		}
		private function PEN(evt:PlayEvent):void
		{
			_SFS.sendXtMessage("CommonExtension","pengPai",evt.m_data,"json");
		}
//		private function repairFlower(evt:PlayEvent):void
//		{
////			_SFS.sendXtMessage("CommonExtension","repairFlower",evt.m_data,"json");
//		}
		private function GANG(evt:PlayEvent):void
		{
			if(evt.m_data.type == 6)
			{
				_SFS.sendXtMessage("CommonExtension","jiaGang",evt.m_data,"json");	// 加杠
			}
			if(evt.m_data.type == 7)
			{
				_SFS.sendXtMessage("CommonExtension","mingGang",evt.m_data,"json");	// 明杠
			}
			if(evt.m_data.type == 8)
			{
				_SFS.sendXtMessage("CommonExtension","anGang",evt.m_data,"json");	// 暗杠
			}
		}
		private function Cancel(evt:PlayEvent):void
		{
			_SFS.sendXtMessage("CommonExtension","runControl",evt.m_data,"json");
		}
		private function newGAME(evt:PlayEvent):void
		{
			_SFS.sendXtMessage("CommonExtension","again",evt.m_data,"json");
		}
		private function EyeHandler(evt:PlayEvent):void
		{
			_SFS.sendXtMessage("CommonExtension","yanPai",new Object(),"json");
		}
		private function SysDelayHandler(evt:PlayEvent):void
		{
			_SFS.sendXtMessage("CommonExtension","delayed",evt.m_data,"json");
		}
		private function sendMsg(evt:PlayEvent):void
		{
			_SFS.sendXtMessage("CommonExtension","chat",evt.m_data,"json");
		}

	}
}