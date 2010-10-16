/**
 * SortedObject
 * 
 * SortedObjects contain properties like other objects but
 * present them in a sorted order when iterating through them
 * with for in and for each loops.
 * You cannot re-define values for a sorted object without deleting
 * the orginal value first.  Assigning new values to pre-existing
 * values instead create new values in addition to the old. To access 
 * duplicate values that are not the last assigned, use a for loop
 */
package com.senocular.utils {
	
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	dynamic public class SortedObject extends Proxy {
		
		private var values:Array = new Array();	// values in a sorted array
		private var _index:int;				// current location in array
			
		// number of items stored in object
		public function get length():int {
			return values.length;
		}
		public function set length(n:int):void {
			if (n < values.length) {
				if (n < 0) {
					n = 0;
				}
				values.length = n;
			}
		}
		
		/**
		 * Constructor 
		 */
		public function SortedObject() {}
		
		/**
		 * toString - string representation 
		 */
		public function toString():String {
			return "[SortedObject "+values.toString()+"]";
		}
		
		/**
		 * getProperty
		 * When a property is accessed from a SortedObject instance
		 * this method is called and the name of the property passed
		 * The correct value for the property is found and returned
		 */
		flash_proxy override function getProperty(name:*):* {
			var i:int = values.length;
			while (i--) {
				if (values[i].name == name) {
					// return found value. If more than one
					// property with name is defined, the most
					// recent value is returned
					return values[i].value;
				}
			}
			return undefined;
		}
		
		/**
		 * setProperty
		 * When a property is defined in a SortedObject instance
		 * this method is called and the name and value of the property passed
		 * The value is assigned to the values array in the location
		 * based on where it would reside sorted in that array
		 */
		flash_proxy override function setProperty(name:*, value:*):void {
			// SortedObjectItem contains the name and value passed
			var item:SortedObjectItem = new SortedObjectItem(name, value);
			var i:int = values.length;
			var comp:*;
			while (i--) {
				
				// if a number convert to a number for correct
				// sorting of negative or decimal values (due to . and -)
				comp = isNaN(values[i].name) ? values[i].name : Number(values[i].name);
				if (comp <= name) {
					values.splice(i + 1, 0, item);
					return;
				}
			}
			
			// less than all other values; add to beginning of array
			values.unshift(item);
		}
		
		/**
		 * deleteProperty
		 * When a property is deleted from a SortedObject instance
		 * this method is called and the name of the property passed
		 * The property is found in the values array and removed
		 * true is returned if successful, false if not
		 * If more than one property with the same name in a
		 * SortedObject instance exists, only the last is removed
		 */
		flash_proxy override function deleteProperty(name:*):Boolean {
			var i:int = values.length;
			while (i--) {
				if (values[i].name == name) {
					values.splice(i, 1);
					return true;
				}
			}
			return false;
		}
		
		/**
		 * nextNameIndex
		 * Lets you determine the next index value to be passed into
		 * nextName and/or nextValue in for loops.  When 0 is
		 * returned, it marks the end of a loop 
		 * For SortedObject it references the location in the values array
		 */
		flash_proxy override function nextNameIndex(index:int):int {
			_index = index;
			return index < values.length ? index + 1 : 0;
		}
		
		/**
		 * nextName
		 * Used for access of the next name in a for..in loop
		 * For SortedObject it references name in the index
		 * location in the values array
		 */
		flash_proxy override function nextName(index:int):String {
			return values[_index].name;
		}
		
		/**
		 * nextValue
		 * Used for access of the next name in a for each loop
		 * For SortedObject it references value in the index
		 * location in the values array
		 */
		flash_proxy override function nextValue(index:int):* {
			return values[_index].value;
		}
	}
}
/**
 * SortedObjectItem
 * 
 * Contains name and value of properties stored in SortedObject
 */
class SortedObjectItem {
	
	public var name:String;	// property name
	public var value:*;		// property value
		
	/**
	 * Constructor 
	 */
	public function SortedObjectItem(name:String, value:*) {
		this.name = name;
		this.value = value;
	}
	
	/**
	 * toString - string representation 
	 */
	public function toString():String {
		return name + ": " + value;
	}
}