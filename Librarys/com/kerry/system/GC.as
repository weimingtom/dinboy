package com.kerry.system {
	import flash.net.LocalConnection;
	/**
	 * AS3 调用内存回收，利用 AS-Hack 进行垃圾回收调度
	 * @author PhoenixKerry（http://blog.sina.com.cn/yyy98）
	 * @version 0.3
	 */
	public class GC {
		/**
		 * 调用内存回收
		 */
		public static function call():void {
			try {
				var lc1:LocalConnection = new LocalConnection();
				var lc2:LocalConnection = new LocalConnection();
				lc1.connect("KerryLib");
				lc2.connect("yyy98");
			} catch (e:Error) {}
		}
		
	}
}