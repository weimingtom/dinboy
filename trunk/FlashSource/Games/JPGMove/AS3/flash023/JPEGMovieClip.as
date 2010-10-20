package flash023{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.display.Sprite;
	public class JPEGMovieClip extends Sprite {
		private var bmd_array:Array;
		private var total:uint;
		private var current:uint;
		private var bitmap:Bitmap;
		public function JPEGMovieClip() {
			bmd_array=new Array  ;
			total=1;
			current=0;
			bitmap=new Bitmap;
			addChild(bitmap);
			addEventListener(Event.ENTER_FRAME,show_func);
		}
		public function get totalframes():uint {
			return total;
		}
		public function get currentframe():uint {
			return current + 1;
		}
		private function show_func(_evt:Event) {
			current%= total;
			bitmap.bitmapData=bmd_array[current++];
		}
		public function pushFrame(_bmd:BitmapData) {
			bmd_array.push(_bmd);
			total=bmd_array.length;
		}
	}
}