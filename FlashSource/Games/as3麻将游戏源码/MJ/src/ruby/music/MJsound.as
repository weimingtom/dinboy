package ruby.music
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	import mx.core.Application;
	
	public class MJsound
	{
		public function MJsound()
		{
		}
		public static function play(name:String):SoundChannel
		{
			var path:String="sound/"+name+".mp3";
			var soundCh:SoundChannel;
			try
			{
				var url:URLRequest=new URLRequest();
				url.url = path;
				var sound:Sound=new Sound();
				sound.load(url);
				sound.addEventListener(Event.COMPLETE,soundComplete);
				
			    soundCh=sound.play();
			    var transform:SoundTransform = new SoundTransform(Application.application.v3.volume,0);
			    soundCh.soundTransform=transform;
			}
			catch(err:Error)
			{
				trace(err);
			}
			return soundCh;
		}
		public static function soundComplete(evt:Event):void
		{
			var sound:Sound=evt.target as Sound;
			sound=null;
		}

	}
}