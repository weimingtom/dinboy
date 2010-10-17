package ruby.MJeffect
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import mx.core.UIComponent;
	
	import ruby.music.MJsound;

	public class playEffect extends UIComponent
	{
		private var m_movieClip:MovieClip;
		private var m_type:String;
		public function playEffect(user:int,type:String)
		{
			super();
			m_type = type;
			switch(type)
			{
				case "抓位":
					m_movieClip = new FindSeat();
					break;
				case "补花":
					m_movieClip = new FlowerMC();
					break;
				case "吃":
					m_movieClip = new ShowEat();
					break;
				case "碰":
					m_movieClip = new ShowPen();
					break;
				case "杠":
					m_movieClip = new ShowGang();
					break;
				case "扔":
					m_movieClip = new ThrowMj();
					break;
				case "胡":
					m_movieClip = new ShowHu();
					break;
				case "自摸":
					m_movieClip = new ShowZimo();
					break;
				case "流局":
					break;
				default:
					break;
			}
			switch(user)
			{
				case -1://中间
					this.x = 400;
					this.y = 280;
					break;
				case 0://///自家
					this.x = 400;
					this.y = 480;
					break;
				case 1://///下家
					this.x = 600;
					this.y = 280;
					break;
				case 2:////对家
					this.y = 100;
					this.x = 400;
					break;
				case 3://///上家
					this.x = 100;
					this.y = 280;
					break;
				default:
					break;
			}
			addChild(m_movieClip);
			m_movieClip.addEventListener(Event.COMPLETE,completeHandler);	// 影片剪辑中，由最后一帧派发此事件->在此接收，用来消毁
			this.addEventListener(Event.ADDED_TO_STAGE,addToStage);
		}
		private function completeHandler(evt:Event):void
		{
			switch(m_type)
			{
				case "胡":
					MJsound.play("hu");
					break;
				case "自摸":
					MJsound.play("zimo");
					break;
				case "流局":
					MJsound.play("draw");
					break;
				default:
					break;
			}
			
			this.dispatchEvent(new Event(Event.COMPLETE));
			this.parent.removeChild(this);
		}
		private function addToStage(evt:Event):void
		{
			m_movieClip.gotoAndPlay(2);
		}
		
	}
}