package com.dinboy.client   
{   
	import fl.controls.List;
	import fl.controls.TextArea;
	import fl.data.DataProvider;
       
    public class clientInvockObj   
    {   
        private var chatList:List;   
        private var chatContent:TextArea;   
		private var dataProvider:DataProvider;
		private var clientName:String;
        public function clientInvockObj(clientName:String,list:List,chatContent:TextArea)   
        {   
			this.clientName = clientName;
            this.chatList=list;   
            this.chatContent = chatContent;   
        }   
           
        public function getUserList(userList:Array):void {   
		   this.dataProvider = new DataProvider(userList);
		   this.dataProvider.addItemAt({ label:"所有人" }, 0);
           this.chatList.dataProvider = this.dataProvider;  
		   this.chatList.selectedIndex = 0;
            }   
           
        public function getMsgInfo(msgUser:String, toWho:String, msg:String):void {
			if (toWho=="所有人") 
			{
				this.chatContent.htmlText  += "[<a href=\"#\">" + msgUser + "</a>]对 [ <a>所有人</a>] 说：" + msg+"\n";
			}
			else {
			//	throw this.clientName+":"+toWho;
				if ( toWho == this.clientName)
				{
					this.chatContent.htmlText += "[<a href=\"#\">" + msgUser + "</a>]对 您 说：" + msg + "\n";
				}
				if (msgUser==this.clientName) 
				{
					this.chatContent.htmlText += "您 对[<a href=\"#\">" + toWho + "</a>] 说：" + msg + "\n";
				}
            }
			this.chatContent.verticalScrollPosition = this.chatContent.maxVerticalScrollPosition;
        }


		
		public function close():void 
		{
			
		}
		
		/********* Class The End ************/
    }   
}  