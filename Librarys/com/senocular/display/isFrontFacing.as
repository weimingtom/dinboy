// ActionScript Document
package com.senocular.display {
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	/**
	 * Determines if a display object, 2D or 3D, is "front-facing",
	 * or not in any way flipped as the result of a scaling or 2D
	 * 3D transformation.  If the display object provided has been
	 * flipped, false is returned.
	 * <p>Usage:</p>
	 * <pre>
	 * import com.senocular.display.isFrontFacing;
	 * if (isFrontFacing(mySprite)) {
	 *	 // show normally
	 * }else{
	 *	 // show alternate back face
	 * }
	 * </pre>
	 * @param displayObject The display object to determine if it's
	 * front-facing or not.
	 * @return  True if the display object is front-facing, false
	 * if not.
	 */
	public function isFrontFacing(displayObject:DisplayObject):Boolean {
		// define 3 arbitary points in the display object for a
		// global path to test winding
		var p1:Point = displayObject.localToGlobal(new Point(0,0));
		var p2:Point = displayObject.localToGlobal(new Point(100,0));
		var p3:Point = displayObject.localToGlobal(new Point(0,100));
		// use the cross-product for winding which will determine if
		// the front face is facing the viewer
		return Boolean((p2.x-p1.x)*(p3.y-p1.y) - (p2.y-p1.y)*(p3.x-p1.x) > 0);
	}
}