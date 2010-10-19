package com.dinboy.util 
{
	/**
	 * ...
	 * @copy Dinboy.com © 2010
	 * @author 钉崽
	 */
	public class ArrayUtil
	{
		
		public function ArrayUtil() 
		{
			
		}
		
		/**
		 * 删除数组中重复的项,并返回新数组
		 * @param	$array	需要删除的数组
		 * @return	返回新数组
		 */
		public static function DelDuplicate($array:Array):Array 
		{
			var $z:Array = $array.filter( function ($a:*, $b:int, $c:Array):Boolean { return (($z ? $z : $z = new Array()).indexOf($a) >= 0 ? false : ($z.push($a) >= 0)); }, $array);
			return $z;
		}
		
		
		
		
		/********** [DINBOY] Say: Class The End  ************/	
	}

}