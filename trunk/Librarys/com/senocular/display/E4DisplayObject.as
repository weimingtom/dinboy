package com.senocular.display {
	
	// external dependencies
	import com.senocular.display.e4d_internal;
	import com.senocular.display.E4DisplayList;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.flash_proxy;
	
	use namespace flash_proxy; // allow flash_proxy to be
	// recognized for classes extending Proxy subclasses

	/**
	 * Class that provides E4X-like access to display objects for
	 * accessing child objects in the display list and display 
	 * object members (as attributes). E4DisplayObject instances
	 * are special variations of E4DisplayList instances which 
	 * represent a single object.  They still exist as lists, but
	 * have a length of one.  E4DisplayObjects are different from
	 * E4DisplayLists in that their valueOf() returns the single
	 * object instance they contain (rather than a reference to 
	 * itself or undefined if empty) and method calls return a 
	 * E4DisplayObject of the result rather than an E4DisplayList with
	 * the results of each call made for each object in the list.
	 * Also, for..in and for each..in iteration for E4DisplayObjects
	 * loop through display object children of the single instance
	 * contained within the E4DisplayObjects rather than the list
	 * of items in the E4DisplayList.
	 * @see com.senocular.display.E4DisplayList
	 * @author Trevor McCauley (senocular.com)
	 */
	public dynamic class E4DisplayObject extends E4DisplayList {
		
		private var target:*; // reference to the object
		private var container:DisplayObjectContainer; // target as DOC
		
		
		/**
		 * Creates a new E4DisplayObject wrapper for a display (or other
		 * kind of) object. To access the value of the object passed into 
		 * the constructor, use the valueOf() method.
		 * @param	source The object to be represented by the new
		 * E4DisplayObject instance.
		 */
		public function E4DisplayObject(source:* = null):void {
			// only include the target source in the super
			// list if it's provided; it must be in the form
			// of an array
			super(source ? [source] : null);
			
			// local references
			target = source;
			container = target as DisplayObjectContainer;
		}
		
		
		/**
		 * The value of the E4DisplayObject object.
		 * @return A direct reference to the source object represented
		 * by the E4DisplayObject object.
		 */
		public override function valueOf():* {
			return target;
		}
		
		/**
		 * The string representation of the E4DisplayObject object.
		 * @return A String conversion of the source object represented
		 * by the E4DisplayObject object.
		 */
		public override function toString():String {
			return String(target);
		}
		
		/**
		 * Calls a function defined within the object referenced by the
		 * E4DisplayObject object. If the function does not exist within
		 * that object, the function by that name defined within E4DisplayObject
		 * under the e4d_internal namespace will be called if it exists.
		 * @return The result of the function call as an E4DisplayObject if
		 * called from the referenced object within the E4DisplayObject or
		 * a direct result of the function within the e4d_internal namespace
		 * if it was called.
		 */
		flash_proxy override function callProperty(name:*, ...rest):* {
			if (target){
				name = String(name);
				if (name in target){
					// allow errors to be thrown since this is just one
					// object and it may be important to know the error
					return new E4DisplayObject(target[name].apply(target, rest));
				}else{
					// fallback if no target method found
					try {
						return e4d_internal::[name].apply(this, rest);
					}catch (error:Error){}
				}
			}
			return null;
		}
		
		/**
		 * Allows enumeration of the child display objects by name of the
		 * object referenced by the E4DisplayObject object if that object
		 * is a DisplayObjectContainer.
		 * @param	index The one-based index value of the object's property. 
		 * @return The name of the display object being iterated over.
		 */
		flash_proxy override function nextName(index:int):String {
			if (container && index <= container.numChildren){
				return container.getChildAt(index - 1).name;
			}
			return String(index);
		}
		
		/**
		 * Allows enumeration of the child display objects by index of the
		 * object referenced by the E4DisplayObject object if that object
		 * is a DisplayObjectContainer.
		 * @param	index The zero-based index value of the object's property. 
		 * @return The next index to be used within the iteration; 0 if there
		 * are no more objects to be iterated over.
		 */
		flash_proxy override function nextNameIndex(index:int):int {
			if (container && index < container.numChildren){
				return index + 1;
			}
			return 0;
		}
		
		/**
		 * Allows enumeration of the child display objects by value of the
		 * object referenced by the E4DisplayObject object if that object
		 * is a DisplayObjectContainer.
		 * @param	index The one-based index value of the object's property. 
		 * @return The value of the display object being iterated over.
		 */
		flash_proxy override function nextValue(index:int):* {
			if (container && index <= container.numChildren){
				return container.getChildAt(index - 1);
			}
			return null;
		}
	}
}