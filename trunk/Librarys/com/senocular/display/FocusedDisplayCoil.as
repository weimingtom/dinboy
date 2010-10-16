/**
 * FocusedDisplayCoil
 * 
 * Creates a dispaly coil that centers focus around a particular
 * location within the coil.  As you spin the coil, it spins
 * "through" this location instead of just spinning in place.
 */
package com.senocular.display {
		
	import com.senocular.utils.Output;
	
	public class FocusedDisplayCoil extends DisplayCoil {
		
		protected var spinOffset:Number = Math.PI/2;	// offset spin to start facing the user (instead of angle of 0 facting right)
		private var _spin:Number = 0;				// new spin variable
		
		// new public spin.  Spin for FocusedDisplayCoil is not
		// bound between -180 and 180 and now goes from spinOffset
		// to the spin allowed based on items within the coil
		public override function get spin():Number {
			return _spin;
		}
		public override function set spin(n:Number):void {
			var index:int = numItems;
			
			// use items to find minimum spin
			var spinMin:Number = (index > 1)
				? -items[index - 1].angle + spinOffset
				: spinOffset;
			if (n > spinOffset) {
				n = spinOffset;
			}else if (n < spinMin) {
				n = spinMin;
			}
			
			// set this class's spin as well as the superclass's
			// spin so that it can be correct when coil is drawn
			_spin = n;
			super.spin = _spin;
		}
		
		// new property itemSpinIndex to identify the
		// item index given the current spin of the coil
		// note, this can be in decimal value
		public function get itemSpinIndex():Number {
			return (spacingAngle && coilCos) ? (spinOffset - _spin)/(spacingAngle*coilCos) : 0;
		}
		public function set itemSpinIndex(n:Number):void {
			spin = spinOffset - n*spacingAngle*coilCos;
		}
		
		/**
		 * Constructor 
		 */
		public function FocusedDisplayCoil() {
			super();
			spin = 0;
		}
		
		
		/**
		 * draw
		 * overridden draw to make sure coil is positioned
		 * to center on focused location in coil
		 */
		protected override function draw():void {
			originY = -coilHeight*(spin - spinOffset)/(Math.PI*2);
			super.draw();
		}
	}
}