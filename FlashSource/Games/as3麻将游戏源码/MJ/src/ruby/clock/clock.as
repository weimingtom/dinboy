package ruby.clock
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.core.Application;
	import mx.core.UIComponent;
	
	import ruby.Event.*;
	import ruby.Model.ModelLocator;
	
	
	public class clock extends UIComponent
	{
		private var m_clock:MJTime;
		private var m_num:MovieClip;
		private var m_btn:MovieClip;
		public var m_timer:Timer;
		private var m_isShow:Boolean;
		private var m_count:int;
		private var m_isMy:Boolean;
		
		[Bindable]
		private var TheModel:ModelLocator;
		public function clock()
		{
			TheModel=ModelLocator.getInstance();
			m_clock=new MJTime();
			addChild(m_clock);
			
			m_num=m_clock.m_timer;
			m_btn=m_clock.m_btn_delay;
			
			m_timer=new Timer(1000,10);
			m_btn.visible=false;
			
			
			this.addEventListener(Event.ADDED_TO_STAGE,ADDED_TO_STAGEhandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE,REMOVED_FROM_STAGEHandler);
			
			TheModel.addEventListener(EventCMD.otherPEN,PenTimerHandler);
			TheModel.addEventListener(EventCMD.otherCHI,ChiTimerHandler);
			TheModel.addEventListener(EventCMD.otherGANG,GANGTimerHandler);
			TheModel.addEventListener(EventCMD.otherMoPai,MoPaiTimerHandler);
			
			TheModel.addEventListener(EventCMD.OutPai,OutPaiHandler);
			TheModel.addEventListener(EventCMD.otherOutPai,otherOutPaiHandler);
			TheModel.addEventListener(EventCMD.myOut,myOutHandler);//////现在是我出牌
			TheModel.addEventListener(EventCMD.myCancel,myCancelHandler);
			
			TheModel.addEventListener(EventCMD.CHI,ChiTimerDelay);
			TheModel.addEventListener(EventCMD.PEN,PENTimerDelay);
			TheModel.addEventListener(EventCMD.GANG,GANGTimerDelay);
			
			m_timer.addEventListener(TimerEvent.TIMER,NumChange);
		    m_timer.addEventListener(TimerEvent.TIMER_COMPLETE,timerComplete);
		    
		    TheModel.addEventListener(EventCMD.otherOutPai,NoShowTimer);
		    m_btn.addEventListener(MouseEvent.CLICK,delayTimer);
		}
		
		private function ADDED_TO_STAGEhandler(evt:Event):void
		{
			m_isShow=true;
		}
		private function REMOVED_FROM_STAGEHandler(evt:Event):void
		{
			m_isShow=false;
		}
		
		private function PenTimerHandler(evt:PlayEvent):void
		{
			if(evt.m_data.cid == 0)
			{
				m_count=10;
				ShowPosition(evt,10);
			}
		   else
		   {
		   		m_count=8;
		   		ShowPosition(evt,8);
		   }
		}
		
		private function ChiTimerHandler(evt:PlayEvent):void
		{
			if(evt.m_data.cid==0)
			{
				m_count=10;
			   	ShowPosition(evt,10);
		    }
		  	else
		  	{
		  	 	m_count=8;
		    	ShowPosition(evt,8);
		    }
		}
		
		private function GANGTimerHandler(evt:PlayEvent):void
		{
			if(evt.m_data.cid==0)
			{
				m_count=10;
				ShowPosition(evt,10);
			}
			else
			{
			  	m_count=8;
		    	ShowPosition(evt,8);
		    }
		}
		
		private function MoPaiTimerHandler(evt:PlayEvent):void
		{
			m_count=8;
			ShowPosition(evt,8);
		}
		
		private function ShowPosition(evt:PlayEvent,repeatCount:int):void
		{
			m_timer.reset();
	    	m_timer.repeatCount = repeatCount;
		    
			 switch(evt.m_data.cid)
		    {
		    	case 0:	// 自家
			        this.x=640;
			        this.y=470;
			        if(!TheModel.m_isDelay)
			        m_btn.visible=true;
			        m_isMy=true;
			    	break;
		    	case 1:	// 下家->右
			    	this.x=650;
			    	this.y=170;
			    	m_btn.visible=false;
			    	 m_isMy=false;
			    	break;
		    	case 2:	// 对家
			    	this.x=250;
			    	this.y=160;
			    	m_btn.visible=false;
			    	 m_isMy=false;
			    	break;
		    	case 3:	// 上家->左
			    	this.x=80;
			    	this.y=340;
			        m_btn.visible=false;
			         m_isMy=false;
			    	break;
		    	default:
		    		break;
		    }
		    m_timer.start();
		}
		private function NumChange(evt:TimerEvent):void
		{
			var count:int=m_count-m_timer.currentCount-1;
			
			if(!m_isShow)
			{
				  Application.application.v3.addChild(this);	// current added into VS
			}
			
			if(count>9)
			{
				m_num.Num.Num1.gotoAndStop(int(count/10)+1)
				m_num.Num.Num2.gotoAndStop(count%10+1);
			}
			else
			{
				m_num.Num.Num1.gotoAndStop(1)
				m_num.Num.Num2.gotoAndStop(count%10+1);
			}
			m_clock.m_timer.gotoAndPlay(1);
		}
		
		private function timerComplete(evt:TimerEvent):void
		{
			if(m_isShow)
			{
				 this.parent.removeChild(this);
				 if(m_isMy)
				 {
				 	TheModel.dispatchEvent(new PlayEvent(EventCMD.myHandler,new Object()));
				 }
			}
		}
		private function NoShowTimer(evt:PlayEvent):void
		{
			if(m_isShow)
			{
			this.parent.removeChild(this);
			}
		}
		private function delayTimer(evt:MouseEvent):void
		{
			TheModel.m_isDelay=true;
			m_timer.reset();
			m_timer.repeatCount = 10;
			m_count=10;
			m_timer.start();
			m_btn.visible=false;
			
			var obj:Object=new Object();
			obj.message="dpd";
			TheModel.dispatchEvent(new PlayEvent(EventCMD.SysDelay,obj));
		}
		private function OutPaiHandler(evt:PlayEvent):void
		{
			if(m_isShow)
			{
			this.parent.removeChild(this);
			}
			m_timer.stop();
			
		}
		
		private function otherOutPaiHandler(evt:PlayEvent):void
		{
			if(m_isShow)
			{
			this.parent.removeChild(this);
			}
			m_timer.stop();
			
		}
		
		private function myOutHandler(evt:PlayEvent):void
		{
			if(!m_isShow)
			{
				this.x=640;
		        this.y=470;
		        m_btn.visible=true;
			}
			m_timer.reset();
			m_count=8;
			m_timer.repeatCount=8;
			m_timer.start();
			m_isMy=true;
		}
		
		private function myCancelHandler(evt:PlayEvent):void
		{
			if(m_isShow)
			{
				this.parent.removeChild(this);
				m_isShow=false;
				m_timer.stop();
				m_timer.reset();
			}
			
		}
		private function ChiTimerDelay(evt:PlayEvent):void
		{
			if(m_isShow)
			{
				m_count=8;
				m_timer.repeatCount=8;
				m_timer.reset();
				m_timer.start();
			}
		}
		private function PENTimerDelay(evt:PlayEvent):void
		{
			
			if(m_isShow)
			{
			
				m_count=8;
				m_timer.repeatCount=8;
				m_timer.reset();
				m_timer.start();
				
			}
		}
		private function GANGTimerDelay(evt:PlayEvent):void
		{
			
			if(m_isShow)
			{
				m_count=8;
				m_timer.repeatCount=8;
				m_timer.reset();
				m_timer.start();
				
			}
		}
	}
}