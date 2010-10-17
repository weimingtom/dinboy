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
		private  var _point:Point;
		
		private var _target:DisplayObject;
		
		private var _local:Point;
		
		private static var _instance:dinTransfrom=null;
		
		public function dinTransfrom() 
		{
			
		}

		public static function init():void 
		{
			if (_instance == null)  _instance = new dinTransfrom();
		}
		
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