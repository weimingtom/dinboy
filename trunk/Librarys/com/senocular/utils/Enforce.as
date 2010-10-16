package com.senocular.utils {
	
	import flash.utils.getQualifiedClassName;
	import flash.utils.Dictionary;
	
	/**
	 * Enforces a class to act as an abstract or (mostly) singleton class
	 * 
	 * Usage:
	 * function MyClass() {
	 * 	// abstract enforcement allows no constructor calls
	 * 	new Enforce(this, MyClass).isAbstract();
	 * }
	 * // or
	 * function MyClass() {
	 * 	// singleton enforcement allows one constructor call
	 * 	new Enforce(this, MyClass).isSingleton();
	 * }
	 */
	public class Enforce {
		
		protected static var singletons:Dictionary = new Dictionary();
		
		protected var instance:Object;	// instance to check
		protected var compareClass:Class;	// allows comparison protecting inheritance
		
		public function Enforce(instance:Object, compareClass:Class) {
			this.instance = instance;
			this.compareClass = compareClass;
		}
		
		/**
		 * throws error is constructor for instance is called
		 */
		public function isAbstract(error:Error = null):void {
			if (instance.constructor === compareClass) {
				if (error == null) {
					error = new ArgumentError("Cannot instantiate abstract class " + getQualifiedClassName(instance) + ".");
				}
				throw error;
			}
		}
		
		
		/**
		 * throws error is constructor for instance is called more than once
		 */
		public function isSingleton(error:Error = null):void {
			if (singletons[compareClass]) {
				if (instance.constructor === compareClass) {
					if (error == null) {
						error = ArgumentError("Cannot instantiate singleton class " + getQualifiedClassName(instance) + ". Use getInstance() instead.");
					}
					throw error;
				}
			}else{
				singletons[compareClass] = true;
			}
		}
	}
}