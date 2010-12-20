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
		 * @param	_value
		 */
		public static function Letter2Num(_value:String):int 
		{
			var _LetterArray:Array=["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];
			var _string:String = _value.charAt(0);
			var _result:int=0;
				 var i:int;
				  for (i = 0; i <_LetterArray.length ; i++) 
				  {
					  if (_LetterArray[i] == _string) {
						  _result = i+1 ;
					  }
				}
				return _result;
		}
		
		/**
		 * 输出重复的文本
		 * @param	_count 重复次数
		 * @param	_value 需要重复的内容
		 */
		public static function RepeatChr(_count:int,_value:String):String 
		{
			var _RepeatString:String="";
					for (var i:int = 0; i < _count; i++) 
					{
						_RepeatString += _value;
					}
			return _RepeatString;
		}
		
		
		/**
		 * 反转字符串 (逐 [字] 反转)
		 * @return 反转后的字符串
		 */
		public static function ReverseStrByChar(_value:String):String 
		{
			var _revaerArray:Array;
			var _reverseString:String;
			_revaerArray = _value.split("");
			_revaerArray.reverse();
			_reverseString = _revaerArray.join("");
			return _reverseString;
		}
		
		/**
		 * 反转字符串 (逐 [词] 反转)
		 * @return 反转后的字符串
		 */
		public static function ReverseStrByWord(_value:String):String 
		{
			var _revaerArray:Array;
			var _reverseString:String;
			_revaerArray = _value.split(" ");
			_revaerArray.reverse();
			_reverseString = _revaerArray.join(" ");
			return _reverseString;
		}
		
		/**
		 * 给字符串换行 (逐 [词] 换行)
		 * @param	_value 需要换行的字符串
		* @param	level 换行的级别 0：普通换行,1：回车换行
		 * @return 换行好了的字符串
		 */
		public static function  WrapStringByWord(_value:String,level:int=0):String
		{
			var _wrapArray:Array;
			var _wrapString:String;
			_wrapArray = _value.split(" ");
			switch (level) 
			{
				case 0:
					_wrapString = _wrapArray.join("\n");
				break;
				case 1:
					_wrapString = _wrapArray.join("\r");
				break;
				default:
					_wrapString = _wrapArray.join("\n");
				break;
			}
			return _wrapString;
		}
		
		/**
		 * 给字符串换行 (逐 [字] 换行)
		 * @param	_value 需要换行的字符串
		 * @param	level 换行的级别 0：普通换行,1：回车换行
		 * @return 换行好了的字符串
		 */
		public static function  WrapStringByChar(_value:String,level:int=0):String
		{
			var _wrapArray:Array;
			var _wrapString:String;
			_wrapArray = _value.split("");
			switch (level) 
			{
				case 0:
					_wrapString = _wrapArray.join("\n");
				break;
				case 1:
					_wrapString = _wrapArray.join("\r");
				break;
				default:
					_wrapString = _wrapArray.join("\n");
				break;
			}
			return _wrapString;
		}
		
		/**
		 * 将字符的调整为不换行
		 * @param	value	需要调整的字符串
		 * @param	level	替换的级别 -1:换行,回车都替换,0:换行替换1:回车替换
		 * @return	调整完成的字符串
		 */
		public static function UnWrapString(value:String,level:int=-1):String
		{
			var _regn:RegExp =/\n/gi;
			var _regr:RegExp =/\r/gi;
			switch (level) 
			{
				case -1:
					value=value.replace(_regn, "");
					value=value.replace(_regr, "");
				break;
				case 0:
					value=value.replace(_regn, "");
				break;
				case 1:
					value=value.replace(_regr, "");
				break;
				default:
					value=value.replace(_regn, "");
					value=value.replace(_regr, "");
				break;
			}
			return value;
		}
		
		/**
		 * 裁剪字符串并返回新字符串
		 * @param	_value			需要裁剪的字符串
		 * @param	_ifsuffix		是否包含后缀 默认:false
		 * @param	_suffix			后缀 默认: "..."
		 * @return   返回裁剪后的字符串
		 */
		public static function CutString(_value:String,_len:int,_ifsuffix:Boolean=false,_suffix:String="..."):String 
		{
			var _returnChr:String;
			if (_value.length>_len) 
				_returnChr = _ifsuffix == true? _value.substring(0, _len).concat(_suffix):_value.substring(0, _len);
			else 
				_returnChr=_value.substring(0, _len)
				  
			return _returnChr;
		}
		
		/******** Class The End **********/
		
	}

}