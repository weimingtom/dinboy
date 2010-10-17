package ruby.Event
{
	import flash.events.Event;

	public class PlayEvent extends Event
	{
		public var m_data:Object;
		public function PlayEvent(type:String,_data:Object)
		{
			super(type);
			m_data=_data;
		}
		
	}
}