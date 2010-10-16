package com.senocular.display {
	
	// external dependencies
	import com.senocular.display.e4d_internal;
	import com.senocular.display.E4DisplayObject;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.flash_proxy;
	import flash.utils.getDefinitionByName;
	import flash.utils.Proxy;

	/**
	 * Class that provides E4X-like access to display objects for
	 * accessing child objects in the display list and display 
	 * object members (as attributes).  E4DisplayList objects represent
	 * collections of one or more objects. For each method call and 
	 * property access made from a E4DisplayList instance is made for
	 * each object within the list it represents. The result is another
	 * E4DisplayList containing the results of the request.
	 * @see com.senocular.display.E4DisplayList
	 * @see com.senocular.display.e4d_internal
	 * @author Trevor McCauley (senocular.com)
	 */
	public dynamic class E4DisplayList extends Proxy {
		
		protected var list:Array = []; // collection of items in E4DisplayList
		private static const XML_INDENT:String = "  "; // indent for toXMLString
		private static const XML_NEWLINE:String = "\n"; // new line char for toXMLString
		
		
		/**
		 * Creates a new E4DisplayObject wrapper for a collection of display 
		 * (or other kind of) objects.
		 * @param	source The array for which the new E4DisplayList is to
		 * represent. If null is passed, the E4DisplayList will be empty.
		 */
		public function E4DisplayList(source:Array = null):void {
			if (source) list = source.concat();
		}
		
		
		/**
		 * The value of the E4DisplayList object.
		 * @return A direct reference to the E4DisplayList object or 
		 * undefined if the the E4DisplayList object is empty.
		 */
		public function valueOf():* {
			return list.length ? this : undefined;
		}
		
		/**
		 * The string representation of the E4DisplayObject object.
		 * @return A String conversion of the array representing the
		 * contents of the E4DisplayObject object.
		 */
		public function toString():String {
			return list.toString();
		}
		
		/**
		 * Creates an XML representation of the E4DisplayList object
		 * similar to that provided by XML.toXMLString(). Each DisplayObject
		 * represents an XML node with its child display objects as child
		 * elements.  Attributes added include any property available to those 
		 * display objects through iteration or those specified by attributeList.
		 * No special care is taken for converting attribute values to valid
		 * XML attribute strings, so specify such values cautiously.
		 * @param attributeList An optional array of the properties
		 * within each object represented by the E4DisplayList, hidden
		 * from enumeration, which are to be included in the resulting XML.
		 * @return An XML String representing the display list contained by 
		 * the E4DisplayList object.
		 */
		e4d_internal function toXMLString(attributeList:Array = null):String {
			var str:String = "";
			
			// iterate through each object within the contained list
			var i:int, n:int = list.length;
			for (i=0; i<n; i++) {
				if (str) str += XML_NEWLINE;
				str += createXMLString(list[i] as DisplayObject, attributeList, "");
			}
			return str;
		}
		
		/**
		 * Called by toXMLString for individual display objects.
		 */
		private function createXMLString(target:DisplayObject, attributeList:Array, indent:String):String {
			if (target == null) return "";
			
			// start of the XML element for this object
			var str:String = indent + "<" + target.name;
			
			var memberLookup:Object = {}; // prevents attribute duplication
			
			// enumerable members as attributes
			var memberName:String;
			for (memberName in target){
				memberLookup[memberName] = true;
				str += " " + memberName + "=\"" + target[memberName] + "\"";
			}
			
			// attributes provided by attributeList
			var i:int, n:int;
			if (attributeList){
				n = attributeList.length;
				for (i=0; i<n; i++){
					var att:String = attributeList[i];
					if (att in memberLookup == false && att in target){
						memberLookup[att] = true;
						str += " " + att + "=\"" + target[att] + "\"";
					}
				}
			}
			
			// child elements
			var container:DisplayObjectContainer = target as DisplayObjectContainer;
			var numChildren:int = 0;
			if (container){
				numChildren = container.numChildren;
			}
			if (numChildren){
				str += ">";
				
				// new XML nodes for each child
				n = numChildren;
				for (i=0; i<n; i++){
					str += XML_NEWLINE + createXMLString(container.getChildAt(i), attributeList, indent + XML_INDENT);
				}
				str += XML_NEWLINE + indent + "</" + target.name + ">";
			}else{
				str += "/>";
			}
			
			return str;
		}
		
		/**
		 * The number of objects contained within the E4DisplayList object.
		 * If any object within the E4DisplayList contains a length() method, 
		 * or to avoid the lookup overhead when calling, call length directly
		 * through the e4d_internal as e4d_internal::length().
		 * @return The number of objects contained within the E4DisplayList
		 * object.
		 */
		e4d_internal function length():uint {
			return list.length;
		}
		
		/**
		 * Filters the contents of the current E4DisplayList for all references
		 * whose name match the specified name.  The original list is not modified;
		 * a new filtered list is returned.
		 * If any object within the E4DisplayList contains a filterByName() method, 
		 * or to avoid the lookup overhead when calling, call filterByName directly
		 * through the e4d_internal as e4d_internal::filterByName().
		 * @param	name The name to search the E4DisplayList for matches.
		 * @return A new E4DisplayList object containing only those objects within
		 * the original that have a name property matching the provided name value.
		 */
		e4d_internal function filterByName(name:*):E4DisplayList {
		
			// filter each object in the list for ones
			// matching the specified name
			var result:E4DisplayList = new E4DisplayList();
			var resultsArr:Array = result.list;
			var i:int, n:int = list.length;
			for (i=0; i<n; i++){  var target:Object = list[i] as Object;
				
				try {
					if (target.name == name){
						resultsArr.push(target);
					}
				}catch(error:Error){} // fail silently
				
			}
			return result;
		}
		
		/**
		 * Filters the contents of the current E4DisplayList for all references
		 * that are of the specified type.  The original list is not modified; a
		 * new filtered list is returned.
		 * If any object within the E4DisplayList contains a filterByType() method, 
		 * or to avoid the lookup overhead when calling, call filterByType directly
		 * through the e4d_internal as e4d_internal::filterByType().
		 * @param	type A class reference, or string representation of a class
		 * to be used as a type check (via is operator) for all values within the
		 * E4DisplayList.
		 * @return A new E4DisplayList object containing only those objects within
		 * the original that match the provided type.
		 */
		e4d_internal function filterByType(type:*):E4DisplayList {
			var result:E4DisplayList = new E4DisplayList();
			var objectType:Class; // ckass reference to check
			if (type is Class) {
				objectType = type as Class;
			}else{
				// type is a string; convert to class reference
				try {
					objectType = getDefinitionByName(String(type)) as Class;
				}catch(error:Error){} // fail silently
			}
			
			// no type, return a new empty list
			if (objectType != null){
			
				// filter each object in the list for ones
				// of the specified type
				var resultsArr:Array = result.list;
				var i:int, n:int = list.length;
				for (i=0; i<n; i++){ var target:Object = list[i] as Object;
					
					if (target is objectType){
						resultsArr.push(target);
					}
					
				}
			}
			
			return result;
		}
		
		/**
		 * Filters the contents of the current E4DisplayList for all references
		 * using a custom callback function.  The original list is not modified; a
		 * new filtered list is returned.
		 * If any object within the E4DisplayList contains a filter() method, 
		 * or to avoid the lookup overhead when calling, call filter directly
		 * through the e4d_internal as e4d_internal::filter().
		 * @param	callBack The function to be called for each object within the
		 * E4DisplayList. The signature for this function is 
		 * callBack(test:E4DisplayObject):Boolean; where test is the item within
		 * the E4DisplayList to be filtered as an E4DisplayObject instance. To get
		 * a reference to the direct value of that object, use test.valueOf(). If
		 * that object is to remain within the filtered list, true is returned.
		 * When false is returned, the object is filtered out of the result.
		 * @return A new E4DisplayList object containing only those objects within
		 * the original that caused the callBack function to return true.
		 */
		e4d_internal function filter(callBack:Function):E4DisplayList {
			var result:E4DisplayList = new E4DisplayList();
			if (callBack == null) return result;
			var resultsArr:Array = result.list;
			var i:int, n:int = list.length;
			for (i=0; i<n; i++){ var target:Object = list[i] as Object;
				
				try {
					if (callBack(new E4DisplayObject(target))){
						resultsArr.push(target);
					}
				}catch(error:Error){} // fail silently
				
			}
			return result;
		}
		
		/**
		 * Add operation for values within an E4DisplayList.  Since ActionScript
		 * does not allow operator overloading, this method is used to add a
		 * value to multiple values stored within the current list.  If the value
		 * is an E4DisplayList, each item in that list will be matched up with each
		 * item in the current object's list for the operation.  If the value
		 * provided is otherwise not a numeric value, the add() method will attempt to 
		 * pass the provided value into an add() method of each item in the list
		 * if available (for example if adding flash.geom.Points to flash.geom.Points).
		 * @param	value The value to be added to each item in the E4DisplayList
		 * object.
		 * @return A new E4DisplayList object containing the results of the operation.
		 */
		e4d_internal function add(value:*):E4DisplayList {
			var target:Object;
			var result:E4DisplayList = new E4DisplayList();
			var resultsArr:Array = result.list;
			var i:int, n:int;
			
			var numValue:Number = Number(value);
			if (isNaN(numValue)){ // non-numeric value
				
				var valueE4D:E4DisplayList = value as E4DisplayList;
				if (valueE4D){ // list to list
					
					var valueList:Array = valueE4D.list;
					n = Math.min(list.length, valueList.length);
					for (i=0; i<n; i++){
						try {
							if (isNaN(list[i]) || isNaN(valueList[i])){
								resultsArr.push( list[i].add(valueList[i]) );
							}else{
								resultsArr.push( list[i] + valueList[i] );
							}
						}catch(error:Error){}
					}
					
				}else{ // not a number, so try API
					
					n = list.length;
					for (i=0; i<n; i++){
						try {
							resultsArr.push( list[i].add(value) );
						}catch (error:Error){}
					}
					
				}
				
			}else{ // numeric value
				
				n = list.length;
				for (i=0; i<n; i++){
					try {
						if (!isNaN(list[i])){
							resultsArr.push( list[i] + numValue );
						}
					}catch(error:Error){}
				}
				
			}
			return result;
		}
		
		/**
		 * Subtract operation for values within an E4DisplayList.  Since ActionScript
		 * does not allow operator overloading, this method is used to subtract a
		 * value to multiple values stored within the current list.  If the value
		 * is an E4DisplayList, each item in that list will be matched up with each
		 * item in the current object's list for the operation.  If the value
		 * provided is otherwise not a numeric value, the subtract() method will attempt to 
		 * pass the provided value into an subtract() method of each item in the list
		 * if available (for example if subtracting flash.geom.Point from flash.geom.Point).
		 * @param	value The value to be subtracted from each item in the E4DisplayList
		 * object.
		 * @return A new E4DisplayList object containing the results of the operation.
		 */
		e4d_internal function subtract(value:*):E4DisplayList {
			var target:Object;
			var result:E4DisplayList = new E4DisplayList();
			var resultsArr:Array = result.list;
			var i:int, n:int;
			
			var numValue:Number = Number(value);
			if (isNaN(numValue)){ // non-numeric value
				
				var valueE4D:E4DisplayList = value as E4DisplayList;
				if (valueE4D){ // list to list
					
					var valueList:Array = valueE4D.list;
					n = Math.min(list.length, valueList.length);
					for (i=0; i<n; i++){
						try {
							if (isNaN(list[i]) || isNaN(valueList[i])){
								resultsArr.push( list[i].subtract(valueList[i]) );
							}else{
								resultsArr.push( list[i] - valueList[i] );
							}
						}catch(error:Error){}
					}
					
				}else{ // not a number, so try API
					
					n = list.length;
					for (i=0; i<n; i++){
						try {
							resultsArr.push( list[i].subtract(value) );
						}catch (error:Error){}
					}
					
				}
				
			}else{ // numeric value
				
				n = list.length;
				for (i=0; i<n; i++){
					try {
						if (!isNaN(list[i])){
							resultsArr.push( list[i] - numValue );
						}
					}catch(error:Error){}
				}
				
			}
			return result;
		}
		
		/**
		 * Multiply operation for values within an E4DisplayList.  Since ActionScript
		 * does not allow operator overloading, this method is used to multiply a
		 * value to multiple values stored within the current list.  If the value
		 * is an E4DisplayList, each item in that list will be matched up with each
		 * item in the current object's list for the operation.  If the value
		 * provided is otherwise not a numeric value, the multiply() method will attempt to 
		 * pass the provided value into an multiply() method of each item in the list
		 * if available.
		 * @param	value The value to be multiplied to each item in the E4DisplayList
		 * object.
		 * @return A new E4DisplayList object containing the results of the operation.
		 */
		e4d_internal function multiply(value:*):E4DisplayList {
			var target:Object;
			var result:E4DisplayList = new E4DisplayList();
			var resultsArr:Array = result.list;
			var i:int, n:int;
			
			var numValue:Number = Number(value);
			if (isNaN(numValue)){ // non-numeric value
				
				var valueE4D:E4DisplayList = value as E4DisplayList;
				if (valueE4D){ // list to list
					
					var valueList:Array = valueE4D.list;
					n = Math.min(list.length, valueList.length);
					for (i=0; i<n; i++){
						try {
							if (isNaN(list[i]) || isNaN(valueList[i])){
								resultsArr.push( list[i].multiply(valueList[i]) );
							}else{
								resultsArr.push( list[i] * valueList[i] );
							}
						}catch(error:Error){}
					}
					
				}else{ // not a number, so try API
					
					n = list.length;
					for (i=0; i<n; i++){
						try {
							resultsArr.push( list[i].multiply(value) );
						}catch (error:Error){}
					}
					
				}
				
			}else{ // numeric value
				
				n = list.length;
				for (i=0; i<n; i++){
					try {
						if (!isNaN(list[i])){
							resultsArr.push( list[i] * numValue );
						}
					}catch(error:Error){}
				}
				
			}
			return result;
		}
		
		/**
		 * Divide operation for values within an E4DisplayList.  Since ActionScript
		 * does not allow operator overloading, this method is used to divide
		 * multiple values stored within the current list by a value.  If the value
		 * is an E4DisplayList, each item in that list will be matched up with each
		 * item in the current object's list for the operation.  If the value
		 * provided is otherwise not a numeric value, the divide() method will attempt to 
		 * pass the provided value into an divide() method of each item in the list
		 * if available.
		 * @param	value The value by which each item in the E4DisplayList object
		 * is to be divided.
		 * @return A new E4DisplayList object containing the results of the operation.
		 */
		e4d_internal function divide(value:*):E4DisplayList {
			var target:Object;
			var result:E4DisplayList = new E4DisplayList();
			var resultsArr:Array = result.list;
			var i:int, n:int;
			
			var numValue:Number = Number(value);
			if (isNaN(numValue)){ // non-numeric value
				
				var valueE4D:E4DisplayList = value as E4DisplayList;
				if (valueE4D){ // list to list
					
					var valueList:Array = valueE4D.list;
					n = Math.min(list.length, valueList.length);
					for (i=0; i<n; i++){
						try {
							if (isNaN(list[i]) || isNaN(valueList[i])){
								resultsArr.push( list[i].divide(valueList[i]) );
							}else{
								resultsArr.push( list[i] / valueList[i] );
							}
						}catch(error:Error){}
					}
					
				}else{ // not a number, so try API
					
					n = list.length;
					for (i=0; i<n; i++){
						try {
							resultsArr.push( list[i].divide(value) );
						}catch (error:Error){}
					}
					
				}
				
			}else{ // numeric value
				
				n = list.length;
				for (i=0; i<n; i++){
					try {
						if (!isNaN(list[i])){
							resultsArr.push( list[i] / numValue );
						}
					}catch(error:Error){}
				}
				
			}
			return result;
		}
		
		/**
		 * Modulus operation for values within an E4DisplayList.  Since ActionScript
		 * does not allow operator overloading, this method is used to mod
		 * multiple values stored within the current list by a value.  If the value
		 * is an E4DisplayList, each item in that list will be matched up with each
		 * item in the current object's list for the operation.  If the value
		 * provided is otherwise not a numeric value, the mod() method will attempt to 
		 * pass the provided value into an mod() method of each item in the list
		 * if available.
		 * @param	value The value by which each item in the E4DisplayList object
		 * is to be divided.
		 * @return A new E4DisplayList object containing the results of the operation.
		 */
		e4d_internal function mod(value:*):E4DisplayList {
			var target:Object;
			var result:E4DisplayList = new E4DisplayList();
			var resultsArr:Array = result.list;
			var i:int, n:int;
			
			var numValue:Number = Number(value);
			if (isNaN(numValue)){ // non-numeric value
				
				var valueE4D:E4DisplayList = value as E4DisplayList;
				if (valueE4D){ // list to list
					
					var valueList:Array = valueE4D.list;
					n = Math.min(list.length, valueList.length);
					for (i=0; i<n; i++){
						try {
							if (isNaN(list[i]) || isNaN(valueList[i])){
								resultsArr.push( list[i].mod(valueList[i]) );
							}else{
								resultsArr.push( list[i] % valueList[i] );
							}
						}catch(error:Error){}
					}
					
				}else{ // not a number, so try API
					
					n = list.length;
					for (i=0; i<n; i++){
						try {
							resultsArr.push( list[i].mod(value) );
						}catch (error:Error){}
					}
					
				}
				
			}else{ // numeric value
				
				n = list.length;
				for (i=0; i<n; i++){
					try {
						if (!isNaN(list[i])){
							resultsArr.push( list[i] % numValue );
						}
					}catch(error:Error){}
				}
				
			}
			return result;
		}
		
		/**
		 * Compares the values represented by two lists to see if they contain
		 * the same values.  Strict equality (===) is used in the comparison.
		 * @param	list A E4DisplayList to compare against this E4DisplayList
		 * object.
		 * @return True if the two lists match, false if not.
		 */
		e4d_internal function equals(displayList:E4DisplayList):Boolean {
			var valueList:Array = displayList.list;
			var i:int = list.length;
			
			// don't match if list lengths don't match
			if (i != valueList.length){
				return false;
			}
			
			// make sure each list item matches
			while (i--){
				if (list[i] !== valueList[i]){
					return false;
				}
			}
			return true;
		}
		
		
		/**
		 * Calls functions defined within the objects referenced within the
		 * E4DisplayList object. If the function does not exist within any of
		 * those objects, the function by that name defined within E4DisplayList
		 * under the e4d_internal namespace will be called if it exists.
		 * @return The results of the function calls as an E4DisplayList if
		 * called from any of the referenced object within the E4DisplayList or
		 * a direct result of the function within the e4d_internal namespace
		 * if it was called.  If a function in some but not all of the objects
		 * referenced within the E4DisplayList, those not found would not create
		 * empty entries in the returned list; they would be skipped. The resulting
		 * list may have a different length than the one from which the method
		 * was called.
		 */
		flash_proxy override function callProperty(name:*, ...rest):* {
			var methodFound:Boolean = false; // determines if to use e4d_internal method
			var result:E4DisplayList = new E4DisplayList();
			var resultsArr:Array = result.list;
			var i:int = list.length;
			while(i--){
				var target:Object = list[i] as Object;
				
				if (target){
					if (name in target){
						if (!methodFound) methodFound = true;
						try {
							resultsArr.push( target[name].apply(target, rest) );
						}catch(error:Error){} // fail silently
					}
				}
			}
			// fallback if no target methods found
			if (!methodFound){
				try {
					return e4d_internal::[name].apply(this, rest);
				}catch(error:Error){} // fail silently
			}
			
			return result;
		}
 	 	
		/**
		 * Deletes members within objects referenced by the E4DisplayList object.
		 * Members referenced directly by name accound for display objects with
		 * the same name defined within display objects within the list. For 
		 * example, delete myList.foo; would remove all display objects
		 * named foo that existed within any of the display objects contained
		 * within the E4DisplayList instance named myList.  For property deletion
		 * reference property names as attributes, such as myList.@bar for the
		 * property named bar.
		 * @param	name The name of the member being deleted
		 * @return True if a member was deleted; false if not.
		 */
		flash_proxy override function deleteProperty(name:*):Boolean {
			var hasDeleted:Boolean = false;
			var target:Object;
			var i:int = list.length;
		
			if (flash_proxy::isAttribute(name)){ // attribute property
				name = new QName(name.uri, name.localName); // removes any @
				
				// for the wildcard, all members are deleted; this
				// only applies to members available in enumeration
				if (name == "*"){
					while (i--){ target = list[i] as Object;
						var memberName:String;
						for (memberName in target){
							if ((delete target[memberName]) && !hasDeleted){
								hasDeleted = true;
							}
						}
					}
				}else{ // named attribute
					while (i--){ target = list[i] as Object;
						if ((delete target[name]) && !hasDeleted){
							hasDeleted = true;
						}
					}
				}
			}else{ // non-attribute property
				while (i--){
					var container:DisplayObjectContainer = list[i] as DisplayObjectContainer;
					if (container){
						var ii:int = container.numChildren;
						while(ii--){
							var child:DisplayObject = container.getChildAt(ii);
							if (name == "*" || name == child.name){
								container.removeChild(child);
								if (!hasDeleted) hasDeleted = true;
							}
						}
					}
				}
			}
			return hasDeleted;
		}
		
		/**
		 * Returns all the display object descendants within the display objects
		 * referenced within the E4DisplayList object as a new E4DisplayList
		 * instance.  Using the wildcard value of "*" will return all descendants,
		 * otherwise only descendants matching the provided name will be returned.
		 * If any object within the E4DisplayList contains a descendants() method, 
		 * or to avoid the lookup overhead when calling, call descendants directly
		 * through the e4d_internal as e4d_internal::descendants().
		 * @param	name The name of the display object descendants to be returned.
		 * If "*" is supplied, all display object descendants are returned.
		 * @return All display object descendants matching the provided name as
		 * a new E4DisplayList object.
		 */
		e4d_internal function descendants(name:* = "*"):E4DisplayList {
			var isAtt:Boolean = flash_proxy::isAttribute(name);
			if (isAtt) name = new QName(name.uri, name.localName); // removes any @
			var result:E4DisplayList = new E4DisplayList();
			var resultsArr:Array = result.list;
			getDescendantsList(resultsArr, name, isAtt);
			return result;
		}
		
		/**
		 * Handles use of the descendants operator (..) to call
		 * e4d_internal::descendants().
		 * @param	name The name of the display object descendants to be returned.
		 * If "*" is supplied, all display object descendants are returned.
		 * @return All display object descendants matching the provided name as
		 * a new E4DisplayList object.
		 */
		flash_proxy override function getDescendants(name:*):* {
			return e4d_internal::descendants(name);
		}
		
		/**
		 * Called by descendants() to iterate through the list items to
		 * get their descendants.
		 */
		protected function getDescendantsList(resultsArr:Array, name:*, isAtt:Boolean):void {
			var i:int, n:int = list.length;
			for (i=0; i<n; i++){
				var container:DisplayObjectContainer = list[i] as DisplayObjectContainer;
				if (container){
					getDescendantsDisplayList(container, resultsArr, name, isAtt);
				}
			}
		}
		/**
		 * Called by getDescendantsList() to iterate through display objects
		 * of a display object container
		 */
		protected function getDescendantsDisplayList(target:DisplayObjectContainer, resultsArr:Array, name:*, isAtt:Boolean):void {
			if (target == null) return;
			var child:DisplayObject;
			var childContainer:DisplayObjectContainer;
			var i:int, n:int = target.numChildren;
			
			// there's a little redundancy in the following loops but it
			// was done to keep the loop operations to a minimum.
			// getDescendantsDisplayList needs to be called within every
			// loop but it's best if the checks for isAtt, and name ==
			// weren't in each iteration to help with performance, otherwise
			// these could all be done in one loop
			
			if (isAtt){ // attribute property
					
				// for the wildcard, all members are captured; this
				// only applies to members available in enumeration
				if (name == "*"){
					for (i=0; i<n; i++){ child = target.getChildAt(i);
						var memberName:String;
						for (memberName in child){
							resultsArr.push(child[memberName]);
						}
						childContainer = child as DisplayObjectContainer;
						if (childContainer) getDescendantsDisplayList(childContainer, resultsArr, name, isAtt);
					}
				}else{ // named attribute
					for (i=0; i<n; i++){ child = target.getChildAt(i);
						try {
							resultsArr.push(child[name]);
						}catch (error:Error){} // fail silently
						childContainer = child as DisplayObjectContainer;
						if (childContainer) getDescendantsDisplayList(childContainer, resultsArr, name, isAtt);
					}
				}
			}else{
				if (name == "*"){ // all display object properties
					for (i=0; i<n; i++){ child = target.getChildAt(i);
						resultsArr.push(child);
						childContainer = child as DisplayObjectContainer;
						if (childContainer) getDescendantsDisplayList(childContainer, resultsArr, name, isAtt);
					}
				}else{ // named properties
					for (i=0; i<n; i++){ child = target.getChildAt(i);
						if (name == child.name){
							resultsArr.push(child);
						}
						childContainer = child as DisplayObjectContainer;
						if (childContainer) getDescendantsDisplayList(childContainer, resultsArr, name, isAtt);
					}
				}
			}
		}
		
		/**
		 * Determines if a property exists within the E4DisplayList object.
		 * Attribute properties (prefixed with an @ symbol) check object
		 * properties while normal property references check display objects
		 * with the provided name within objects referenced by the 
		 * E4DisplayList object.
		 * @param	name The name of the property to check if exists.
		 * @return True if the property exists, false if not.
		 */
		flash_proxy override function hasProperty(name:*):Boolean {
			var target:Object;
			var container:DisplayObjectContainer;
			var i:int = list.length;
			
			if (flash_proxy::isAttribute(name)){ // attribute property
				name = new QName(name.uri, name.localName); // removes any @
				while (i--){ target = list[i] as Object;
					if (name in target){
						return true;
					}
				}
			}else{ // display object properties
				while (i--){ container = list[i] as DisplayObjectContainer;
					if (container && container.getChildByName(name)){
						return true;
					}
				}
			}
			
			return false;
		}
		
		/**
		 * Returns all the display objects within the display objects referenced
		 * within the E4DisplayList object as a new E4DisplayList instance. 
		 * Using the wildcard value of "*" will return all display objects,
		 * otherwise only display objects matching the provided name will be
		 * returned.
		 * If any object within the E4DisplayList contains a elements() method, 
		 * or to avoid the lookup overhead when calling, call elements directly
		 * through the e4d_internal as e4d_internal::elements().
		 * @param	name The name of the display objects to be returned.
		 * If "*" is supplied, all display objects are returned.
		 * @return All display objects matching the provided name as
		 * a new E4DisplayList object.
		 */
		e4d_internal function elements(name:* = "*"):E4DisplayList {
			name = String(name); // names are simple strings for display objects
			var result:E4DisplayList = new E4DisplayList();
			var resultsArr:Array = result.list;
			var container:DisplayObjectContainer;
			var ii:int, nn:int;
			var i:int, n:int = list.length;
			if (name == "*"){ // all children
				for (i=0; i<n; i++){ container = list[i] as DisplayObjectContainer;
					if (container){
						nn = container.numChildren;
						for (ii=0; ii<nn; ii++){
							resultsArr.push( container.getChildAt(ii) );
						}
					}
				}
			}else{ // only children matching name
				for (i=0; i<n; i++){ container = list[i] as DisplayObjectContainer;
					if (container){
						nn = container.numChildren;
						for (ii=0; ii<nn; ii++){
							var child:DisplayObject = container.getChildAt(ii);
							if (name == child.name){
								resultsArr.push(child);
							}
						}
					}
				}
			}
			return result;
		}
		
		/**
		 * Returns all attribute (property) values within the objects referenced
		 * within the E4DisplayList object as a new E4DisplayList instance. 
		 * Using the wildcard value of "*" will return all values,
		 * otherwise only those matching the provided name will be
		 * returned.
		 * If any object within the E4DisplayList contains a attribute() method, 
		 * or to avoid the lookup overhead when calling, call attribute directly
		 * through the e4d_internal as e4d_internal::attribute().
		 * @param	name The name of the attribute (property), without the "@" 
		 * symbol, to have values be returned for. 
		 * If "*" is supplied, all attribute are returned.  Attributes returned
		 * in this manner are only those accessible through enumeration.
		 * @return All values matching the provided name as
		 * a new E4DisplayList object.
		 */
		e4d_internal function attribute(name:* = "*"):E4DisplayList {
			var result:E4DisplayList = new E4DisplayList();
			var resultsArr:Array = result.list;
			var target:Object;
			var i:int, n:int = list.length;
				
			// for the wildcard, all members are referenced; this
			// only applies to members available in enumeration
			if (name == "*"){
				for (i=0; i<n; i++){ target = list[i] as Object;
					var memberName:String;
					for (memberName in target){
						resultsArr.push(target[memberName]);
					}
				}
			}else{ // named attribute
				for (i=0; i<n; i++){ target = list[i] as Object;
					try {
						resultsArr.push(target[name]);
					}catch(error:Error){} // fail silently
				}
			}
				
			return result;
		}
		
		/**
		 * Handles property access using the dot (.) operator.  Normal property
		 * members reference display objects by name while attributes references
		 * (prefixed with "@") access object properties. This call is resolved to
		 * either e4d_internal::elements() or e4d_internal::attribute() with the
		 * exception of lookup by numeric index.  A numeric index value, such as
		 * myList[0], will return a reference to the object in that index of the
		 * E4DisplayList object as a E4DisplayObject instance.
		 * @param	name The name of the property to be returned. If prefixed with
		 * an @ symbol when referenced, attribute() is called, otherwise elements().
		 * When a numeric index, the object within the list at that index is
		 * returned.
		 * @return A E4DisplayList of the objects matching the name of the
		 * property being accessed.  If property is a numeric index, a 
		 * E4DisplayObject instance of the object at that index in the list is
		 * returned. If that index does not exist, undefined is returned.
		 */
		flash_proxy override function getProperty(name:*):* {
			// indexed value
			if (name is String){
				var index:Number = Number(name);
				if (!isNaN(index)){
					if (index < list.length){
						return new E4DisplayObject(list[index]);
					}
					return undefined;
				}
			}
			
			if (flash_proxy::isAttribute(name)){
				return e4d_internal::attribute(new QName(name.uri, name.localName));
			}
			
			return e4d_internal::elements(name);
		}
		
		/**
		 * Sets a property of the referenced name to the specified value
		 * for all objects referenced in the E4DisplayList object in an equals
		 * (=) assignment.  If a non-attribute property is being set, the value
		 * must be a display object.  This display object is added to the display
		 * list of the last display object container within the E4DisplayList
		 * object using addChild(). For display objects, only one assignment 
		 * can be made since any one display object can only exist in one display
		 * list.  Once such a display object is added to a display list, the
		 * assignment is complete.  Normal attribute assignments are applied to
		 * every object wihtin the E4DisplayList.
		 * @param	name The name of the property to be assigned.
		 * @param	value The value to be assigned.
		 */
		flash_proxy override function setProperty(name:*, value:*):void {
			var target:Object;
			var memberName:String;
			var container:DisplayObjectContainer;
			var child:DisplayObject;
			var i:int, n:int;
			
			// if value is E4DisplayList, must match list values
			// to property values identied in name
			var valueE4D:E4DisplayList = value as E4DisplayList;
			if (valueE4D){
				
				
				var valueList:Array = valueE4D.list;
				var vi:int, vn:int = valueList.length; // counting, position in valueList
				
				if (flash_proxy::isAttribute(name)){ // attribute property
					name = new QName(name.uri, name.localName); // removes any @
					
					// for the wildcard, all members are set; this
					// only applies to members available in enumeration
					if (name == "*"){
						vi = 0;
						n = list.length;
						for (i=0; i<n; i++){ target = list[i] as Object;
							for (memberName in target){
								target[memberName] = valueList[vi];
								if (++vi >= vn){
									// out of values in valueList
									return;
								}
							}
						}
					}else{ // named attribute
						n = Math.min(list.length, valueList.length);
						for (i=0; i<n; i++){ target = list[i] as Object;
							try {
								target[name] = valueList[i];
							}catch(error:Error){} // fail silently
						}
					}
					
				}else{ // non-attribute property
					
					// reverse traversal to simulate addChild()-like behavior
					name = String(name); // names are simple strings for display objects
					n = list.length;
					while (n--){
						container = list[n] as DisplayObjectContainer;
						if (container){
							for (vi=0; vi<vn; vi++){ child = valueList[vi] as DisplayObject;
								if (child){
									child.name = name;
									container.addChild(child);
								}
							}
							// kill it here since a display object can
							// only be added to one display list
							return;
						}
					}
					
				}
				
				
			}else{ // direct value assignment
				
				
				n = list.length;
				if (flash_proxy::isAttribute(name)){ // attribute property
					name = new QName(name.uri, name.localName); // removes any @
					
					// for the wildcard, all members are set; this
					// only applies to members available in enumeration
					if (name == "*"){
						for (i=0; i<n; i++){ target = list[i] as Object;
							for (memberName in target){
								try {
									target[memberName] = value;
								}catch(error:Error){} // fail silently
							}
						}
					}else{ // named attribute
						for (i=0; i<n; i++){ target = list[i] as Object;
							try {
								target[name] = value;
							}catch(error:Error){} // fail silently
						}
					}
					
				}else{ // non-attribute property
					
					child = value as DisplayObject;
					if (child == null){
						// for non-attribute references (display objects)
						// if the value passed itself is not a display object
						// then nothing can be done, so exit the call
						return;
					}
					// Note: * does not apply to display objects
					
					// reverse traversal to simulate addChild()-like behavior
					while (n--){
						container = list[n] as DisplayObjectContainer;
						if (container){
							child.name = String(name);
							container.addChild(child);
							// kill it here since a display object can
							// only be added to one display list
							return;
						}
					}
				}
			}
		}
		
		/**
		 * Allows enumeration of all the objects by name within the E4DisplayList 
		 * object.
		 * @param	index The one-based index value of the object's property. 
		 * @return The name of the display object being iterated over.
		 */
		flash_proxy override function nextName(index:int):String {
			var target:DisplayObject = list[index - 1] as DisplayObject;
			if (target){
				return target.name;
			}
			return String(index);
		}
		
		/**
		 * Allows enumeration of all the objects by index within the E4DisplayList 
		 * object.
		 * @param	index The zero-based index value of the object's property. 
		 * @return The next index to be used within the iteration; 0 if there
		 * are no more objects to be iterated over.
		 */
		flash_proxy override function nextNameIndex(index:int):int {
			if (index < list.length){
				return index + 1;
			}
			return 0;
		}
		
		/**
		 * Allows enumeration of all the objects by value within the E4DisplayList 
		 * object.
		 * @param	index The one-based index value of the object's property. 
		 * @return The E4DisplayObject representation of the item being iterated
		 * over.
		 */
		flash_proxy override function nextValue(index:int):* {
			return new E4DisplayObject(list[index - 1]);
		}
	}
}