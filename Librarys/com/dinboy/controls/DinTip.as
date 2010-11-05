package com.dinboy.display 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @copy Dinboy.com © 2010
	 * @author 钉崽
	 * 我的约定:
	 * public(公有属性)            定义名称无前缀,并使用驼峰写法;
	 * private(私有属性)           函数名称无前缀,并使用驼峰写法; 变量名称使用下划线前缀"_",并使用驼峰写法;
	 * const(定义常量)             函数名称无前缀,并使用驼峰写法; 常量名称使用大写字母,必要时使用下划线"_";
	 * function(函数内部定义)  函数内部变量使用美元符号前缀"$",并使用驼峰写法;
	 */
  
		//==============================
		//#### This Is A Interpretation Template ####
		//==============================
	
	public class DinTip 
	{
		/**
		 * 实例本身
		 */
		private static var _instance:DinTip = null;
		
		/**
		 * 显示对象的容器
		 */
		private var _displayObjectContainer:DisplayObjectContainer;
		
		public function DinTip() 
		{
			
		}
		
		/**
		 * 初始化程序
		 * @param	$displayObjectContainer
		 */
		public static function init($displayObjectContainer:DisplayObjectContainer):void 
		{
			if (_instance==null) 
			{
				_instance = new DinTip();
			}
			_instance._displayObjectContainer = $displayObjectContainer;
		}
		
		public static function show($message:String = "Message", $areaWidth:Number = 0, $areaHeight:Number=0,$iconSrc:String = null):void 
		{
			var	$dinTipBase:DinTipBase = new DinTipBase($message, $areaWidth, $areaHeight, $iconSrc);
					$dinTipBase.mouseEnabled = false;
					$dinTipBase.show(_instance._displayObjectContainer);
		}

		//==============================
		//#### 设置/获取 属性 ####
		//==============================
		/**
		 * [Ready Only]	显示对象的容器
		 */
		public static function get displayObjectContainer():DisplayObjectContainer {
			var $displayObjectContainer:DisplayObjectContainer;
					_instance == null?$displayObjectContainer = null : $displayObjectContainer = _instance._displayObjectContainer; 
					return $displayObjectContainer;
			}
		
		
		
		
		
		//==============================
		//#### DinBoy Say : This Class["DinTip"] Is Finish ####
		//==============================
	}

}