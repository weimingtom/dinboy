package com.kerry.util {
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	
	/**
	 * ObjectUtil 用于实例对象的工具类
	 * @author PhoenixKerry（http://blog.sina.com.cn/yyy98）
	 * @version 0.2
	 */
	public class ObjectUtil	{
		
		/**
		 * 将 fromObject 对象中的属性复制到 toObject 对象的相应属性中
		 * @param	fromObject 源对象
		 * @param	toObject 目标对象
		 */
		public static function copyProperties(fromObject:Object, toObject:Object):void {
			var isDynamicObject:Boolean = isDynamic(toObject);
			 for (var prop:String in fromObject) {
				 if (isDynamicObject || toObject.hasOwnProperty(prop)) toObject[prop] = fromObject[prop];
			}
		}
		
		/**
		 * 深度复制一个对象
		 * @param obj 要复制的对象
		 * @return 返回深度复制出的对象
		 */
		public static function copy (obj:Object):Object {
			var buffer:ByteArray = new ByteArray();
			buffer.writeObject(obj);
			buffer.position = 0;
			return buffer.readObject();
		}
		
		/**
		 * 判断一个对象是否为动态对象
		 * @return 如果是动态对象返回 ture，否则返回 false
		 */
		public static function isDynamic(obj:Object):Boolean {
			var xml:XML = describeType(obj);
			return xml.@isDynamic == "true";
		}
		
	}
}