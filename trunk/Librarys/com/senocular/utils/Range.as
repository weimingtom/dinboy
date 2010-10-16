package com.senocular.utils {
	
	import flash.geom.Point;
	
	public class Range extends Point {
		
		private var _span:Number = 0;
		
		
		public function get min():Number {
			return x;
		}
		public function set min(n:Number):void {
			x = n;
			updateSpan();
		}
		public function get max():Number {
			return y;
		}
		public function set max(n:Number):void {
			y = n;
			updateSpan();
		}
		
		public function get span():Number {
			return _span;
		}
		
		public function Range(min:Number = 0, max:Number = 1) {
			x = min;
			y = max;
			updateSpan();
		}
		
		public function getRandom():Number {
			return x + Math.floor(Math.random()*(_span + 1));
		}
		
		private function updateSpan():void {
			_span = y - x;
		}
	}
}
