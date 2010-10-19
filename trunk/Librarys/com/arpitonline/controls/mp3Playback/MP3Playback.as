/*
The MIT License

Copyright (c) 2007 Arpit Mathur

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/


package com.arpitonline.controls.mp3Playback{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.media.ID3Info;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
    [Event(name="onID3", type="com.arpitonline.controls.mp3Playback.MP3Playback")]
    [Event(name="songComplete", type="com.arpitonline.controls.mp3Playback.MP3Playback")]
    [Event(name="IOError", type="flash.events.IOErrorEvent")]
    [Event(name="playbackProgress", type="com.arpitonline.controls.mp3Playback.PlaybackProgressEvent")]
    
    /**
	 * Non-visual class responsible for playing any MP3 from a url.
	 * To use this class, all you have to do is set the source property
	 * to the url of the audio file. 
	 * 
	 * While most of the api of the class is pretty similar to mx:VideoDisplay
	 * class, the one interesting function here is the crossfade function
	 * that can be called at anytime to fade the audio out.
	 * 
	 */
	 
	public class MP3Playback extends EventDispatcher{
		
		private var soundFactory:Sound;
 		private var info:ID3Info;
 		private var song:SoundChannel;

 		
 		private var timer:Timer;
 		private var baseTime:Date;
 		private var pausePosition:Number;
		private var _fileURL:String;
		private var autoPlay:Boolean = true;
		
		
		public static const ON_ID3:String = "onID3";
		public static const SONG_COMPLETE:String="songComplete";
		public static const URL_NOT_FOUND:String = "urlNotFound";
		
		[Bindable] public var enabled:Boolean = false;
		[Bindable] public var hasStarted:Boolean=false;
		
		public function set source(url:String):void{
			hasStarted=false;
			enabled = true;
			this._fileURL = url;
			this.info = null;
			
			// kill old
			if(timer){
				timer.removeEventListener(TimerEvent.TIMER, onUpdateTimer);
				timer =null;
			}
			
			//create a new
			timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER,onUpdateTimer);
			if(autoPlay){
				doPlay()
			}
		}
		
		/**
		 * @private
		 * This is the internal implementation for play.
		 * This is used by the play() function.
		 */ 
		private function doPlay():void{
			hasStarted=true;
			timer.start();
			var request:URLRequest = new URLRequest(_fileURL);
            if(soundFactory != null){
            	song.stop();
            	try{
            		soundFactory.close();
            	}catch(e:Error){
            		// fired if soundFactory is already closed
            	}
            	soundFactory = null;
            }

            soundFactory = new Sound();
            soundFactory.addEventListener(Event.ID3, onID3);
            soundFactory.addEventListener(ProgressEvent.PROGRESS, onProgress);
            soundFactory.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
            soundFactory.load(request);
            song = soundFactory.play();
            if(song){
            	song.addEventListener(Event.SOUND_COMPLETE, onSongComplete);
            }	
		}
		
		private function onUpdateTimer(e:Event):void{
			if(song && soundFactory){
				dispatchEvent(new PlaybackProgressEvent(song.position, soundFactory.length*this.soundFactory.bytesTotal/this.soundFactory.bytesLoaded));
			}
		}
		
		private function onSongComplete(e:Event):void{
			dispatchEvent(new Event(SONG_COMPLETE));
		}
		
		private function onIOError(event:IOErrorEvent):void{
			this.enabled = false;
			dispatchEvent(event.clone());	
		}
		
		
		private function onID3(e:Event):void{
			this.info = this.soundFactory.id3;
			dispatchEvent(new Event(ON_ID3));
		}
		private function onProgress(e:Event):void{
			dispatchEvent(new DownloadEvent(e.target.bytesLoaded, e.target.bytesTotal));
		}
		
		
		//--- api ---//
		public function play():void{
			if(!hasStarted || !song || !soundFactory){
				doPlay()
			}
			else{
 				song = soundFactory.play(pausePosition);	
 			}	
 		}
 		
		
 		public function pause():void{
 			pausePosition = this.song.position;
 			song.stop();
		}
		
		
 		public function stop():void{
			pausePosition=0;
 			if(song){
 				song.stop();
 			}
			if (hasStarted) 
			{
				hasStarted = !hasStarted;
			}
 			this.soundFactory = null;
 		}
 		
 		
 		/**
 		 * fadeOut can be called at anytime and the audio will fade out
 		 * till the volume reaches 0 at which time, the stop() function
 		 * will be fired.
 		*/
 		public function fadeOut(duration:Number=5000):void{
 			var fadeOutTimer:Timer = new Timer(duration/10,10)
 			fadeOutTimer.addEventListener(TimerEvent.TIMER, onFadeOutTimer);
 			fadeOutTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onFadeTimerComplete)
 			fadeOutTimer.start();
 		}
 		
		
 		private function onFadeOutTimer(e:TimerEvent):void{
 			var tr:SoundTransform = song.soundTransform
 			tr.volume = tr.volume*3/4;
 			song.soundTransform = tr;
 		}
 		
		
 		private function onFadeTimerComplete(e:TimerEvent):void{
 			stop()
 		}
		
		/**
		 * 设置/获取 音量
		 */
		public function  set volume(value:Number):void 
		{
			var	tr:SoundTransform = new SoundTransform();
					tr.volume = value;
			song.soundTransform = tr;
		}
		public function  get volume():Number 
		{
			return song.soundTransform.volume;
		}
		
		
		/**
		 * The ID3Info is just a getter so that id3Info data is
		 * guaranteed to be from the song
		 */  
		public function get id3():ID3Info{
			return info;
		}			
	}
}