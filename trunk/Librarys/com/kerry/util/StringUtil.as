package com.kerry.util {
	
	/**
	 * StringUtil 字符串处理的工具类
	 * @author PhoenixKerry（http://blog.sina.com.cn/yyy98）
	 * @version 0.2
	 */
	public class StringUtil {
		/**
		 * 消除字符串前后的空格
		 * @param	input 字符串
		 * @return 改变后的字符串
		 */
		public static function trim(input:String):String {
			return StringUtil.ltrim(StringUtil.rtrim(input));
		}
		
		/**
		 * 消除字符串左侧的空格
		 * @param	input 字符串
		 * @return 改变后的字符串
		 */
		public static function ltrim(input:String):String {
			var size:Number = input.length;
			for (var i:Number = 0; i < size; i++) {
				if (input.charCodeAt(i) > 32) {
					return input.substring(i);
				}
			}
			return "";
		}
		
		/**
		 * 消除字符串右侧的空格
		 * @param	input 字符串
		 * @return 改变后的字符串
		 */
		public static function rtrim(input:String):String {
			var size:Number = input.length;
			for (var i:Number = size; i > 0; i--) {
				if (input.charCodeAt(i - 1) > 32) {
					return input.substring(0, i);
				}
			}
			return "";
		}
		
		/**
		 * 判断字符串是否有值
		 * @param	s 字符串
		 * @return 如果有值返回 true，没有值返回 false
		 */
		public static function stringHasValue(s:String):Boolean {
			return (s != null && s.length > 0);			
		}
		
		/**
		 * 判断字符串是否为有效的 email 地址
		 * @return 如果是有效 email 地址返回 true，否则返回 false
		 */
		public static function isEmail(s:String):Boolean {
			return /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,6}$/i.test( s );
		}
		
		/**
		 * 判断字符串是否为空白字符
		 * @return 如果是空白字符返回 true，否则返回 false
		 */
		public static function isWhitespace(s:String):Boolean {
			switch(s) {
				case " ":
				case "\t":
				case "\r" :
	            case "\n" :
	            case "\f" :
				return true;
			}
			return false;
		}
		
	}
}