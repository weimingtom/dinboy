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

	public class PlaybackProgressEvent extends Event{
		public static const PLAYBACK_PROGRESS:String = "playbackProgress";
		
		//units in milliseconds
		public var position:Number;
		public var duration:Number;
		
		public function PlaybackProgressEvent(position:Number, duration:Number){
			super(PLAYBACK_PROGRESS);
			this.position = position;
			this.duration = duration;
		}
		
		public function get playheadPercent():Number{
			return this.position/this.duration;
		}
		
	}
}