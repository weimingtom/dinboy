package ruby.winTable
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.binding.utils.BindingUtils;
	import mx.core.Application;
	import mx.core.UIComponent;
	import ruby.music.MJsound;

    [Embed(source="settingBar.swf",symbol="settingBar")]
	public class setting extends UIComponent
	{
		public var sound1MC:MovieClip;
		public var sound2MC:MovieClip;
		public var sound3MC:MovieClip;
		public var sound4MC:MovieClip;
		public var sound5MC:MovieClip;
		
		public var openMC:MovieClip;
		public var closeMC:MovieClip;
		public var quitGameMC2:MovieClip;///离开游戏MC
		public var quitMC2:MovieClip; ////取消MC
		public var enterMC2:MovieClip;////确定MC
		
		public var sound1Btn:SimpleButton;
		public var sound2Btn:SimpleButton;
		public var sound3Btn:SimpleButton;
		public var sound4Btn:SimpleButton;
		public var sound5Btn:SimpleButton;
		
		public var openBtn:SimpleButton;
		public var closeBtn:SimpleButton;
		public var quitGameBtn:SimpleButton;/////离开游戏Btn
		public var quitBtn:SimpleButton;////取消
		public var enterBtn:SimpleButton;////确定
		
		public var m_IsADD:Boolean;
		
		
	    
	
	
		public var LeftMC:MovieClip;
		
		private var m_soundVelue:Number=1;
		
		private var soundVelue:Number=1;
		
		private var m_isOpen:Boolean=true;
	//	private var m_isClose:Boolean;
		
		[Bindable]
		public var m_Open:Boolean=true;;
		
		
		
		
		public function setting()
		{
			super();
			this.scaleX=0.5;
			this.scaleY=0.5;
			this.y=430;
			LeftMC.visible=false;
			sound1MC.mouseEnabled=false;
			sound2MC.mouseEnabled=false;
			sound3MC.mouseEnabled=false;
			sound4MC.mouseEnabled=false;
			sound5MC.mouseEnabled=false;
			closeMC.mouseEnabled=false;
			openMC.mouseEnabled=false;
			quitGameMC2.mouseEnabled=false;
			quitMC2.mouseEnabled=false;
			enterMC2.mouseEnabled=false;
			LeftMC.quitEnterMC2.mouseEnabled=false;
			LeftMC.quitCloseMC1.mouseEnabled=false;
			
			
			BindingUtils.bindSetter(setOpen,this,"m_Open",false);

			this.addEventListener(Event.ADDED_TO_STAGE,addToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE,removeFromStageHandler);
			
			
			sound1Btn.addEventListener(MouseEvent.CLICK,sound1BtnHandler);
			sound2Btn.addEventListener(MouseEvent.CLICK,sound2BtnHandler);
			sound3Btn.addEventListener(MouseEvent.CLICK,sound3BtnHandler);
			sound4Btn.addEventListener(MouseEvent.CLICK,sound4BtnHandler);
			sound5Btn.addEventListener(MouseEvent.CLICK,sound5BtnHandler);
			
			openBtn.addEventListener(MouseEvent.CLICK,openBtnHandler);
			closeBtn.addEventListener(MouseEvent.CLICK,closeBtnHandler);
			quitGameBtn.addEventListener(MouseEvent.CLICK,quitGameHandler);
			LeftMC.quitEnterBtn.addEventListener(MouseEvent.CLICK,quitEnterHandler);
			LeftMC.quitCloseBtn.addEventListener(MouseEvent.CLICK,quitCloseHandler);
			enterBtn.addEventListener(MouseEvent.CLICK,enterBtnHandler);
			quitBtn.addEventListener(MouseEvent.CLICK,quitBtnHandler);
			
		}
		private function addToStageHandler(evt:Event):void
		{
			m_IsADD=true;
			LeftMC.visible=false;
			trace("###########################="+m_isOpen);
		}
		private function removeFromStageHandler(evt:Event):void
		{
			m_IsADD=false;
		}
		private function initStage():void
		{
			
		}
		public function setOpen(b:Boolean):void
		{
		   
			openMC.visible=b;
			closeMC.visible=!b;
		}
	
		private function sound1BtnHandler(evt:MouseEvent):void
		{
			sound1MC.visible=true;
			soundVelue=0.2;
			sound1MC.visible=false;
			sound2MC.visible=false;
			sound3MC.visible=false;
			sound4MC.visible=false;
		
		}
		private function sound2BtnHandler(evt:MouseEvent):void
		{
			sound2MC.visible=true;
			soundVelue=0.4;
			
			sound1MC.visible=true;
			sound3MC.visible=false;
			sound4MC.visible=false;
			sound5MC.visible=false;
	
		}
		private function sound3BtnHandler(evt:MouseEvent):void
		{
			sound3MC.visible=true;
			soundVelue=0.6;
			sound1MC.visible=true;
			sound2MC.visible=true;
			sound4MC.visible=false;
			sound5MC.visible=false;
	
		}
		private function sound4BtnHandler(evt:MouseEvent):void
		{
			sound4MC.visible=true;
			soundVelue=0.8;
			sound1MC.visible=true;
			sound2MC.visible=true;
			sound3MC.visible=true;
			sound5MC.visible=false;
		
		}
		private function sound5BtnHandler(evt:MouseEvent):void
		{
			sound5MC.visible=true;
			sound1MC.visible=true;
			sound2MC.visible=true;
			sound3MC.visible=true;
			sound4MC.visible=true;
			soundVelue=1;

		}
		private function openBtnHandler(evt:MouseEvent):void
		{
			m_Open=!m_Open;
		}
		private function closeBtnHandler(evt:MouseEvent):void
		{
			m_Open=!m_Open;
		}
		private function quitGameHandler(evt:MouseEvent):void
		{
			MJsound.play("soundBtn");
			LeftMC.visible=true;
			
		}
		private function quitEnterHandler(evt:MouseEvent):void
		{
			MJsound.play("soundBtn");
			Application.application.close();
			
		}
		private function quitCloseHandler(evt:MouseEvent):void
		{
			MJsound.play("soundBtn");
			LeftMC.visible=false;
		}
		private function enterBtnHandler(evt:MouseEvent):void
		{
			MJsound.play("soundBtn");
			m_isOpen=m_Open;
			m_soundVelue=soundVelue;
			trace("m_isOpen="+m_isOpen);
			trace("m_soundVelue="+m_soundVelue);
			
			switch(m_soundVelue)
			{
				case 0.2:
			sound1MC.visible=true;
			sound1MC.visible=false;
			sound2MC.visible=false;
			sound3MC.visible=false;
			sound4MC.visible=false;
				break;
				case 0.4:
			sound2MC.visible=true;
			sound1MC.visible=true;
			sound3MC.visible=false;
			sound4MC.visible=false;
			sound5MC.visible=false;
				break;
				case 0.6:
			sound3MC.visible=true;
			sound1MC.visible=true;
			sound2MC.visible=true;
			sound4MC.visible=false;
			sound5MC.visible=false;
				break;
				case 0.8:
			sound4MC.visible=true;
			sound1MC.visible=true;
			sound2MC.visible=true;
			sound3MC.visible=true;
			sound5MC.visible=false;
				break;
				case 1:
			sound5MC.visible=true;
			sound1MC.visible=true;
			sound2MC.visible=true;
			sound3MC.visible=true;
			sound4MC.visible=true;
				break;
				default:
				break;
			}
			
				openMC.visible=m_isOpen;
				closeMC.visible=!m_isOpen;
				if(!m_isOpen)
				m_soundVelue=0;
				Application.application.v3.volume=m_soundVelue;
			this.parent.removeChild(this);
			m_IsADD=false;
		}
		private function quitBtnHandler(evt:MouseEvent):void
		{
			trace("************************="+m_soundVelue);
			MJsound.play("soundBtn");
			switch(m_soundVelue)
			{
			case 0.2:
			sound1MC.visible=true;
			sound1MC.visible=false;
			sound2MC.visible=false;
			sound3MC.visible=false;
			sound4MC.visible=false;
				break;
			case 0.4:
			sound2MC.visible=true;
			sound1MC.visible=true;
			sound3MC.visible=false;
			sound4MC.visible=false;
			sound5MC.visible=false;
				break;
				case 0.6:
			sound3MC.visible=true;
			sound1MC.visible=true;
			sound2MC.visible=true;
			sound4MC.visible=false;
			sound5MC.visible=false;
				break;
				case 0.8:
			sound4MC.visible=true;
			sound1MC.visible=true;
			sound2MC.visible=true;
			sound3MC.visible=true;
			sound5MC.visible=false;
				break;
				case 1:
			sound5MC.visible=true;
			sound1MC.visible=true;
			sound2MC.visible=true;
			sound3MC.visible=true;
			sound4MC.visible=true;
				break;
				default:
				break;
			}
			openMC.visible=m_isOpen;
			closeMC.visible=!m_isOpen;
			this.parent.removeChild(this);
		}
			
	}
}