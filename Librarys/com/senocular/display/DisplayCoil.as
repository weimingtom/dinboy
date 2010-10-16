/**
 * DisplayCoil
 * 
 * Creates a dispaly object which displays objects added to it
 * (with addItem) in a coil pattern
 */
package com.senocular.display {

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.utils.Dictionary;
	
	import com.senocular.utils.Output;
	import com.senocular.utils.SortedObject;
	
	public class DisplayCoil extends Sprite {
		
		private var _spin:Number = 0;			// coil spin (rotation around coil axis
		private var _radius:Number = 100;		// radius of coiling 
		private var _itemWidth:Number = 100;	// intended size of items (used for spacing)..
		private var _itemHeight:Number = 100;
		private var _itemPadding:Number = 0;	// padding between items
		private var _coilHeight:Number = 0;	// height between coil items after 360 degrees of coiling
		private var _coilHeightMin:Number = 0;	// minimum height for _coilHeight before the coil items overlap
		private var _coiling:Number = 0;		// coiling angle in radians that relate to the items angle (rotation) in coil
		private var _coilingMin:Number = 0;	// minimum coiling for _coiling before the coil items overlap
		protected var coilCos:Number = 0;		// saved cosine value for the coiling angle
		protected var coilSin:Number = 0;		// saved sine value for the coiling angle
		protected var originX:Number = 0;		// offset for coiled items..
		protected var originY:Number = 0;
		
		private var _backDarkness:Number = .25;	// how dark the back items are
			
		private var _front:Sprite = new Sprite();			// sprite containing background items (2 sprites so you can place items in between)
		private var _back:Sprite = new Sprite();			// sprite containing foreground items
		protected var spacingAngle:Number = 0;				// angle to space items around coil
		protected var items:Array = new Array();			// array of all items added
		protected var itemLookup:Dictionary = new Dictionary();	// object for quick reference to items by the display objects coil contains
		protected var isValid:Boolean = false;				// false if the coil needs updating (needs to be drawn)
		
		private static const PI2:Number = Math.PI*2;
		
		// public front
		public function get front():Sprite {
			return _front;
		}
		
		// public back
		public function get back():Sprite {
			return _back;
		}
		
		// public itemWidth
		public function get itemWidth():Number {
			return _itemWidth;
		}
		public function set itemWidth(n:Number):void {
			_itemWidth = n;
			calculateCoilValues();
		}
		
		// public itemHeight
		public function get itemHeight():Number {
			return _itemHeight;
		}
		public function set itemHeight(n:Number):void {
			_itemHeight = n;
			calculateCoilValues();
		}
		
		// returns number of items in coil
		public function get numItems():Number {
			return items.length;
		}
		
		// public radius
		public function get radius():Number {
			return _radius;
		}
		public function set radius(n:Number):void {
			_radius = n;
			calculateCoilValues();
		}
		
		// cRadius (coilRadius) is the same as the radius
		// but will retain the coiling ratio when changed
		public function get cRadius():Number {
			return _radius;
		}
		public function set cRadius(n:Number):void {
			var coilDiff:Number = (_coiling - _coilingMin)/n;
			var lastRadius:Number = _radius;
			_radius = n;
			calculateCoilValues();
			coiling = _coilingMin + coilDiff*lastRadius;
		}
		
		// public itemPadding
		public function get itemPadding():Number {
			return _itemPadding;
		}
		public function set itemPadding(n:Number):void {
			_itemPadding = n;
			calculateCoilValues();
		}
		
		// public spin
		public function get spin():Number {
			return _spin;
		}
		public function set spin(n:Number):void {
			_spin = n;
			
			// keep spin within -180 and 180 degrees (like rotation)
			_spin %= PI2;
			if (_spin < -Math.PI) {
				_spin += PI2;
			}else if (_spin > Math.PI) {
				_spin -= PI2;
			}
			isValid = false;
		}
		
		// public coiling
		public function get coiling():Number {
			return _coiling;
		}
		public function set coiling(n:Number):void {
			_coiling = n;
			
			// assign coilCos and coilSin for future reference
			coilCos = Math.cos(_coiling);
			coilSin = Math.sin(_coiling);
			_coilHeight = PI2*_radius*coilSin/coilCos;
			isValid = false;
		}
		
		// public coilingMin
		public function get coilingMin():Number {
			return _coilingMin;
		}
		
		// public coilHeight
		public function get coilHeight():Number {
			return _coilHeight;
		}
		public function set coilHeight(n:Number):void {
			_coilHeight = n;
			
			// update _coiling for change in coilHeight
			_coiling = (_radius) ? Math.asin(_coilHeight/(PI2*_radius)) : 0;
			
			// assign coilCos and coilSin for future reference
			coilCos = Math.cos(_coiling);
			coilSin = Math.sin(_coiling);
			isValid = false;
		}
		
		// public coilHeightMin
		public function get coilHeightMin():Number {
			return _coilHeightMin;
		}
		
		// public backDarkness
		public function get backDarkness():Number {
			return _backDarkness;
		}
		public function set backDarkness(n:Number):void {
			_backDarkness = n;
			isValid = false;
		}
		
		/**
		 * Constructor 
		 */
		public function DisplayCoil() {
			
			// define basic properties
			calculateCoilValues();
			coiling = _coilingMin;
			
			// add back and front into this sprite by default
			// but allow users to add front and back to other
			// sprites if needed using front and back properties
			addChild(_back);
			addChild(_front);
		}
		
		/**
		 * addItem
		 * adds a display object to the coil and stores internally
		 * in the items array and itemLookup dictionary
		 * Display objects passed are wrapped in DisplayCoilItem
		 * objects which are actually added to the front and back
		 * container sprites depending on its position
		 */
		public function addItem(item:DisplayObject):void {
			// if already in coil, exit
			if (itemLookup[item]) {
				return;
			}
			
			// create DisplayCoilItem wrapper
			var coilItem:DisplayCoilItem = new DisplayCoilItem(item);
			
			// wrapper in itemLookup using the provided
			// display object as a key
			itemLookup[item] = coilItem;
			
			// add wrapper to items array
			items.push(coilItem);
			
			// initially add to front container, updated when drawn
			_front.addChild(coilItem);
			isValid = false;
		}
		
		/**
		 * addItemAt
		 * adds a display object to a particular location in the coil
		 */
		public function addItemAt(item:DisplayObject, index:int):void {
			var coilItem:DisplayCoilItem;
			
			// if the display object already exists within coil
			if (itemLookup[item]) {
				
				// exit function if in the same position as index
				if (items[index].content == item) {
					return;
				}
				
				// if added to a different position, remove from current position
				coilItem = itemLookup[item];
				var oldIndex:int = getItemIndex(item);
				items.splice(oldIndex, 1);
			}else{
				
				// create new wrapper and assign to itemLookup; add to front
				coilItem = new DisplayCoilItem(item);
				itemLookup[item] = coilItem;
				_front.addChild(coilItem);
			}
			
			// splice wrapper into items array
			items.splice(index, 0, coilItem);
			isValid = false;
		}
		
		/**
		 * getItemAt 
		 * @return dispay object at index
		 */
		public function getItemAt(index:int):DisplayObject {
			
			// return null if index out of range
			if (index < 0 || index >= items.length) {
				return null;
			}
			
			// return display object in DisplayCoilItem wrapper at index
			return items[index].content;
		}
		
		/**
		 * getItemIndex 
		 * @return index in coil at which item is displayed; -1 if not present
		 */
		public function getItemIndex(item:DisplayObject):int {
			
			// if item not in coil, return -1
			if (!itemLookup[item]) {
				return -1;
			}
			
			// find item in items array; return index when found
			var i:int = items.length;
			while (i--) {
				if (items[i].content == item) {
					return i;
				}
			}
			
			// if not found, return -1
			return -1;
		}
		
		/**
		 * removeItem 
		 * removes item from coil
		 * @return item removed, null if item not in coil
		 */
		public function removeItem(item:DisplayObject):DisplayObject {
			
			// if not in coil, exit function
			if (!itemLookup[item]) {
				return null;
			}
			
			// find location in coil
			var index:int = getItemIndex(item);
			
			// remove from front or back containers
			if (itemLookup[item].parent) {
				itemLookup[item].parent.removeChild(itemLookup[item]);
			}
			
			// remove from items array
			if (index >= 0) {
				items.splice(index, 1);
			}
			
			// delete from lookup
			delete itemLookup[item];
			isValid = false;
			return item;
		}
		
		/**
		 * removeItemAt 
		 * removes item from coil at specific index
		 * @return item removed, null if item not in coil
		 */
		public function removeItemAt(index:Number):DisplayObject {
			
			// if index not in range, return null
			if (index < 0 || index >= items.length) {
				return null;
			}
			
			var coilItem:DisplayCoilItem = items[index];
			
			// remove from front or back containers
			if (coilItem.parent) {
				coilItem.parent.removeChild(coilItem);
			}
			
			// remove from items array
			if (index >= 0) {
				items.splice(index, 1);
			}
			
			// delete from lookup
			delete itemLookup[coilItem.content];
			isValid = false;
			
			// return item
			return coilItem.content;
		}
		
		/**
		 * clearItems 
		 * removes all items from coil 
		 */
		public function clearItems():void {
			
			// if there are no items, exit
			if (!items.length) {
				return;
			}
			
			// loop through all items removing them from coil
			var coilItem:DisplayCoilItem;
			var i:int = items.length;
			while (i--) {
				coilItem = items[i];
				if (coilItem.parent) {
					coilItem.parent.removeChild(coilItem);
				}
				delete itemLookup[coilItem.content];
			}
			
			// reset items array to have a length of 0
			items.length = 0;
			isValid = false;
		}
		
		/**
		 * getItemAngle 
		 * @return the angle associated with the item in the coil.
		 * This angle does not change with coil spin and is relative
		 * to the first item in the coil
		 */
		public function getItemAngle(item:DisplayObject):Number {
			
			// if item not in coil, return null
			if (!itemLookup[item]) {
				return NaN;
			}
			
			// return item angle
			var coilItem:DisplayCoilItem = itemLookup[item];
			return coilItem.angle;
		}
		
		/**
		 * validate 
		 * evaluates the state of the coil and draws it if necessary
		 * Using this instead of draw prevents unnecessary drawing
		 * of the coil improving performance
		 */
		public function validate(evt:Event = null):void {			
			if (!isValid) {
				draw();
				isValid = true;
			}
		}
		
		/**
		 * draw 
		 * updates the locations of all items in the coil
		 * based on the properties defined for it
		 */
		protected function draw():void {
			var n:int = items.length;
			
			// if no items, exit
			if (!n) {
				return;
			}
			
			// loop through all items positioning
			// and adding depths to a SortedObject
			var depths:SortedObject = new SortedObject();
			var item:DisplayCoilItem;
			var i:int;
			for (i=0; i<n; i++) {
				item = items[i];
				positionItem(item, i);
				depths[item.depth] = item;
			}
			
			// assign each item to front or back using
			// isFrontFacing property updated in positionItem
			// by using a SortedObject items are looped through
			// in order based on their depth so when added
			// to front and back, they are ordered in desired depths
			for each (item in depths) {
				(item.isFrontFacing ? _front : _back).addChild(item);
			}
			
			// apply backDarkness to back if changed
			var col:ColorTransform = _back.transform.colorTransform;
			if (col.redMultiplier != _backDarkness) {
				col.redMultiplier = col.greenMultiplier = col.blueMultiplier = _backDarkness;
				_back.transform.colorTransform = col;
			}
		}
		
		/**
		 * positionItem
		 * positions an item within the coil based on its position
		 */
		private function positionItem(coilItem:DisplayCoilItem, position:Number):void {
			
			// determine angle of coilItem
			coilItem.angle = position*spacingAngle*coilCos;
			
			// absolute angle based on spin; obtain sine and cosine
			var angleOff:Number = coilItem.angle + _spin;
			var spinCos:Number = Math.cos(angleOff);
			var spinSin:Number = Math.sin(angleOff);
			
			// modify coilItem transformation matrix
			// for skew and position within the coil
			var mat:Matrix = coilItem.transform.matrix;
			mat.a = coilCos*spinSin;
			mat.b = coilSin;
			mat.c = -coilSin*spinSin;
			mat.d = coilCos;
			mat.tx = originX + spinCos*_radius;
			mat.ty = originY - position*spacingAngle*coilSin*_radius;
			coilItem.transform.matrix = mat;
			
			// base depth and isFrontFacing on sine
			coilItem.isFrontFacing  = Boolean(spinSin > 0);
			coilItem.depth = (coilItem.isFrontFacing) ? spinSin : -spinSin - 1;
		}
		
		/**
		 * calculateCoilValues 
		 * performs calculations for values required to draw coil 
		 */
		private function calculateCoilValues():void {
			// math mumbo jumbo
			var r2:Number = 2*_radius;
			var h:Number = _itemPadding + _itemHeight;
			var w:Number = _itemPadding + _itemWidth;
			spacingAngle = (_radius) ? 2*Math.atan(w/r2) : 0;
			_coilingMin = (_radius) ? Math.asin(h/(PI2*_radius)) : 0;
			var minCos:Number = Math.cos(_coilingMin);
			_coilHeightMin = (minCos) ? h/minCos : 0;
			_coilHeight = PI2*_radius*coilSin/coilCos;
			isValid = false;
		}
	}
}

import flash.display.DisplayObject;
import flash.display.Sprite;

/**
 * DisplayCoilItem
 * 
 * Sprite container for items placed in a display coil
 */
class DisplayCoilItem extends Sprite {
	
	public var content:DisplayObject;			// display object added to display coil
	public var isFrontFacing:Boolean = true;	// determines if in coil.front (true) or coil.back (false)
	public var angle:Number = 0;				// angle of spin within the coil
	public var depth:Number = 0;				// depth value in respect to other items in coil
	
	/**
	 * Constructor 
	 */
	public function DisplayCoilItem(content:DisplayObject) {
		this.content = content;
		addChild(content);
	}
}