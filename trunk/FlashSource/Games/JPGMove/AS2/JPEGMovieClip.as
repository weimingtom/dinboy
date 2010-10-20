import flash.display.BitmapData;
class JPEGMovieClip extends MovieClip {
	private var bmd_array:Array;
	private var total:Number;
	private var current:Number;
	public function JPEGMovieClip() {
		bmd_array = new Array();
		total = 1;
		current = 0;
		onEnterFrame=show_func;
	}
	public function get totalframes():Number {
		return total;
	}
	public function get currentframe():Number {
		return current + 1;
	}
	private function show_func() {
		current %= total;
		this.attachBitmap(bmd_array[current++],0);
	}
	public function push(_bmd:BitmapData ){
		bmd_array.push (_bmd);
		total=bmd_array.length;
	}
}