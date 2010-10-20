package flash023{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.geom.Point;
	//import flash023.JPEGMovieClip;
	public class Main extends Sprite {
		private var loader:Loader;
		public function Main():void {
			loader=new Loader;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE ,onJPEGLoaderComplete);
			try {
				loader.load(new URLRequest("mode.jpg"));
			} catch (_e:Error) {
				trace(_e);
			}
		}
		public function onJPEGLoaderComplete(_evt:Event):void {
			var _bmp:Bitmap =_evt.target.content as Bitmap;
			var main_bmd:BitmapData = _bmp.bitmapData.clone();
			loader.unload();
			createBmdArray(main_bmd);
		}
		public function createBmdArray(_bmd:BitmapData) {
			var posW:uint = _bmd.width / 4;
			var posH:uint = _bmd.height / 4;
			for (var _h:uint = 0; _h < 4; _h++) {
				var _mc:JPEGMovieClip=new JPEGMovieClip;
				_mc.x = Math.random() * 500, _mc.y = Math.random() * 360;
				addChild(_mc);
				for (var _w:uint = 0; _w < 4; _w++) {
					var _temp:BitmapData = new BitmapData(posW, posH);
					var _rec:Rectangle = new Rectangle(1 + _w * posW, _h * posH, posW, posH);
					_temp.copyPixels(_bmd,_rec,new Point());
					_mc.pushFrame(_temp);
				}
			}
		}
	}
}