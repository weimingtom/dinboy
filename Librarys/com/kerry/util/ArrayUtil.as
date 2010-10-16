package com.kerry.util {
	/**
	 * ArrayUtil 数组处理的工具类
	 * @author PhoenixKerry（http://blog.sina.com.cn/yyy98）
	 * @version 0.2
	 */
	public class ArrayUtil {
		/**
		 * 判断数组中是否存在某个值
		 * @param	arr 数组
		 * @param	value 值
		 * @return 如果存在返回 true，不存在返回 false
		 */
		public static function arrayContainsValue(arr:Array, value:Object):Boolean {
			return (arr.indexOf(value) != -1);
		}
		
		/**
		 * 判断数组中是否存在某个值
		 * @param	arr 数组
		 * @param	value 值
		 * @return 如果存在返回 true，不存在返回 false
		 */
		public static function removeValueFromArray(arr:Array, value:Object):void {
			var len:uint = arr.length;
			for (var i:Number = len; i > -1; i--) {
				if (arr[i] === value) {
					arr.splice(i, 1);
				}
			}
		}
		
		/**
		 * 返回当前数组的副本
		 * @param	arr 数组
		 * @return 数组的副本
		 */
		public static function copyArray(arr:Array):Array {	
			return arr.slice();
		}
		
		/**
		 * 判断两个数组是否相同
		 * @param	arr1 数组1
		 * @param	arr2 数组2
		 * @return 如果两个数组相同返回 true，如果不相同返回 false
		 */
		public static function arraysAreEqual(arr1:Array, arr2:Array):Boolean {
			if (arr1.length != arr2.length) {
				return false;
			}
			var len:Number = arr1.length;
			for (var i:Number = 0; i < len; i++) {
				if (arr1[i] !== arr2[i]) {
					return false;
				}
			}
			return true;
		}
		
		/**
		 * 打乱数组元素
		 * @param source 将数组乱序排列
		 */
		public static function randomArray(arr:Array):void {
			if (arr == null) return;
			for (var i:uint = 0, len:uint = arr.length; i < len; i++ ) {
				var n:uint = len - i;
				var r:uint = Math.floor(Math.random() * n);
				var t:* = arr[r];
				arr[r] = arr[n - 1];
				arr[n - 1] = t;
			}
		}
		
	}
}
