package ruby.Chart
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import mx.controls.List;
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.events.ListEvent;
	import mx.managers.PopUpManager;
	
	import ruby.Event.*;
	import ruby.Model.ModelLocator;
	import ruby.music.MJsound;
	
	

    [Embed(source="ChatBox.swf",symbol="ChatBox")]
	public class charBox extends UIComponent
	{
		
		public var Move:MovieClip;
		public var Send:TextField;
		public var charList:MovieClip;
		public var btn_close:SimpleButton;
		public var btn_send:SimpleButton;
		public var ActPic:MovieClip;
		private var m_list:List;
		
		private var m_chartAry:Array;
		
		[Bindable]
		private var TheModel:ModelLocator;
		public function charBox()
		{
			this.y=380;
			super();
	        
			TheModel=ModelLocator.getInstance();
			charList.stop();
			m_chartAry=["大家好！","打牌就是要眼明手快","人生就是如此","居然敢打这一张","会不会打啊！。。。","枪王","摸不到","我等到花儿都谢了","好久没进牌了"];
			m_list=new List();
			m_list.width=charList.width;
			m_list.height=charList.height;
			m_list.x=charList.x;
			m_list.y=charList.y;
			addChild(m_list);
			m_list.dataProvider=m_chartAry;
			m_list.addEventListener(ListEvent.ITEM_CLICK,changeHandler);
			btn_send.addEventListener(MouseEvent.CLICK,sendMessage);
			btn_close.addEventListener(MouseEvent.CLICK,closeWnd);
			TheModel.addEventListener(EventCMD.sysKeYsend,KeyboardEventHandler);
			this.addEventListener(KeyboardEvent.KEY_DOWN,KeyboardEventHandler1);
			this.setFocus();
	//		trace(hasEventListener()
		}
		private function KeyboardEventHandler1(evt:KeyboardEvent):void
		{
			if(evt.keyCode==13)
			{
			TheModel.dispatchEvent(new PlayEvent(EventCMD.sysKeYsend,null));
			}
		}
		private function KeyboardEventHandler(evt:PlayEvent):void
		{
		   sendMessage();
		}
		private function changeHandler(evt:ListEvent):void
		{
			var list:List=evt.target as List;
		    var Message:String=list.selectedItem.toString();
			Send.text=Message;
		}
		private function sendMessage(evt:MouseEvent=null):void
		{
			trace("------------>发送消息");
			var obj:Object=new Object();
			obj.content=Send.text.toString();
			if(Send.text.length>0)
			{
				TheModel.dispatchEvent(new PlayEvent(EventCMD.sendMsg,obj));
				Send.text="";
			}
			
		}
		private function closeWnd(evt:MouseEvent):void
		{
			MJsound.play("soundBtn");
			PopUpManager.removePopUp(this);
			Application.application.v3.m_mainMC.m_chat=null;
		}
		
	}
}