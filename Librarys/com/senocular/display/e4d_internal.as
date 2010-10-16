package com.senocular.display {
	
	/**
	 * Namespace used by methods of E4DisplayList and E4DisplayObject
	 * to help separate their definitions from those defined within
	 * the objects they reference.  If a E4DisplayList or E4DisplayObject
	 * method conflicts with one of their references, calling that
	 * method through the e4d_internal (e.g. e4d_internal::length())
	 * will correctly target the method of the E4DisplayList or
	 * E4DisplayObject instance.  Methods not in this namespace include
	 * toString() and valueOf().
	 */
	public namespace e4d_internal = "http://www.senocular.com/display/e4d_internal";
}
