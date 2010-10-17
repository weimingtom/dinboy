package ruby.winTable
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import mx.core.UIComponent;
	
	import ruby.Event.*;
	import ruby.Model.ModelLocator;

	public class winTabelView extends UIComponent
	{
		[Bindable]
		private var TheModel:ModelLocator;
		
		public var main:MovieClip;
		public var OpenBtn:MovieClip;
		public var Time:MovieClip;
		private var m_bar0:MovieClip;
		private var m_bar1:MovieClip;
		private var m_bar2:MovieClip;
		private var m_bar3:MovieClip;
		private var m_mainBar:MovieClip;
		private var m_tabel:winTabel;
		
		private var m_bar0_Sco1:Array=new Array();
		private var m_bar1_Sco1:Array=new Array();
		private var m_bar2_Sco1:Array=new Array();
		private var m_bar3_Sco1:Array=new Array();
		
		private var m_bar0_Sco3:Array=new Array();
		private var m_bar1_Sco3:Array=new Array();
		private var m_bar2_Sco3:Array=new Array();
		private var m_bar3_Sco3:Array=new Array();
		
		private var m_bar0_Sco2:Array=new Array();
		private var m_bar1_Sco2:Array=new Array();
		private var m_bar2_Sco2:Array=new Array();
		private var m_bar3_Sco2:Array=new Array();
		
		private var m_bar0_Id:Array=new Array();
		private var m_bar1_Id:Array=new Array();
		private var m_bar2_Id:Array=new Array();
		private var m_bar3_Id:Array=new Array();
		
		private var m_Sco1:Array=new Array();
		private var m_Sco2:Array=new Array();
		private var m_Sco3:Array=new Array();
		private var m_Id:Array=new Array();
		
	
		private var m_base:TextField;
		private var m_tai:TextField;
		private var m_count:TextField;
		
		private var m_flag:Boolean=false;
		
		private var m_btn_continue:SimpleButton;
		private var m_btn_delay:SimpleButton;
		
		private var m_timer:Timer=new Timer(1000,30);
		
		private var publicPoint:Array;
		private var winIndex:int;
		private var winAndLosePoint:Array;
		private var totalPoint:Array;
		private var totalTai:int;
		private var totalWinAndLosePoint:Array;
		private var allUserPai:Array;
		private var bid:int;
		private var pai:int;
		private var sc:int;
		private var listTai:Array;
		
		public function winTabelView()
		{
			super();
		//	this.x=50;
		//	this.y=;
		
			m_timer.addEventListener(TimerEvent.TIMER,NumShowHandler);
			m_timer.addEventListener(TimerEvent.TIMER_COMPLETE,timerCompleteHandler);
			TheModel=ModelLocator.getInstance();
			TheModel.m_again[0]=4;
			TheModel.m_again[1]=4;
			TheModel.m_again[2]=4;
			TheModel.m_again[3]=4;
			m_tabel=new winTabel();
			m_Sco1.push(m_bar0_Sco1);
			m_Sco1.push(m_bar1_Sco1);
			m_Sco1.push(m_bar2_Sco1);
			m_Sco1.push(m_bar3_Sco1);
			
			m_Sco2.push(m_bar0_Sco2);
			m_Sco2.push(m_bar1_Sco2);
			m_Sco2.push(m_bar2_Sco2);
			m_Sco2.push(m_bar3_Sco2);
			
			m_Sco3.push(m_bar0_Sco3);
			m_Sco3.push(m_bar1_Sco3);
			m_Sco3.push(m_bar2_Sco3);
			m_Sco3.push(m_bar3_Sco3);
			
			m_Id.push(m_bar0_Id);
			m_Id.push(m_bar1_Id);
			m_Id.push(m_bar2_Id);
			m_Id.push(m_bar3_Id);
			
			main=m_tabel.main;
			Time=m_tabel.Time;
			OpenBtn=m_tabel.OpenBtn;
			m_bar0=main.Bar1;
			m_bar1=main.Bar2;
			m_bar2=main.Bar3;
			m_bar3=main.Bar4;
			m_mainBar=main.MainBar;
	        m_base=m_mainBar.base as TextField;
			m_tai=m_mainBar.tai as TextField;
			m_count=m_mainBar.count as TextField;
			m_btn_continue=m_tabel.m_btn_continue;
			m_btn_delay=m_tabel.m_btn_delay;
			addChild(m_tabel);
			stopStage();
			OpenBtn.addEventListener(MouseEvent.CLICK,clickHandler);
			main.addEventListener(Event.ENTER_FRAME,ENTER_FRAMEHandler);
			TheModel.addEventListener(EventCMD.WinTabel,initHandler);
			this.addEventListener(Event.ADDED_TO_STAGE,addEffect);
			
		  
			TheModel.addEventListener(EventCMD.otherAgain,otherAgain);
		}
		private function continueGame(evt:MouseEvent):void
		{
			TheModel.dispatchEvent(new PlayEvent(EventCMD.again,new Object()));
			m_btn_continue.removeEventListener(MouseEvent.CLICK,continueGame);
		}
		private function otherAgain(evt:PlayEvent):void
		{
			var uid:int=evt.m_data.uid;
			switch(uid)
			{
				case 1:
				TheModel.m_again[1]=1;
				break;
				case 2:
				TheModel.m_again[2]=1;
				break;
				case 3:
				TheModel.m_again[3]=0;
				break;
				default :
				break;
			}
			
		}
		private function ENTER_FRAMEHandler(evt:Event):void
		{
			
			if(main.currentFrame==1)
			{
				main.removeEventListener(Event.ENTER_FRAME,ENTER_FRAMEHandler);
				stopStage();
				if(m_flag)
				{
					viewShow();
                    particularCount();	
				}
			}
		}
		private function clickHandler(evt:MouseEvent):void
		{
			main.addEventListener(Event.ENTER_FRAME,ENTER_FRAMEHandler);
			if(main.currentFrame==2&&OpenBtn.currentFrame==1)/////收起
			{
				main.play();
				OpenBtn.play();
				
			}
			if(main.currentFrame==28&&OpenBtn.currentFrame==3)//////打开
			{
				main.play();
				OpenBtn.play();
			}
		}
		private function NumShowHandler(evt:TimerEvent):void
		{
			var count:int=m_timer.currentCount;
			var num:int=30;
			var index:int=num-count-1;
			
			m_tabel.Time.Clock.Num.Num1.gotoAndStop(int(index/10)+1);
		
			m_tabel.Time.Clock.Num.Num2.gotoAndStop(index%10+1);
		}
		private function timerCompleteHandler(evt:TimerEvent):void
		{
			m_timer.stop();
			m_timer.reset();
			TheModel.dispatchEvent(new PlayEvent(EventCMD.again,new Object()));
		}
		private function delayGameHandler(evt:MouseEvent):void
		{
			m_timer.reset();
			m_timer.start();
		    var obj:Object=new Object();
		    obj.message="wtd";
		    m_btn_delay.removeEventListener(MouseEvent.CLICK,delayGameHandler);
		    TheModel.dispatchEvent(new PlayEvent(EventCMD.SysDelay,obj));
		}
		private function addEffect(evt:Event):void
		{
	//		main.gotoAndPlay("Open");
	//		PopUpManager.centerPopUp(this);	
	      main.gotoAndPlay(1);
	      
	      OpenBtn.gotoAndStop(1);
	      m_btn_continue.addEventListener(MouseEvent.CLICK,continueGame);
	      m_btn_delay.addEventListener(MouseEvent.CLICK,delayGameHandler);
	      m_timer.start();
		}
        private function stopStage():void
		{
			var i:int;
			var j:int;

			/****/
			main=m_tabel.main;
			Time=m_tabel.Time;
			OpenBtn=m_tabel.OpenBtn;
			m_bar0=main.Bar1;
			m_bar1=main.Bar2;
			m_bar2=main.Bar3;
			m_bar3=main.Bar4;
			m_mainBar=main.MainBar;
	       
	        m_base=m_mainBar.base as TextField;
			m_tai=m_mainBar.tai as TextField;
			m_count=m_mainBar.count as TextField;
			
			
			m_bar0_Sco1[0]=m_bar0.Sco1.Num12;
			m_bar0_Sco1[1]=m_bar0.Sco1.Num11;
			m_bar0_Sco1[2]=m_bar0.Sco1.Num10;
			m_bar0_Sco1[3]=m_bar0.Sco1.Num9;
			m_bar0_Sco1[4]=m_bar0.Sco1.Num8;
			m_bar0_Sco1[5]=m_bar0.Sco1.Num7;
			m_bar0_Sco1[6]=m_bar0.Sco1.Num6;
			m_bar0_Sco1[7]=m_bar0.Sco1.Num5;
			m_bar0_Sco1[8]=m_bar0.Sco1.Num4;
			m_bar0_Sco1[9]=m_bar0.Sco1.Num3;
			m_bar0_Sco1[10]=m_bar0.Sco1.Num2;
			m_bar0_Sco1[11]=m_bar0.Sco1.Num1;
			
			m_bar1_Sco1[0]=m_bar1.Sco1.Num12;
			m_bar1_Sco1[1]=m_bar1.Sco1.Num11;
			m_bar1_Sco1[2]=m_bar1.Sco1.Num10;
			m_bar1_Sco1[3]=m_bar1.Sco1.Num9;
			m_bar1_Sco1[4]=m_bar1.Sco1.Num8;
			m_bar1_Sco1[5]=m_bar1.Sco1.Num7;
			m_bar1_Sco1[6]=m_bar1.Sco1.Num6;
			m_bar1_Sco1[7]=m_bar1.Sco1.Num5;
			m_bar1_Sco1[8]=m_bar1.Sco1.Num4;
			m_bar1_Sco1[9]=m_bar1.Sco1.Num3;
			m_bar1_Sco1[10]=m_bar1.Sco1.Num2;
			m_bar1_Sco1[11]=m_bar1.Sco1.Num1;
			
			m_bar2_Sco1[0]=m_bar2.Sco1.Num12;
			m_bar2_Sco1[1]=m_bar2.Sco1.Num11;
			m_bar2_Sco1[2]=m_bar2.Sco1.Num10;
			m_bar2_Sco1[3]=m_bar2.Sco1.Num9;
			m_bar2_Sco1[4]=m_bar2.Sco1.Num8;
			m_bar2_Sco1[5]=m_bar2.Sco1.Num7;
			m_bar2_Sco1[6]=m_bar2.Sco1.Num6;
			m_bar2_Sco1[7]=m_bar2.Sco1.Num5;
			m_bar2_Sco1[8]=m_bar2.Sco1.Num4;
			m_bar2_Sco1[9]=m_bar2.Sco1.Num3;
			m_bar2_Sco1[10]=m_bar2.Sco1.Num2;
			m_bar2_Sco1[11]=m_bar2.Sco1.Num1;
			
			
			m_bar3_Sco1[0]=m_bar3.Sco1.Num12;
			m_bar3_Sco1[1]=m_bar3.Sco1.Num11;
			m_bar3_Sco1[2]=m_bar3.Sco1.Num10;
			m_bar3_Sco1[3]=m_bar3.Sco1.Num9;
			m_bar3_Sco1[4]=m_bar3.Sco1.Num8;
			m_bar3_Sco1[5]=m_bar3.Sco1.Num7;
			m_bar3_Sco1[6]=m_bar3.Sco1.Num6;
			m_bar3_Sco1[7]=m_bar3.Sco1.Num5;
			m_bar3_Sco1[8]=m_bar3.Sco1.Num4;
			m_bar3_Sco1[9]=m_bar3.Sco1.Num3;
			m_bar3_Sco1[10]=m_bar3.Sco1.Num2;
			m_bar3_Sco1[11]=m_bar3.Sco1.Num1;
			
			m_bar0_Sco2[0]=m_bar0.Sco2.Num12;
			m_bar0_Sco2[1]=m_bar0.Sco2.Num11;
			m_bar0_Sco2[2]=m_bar0.Sco2.Num10;
			m_bar0_Sco2[3]=m_bar0.Sco2.Num9;
			m_bar0_Sco2[4]=m_bar0.Sco2.Num8;
			m_bar0_Sco2[5]=m_bar0.Sco2.Num7;
			m_bar0_Sco2[6]=m_bar0.Sco2.Num6;
			m_bar0_Sco2[7]=m_bar0.Sco2.Num5;
			m_bar0_Sco2[8]=m_bar0.Sco2.Num4;
			m_bar0_Sco2[9]=m_bar0.Sco2.Num3;
			m_bar0_Sco2[10]=m_bar0.Sco2.Num2;
			m_bar0_Sco2[11]=m_bar0.Sco2.Num1;
			
			m_bar1_Sco2[0]=m_bar1.Sco2.Num12;
			m_bar1_Sco2[1]=m_bar1.Sco2.Num11;
			m_bar1_Sco2[2]=m_bar1.Sco2.Num10;
			m_bar1_Sco2[3]=m_bar1.Sco2.Num9;
			m_bar1_Sco2[4]=m_bar1.Sco2.Num8;
			m_bar1_Sco2[5]=m_bar1.Sco2.Num7;
			m_bar1_Sco2[6]=m_bar1.Sco2.Num6;
			m_bar1_Sco2[7]=m_bar1.Sco2.Num5;
			m_bar1_Sco2[8]=m_bar1.Sco2.Num4;
			m_bar1_Sco2[9]=m_bar1.Sco2.Num3;
			m_bar1_Sco2[10]=m_bar1.Sco2.Num2;
			m_bar1_Sco2[11]=m_bar1.Sco2.Num1;
			
			m_bar2_Sco2[0]=m_bar2.Sco2.Num12;
			m_bar2_Sco2[1]=m_bar2.Sco2.Num11;
			m_bar2_Sco2[2]=m_bar2.Sco2.Num10;
			m_bar2_Sco2[3]=m_bar2.Sco2.Num9;
			m_bar2_Sco2[4]=m_bar2.Sco2.Num8;
			m_bar2_Sco2[5]=m_bar2.Sco2.Num7;
			m_bar2_Sco2[6]=m_bar2.Sco2.Num6;
			m_bar2_Sco2[7]=m_bar2.Sco2.Num5;
			m_bar2_Sco2[8]=m_bar2.Sco2.Num4;
			m_bar2_Sco2[9]=m_bar2.Sco2.Num3;
			m_bar2_Sco2[10]=m_bar2.Sco2.Num2;
			m_bar2_Sco2[11]=m_bar2.Sco2.Num1;
			
			m_bar3_Sco2[0]=m_bar3.Sco2.Num12;
			m_bar3_Sco2[1]=m_bar3.Sco2.Num11;
			m_bar3_Sco2[2]=m_bar3.Sco2.Num10;
			m_bar3_Sco2[3]=m_bar3.Sco2.Num9;
			m_bar3_Sco2[4]=m_bar3.Sco2.Num8;
			m_bar3_Sco2[5]=m_bar3.Sco2.Num7;
			m_bar3_Sco2[6]=m_bar3.Sco2.Num6;
			m_bar3_Sco2[7]=m_bar3.Sco2.Num5;
			m_bar3_Sco2[8]=m_bar3.Sco2.Num4;
			m_bar3_Sco2[9]=m_bar3.Sco2.Num3;
			m_bar3_Sco2[10]=m_bar3.Sco2.Num2;
			m_bar3_Sco2[11]=m_bar3.Sco2.Num1;
			
			m_bar0_Sco3[0]=m_bar0.Sco3.Num12;
			m_bar0_Sco3[1]=m_bar0.Sco3.Num11;
			m_bar0_Sco3[2]=m_bar0.Sco3.Num10;
			m_bar0_Sco3[3]=m_bar0.Sco3.Num9;
			m_bar0_Sco3[4]=m_bar0.Sco3.Num8;
			m_bar0_Sco3[5]=m_bar0.Sco3.Num7;
			m_bar0_Sco3[6]=m_bar0.Sco3.Num6;
			m_bar0_Sco3[7]=m_bar0.Sco3.Num5;
			m_bar0_Sco3[8]=m_bar0.Sco3.Num4;
			m_bar0_Sco3[9]=m_bar0.Sco3.Num3;
			m_bar0_Sco3[10]=m_bar0.Sco3.Num2;
			m_bar0_Sco3[11]=m_bar0.Sco3.Num1;
			
			m_bar1_Sco3[0]=m_bar1.Sco3.Num12;
			m_bar1_Sco3[1]=m_bar1.Sco3.Num11;
			m_bar1_Sco3[2]=m_bar1.Sco3.Num10;
			m_bar1_Sco3[3]=m_bar1.Sco3.Num9;
			m_bar1_Sco3[4]=m_bar1.Sco3.Num8;
			m_bar1_Sco3[5]=m_bar1.Sco3.Num7;
			m_bar1_Sco3[6]=m_bar1.Sco3.Num6;
			m_bar1_Sco3[7]=m_bar1.Sco3.Num5;
			m_bar1_Sco3[8]=m_bar1.Sco3.Num4;
			m_bar1_Sco3[9]=m_bar1.Sco3.Num3;
			m_bar1_Sco3[10]=m_bar1.Sco3.Num2;
			m_bar1_Sco3[11]=m_bar1.Sco3.Num1;
			
			m_bar2_Sco3[0]=m_bar2.Sco3.Num12;
			m_bar2_Sco3[1]=m_bar2.Sco3.Num11;
			m_bar2_Sco3[2]=m_bar2.Sco3.Num10;
			m_bar2_Sco3[3]=m_bar2.Sco3.Num9;
			m_bar2_Sco3[4]=m_bar2.Sco3.Num8;
			m_bar2_Sco3[5]=m_bar2.Sco3.Num7;
			m_bar2_Sco3[6]=m_bar2.Sco3.Num6;
			m_bar2_Sco3[7]=m_bar2.Sco3.Num5;
			m_bar2_Sco3[8]=m_bar2.Sco3.Num4;
			m_bar2_Sco3[9]=m_bar2.Sco3.Num3;
			m_bar2_Sco3[10]=m_bar2.Sco3.Num2;
			m_bar2_Sco3[11]=m_bar2.Sco3.Num1;
			
			m_bar3_Sco3[0]=m_bar3.Sco3.Num12;
			m_bar3_Sco3[1]=m_bar3.Sco3.Num11;
			m_bar3_Sco3[2]=m_bar3.Sco3.Num10;
			m_bar3_Sco3[3]=m_bar3.Sco3.Num9;
			m_bar3_Sco3[4]=m_bar3.Sco3.Num8;
			m_bar3_Sco3[5]=m_bar3.Sco3.Num7;
			m_bar3_Sco3[6]=m_bar3.Sco3.Num6;
			m_bar3_Sco3[7]=m_bar3.Sco3.Num5;
			m_bar3_Sco3[8]=m_bar3.Sco3.Num4;
			m_bar3_Sco3[9]=m_bar3.Sco3.Num3;
			m_bar3_Sco3[10]=m_bar3.Sco3.Num2;
			m_bar3_Sco3[11]=m_bar3.Sco3.Num1;
			
			m_bar0_Id[0]=m_bar0.Id.Num7;
			m_bar0_Id[1]=m_bar0.Id.Num6;
			m_bar0_Id[2]=m_bar0.Id.Num5;
			m_bar0_Id[3]=m_bar0.Id.Num4;
			m_bar0_Id[4]=m_bar0.Id.Num3;
			m_bar0_Id[5]=m_bar0.Id.Num2;
			m_bar0_Id[6]=m_bar0.Id.Num1;
			
			m_bar1_Id[0]=m_bar1.Id.Num7;
			m_bar1_Id[1]=m_bar1.Id.Num6;
			m_bar1_Id[2]=m_bar1.Id.Num5;
			m_bar1_Id[3]=m_bar1.Id.Num4;
			m_bar1_Id[4]=m_bar1.Id.Num3;
			m_bar1_Id[5]=m_bar1.Id.Num2;
			m_bar1_Id[6]=m_bar1.Id.Num1;
			
			m_bar2_Id[0]=m_bar2.Id.Num7;
			m_bar2_Id[1]=m_bar2.Id.Num6;
			m_bar2_Id[2]=m_bar2.Id.Num5;
			m_bar2_Id[3]=m_bar2.Id.Num4;
			m_bar2_Id[4]=m_bar2.Id.Num3;
			m_bar2_Id[5]=m_bar2.Id.Num2;
			m_bar2_Id[6]=m_bar2.Id.Num1;
			
			m_bar3_Id[0]=m_bar3.Id.Num7;
			m_bar3_Id[1]=m_bar3.Id.Num6;
			m_bar3_Id[2]=m_bar3.Id.Num5;
			m_bar3_Id[3]=m_bar3.Id.Num4;
			m_bar3_Id[4]=m_bar3.Id.Num3;
			m_bar3_Id[5]=m_bar3.Id.Num2;
			m_bar3_Id[6]=m_bar3.Id.Num1;
			
			
			/****/
			
			m_bar0.WindSeat.gotoAndStop(5);
			m_bar1.WindSeat.gotoAndStop(5);
			m_bar2.WindSeat.gotoAndStop(5);
			m_bar3.WindSeat.gotoAndStop(5);
			
		//	m_tabel.main["Bar4"]["WindSeat"].y+=100;
			
			//m_tabel.main.Bar4.x += 100;
			
			m_bar0.Eye.gotoAndStop(2);
			m_bar1.Eye.gotoAndStop(2);
			m_bar2.Eye.gotoAndStop(2);
			m_bar3.Eye.gotoAndStop(2);
			
			m_bar0.Wind.gotoAndStop(5);
			m_bar1.Wind.gotoAndStop(5);
			m_bar2.Wind.gotoAndStop(5);
			m_bar3.Wind.gotoAndStop(5);
			
	       for(i=0;i<4;i++)
	       {
	       	for(j=0;j<12;j++)
	       	{
	       		m_Sco1[i][j].gotoAndStop(14);
	       		m_Sco2[i][j].gotoAndStop(14);
	       		m_Sco3[i][j].gotoAndStop(14);
	       	}
	       }
	       
	        for(i=0;i<4;i++)
	       {
	       	for(j=0;j<7;j++)
	       	{
	       		m_Id[i][j].gotoAndStop(14);
	       	}
	       }
			
			m_bar0.pStage.gotoAndStop(4);
			m_bar1.pStage.gotoAndStop(4);
			m_bar2.pStage.gotoAndStop(4);
			m_bar3.pStage.gotoAndStop(4);
			
			m_bar0.OtherGet.gotoAndStop(1);
			m_bar1.OtherGet.gotoAndStop(1);
			m_bar2.OtherGet.gotoAndStop(1);
			m_bar3.OtherGet.gotoAndStop(1);
		}
		
		private function initHandler(evt:PlayEvent):void
		{
			 trace("initHandler");
			 publicPoint=evt.m_data.pubPoint;  //公点[自家,下家,对家,上家]
			 winIndex=evt.m_data.winIndex; //赢家索引
			 winAndLosePoint=evt.m_data.winAndLosePoint;  //输赢点数[自家,下家,对家,上家]
			 totalPoint=evt.m_data.totalPoint;   //用户余额[自家,下家,对家,上家]
			 totalTai=evt.m_data.totalTai;  //总台数
			 listTai=evt.m_data.listTai;/////二维数组  //台数明细
			 totalWinAndLosePoint=evt.m_data.totalWinAndLosePoint; // 用户总输赢点数[自家,下家,对家,上家]
         	 allUserPai=evt.m_data.allUserPai;  /////用户手中的牌[自家,下家,对家,上家]
             bid=evt.m_data.bid;  //被胡牌玩家索引
             pai=evt.m_data.pai;  ////胡的牌
             sc=evt.m_data.sc[0]; //////	胡	9  /	流局	-3		
             viewShow();
             particularCount();
             m_flag=true;
		}
		
		
		/*********************///
		
		private function viewShow():void
		{
			trace("**********************************");
			var i:int;
			var j:int;
			var cidWin:int=(winIndex+4-TheModel.m_ID)%4;
			m_mainBar.Num.Num1.gotoAndStop(int(totalTai/10));
			m_mainBar.Num.Num1.gotoAndStop(totalTai%10);
			
			var index0_publicPoint:Array=getIndex(publicPoint[0]);
			var index1_publicPoint:Array=getIndex(publicPoint[1]);
			var index2_publicPoint:Array=getIndex(publicPoint[2]);
			var index3_publicPoint:Array=getIndex(publicPoint[3]);
			trace("index0_publicPoint="+index0_publicPoint);
			trace("index1_publicPoint="+index1_publicPoint);
			trace("index2_publicPoint="+index2_publicPoint);
			trace("index3_publicPoint="+index3_publicPoint);
			
			var index0_winAndLosePoint:Array=getIndex(winAndLosePoint[0]);
			var index1_winAndLosePoint:Array=getIndex(winAndLosePoint[1]);
			var index2_winAndLosePoint:Array=getIndex(winAndLosePoint[2]);
			var index3_winAndLosePoint:Array=getIndex(winAndLosePoint[3]);
			
			trace("index0_winAndLosePoint="+index0_winAndLosePoint);
			trace("index1_winAndLosePoint="+index1_winAndLosePoint);
			trace("index2_winAndLosePoint="+index2_winAndLosePoint);
			trace("index3_winAndLosePoint="+index3_winAndLosePoint);
			
			var index0_totalWinAndLosePoint:Array=getIndex(totalWinAndLosePoint[0]);
			var index1_totalWinAndLosePoint:Array=getIndex(totalWinAndLosePoint[1]);
			var index2_totalWinAndLosePoint:Array=getIndex(totalWinAndLosePoint[2]);
			var index3_totalWinAndLosePoint:Array=getIndex(totalWinAndLosePoint[3]);
			
			trace("index0_totalWinAndLosePoint="+index0_totalWinAndLosePoint);
			trace("index1_totalWinAndLosePoint="+index1_totalWinAndLosePoint);
			trace("index2_totalWinAndLosePoint="+index2_totalWinAndLosePoint);
			trace("index3_totalWinAndLosePoint="+index3_totalWinAndLosePoint);
			
			
			var index0_totalPoint:Array=getIndex(totalPoint[0]);
			var index1_totalPoint:Array=getIndex(totalPoint[1]);
			var index2_totalPoint:Array=getIndex(totalPoint[2]);
			var index3_totalPoint:Array=getIndex(totalPoint[3]);
			
			trace("index0_totalPoint="+index0_totalPoint);
			trace("index1_totalPoint="+index1_totalPoint);
			trace("index2_totalPoint="+index2_totalPoint);
			trace("index3_totalPoint="+index3_totalPoint);
			
		     for(j=0;j<index0_winAndLosePoint.length;j++)
		     {
		     	m_Sco1[0][j].gotoAndStop(index0_winAndLosePoint[j]);
		     }
		     
		     for(j=0;j<index1_winAndLosePoint.length;j++)
		     {
		     	m_Sco1[1][j].gotoAndStop(index1_winAndLosePoint[j]);
		     }
		     
		     for(j=0;j<index2_winAndLosePoint.length;j++)
		     {
		     	m_Sco1[2][j].gotoAndStop(index2_winAndLosePoint[j]);
		     }
		     
		     for(j=0;j<index3_winAndLosePoint.length;j++)
		     {
		     	m_Sco1[3][j].gotoAndStop(index3_winAndLosePoint[j]);
		     }
		     
		     
		      for(j=0;j<index0_publicPoint.length;j++)
		     {
		     	m_Sco2[0][j].gotoAndStop(index0_publicPoint[j]);
		     }
		     
		     for(j=0;j<index1_publicPoint.length;j++)
		     {
		     	m_Sco2[1][j].gotoAndStop(index1_publicPoint[j]);
		     }
		     
		     for(j=0;j<index2_publicPoint.length;j++)
		     {
		     	m_Sco2[2][j].gotoAndStop(index2_publicPoint[j]);
		     }
		     
		     for(j=0;j<index3_publicPoint.length;j++)
		     {
		     	m_Sco2[3][j].gotoAndStop(index3_publicPoint[j]);
		     }
		     
		     
		     for(i=0;i<index0_totalWinAndLosePoint.length;i++)
		     {
		     
		     	m_Id[0][i].gotoAndStop(index0_totalWinAndLosePoint[i]);
		     }
		     
		      for(i=0;i<index1_totalWinAndLosePoint.length;i++)
		     {
		     	
		     	m_Id[1][i].gotoAndStop(index1_totalWinAndLosePoint[i]);
		     }
		     
		      for(i=0;i<index2_totalWinAndLosePoint.length;i++)
		     {
		     	
		     	m_Id[2][i].gotoAndStop(index2_totalWinAndLosePoint[i]);
		     }
		     
		      for(i=0;i<index3_totalWinAndLosePoint.length;i++)
		     {
		     	
		     	m_Id[3][i].gotoAndStop(index3_totalWinAndLosePoint[i]);
		     }
		     
		     for(i=0;i<index0_totalPoint.length;i++)
		     {			     
		     	m_Sco3[0][i].gotoAndStop(index0_totalPoint[i]);
		     }
		     
		     for(i=0;i<index1_totalPoint.length;i++)
		     {
		     	m_Sco3[1][i].visible=true;
		     	m_Sco3[1][i].gotoAndStop(index1_totalPoint[i]);
		     }
		     
		     for(i=0;i<index2_totalPoint.length;i++)
		     {
		     	m_Sco3[2][i].visible=true;
		     	m_Sco3[2][i].gotoAndStop(index2_totalPoint[i]);
		     }
		     
		     for(i=0;i<index3_totalPoint.length;i++)
		     {
		     	m_Sco3[3][i].visible=true;
		     	m_Sco3[3][i].gotoAndStop(index3_totalPoint[i]);
		     }
			     
	     	m_bar1.pStage.gotoAndStop(TheModel.m_again[1]);
			m_bar2.pStage.gotoAndStop(TheModel.m_again[1]);
			m_bar3.pStage.gotoAndStop(TheModel.m_again[1]);
			     
			switch(TheModel.m_ID)
			{
				case 1:
				m_bar0.WindSeat.gotoAndStop(1);
				m_bar1.WindSeat.gotoAndStop(2);
				m_bar2.WindSeat.gotoAndStop(3);
				m_bar3.WindSeat.gotoAndStop(4);
		
				break;
				case 2:
				m_bar0.WindSeat.gotoAndStop(2);
				m_bar1.WindSeat.gotoAndStop(3);
				m_bar2.WindSeat.gotoAndStop(4);
				m_bar3.WindSeat.gotoAndStop(1);
		
				break;
				case 3:
				m_bar0.WindSeat.gotoAndStop(3);
				m_bar1.WindSeat.gotoAndStop(4);
				m_bar2.WindSeat.gotoAndStop(1);
				m_bar3.WindSeat.gotoAndStop(2);
		
				break;
				case 4:
				m_bar0.WindSeat.gotoAndStop(4);
				m_bar1.WindSeat.gotoAndStop(1);
				m_bar2.WindSeat.gotoAndStop(2);
				m_bar3.WindSeat.gotoAndStop(3);
			
				break;
				default:
				break;
			}
			//////switch	
			
	}
	
		public function particularCount():void
		{
			var i:int;
			var j:int;
		//	m_count
		    var str:String="";
			
			for(i=0;i<listTai.length;i++)
			{
				switch(listTai[i][0])
				{
					case 1:
					str+="八仙过海";
				    break;
				    case 2:
				    str+="七抢一";
				    break;
				    case 3:
				    str+="大四喜";
				    break;
				    case 4:
				    str+="小四喜";
				    break;
				    case 5:
				    str+="大叁元";
				    break;
				    case 6:
				    str+="小叁元";
				    break
				    case 7:
				    str+="清一色";
				    break
				    case 8:
				    str+="混一色";
				    break;
				    case 9:
				    str+="五暗刻";
				    break
				    case 10:
				    str+="四暗刻";
				    break;
				    case 11:
				    str+="叁暗刻";
				    break;
				    case 12:
				    str+="碰碰胡";
				    break;
				    case 13:
				    str+="平胡";
				    break;
				    case 14:
				    str+="庄家";
				    break;
				    case 15:
				    str+="连庄拉庄";
				    break;
				    case 16:
				    str+="门清";
				    break;
				    case 17:
				    str+="自摸";
				    break;
				    case 18:
				    str+="门清自摸";
				    break;
				    case 19:
				    str+="东风圈";
				    break;
				    case 20:
				    str+="南风圈";
				    break;
				    case 21:
				    str+="西风圈";
				    break;
				    case 22:
				    str+="北风圈";
				    break;
				    case 23:
				    str+="东风位";
				    break;
				    case 24:
				    str+="南风位";
				    break;
				    case 25:
				    str+="西风位";
				    break;
				    case 26:
				    str+="北风位";
				    break;
				    case 27:
				    str+="红中";
				    break;
				    case 28:
				    str+="青发";
				    break;
				    case 29:
				    str+="白板";
				    break;
				    case 30:
				    str+="花牌";
				    break;
				    case 31:
				    str+="海底捞月";
				    break;
				    case 32:
				    str+="全求人";
				    break;
				    case 33:
				    str+="眼牌";
				    break;
				    case 34:
				    str+="花槓";
				    break;
				    case 35:
				    str+="抢槓胡";
				    break;
				    case 36:
				    str+="槓上开花";
				    break;
				    case 37:
				    str+="单吊";
				    break;
				    case 38:
				    str+="miji";
				    break;
				    case 39:
				    str+="天胡";
				    break;
				    case 40:
				    str+="地胡";
				    break;
				    case 41:
				    str+="人胡";
				    break;
				    case 43:
				    str+="庄家";
				    break;
				    default:
				    break;
				}
				str+=listTai[i][1].toString()+"台\n";
			}
			m_count.text=str;
		}
			
		public function getIndex(Num:Number):Array
	{
		var position:Array=new Array();
		var i:int;
		var Numstr:String=Num.toString();
		
	    for(i=Numstr.length-1;i>=0;i--)  /////反序帧代表的位置
		{
			if(Numstr.charAt(i)=='-')
			{
				position.push(13);
				continue;
			}
			if(Numstr.charAt(i)=='.')
			{
				position.push(11);
				continue;
			}
			position.push(parseInt(Numstr.charAt(i))+1);
		}
		if(Num>0)
		{
			position.push(12);
		}
		return position;
	}
		
	}
}