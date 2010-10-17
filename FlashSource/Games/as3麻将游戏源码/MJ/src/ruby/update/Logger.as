package ruby.update
	{
	
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	import flash.utils.getQualifiedClassName;
	
	public class Logger
	{
		private var conn:LocalConnection;
		private static var ID:Number;
		public function Logger()
		{
			conn = new LocalConnection();
			conn.allowDomain("*");
			conn.addEventListener(StatusEvent.STATUS,onLncStatus,false,0,true);
			ID=Math.ceil(Math.random()*10000);
		}
		
		private function onLncStatus(evt:StatusEvent):void
		{
			//trace(evt.level);
		}
		
		private static var _instance:Logger;
		
		public static var level:Number=LEVEL_DEBUG;
		
		public static var show_in_console:Boolean=true;
		public static var show_in_win:Boolean=true;
		
		public static const LEVEL_DEBUG:Number=1;
		public static const LEVEL_WARN:Number=2;
		public static const LEVEL_ERROR:Number=3;
		public static const LEVEL_NONE:Number=4;
		
		private static function getInstance():Logger
		{
			if(_instance==null)
			{
				_instance=new Logger;
			}
			return _instance;
		}
		
		public static function debug(msg:String,target:Object=null):void
		{
			if(level<=1)
			{
				print("debug",msg,1,target);
			}
		}
		public static function warn(msg:String,target:Object=null):void
		{
			if(level<=2)
			{
				print("warn",msg,2,target);
			}
		}
		public static function error(msg:String,target:Object=null):void
		{
			if(level<=3)
			{
				print("error",msg,3,target);
			}
		}
		
		private static function print(_level:String,msg:String,level:Number,target:Object=null):void
		{
			if(target)
			{
				msg="["+_level+"]-["+getQualifiedClassName(target)+"]-["+msg+"]";
			}else
			{
				msg="["+_level+"]-["+msg+"]";
			}
			
			if(show_in_console)
			{
				trace(msg);
			}
			if(show_in_win)
			{
				var pattern1:RegExp = /</g;
        		var pattern2:RegExp = />/g;
				msg=msg.replace(pattern1,"&lt;");
				msg=msg.replace(pattern2,"&gt;");
				getInstance().conn.send("_debug_client","print",msg,level,ID);
			}
		}
	}
}