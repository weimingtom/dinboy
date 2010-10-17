package ruby.MJeffect
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import mx.core.UIComponent;
	
	import ruby.music.MJsound;

	public class WindEffect extends UIComponent
	{
		private var m_MovieClip:MovieClip;
		private var m_type:String;
		public function WindEffect(type:String)
		{
			this.x=400;	// all init object position
			this.y=260;
			m_type=type;
			super();
			switch(type)
			{
				case "r11":
					m_MovieClip=new wind1_1();
					break;
				case "r12":
					m_MovieClip=new wind1_2();
					break;
				case "r13":
					m_MovieClip=new wind1_3();
					break;
				case "r14":
					m_MovieClip=new wind1_4();
					break;
				case "r21":
					m_MovieClip=new wind2_1();
					break;
				case "r22":
					m_MovieClip=new wind2_2();
					break;
				case "r23":
					m_MovieClip=new wind2_3();
					break;
				case "r24":
					m_MovieClip=new wind2_4();
					break;
				case "r31":
					m_MovieClip=new wind3_1();
					break;
				case "r32":
					m_MovieClip=new wind3_2();
					break;
				case "r33":
					m_MovieClip=new wind3_3();
					break;
				case "r34":
					m_MovieClip=new wind3_4();
					break;
				case "r41":
					m_MovieClip=new wind4_1();
					break;
				case "r42":
					m_MovieClip=new wind4_2();
					break;
				case "r43":
					m_MovieClip=new wind4_3();
					break;
				case "r44":
					m_MovieClip=new wind4_4();
					break;
				default:
					break;
			}
			addChild(m_MovieClip);
			m_MovieClip.addEventListener(Event.COMPLETE,completeHandler,false,0,true);	//   modify
			this.addEventListener(Event.ADDED_TO_STAGE,addToStage,false,0,true);	//  modify
//			m_MovieClip.addEventListener(Event.COMPLETE,completeHandler);	// wangtao
//			this.addEventListener(Event.ADDED_TO_STAGE,addToStage); //  wangtao
		}
		private function completeHandler(evt:Event):void
		{
			//this.parent.removeChild(this);
		
			this.dispatchEvent(new Event(Event.COMPLETE));
			
		}
		private function addToStage(evt:Event):void
		{
			
			m_MovieClip.gotoAndPlay(1);
			MJsound.play("soundWnd");
			MJsound.play(m_type);
		}
		
	}
}