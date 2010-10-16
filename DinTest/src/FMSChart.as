package {
import fl.controls.Button;
import fl.controls.TextInput;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.net.NetConnection;
import flash.net.SharedObject;
import flash.events.NetStatusEvent;
import flash.events.SyncEvent;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.text.TextField;

/* 
* A sample chat room to display how communication between adobe FMS3 and as3
* @Author:Michael 
* @home:http://hi.baidu.com/wwwanq/
*/
public class FMSChart extends Sprite {
   private var _remoteSahareObj:SharedObject;
   private var _localSahareObj:SharedObject;
   private var _nc:NetConnection;
   private var _date:Date;
  
   private var send_btn:Button=new Button();
   private var user_txt:TextInput =new TextInput();
   private var talklist_btn:Button=new Button();
   private var clear_talklist_btn:Button = new Button();
   private var outTxt:TextField = new TextField();
   private var in_txt:TextInput = new TextInput();
   
   public function FMSChart():void {
	   initUI();
    _localSahareObj = SharedObject.getLocal("FMSChart");
    _nc = new NetConnection();
    _nc.connect("rtmp://localhost/talk");
    readLocalData();     // Read local data
    setListeners();
   }
   
   private function  initUI():void 
   {
	   this.addChild(this.send_btn);
	   this.send_btn.label = "发送";
	   this.send_btn.x = 220;
	   this.send_btn.y = 350;
	   
	   this.addChild(talklist_btn);
	   this.talklist_btn.x = 300;
	   this.talklist_btn.y = 0;
	   this.talklist_btn.label = "谈话列表";
	   
	   this.addChild(clear_talklist_btn);
	   this.clear_talklist_btn.x = 220;
	   this.clear_talklist_btn.y = 320;
	   this.clear_talklist_btn.label = "清除";
	   
	   
	   /**
	    * 打印
	    */
	   this.addChild(outTxt);
	   this.outTxt.x = 0;
	   this.outTxt.y = 0;
	   this.outTxt.width = 300;
	   this.outTxt.height = 300;
	   this.outTxt.border = true;
	   
	   /**
	    * 用户
	    */
	   this.addChild(user_txt);
	   this.user_txt.x = 0;
	   this.user_txt.y = 320;
 
	   
	  /**
	   * 输入
	   */
		this.addChild(in_txt);
	   this.in_txt.x = 0;
	   this.in_txt.y = 350;
	   this.in_txt.width = 200;
	   

	   
   }
   
   private function readLocalData():void {
    try {
     user_txt.text=_localSahareObj.data.clientName;
    } catch (error:Error) {
     user_txt.text = "talker";   // SharedObject is not exist
    }
   }
  
   private function setListeners():void {
    _nc.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
    send_btn.addEventListener("click",sendMsg);
    user_txt.addEventListener(Event.CHANGE,txtchange);
    stage.addEventListener(KeyboardEvent.KEY_UP,sendByEnter);
    talklist_btn.addEventListener("click",show_talklist);
    clear_talklist_btn.addEventListener("click",clear_talklist);
   }
   private function clear_talklist(event:MouseEvent):void {
    _localSahareObj.data.talklist = "";
    show_talklist(null);
   }
  
   /* Show all the message in local shareobject */
   private function show_talklist(event:MouseEvent):void {
    outTxt.text = _localSahareObj.data.talklist;
   
   }
   private function txtchange(event:Event):void {     // Save user name to shareobject if user_txt change
    _localSahareObj.data.clientName = user_txt.text;
    _localSahareObj.flush();
   }
   public function netStatusHandler(event:NetStatusEvent):void {
    switch (event.info.code) {
     case "NetConnection.Connect.Success" :
      _remoteSahareObj = SharedObject.getRemote("talk", _nc.uri, false);
      _remoteSahareObj.connect(_nc);
      _remoteSahareObj.addEventListener(SyncEvent.SYNC, syncHandler);
      break;
     case "NetConnection.Connect.Rejected" :
     case "NetConnection.Connect.Failed" :
      trace("Oops! you weren't able to connect");
      break;
    }
   }
   private function syncHandler(event:SyncEvent):void {   // when a sync event is fired
    try {
     if (_remoteSahareObj.data.message != undefined) {
      outTxt.appendText(_remoteSahareObj.data.user + " 在 " + _remoteSahareObj.data.date + " 说：\n" + _remoteSahareObj.data.message + "\n");
      _localSahareObj.data.talklist += _remoteSahareObj.data.user + " 在 " + _remoteSahareObj.data.date + " 说：\n" + _remoteSahareObj.data.message + "\n";
     }
    } catch (error:Error) {
     trace("Error:", error);
    }

   }
   private function send():void {
    if ( _remoteSahareObj != null ) {
     _remoteSahareObj.setProperty("message", in_txt.text);
     _remoteSahareObj.setProperty("user", user_txt.text);
     _date=new Date;
     _remoteSahareObj.setProperty("date", _date.getFullYear() + "-"+Number(_date.getMonth() + 1) + "-" + _date.getDate() + " " + _date.getHours() + ":" + _date.getMinutes());
     in_txt.text = "";
    }
   }
  
   /* Use Enter of key to send message quickly */
   private function sendByEnter(event:KeyboardEvent):void {
    if (event.keyCode == 13) {
     send();
    }
   }
   private function sendMsg( event:MouseEvent):void {
    send();
   }
}
}
