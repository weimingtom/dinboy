package com.kerry.util {
	
	/**
	 * MathUtil 用于处理数学计算的工具类
	 * @author PhoenixKerry（http://blog.sina.com.cn/yyy98）
	 * @version 0.2
	 */
	public class MathUtil	{
		/**
		* 将弧度制转换为角度制
		* @param radian 弧度
		* @return 角度
		*/
		public static function radianToDegree (radian:Number):Number {
			return radian * 180 / Math.PI;
		}
		
		/**
		* 将角度制转换为弧度制
		* @param degree 角度
		* @return 弧度
		*/
		public static function degreeToRadian(degree:Number):Number {
			return degree / 180 * Math.PI;
		}
		
		/**
		 * 勾股定理计算三角型
		 * @param s1 第一条边的长度
		 * @param s2 第二条边的长度
		 * @param searchHypotenuse 一个 Boolean 对象指定是否要计算出斜边长度
		 * @return 第三边的长度
		 */
		public static function pythagoras(s1:Number , s2:Number, searchHypotenuse:Boolean = false):Number {
			if (searchHypotenuse) return Math.sqrt( s1 * s1 + s2 * s2 );
			var hypo:Number = Math.max( s1 , s2 );
			var side:Number = Math.min( s1 , s2 );
			return Math.sqrt(hypo * hypo - side * side);
		}
		
		/**
		 * 计算两点间的距离
		 * @param	p1X 第一点的X
		 * @param	p1Y 第一点的Y
		 * @param	p2X 第二点的X
		 * @param	p2Y 第二点的Y
		 * @return 两点的间的距离
		 */
		public static function distance(p1X:Number, p1Y:Number, p2X:Number, p2Y:Number):Number {
			var dx:Number = p1X - p2X;
			var dy:Number = p1Y - p2Y;
			return Math.sqrt(dx * dx + dy * dy);
		}
		
	}
}