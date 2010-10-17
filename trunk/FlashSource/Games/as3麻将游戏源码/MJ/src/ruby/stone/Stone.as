package ruby.stone
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.containers.Canvas;
	import mx.effects.Move;
	import mx.events.EffectEvent;
	public class Stone extends Canvas
	{
		private var m_num1:int=0;
		private var m_num2:int=0;
		private var m_num3:int=0;
		
		private var m_dot1:*;
		private var m_dot2:*;
		private var m_dot3:*;
		
		private var m_x:int;
		private var m_y:int;
		
		private var dot1:Stone1;
		private var dot2:Stone1;
		private var dot3:Stone1;
		private var m_timer:Timer;
		
		private var move1:Move;
		private var move2:Move;
		private var move3:Move;
		
		public function Stone(num1:int,num2:int,num3:int):void
		{
			this.scaleX=0.8;
			this.scaleY=0.8;
//		 	this.x=0;
//		 	this.y=0;
			m_x=455;
			m_y=300;
			var formX:int=300;
			var formY:int=50;
			m_num1=num1;
			m_num2=num2;
			m_num3=num3;
			
			
			dot1=new Stone1();
			dot2=new Stone1();
			dot3=new Stone1();
			
			dot1.x=formX;
			dot1.y=formY;
			dot2.x=dot1.x+10;
			dot2.y=dot1.y+10;
			dot3.x=dot1.x+15;
			dot3.y=dot1.y+25;
			
			this.addChild(dot1);
			this.addChild(dot2);
			this.addChild(dot3);
			
            move1=new Move();
            move2=new Move();
            move3=new Move();
            
            move1.target=dot1;
            move1.startDelay=10;
            move1.duration=300;
            move1.xFrom=dot1.x;
            move1.yFrom=dot1.y;
            move1.yTo=m_y;
            move1.xTo=m_x;
            
            move2.target=dot2;
            move2.startDelay=10;
            move2.duration=300;
            move2.xFrom=dot2.x;
            move2.yFrom=dot2.y;
            move2.yTo=m_y;
            move2.xTo=m_x+40;
            
            move3.target=dot3;
            move3.startDelay=10;
            move3.duration=300;
            move3.xFrom=dot3.x;
            move3.yFrom=dot3.y;
            move3.yTo=m_y+40;
            move3.xTo=m_x+20;
            
            move3.addEventListener(EffectEvent.EFFECT_END,effectEventEnd);
            move1.play();
            move2.play();
            move3.play();
		}
		private function effectEventEnd(evt:EffectEvent):void
		{
			move1.stop();
			move2.stop();
			move3.stop();
			move1.target=null;
			move2.target=null;
			move3.target=null;
			removeChild(dot1);
			removeChild(dot2);
			removeChild(dot3);
			
			getThreeMC();	// 获取三个骰子点数
			
			addChild(m_dot1);
			addChild(m_dot2);
			addChild(m_dot3);
			
			m_timer=new Timer(1000,2);
			m_timer.addEventListener(TimerEvent.TIMER_COMPLETE,timerComplete);
			m_timer.start();
		//	this.dispatchEvent(new Event(Event.COMPLETE));
		}
		private function timerComplete(evt:TimerEvent):void
		{   m_timer.removeEventListener(TimerEvent.TIMER_COMPLETE,timerComplete);
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		private function getThreeMC():void
		{
			switch(m_num1)
			{
				case 1:
				m_dot1=new Stone1();
				break;
				case 2:
				m_dot1=new Stone2();
				break;
				case 3:
				m_dot1=new Stone3();
				break;
				case 4:
				m_dot1=new Stone4();
				break;
				case 5:
				m_dot1=new Stone5();
				break;
				case 6:
				m_dot1=new Stone6();
				break;
			}
			switch(m_num2)
			{
				case 1:
				m_dot2=new Stone1();
				break;
				case 2:
				m_dot2=new Stone2();
				break;
				case 3:
				m_dot2=new Stone3();
				break;
				
				case 4:
				m_dot2=new Stone4();
				break;
				
				case 5:
				m_dot2=new Stone5();
				break;
				
				case 6:
				m_dot2=new Stone6();
				break;
			}
			switch(m_num3)
			{
				case 1:
				m_dot3=new Stone1();
				break;
				case 2:
				m_dot3=new Stone2();
				break;
				case 3:
				m_dot3=new Stone3();
				break;
				case 4:
				m_dot3=new Stone4();
				break;
				case 5:
				m_dot3=new Stone5();
				break;
				case 6:
				m_dot3=new Stone6();
				break;
			}
		    m_dot1.x=m_x;
		    m_dot1.y=m_y;
		    m_dot2.x=m_dot1.x+40;
		    m_dot2.y=m_dot1.y;
			m_dot3.x=m_dot1.x+20;
			m_dot3.y=m_dot1.y+40;
		}
	}
}