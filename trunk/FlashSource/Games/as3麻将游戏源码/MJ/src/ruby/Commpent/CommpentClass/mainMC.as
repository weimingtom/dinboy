package ruby.Commpent.CommpentClass
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	
	import ruby.Chart.charBox;
	import ruby.Event.*;
	import ruby.Model.ModelLocator;
	import ruby.music.MJsound;
	import ruby.winTable.setting;
	import ruby.winTable.warnBox;
	
	[Embed(source="mainMC.swf",symbol="mainMC")]
	public class mainMC extends UIComponent
	{	
		[Bindable]
		private var TheModel:ModelLocator;
		
		public var m_txt_name:TextField;
		public var m_txt_money:TextField;
		public var m_txt_money1:TextField;
		public var m_txt_money2:TextField;
		public var m_txt_money3:TextField;
		
		
		public var m_txt_win:TextField;
		public var m_txt_win1:TextField;
		public var m_txt_win2:TextField;
		public var m_txt_win3:TextField;
		public var m_txt_jh:TextField;
		
		public var m_btn_system:SimpleButton;
		public var m_btn_eye:MovieClip;
		public var m_btn_chat:SimpleButton;
		
		public var m_zhuang:MovieClip;
		public var m_zhuang1:MovieClip;
		public var m_zhuang2:MovieClip;
		public var m_zhuang3:MovieClip;
		
		public var m_wind:MovieClip;
		public var m_wind0:MovieClip;
		public var m_wind1:MovieClip;
		public var m_wind01:MovieClip;
		public var m_wind2:MovieClip;
		public var m_wind02:MovieClip;
		public var m_wind3:MovieClip;
		public var m_wind03:MovieClip;
		
		public var m_set1:MovieClip;
		public var m_set2:MovieClip;
		private var m_textformat:TextFormat;
		private var m_OK:SimpleButton;
		private var m_NO:SimpleButton;
		private var m_warnBox:warnBox;	// 警告提示框
		private var m_setBar:setting;
		public var m_chat:charBox;
		public function mainMC()
		{
			TheModel=ModelLocator.getInstance();
			TheModel.addEventListener(EventCMD.ConfigPai,ConfigPai);
			m_warnBox=new warnBox();	// 警告提示框
	//		m_chat=new charBox();
			m_OK = m_warnBox.m_Ok;
			m_NO = m_warnBox.m_NO;
		    m_txt_jh.y += 5;
		    m_textformat = new TextFormat();
		    m_textformat.font = "Verdana";
		    m_textformat.size = "9";
		    m_textformat.color = 0xccff00;
		    
		    m_OK.addEventListener(MouseEvent.CLICK,eyeYesHandler);
		    m_NO.addEventListener(MouseEvent.CLICK,eyeNoHandler);
		    m_btn_system.addEventListener(MouseEvent.CLICK,systemSetting);
		    m_btn_chat.addEventListener(MouseEvent.CLICK,CharHandler);
		    m_setBar = new setting();
		}

		private function initStage():void	// 更新桌面
		{
			m_btn_eye.gotoAndStop(1);
			m_btn_eye.mouseEnabled=false;
			m_btn_eye.addEventListener(MouseEvent.CLICK, EyeHandler);

			m_set1.gotoAndStop(5);
			m_set2.gotoAndStop(5);

			m_zhuang.gotoAndStop(3);
			m_zhuang1.gotoAndStop(3);
			m_zhuang2.gotoAndStop(3);
			m_zhuang3.gotoAndStop(3);

			m_wind.gotoAndStop(5);
			m_wind1.gotoAndStop(5);
			m_wind2.gotoAndStop(5);
			m_wind3.gotoAndStop(5);

			m_wind0.gotoAndStop(5);
			m_wind01.gotoAndStop(5);
			m_wind02.gotoAndStop(5);
			m_wind03.gotoAndStop(5);
		}
		
		private function GetUserMessage(evt:PlayEvent):void
		{
			 
		/*	 m_buttom_txt_jh.text=evt.m_data.jh;
			 m_buttom_txt_num.text=evt.m_data.money;
			 m_user3_txt.text=evt.m_data.u1m;
			 m_user2_txt.text=evt.m_data.u2m;
			 m_user1_txt.text=evt.m_data.u3m;
			 */
		}
		
		private function ConfigPai(evt:PlayEvent):void		// 初始化牌，玩家信息 -> ModelLocator
		{
			var i:int;
			var j:int;
			
			trace("ConfigPai resived!");
			
			TheModel.m_ID = evt.m_data.uid;  ////自家
			TheModel.m_szs = evt.m_data.szs; ////骰子
			TheModel.m_bu = evt.m_data.bu;////自家玩家补牌信息
			TheModel.m_bu1 = evt.m_data.bu1;////下家
			TheModel.m_bu2 = evt.m_data.bu2;/////对家
		    TheModel.m_bu3 = evt.m_data.bu3;/////上家
//            trace(typeof(evt.m_data.bu1));
			TheModel.m_jh = evt.m_data.jh;////将号
			TheModel.m_lbc = evt.m_data.lbc;////连庄数
			TheModel.m_juhao = evt.m_data.tc;/////第几局
			TheModel.m_pai = evt.m_data.pai;/////玩家的牌
			
			TheModel.m_money[0]=evt.m_data.money;/////玩家自己的钱
			TheModel.m_money[1]=evt.m_data.u1m;/////下家余额
			TheModel.m_money[2]=evt.m_data.u2m;////对家余额
			TheModel.m_money[3]=evt.m_data.u3m;/////上家余额
			
			TheModel.m_Zbank[0] = evt.m_data.ib as Boolean;	// self modify
			TheModel.m_Zbank[1] = evt.m_data.ib1 as Boolean;
			TheModel.m_Zbank[2] = evt.m_data.ib2 as Boolean;
			TheModel.m_Zbank[3] = evt.m_data.ib3 as Boolean;
			
			TheModel.m_begin=evt.m_data.isBegin;/////是否开局
			TheModel.m_js=evt.m_data.js;   /////什么局->局数
			TheModel.m_qs=evt.m_data.qs;   /////什么圈->圈数
			TheModel.m_utw=evt.m_data.utw;
		
		    trace(TheModel.m_szs);	// 骰子数
		    
		    initStage();	// 更新桌面
			
		    switch(TheModel.m_ID)
		    {
		    	case 1:
			    	m_wind.gotoAndStop(1);
			    	m_wind0.gotoAndStop(1);
			    	m_wind1.gotoAndStop(2);
			    	m_wind01.gotoAndStop(2);
			    	m_wind2.gotoAndStop(3);
			    	m_wind02.gotoAndStop(3);
			    	m_wind3.gotoAndStop(4);
			    	m_wind03.gotoAndStop(4);
			    	break;
		    	case 2:
			        m_wind.gotoAndStop(2);
			        m_wind0.gotoAndStop(2);
			        m_wind01.gotoAndStop(3);
			        m_wind1.gotoAndStop(3);
			        m_wind2.gotoAndStop(4);
			        m_wind02.gotoAndStop(4);
			        m_wind3.gotoAndStop(1);
			        m_wind03.gotoAndStop(1);
			    	break;
		    	case 3:
			        m_wind.gotoAndStop(3);
			        m_wind0.gotoAndStop(3);
			        m_wind01.gotoAndStop(4);
			        m_wind1.gotoAndStop(4);
			        m_wind2.gotoAndStop(1);
			        m_wind02.gotoAndStop(1);
			        m_wind3.gotoAndStop(2);
			        m_wind03.gotoAndStop(2);
			    	break;
		    	case 4:
			        m_wind.gotoAndStop(4);
			        m_wind0.gotoAndStop(4);
			        m_wind01.gotoAndStop(1);
			        m_wind1.gotoAndStop(1);
			        m_wind2.gotoAndStop(2);
			        m_wind02.gotoAndStop(2);
			        m_wind3.gotoAndStop(3);
			        m_wind03.gotoAndStop(3);
			        break;
		    	default:
		    		break;
		    }
		    
		    var timer:Timer;
		    var lbc:int = TheModel.m_lbc;
		    for(i=0;i<4;i++)
		    {
		    	if(TheModel.m_Zbank[i])
		    	{
		    		var index:int;
		    		switch(i)
		    		{
		    			case 0 :
			    			if(lbc>0)
			    			{
			    				m_zhuang.gotoAndStop(2);
			    				timer=new Timer(300,1);
			    				timer.addEventListener(TimerEvent.TIMER_COMPLETE,ZhuangHandler);
			    				timer.start();
			    			//	m_zhuang.callLater(Zhuang1Handler);
			    				
			    			 //   m_zhuang.Num.Num2.gotoAndStop(lbc);
			    			}
			    			else
			    			{
			    				m_zhuang.gotoAndStop(1);
			    			}
			    			break;
		    			case 1:
			    			if(lbc>0)
			    			{
			    				m_zhuang1.gotoAndStop(2);
			    				timer=new Timer(300,1);
			    				timer.addEventListener(TimerEvent.TIMER_COMPLETE,Zhuang1Handler);
			    				timer.start();
			    			//	m_zhuang1.callLater(Zhuang2Handler);
			    			  //  m_zhuang1.Num.Num2.gotoAndStop(lbc);
			    			}
			    			else
			    			{
			    				m_zhuang1.gotoAndStop(1);
			    			}
			    			index++;
			    			break;
		    			case 2:
			    			if(lbc>0)
			    			{
			    				m_zhuang2.gotoAndStop(2);
			    				timer=new Timer(300,1);
			    				timer.addEventListener(TimerEvent.TIMER_COMPLETE,Zhuang2Handler);
			    				timer.start();
			    			//	m_zhuang2.callLater(Zhuang3Handler);
			    			   // m_zhuang2.Num.Num2.gotoAndStop(lbc);
			    			}
			    			else
			    			{
			    				m_zhuang2.gotoAndStop(1);
			    			}
			    			index+=2;
			    			break;
		    			case 3:
			    			index+=3;
			    			if(lbc>0)
			    			{
			    				m_zhuang3.gotoAndStop(2);
			    				timer=new Timer(300,1);
			    				timer.addEventListener(TimerEvent.TIMER_COMPLETE,Zhuang3Handler);
			    				timer.start();
			    		//		m_zhuang3.callLater(h);
			    			  //  m_zhuang3.Num.Num2.gotoAndStop(lbc);
			    			}
			    			else
			    			{
			    				m_zhuang3.gotoAndStop(1);
			    			}
			    			break;
		    			default:
		    				break;
		    		}
		    		break;
		    	}
		    }
		        
		    switch(TheModel.m_qs)
		    {
		    	case "1":
		    		m_set1.gotoAndStop(1);
		    		break;
		    	case "2":
		    		m_set1.gotoAndStop(2);
		    		break;
		    	case "3":
		    		m_set1.gotoAndStop(3);
		    		break;
		    	case "4":
		    		m_set1.gotoAndStop(4);
		    		break;
		    	default:
		    		break;
		    }
		    switch(TheModel.m_js)
		    {
		    	case "1":
		      		m_set2.gotoAndStop(1);
		    		break;
		    	case "2":
		      		m_set2.gotoAndStop(2);
		    		break;
		    	case "3":
			       	m_set2.gotoAndStop(3);
			    	break;
		    	case "4":
		       		m_set2.gotoAndStop(4);
		    		break;
		    	default:
		    		break;
		    }
		    
		   m_txt_money.text=TheModel.m_money[0].toString();
		   m_txt_money3.text=TheModel.m_money[1].toString();
		   m_txt_money2.text=TheModel.m_money[2].toString();
		   m_txt_money1.text=TheModel.m_money[3].toString();
		   m_txt_jh.text=TheModel.m_jh;
		   m_txt_name.text=TheModel.m_userName.toString();
		   m_txt_win.text=TheModel.m_utw.toString();
		   
		   m_txt_money.setTextFormat(m_textformat);
		   m_txt_money3.setTextFormat(m_textformat);
		   m_txt_money2.setTextFormat(m_textformat);
		   m_txt_money1.setTextFormat(m_textformat);
		   m_txt_jh.setTextFormat(m_textformat);
		   m_txt_name.setTextFormat(m_textformat);
		   m_txt_win.setTextFormat(m_textformat);
		   
		    
		    TheModel.dispatchEvent(new PlayEvent(EventCMD.InitStage,new Object())); // 配牌结束。开始进行游戏
		}
		private function ZhuangHandler(evt:TimerEvent):void
		{
			var timer:Timer=evt.target as Timer;
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE,ZhuangHandler);
			m_zhuang.Num.Num2.gotoAndStop(TheModel.m_lbc+1);
			m_zhuang.Num.Num1.gotoAndStop(1);
		}
		private function Zhuang1Handler(evt:TimerEvent):void
		{
			var timer:Timer=evt.target as Timer;
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE,Zhuang1Handler);
			m_zhuang1.Num.Num2.gotoAndStop(TheModel.m_lbc+1);
			m_zhuang1.Num.Num1.gotoAndStop(1);
		}
		private function Zhuang2Handler(evt:TimerEvent):void
		{
			var timer:Timer=evt.target as Timer;
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE,Zhuang2Handler);
			m_zhuang2.Num.Num2.gotoAndStop(TheModel.m_lbc+1);
			m_zhuang2.Num.Num1.gotoAndStop(1);
		}
		private function Zhuang3Handler(evt:TimerEvent):void
		{
			var timer:Timer=evt.target as Timer;
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE,Zhuang3Handler);
			m_zhuang3.Num.Num2.gotoAndStop(TheModel.m_lbc+1);
			m_zhuang3.Num.Num1.gotoAndStop(1);
		}
		
		private function EyeHandler(evt:MouseEvent):void
		{
		    this.parent.addChild(m_warnBox);
		}
		
		private function eyeYesHandler(evt:MouseEvent):void
		{
			TheModel.dispatchEvent(new PlayEvent(EventCMD.Eye,null));
			m_btn_eye.removeEventListener(MouseEvent.CLICK,EyeHandler);
			m_btn_eye.mouseEnabled = false;
		    m_btn_eye.gotoAndStop(3);
		    this.parent.removeChild(m_warnBox);
		}
		private function eyeNoHandler(evt:MouseEvent):void
		{
			 this.parent.removeChild(m_warnBox);
		}
		private function systemSetting(evt:MouseEvent):void
		{
			MJsound.play("soundBtn");
			if(!m_setBar.m_IsADD)
			{
				this.parent.addChild(m_setBar);
			}
			else
			{
				this.parent.removeChild(m_setBar);
			}
		}
		
		private function CharHandler(evt:MouseEvent):void
		{
			MJsound.play("soundBtn");
			if(!m_chat)
			m_chat=PopUpManager.createPopUp(this.parent,charBox,false) as charBox;
			else
			{
				PopUpManager.removePopUp(m_chat);
				m_chat=null;
			}
		}
	}
}