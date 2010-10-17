package ruby.Chart
{
	import flash.display.BlendMode;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	
	import ruby.Event.*;
	import ruby.Model.ModelLocator;

	public class charArea extends UIComponent
	{
		[Bindable]
		private var TheModel:ModelLocator;
		
		private var m_isShow:Boolean=false;
		private var m_txt:TextField;
		private var m_size:Array=new Array();
		private var m_myTxtForm:TextFormat;
		private var m_publicTxtForm:TextFormat;

		
		private var m_timer:Timer=new Timer(1000,10);
		public function charArea()
		{
			this.x=80
			this.y=80;
			TheModel=ModelLocator.getInstance();
			TheModel.addEventListener(EventCMD.receiveMsg,receiveMsg);
		//	this.alpha=0;
			this.mouseEnabled=false;
		
			m_txt=new TextField();
			m_txt.width=250;
			m_txt.height=200;
	//		m_txt.blendMode = BlendMode.LAYER;
	
		    m_txt.blendMode=BlendMode.LAYER;
           
			addChild(m_txt);
			m_publicTxtForm=new TextFormat();
			 m_publicTxtForm.font = "Verdana";
            m_publicTxtForm.color = 0x990000;
            m_publicTxtForm.size = 14;
            m_publicTxtForm.underline = true;

			
		
			super();
		}
		
		private function receiveMsg(evt:PlayEvent):void
		{
			var i:int;
			if(!m_isShow)
			{
			PopUpManager.addPopUp(this,Application.application.v3,false);
			m_isShow=true;
			}
			m_txt.alpha=1;
            
             
             var say:String=new String();
             
           
  
             switch(evt.m_data.cid)
             {
             	case 1:
             	say="[东]玩家说： "+evt.m_data.content+"\n";
             	break;
             	case 2:
             	say="[南]玩家说： "+evt.m_data.content+"\n";
             	break;
             	case 3:
             	say="[西]玩家说： "+evt.m_data.content+"\n";
             	break;
             	case 4:
             	say="[北]玩家说： "+evt.m_data.content+"\n";
             	break;
             	default:
             	break;
             }
            
		    if(m_size.length<10)
		    {
		    	 m_size.push(say);
		    }
		    else
		    {
		    	m_size.splice(0,1);
		    	m_size.push(say);
		    }
			var allStr:String=new String();
			for(i=0;i<m_size.length;i++)
			{
				allStr+=m_size[i];
			}
			m_txt.text=allStr;	
			m_txt.setTextFormat(m_publicTxtForm);
			
			m_timer.addEventListener(TimerEvent.TIMER,timerHandler);
			m_timer.addEventListener(TimerEvent.TIMER_COMPLETE,timerComplete);
			m_timer.reset();
			m_timer.start();
		}
		private function timerHandler(evt:TimerEvent):void
		{
			m_txt.alpha-=0.1;
		}
		private function timerComplete(evt:TimerEvent):void
		{
			m_txt.alpha=0;
			m_timer.removeEventListener(TimerEvent.TIMER,timerHandler);
			m_timer.removeEventListener(TimerEvent.TIMER_COMPLETE,timerComplete);
		}
		
	}
}