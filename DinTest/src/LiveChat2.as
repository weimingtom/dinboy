package {
import flash.display.Sprite;
import flash.net.NetConnection;
import flash.net.Responder;
import flash.events.MouseEvent;
import flash.events.Event;
import flash.events.NetStatusEvent;
import flash.events.AsyncErrorEvent;
import flash.events.KeyboardEvent;
import fl.controls.Button;
import fl.data.DataProvider;

/* 
* A chat room have public talking and private 
* @Author:Michael
* @home:http://hi.baidu.com/wwwanq/
*/ 
public class LiveChat2 extends Sprite {
   private var _nc:NetConnection;
   private var _responder:Responder;
   private var _onlineUserArr:Array;
   private var _userNum:uint;
   private var _myName:String;
  
   /* Constructor */
   public function LiveChat2() {
    _nc = new NetConnection();
    var client:Object = {};
    client.updateUser = updateUser;
   
    _nc.client = client;
    _myName = String(new Date().getTime());
    _responder = new Responder(onResult, onFault);           
    _nc.connect("rtmp://localhost/fmschat", _myName);
    _nc.addEventListener(NetStatusEvent.NET_STATUS, netStatusHdr);
    _nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR,asyncEvtHdr);
    stage.addEventListener(KeyboardEvent.KEY_UP,sendByEnter);
    sendBtn.addEventListener(MouseEvent.CLICK, sendBtnHdr);
    //updateuser(null);
   }
  
   /* Call the function of on server and pass the content of talking */
   private function sendBtnHdr(e:MouseEvent) {
    var sendWho:String = toWho.selectedItem.label;
    if (inputTxt.text != "") {
     if (sendWho != "public") {
      showPrivateTxt.appendText("myself said to " + toWho.selectedItem.label + ": " + inputTxt.text + "\n");
     }
     _nc.call("someoneTalk", null, inputTxt.text,nameTxt.text,toWho.selectedItem.label);
     inputTxt.text = "";
    }
   }
  
   private function netStatusHdr(e:NetStatusEvent) {
    statusTxt.text = e.info.code;
   }
  
   private function asyncEvtHdr(e:AsyncErrorEvent) {
    trace("AsyncErrorEvent!");
   }
  
   private function onResult (result:Object):void {
    trace(String(result)+"onResult");
   }
  
   private function onFault (result:Object):void {
    trace(String("Something error:" + result));
   }
  
   /* Display talking content on the screen */
   private function debug(msg:String,toWho:String){

    if (toWho == "public") {
     showTxt.appendText(msg + "\n");
    } else {
     if (_myName == toWho) {
      showPrivateTxt.appendText(msg + "\n");
     }
    
    }
   }
  
   /* Enter key pressed handler */
   private function sendByEnter(e:KeyboardEvent):void {
    if (e.keyCode == 13) {    // If pressed the ENTER key on the keyboard send message to server
     sendBtnHdr(null);
    }
   }
  
   /* Called by the server pass new massage */
   private function updateUser(msg:String,arr,toWho:String) {
    if (arr != null) {      // If data is null show that pass talking message only
     if (arr is String ) {    // If format of data if String show some one get out 
      _userNum = _onlineUserArr.length;
      for (var j:uint = 0; j < _userNum; j++) {
       if (_onlineUserArr[j] == arr as String) {
        _onlineUserArr.splice(j,1);
       }
      }
     } else if (arr is Array){   // If format of data if Array show some one come in
      _onlineUserArr = arr;
     } else {}
    
     _userNum = _onlineUserArr.length;
     recombineUsers();
    }
   
    debug(msg,toWho);    // Display the talking content
   }
  
   /* If sone one come in or get out rebuild the user list of online */
   private function recombineUsers() {
    var sprite:Sprite = new Sprite();
    for (var i:uint; i < _userNum; i++) {
     var button:Button = new Button();
     sprite.addChild(button);
     button.y = i * 22;
     button.width = 85;
     button.label = _onlineUserArr[i];
     onlineUsername.source = sprite;
     button.addEventListener(MouseEvent.CLICK, userBtnClick);
    }
    var newArr:Array = new Array("public");    // Update combobox data
    var dp:DataProvider = new DataProvider(newArr.concat(_onlineUserArr));
    toWho.dataProvider = dp;
   }
  
   /* Click user list handler */
   private function userBtnClick(e:MouseEvent) {
    trace(e.currentTarget.label);
   }
}
}
