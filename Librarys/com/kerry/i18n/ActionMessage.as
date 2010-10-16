package com.kerry.i18n {
	import flash.utils.Dictionary;
	/**
	* ActionMessage 类实现对国际化资源文件的访问
	* @author PhoenixKerry（http://blog.sina.com.cn/yyy98）
	* @version 0.3
	*/
	public class ActionMessage {
		private var _resources:Dictionary;
		
		/**
		 * 设置要访问的国际化资源文件
		 * @param	resTxt 国际化资源文件
		 */
		public function setResourcesTxt(resTxt:String):void {
			_resources = new Dictionary;
			var resAry:Array = resTxt.split("\n");
			for (var i:uint = 0; i < resAry.length; i++ ) {
				var line:String = resAry[i] as String;
				var startIndex:uint = line.search("=");
				_resources[line.slice(0, startIndex)] = line.slice(startIndex + 1, -1);
			}
		}
		
		/**
		 * 根据 key 查找相应的文本内容
		 * @param	key 文本键值
		 * @param	... args 值插参数，按传入顺序对应 #{0}，#{1}，#{2} ... ...
		 * @return 对应的文本信息
		 */
		public function getMessage(key:String, ... args:*):String {
			var message:String = _resources[key];
			
			if (args.length > 0) {
				for (var i:uint = 0; i < args.length; i++ ) {
					var pattern:String = "#{" + i + "}";
					message = message.replace(pattern, args[i]);
				}
			}
			
			return message;
		}
		
		public function get resources():Dictionary {
			return _resources;
		}
		
	}
}