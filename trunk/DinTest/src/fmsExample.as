package  
{
	import flash.display.Sprite;
	import flash.events.NetStatusEvent;
	import flash.net.*;	


		
	/**
	 * @copy     版权所有 © 2010
	 * @author  钉崽 - [dinboy.Com]
	 	*/
	public class fmsExample extends Sprite
	{
		//指定播放的mp3名字
		private var id:String = "mp3:zandy";
		private var in_ns:NetStream;
		private var nc:NetConnection = new NetConnection();
		
		public function fmsExample() 
		{
				//by roading http://roading.net/blog 
				//导入net包
				
				//指定编码
				nc.objectEncoding = ObjectEncoding.AMF0;
				//连接fms的playmp3应用程序
				nc.connect("rtmp://localhost/vod/");
				nc.client = this;
				//侦听状态
				nc.addEventListener("netStatus",netStatusHandler);
		}
		
		private function netStatusHandler(e:NetStatusEvent):void
		{
				 trace("netstate...............")
				 //for(var i in e.info)
				 //trace(i+"==="+e.info[i])
				//连接成功
				 if(e.info.code=="NetConnection.Connect.Success")
				  {
					//获取mp3时间
				 //  nc.call("GetMp3Length", new Responder(lengLoaded), id);
				   in_ns = new NetStream(nc);
				//播放
				   in_ns.play(id);
				//设置缓冲的音乐长度
				   in_ns.bufferTime = 5;
				//侦听ns的状态
				   in_ns.addEventListener("netStatus",in_nsnetStatusHandler);
				  }
		}
		
		//得到mp3的时间
		private function lengLoaded(length:Number):void {
				 trace("mp3length==="+length);
		}
		
		
		private function in_nsnetStatusHandler(e:NetStatusEvent):void
		{
				trace(e.info.code);
		}
				
		public function onBWDone():void{}
		
	/*************** Class The End ****************/
	}

}