package ruby.controlCommpent
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	
	import mx.binding.utils.BindingUtils;
	import mx.core.UIComponent;
	import mx.effects.Fade;
	
	import ruby.Event.*;
	import ruby.Model.ModelLocator;
	import ruby.music.MJsound;

	public class UsercontrolBar extends UIComponent
	{
		public var bar:ChoiceBar;
		public var m_Btn_chi:MovieClip;
		public var m_Btn_pen:MovieClip;
		public var m_Btn_gang:MovieClip;
		public var m_Btn_cancel:SimpleButton;
		
		[Bindable]
		public var effect:Boolean;
		
		[Bindable]
		private var TheModel:ModelLocator;
		
		public function UsercontrolBar()
		{
			super();
			y+=25;
			TheModel = ModelLocator.getInstance();
			bar = new ChoiceBar();
			addChild(bar);
			m_Btn_chi = bar.m_btn_chi;
			m_Btn_pen = bar.m_btn_pen;
			m_Btn_gang = bar.m_btn_gang;
			m_Btn_cancel = bar.m_btn_cancel;

			BindingUtils.bindSetter(setEffectOff,this,"effect",true);
	  
			TheModel.addEventListener(EventCMD.otherCHI,otherCHI1);
			TheModel.addEventListener(EventCMD.otherPEN,otherPEN1);
			TheModel.addEventListener(EventCMD.otherGANG,otherGANG1);
			m_Btn_cancel.addEventListener(MouseEvent.CLICK,cancelHandler);
		}
		
		public function OffSet():void	// 取消吃，碰，杠
		{
			TheModel.removeEventListener(EventCMD.otherCHI,otherCHI1);
			TheModel.removeEventListener(EventCMD.otherPEN,otherPEN1);
			TheModel.removeEventListener(EventCMD.otherGANG,otherGANG1);
		}
		public function OnSet():void	// 添加吃，碰，杠
		{
			TheModel.addEventListener(EventCMD.otherCHI,otherCHI1);
			TheModel.addEventListener(EventCMD.otherPEN,otherPEN1);
			TheModel.addEventListener(EventCMD.otherGANG,otherGANG1);
		}
		[Bindable]
		public function setEffectOff(b:Boolean):void
		{
			var diss:Fade=new Fade();
			diss.target=this;
			if(b)
			{
				MJsound.play("control");
				diss.alphaFrom=0;
				diss.alphaTo=1;
				diss.duration=1000;
				m_Btn_cancel.addEventListener(MouseEvent.CLICK,cancelHandler);
			}
			else
			{
				m_Btn_cancel.removeEventListener(MouseEvent.CLICK,cancelHandler);
				diss.alphaFrom=1;
				diss.alphaTo=0;
				diss.duration=1000;
				m_Btn_chi.gotoAndStop(1);
				m_Btn_gang.gotoAndStop(1);
				m_Btn_pen.gotoAndStop(1);
				m_Btn_chi.removeEventListener(MouseEvent.CLICK,chiHandler);
				m_Btn_pen.removeEventListener(MouseEvent.CLICK,penHandler);
				m_Btn_gang.removeEventListener(MouseEvent.CLICK,gangHandler);
			}
			diss.play();
		}
		
		private function otherCHI1(evt:PlayEvent):void
		{
			if(evt.m_data.cid==0)
			{
				trace("是否吃?");
				this.effect=true;
				m_Btn_chi.gotoAndPlay(2);
				m_Btn_chi.addEventListener(MouseEvent.CLICK,chiHandler);
			}
		}
		private function otherPEN1(evt:PlayEvent):void
		{
		
			if(evt.m_data.cid==0)
			{
				trace("是否碰?");
				this.effect=true;
				m_Btn_pen.gotoAndPlay(2);
				m_Btn_pen.addEventListener(MouseEvent.CLICK,penHandler);
			}
		}
		private function otherGANG1(evt:PlayEvent):void
		{
			if(evt.m_data.cid==0)
			{
				trace("是否杠?");
				this.effect=true;
				m_Btn_gang.gotoAndPlay(2);
				m_Btn_gang.addEventListener(MouseEvent.CLICK,gangHandler);
			}
		}
		
		private function gangHandler(evt:MouseEvent):void
		{
			TheModel.dispatchEvent(new PlayEvent(EventCMD.myGang,null));
			this.effect=false;
		}
		private function penHandler(evt:MouseEvent):void
		{
			TheModel.dispatchEvent(new PlayEvent(EventCMD.myPen,null));
		    this.effect=false;
		}
		private function chiHandler(evt:MouseEvent):void
		{
			TheModel.dispatchEvent(new PlayEvent(EventCMD.myEat,null));
		    this.effect=false;
	
		}
		private function cancelHandler(evt:MouseEvent):void
		{
			TheModel.dispatchEvent(new PlayEvent(EventCMD.myCancel,new Object()));
			effect=false;
		}
		
	}
}