package com.dinboy.text 
{
	import com.adobe.images.BitString;
	/**
	 * ...
	 * @author 钉崽 [DinBoy]
	 */
	public class DinString
	{
		
		public function DinString() 
		{
			trace("本帅不需要实例化~");
		}
				
		
		/**
		 * 把字母转换成对应的数字. A,B,C=1,2,3
		 * @param	$value
		 */
		public static function Letter2Num($value:String):int 
		{
			var $LetterArray:Array=["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];
			var $string:String = $value.charAt(0);
			var $result:int=0;
				 var i:int;
				  for (i = 0; i <$LetterArray.length ; i++) 
				  {
					  if ($LetterArray[i] == $string) {
						  $result = i+1 ;
					  }
				}
				return $result;
		}
		
		/**
		 * 输出重复的文本
		 * @param	$count 重复次数
		 * @param	$value 需要重复的内容
		 */
		public static function RepeatChr($count:int,$value:String):String 
		{
			var $RepeatString:String="";
					for (var i:int = 0; i < $count; i++) 
					{
						$RepeatString += $value;
					}
			return $RepeatString;
		}
		
		
		/**
		 * 反转字符串 (逐 [字] 反转)
		 * @return 反转后的字符串
		 */
		public static function ReverseStrByChar($value:String):String 
		{
			var $revaerArray:Array;
			var $reverseString:String;
			$revaerArray = $value.split("");
			$revaerArray.reverse();
			$reverseString = $revaerArray.join("");
			return $reverseString;
		}
		
		/**
		 * 反转字符串 (逐 [词] 反转)
		 * @return 反转后的字符串
		 */
		public static function ReverseStrByWord($value:String):String 
		{
			var $revaerArray:Array;
			var $reverseString:String;
			$revaerArray = $value.split(" ");
			$revaerArray.reverse();
			$reverseString = $revaerArray.join(" ");
			return $reverseString;
		}
		
		/**
		 * 给字符串换行 (逐 [词] 换行)
		 * @param	$value 需要换行的字符串
		 * @return 换行好了的字符串
		 */
		public static function  WrapStringByWord($value:String):String
		{
			var $wrapArray:Array;
			var $wrapString:String;
			$wrapArray = $value.split(" ");
			$wrapString = $wrapArray.join("\n");
			return $wrapString;
		}
		
		/**
		 * 给字符串换行 (逐 [字] 换行)
		 * @param	$value 需要换行的字符串
		 * @return 换行好了的字符串
		 */
		public static function  WrapStringByChar($value:String):String
		{
			var $wrapArray:Array;
			var $wrapString:String;
			$wrapArray = $value.split("");
			$wrapString = $wrapArray.join("\n");
			return $wrapString;
		}
		
		/**
		 * 裁剪字符串并返回新字符串
		 * @param	$value			需要裁剪的字符串
		 * @param	$ifsuffix		是否包含后缀 默认:false
		 * @param	$suffix			后缀 默认: "..."
		 * @return   返回裁剪后的字符串
		 */
		public static function CutString($value:String,$len:int,$ifsuffix:Boolean=false,$suffix:String="..."):String 
		{
			var $returnChr:String;
			if ($value.length>$len) 
				$returnChr = $ifsuffix == true? $value.substring(0, $len).concat($suffix):$value.substring(0, $len);
			else 
				$returnChr=$value.substring(0, $len)
				  
			return $returnChr;
		}
		
		/******** Class The End **********/
		
	}

}