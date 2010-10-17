package ruby.card
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;

	import mx.core.UIComponent;


	public class Card extends UIComponent
	{
		public var m_dot:int=0;
		private var bflag:Boolean;
		public var m_bmove:Boolean;
		private var m_huaflag:Boolean;
		public var isUp:Boolean;
		private var m_user:int;
		private var m_type:int;
		public var m_crrueY:int=0;
		public var m_MCheight:int;
		public var m_MCwidth:int;


		/**
		 * user=0 自家
		 * user=1 下家
		 * user=2 对家
		 * user=3 上家
		 *
		 *
		 * type=0 手牌
		 * type=1 吃碰摃处理的牌
		 * type=2 暗摃
		 * type=3 海底出牌
		 * type=4 自家海底牌
		 *
		 * dot: 牌点数  默认为0
		 * 
		 * ------------------
		 * 各种牌对应点数		->共144张牌
		 * 万：11-19
		 * 简：21-29
		 * 锁(条)：31-39
		 * 东，南，西，北，中，发，白。41-47
		 * 花牌：（八张） 51-58	（经排序，花牌被告放置在最后面）。
		 * 
		 * */


		public function Card(user:int, type:int, dot:int=0)///user=-1为上下两家,-2左右两家,海底牌 0，自家牌1下家，2对家，3上家，out=0,手牌out=1 出牌
		{

			m_dot=dot;
			m_user=user;
			m_type=type;
			isUp=false;
			m_bmove=false;
			super();

			var name:String;
			if(user==0)
			{
				if(dot<11)
				{
					name="card"+user.toString()+type.toString();
				}
				else
				{
					name="card"+user.toString()+type.toString()+dot.toString();
				}
			}
			if(user==1||user==3)
			{
				if(type==2)
				{
					name="card"+user.toString()+"4";
				}
				else 
				if(type==3)
				{
					name="card"+user.toString()+"1";
				}
				else
				{
					name="card"+user.toString()+type.toString();
				}
				if(dot>=11)
				{
					name+=dot.toString();
				}
			}
			if(user == 2)
			{
				if(type == 2)
				{
					name = "card"+user.toString()+"4";
				}
				else
				if(type == 1)
				{
					name = "card"+user.toString()+"3";
				}
				else
				{
					name = "card"+user.toString()+type.toString();
				}
				if(dot >= 11)
				{
					name += dot.toString();
				}
			}

			getmap(name);

			switch(user)
			{
				case 0:
					if(type==0)
					{
						bflag=true;
						m_MCheight=69;
						m_MCwidth=42*0.9;
					}
					if(type==1)
					{
						m_MCheight=63;
						m_MCwidth=42;
					}
					if(type==2)
					{
						m_MCheight=63;
						m_MCwidth=42;
					}
					if(type==3)
					{
						m_MCheight=44;
						m_MCwidth=24;
					}
					if(type==4)
					{
						m_MCheight=44;
						m_MCwidth=24;
					}
					break;
				case 1:
					if(type==0)
					{
						m_MCheight=44;
						m_MCwidth=22;
					}
					if(type==1)
					{
						m_MCheight=37;
						m_MCwidth=40;
					}
					if(type==2)
					{
						m_MCheight=37;
						m_MCwidth=40;
					}
					if(type==3)
					{
						m_MCheight=37;
						m_MCwidth=40;
					}
					if(type==4)
					{
						m_MCheight=37;
						m_MCwidth=40;
					}
					break;
				case 2:
					if(type==0)
					{
						m_MCheight=42;
						m_MCwidth=30;
					}
					if(type==1)
					{
						m_MCheight=44;
						m_MCwidth=24;
					}
					if(type==2)
					{
						m_MCheight=44;
						m_MCwidth=24;
					}
					if(type==3)
					{
						m_MCheight=44;
						m_MCwidth=24;
					}
					if(type==4)
					{
						m_MCheight=44;
						m_MCwidth=24;
					}
					break;
				case 3:
					if(type==0)
					{
						m_MCheight=44;
						m_MCwidth=22;
					}
					if(type==1)
					{
						m_MCheight=37;
						m_MCwidth=40;
					}
					if(type==2)
					{
						m_MCheight=37;
						m_MCwidth=40;
					}
					if(type==3)
					{
						m_MCheight=37;
						m_MCwidth=40;
					}
					if(type==4)
					{
						m_MCheight=37;
						m_MCwidth=40;
					}

					break;
				default:
					break;
			}

			if(bflag)
			{
				this.addEventListener(MouseEvent.MOUSE_OVER,Up);
				this.addEventListener(MouseEvent.MOUSE_OUT,down);
				this.addEventListener(Event.ADDED_TO_STAGE,addHandler);
			}
		}
		private function getmap(name:String):void
		{
			var Cla:Class = getDefinitionByName(name) as Class;
			var map:MovieClip = new Cla();
			map.name = "map";
			map.scaleX = 0.9;
			map.scaleY = 0.9;
			addChild(map);
		}
		private function Up(event:MouseEvent):void
		{
			if(m_bmove&&!isUp&&m_crrueY == this.y)
			{
				this.y -= 15;
				isUp = true;
			}
		}
		private function down(event:MouseEvent):void
		{
			if(m_bmove&&isUp && m_crrueY > this.y)
			{
				this.y = m_crrueY;
				isUp = false;
			}
		}
		private function addHandler(event:Event):void
		{
			m_crrueY = this.y;
		}
	}
}
