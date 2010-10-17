package com.dinboy.util 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author		DinBoy
	 * @copy		钉崽 © 2010
	 * @version		v1.0 [2010-10-17 11:41]
	 */
	public class dinTransfrom
	{
		/**
		 * 显示需要沿某个转换的注册点
		 */
		private  var _point:Point;
		
		/**
		 * 需要被转换的显示对象
		 */
		private var _target:DisplayObject;
		
		/**
		 * 对象转换前的坐标点
		 */
		private var _local:Point;
		
		/**
		 * 静态的本转换对象
		 */
		private static var _instance:dinTransfrom=null;
		
		/**
		 * 改变对象属性的工具.
		 */
		public function dinTransfrom() 
		{
			trace("[dinTransfrom] 是一个静态类,不需要实例化~");
		}
		
		/**
		 * 初始化转换工具.为了让静态函数使用
		 */
		public static function init():void 
		{
			if (_instance == null)  _instance = new dinTransfrom();
		}
		
		/**
		 * 显示对象需要沿注册点缩放
		 * @param	__target	显示对象;
		 * @param	__v			需要转换的显示对象的参数 point(注册点)是必须的 如:{x:100,y:100,scale:1,point:new point(10,10)};
		 */
		public static function transfromByPoint(__target:Object,__v:*):void 
		{
			if (!(__v.point is Point)) 
			{
				return;
			}
			init();
			var __p:Point;
			_instance._point = __v.point.clone();
			_instance._target = __target as DisplayObject;
			_instance._local = _instance._target.globalToLocal(_instance._target.parent.localToGlobal(_instance._point));
			_instance.transfromIng(__v);
			__p = _instance._target.parent.globalToLocal(_instance._target.localToGlobal(_instance._local));
			_instance._target.x += _instance._point.x - __p.x;
			_instance._target.y += _instance._point.y - __p.y;
		}
		
		/**
		 * 显示对象以中心点进行改变
		 * @param	__target	显示对象;
		 * @param	__v			显示对象需要改变的参数 不需要 point(注册点) 如:{x:100,y:100,scale:1};
		 */
		public static function  transfromByCenter(__target:Object,__v:*):void 
		{
			init();
			var __t:DisplayObject = __target as DisplayObject;
			if (__t.parent==null) 
			{
				var 	__s:Sprite = new Sprite();
						__s.addChild(__t);
			}
			var __r:Rectangle = __t.getBounds(__t.parent);
			 __v.point = new Point(__r.x + (__r.width * 0.5), __r.y + (__r.height * 0.5));
			 transfromByPoint(__target, __v);
			 if (__t.scaleX == 0 || __t.scaleY == 0) {
				__r = __t.getBounds(__t);
				_instance._local = new Point(__r.x + (__r.width * 0.5), __r.y + (__r.height * 0.5))
			}
		}
		
		/**
		 * 进行转换中
		 * @param	__value	显示对象需要改变的参数 
		 */
		private function transfromIng(__value:*):void 
		{
			for (var __n:String in __value ) 
			{
				if (__n=="point") 
				{
				}
				else if (__n=="scale")
				{
					_target.scaleX = _target.scaleY =__value[__n];
				}
				else if(__n=="x"||__n=="y")
				{
					_point[__n] = __value[__n];
				}
				else 
				{
					_target[__n] = __value[__n];
				}
			}
		}





	//============================================
	//===== Class[transfrom] Has Finish ======
	//============================================
	}

}