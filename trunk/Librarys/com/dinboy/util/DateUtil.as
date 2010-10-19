package com.dinboy.util 
{
	/**
	 * ...
	 * @copy Dinboy.com © 2010
	 * @author 钉崽
	 */
  
		//==============================
		//#### This Is A Interpretation Template ####
		//==============================
	
	public class DateUtil
	{
		
		public function DateUtil() 
		{
			 throw new Error("DateUtil class is static container only");  
		}
		
		/**
		 * 将传进来的秒数进行转换成标准的时间显示(以秒为单位)
		 * @param	$time		传进来的秒数,如果不传,返回的为0秒; 
		 * @param	$object	您可以使用如下参数 
		 * 								ignore:Boolean(true)	忽略第一位没有的,默认为忽略(true)
		 * 								suffix:Boolean(false)	是否使用后最(年.月.日...),默认不显示"true";
		 * 								year:String (年)    			以年为单位的年显示中文的"年",可以自定义替换,默认为"年";
		 * 								day:String (天) 				以天为单位的天显示中文的"天",可以自定义替换,默认为"天";
		 * 								hour:String (时) 			以时为单位的时显示中文的"时",可以自定义替换,默认为"时";
		 * 								minute:String (分) 		以分为单位的分显示中文的"分",可以自定义替换,默认为"分";
		 * 								second:String (秒)		以秒为单位的秒显示中文的"秒",可以自定义替换,默认为"秒";
		 * 								space:String (-)				单位之间的间隔显示文本,可以自定义替换,默认为"";
		 */
		public static function second2date($time:int=0,$object:Object=null):String 
		{
			var $ignore:Boolean	=	($object&&$object["ignore"])?($object["ignore"]):true;
			var $suffix:Boolean	= ($object&&$object["suffix"]!=null)?($object["suffix"]):true;
			var $year:String 		=	$suffix?($object&&$object["year"])?($object["year"]):"年":"";
			var $day:String 			= $suffix?($object&&$object["day"])?($object["day"]):"天":"";
			var $hour:String 		= $suffix?($object&&$object["hour"])?($object["hour"]):"时":"";
			var $minute:String 	= $suffix?($object&&$object["minute"])?($object["minute"]):"分":"";
			var $second:String 	= $suffix?($object && $object["second"])?($object["second"]):"秒":"";
			var $space:String 		= ($object && $object["space"])?($object["space"]):"";
			
			/**
			 * 一年等于365天5小时48分46秒，少于6小时，所以逢百之年必须要是400的倍数才能算是闰年。照这样，每3000年左右才相差1天。 
			 * 一年=((365*24+5)*60+48)*60 +46 (s)
			 * 这样一算,一年有31556926秒;
			 */
			var $timeChar:String 	=	getYear($time) 		+	 $year		+ $space 
													+ getDay($time)		+	 $day		+$space
													+ getHour($time)		+	 $hour	+$space
													+ getMinute($time)	+	 $minute+ $space 
													+ getSecond($time)	+	 $second;
			return $timeChar;
			}
			
			/**
			 * 将秒数转换成年,共有几年
			 * @param	$time 秒数
			 * @return 返回年数
			 */
			public static function getYear($time:int):int 
			{
					return int($time / 31556926);
			}

			/**
			 * 将秒数转换成时间以后所得到剩余的天数
			 * @param	$time 秒数
			 * @return 返回天数
			 */
			public static function getDay($time:int):int 
			{
				return int($time % 31556926  /  60  /  60  /  24);
			}
			
			/**
			 * 将秒数转换成时间以后得到剩余的小时数
			 * @param	$time	秒数
			 * @return	返回小时数
			 */
			public static function getHour($time:int):int
			{
				return int($time % 31556926 % (86400) / 3600);
			}
			
			/**
			 * 将秒数转换成时间以后得到剩余的分钟数
			 * @param	$time	秒数
			 * @return	返回分钟数
			 */
			public static function getMinute($time:int):int
			{
				return int($time % 31556926 % (86400) % 3600 /60) ;
			}
			
			/**
			 * 将秒数转换成时间以后得到剩余的秒数
			 * @param	$time	秒数
			 * @return	返回秒数
			 */
			public static function getSecond($time:int):int
			{
				return int($time % 31556926 % (86400) %3600 %60 );
			}
			
			/**
			 * 将秒数转换成天数
			 * @param	$time
			 */
			public static function  second2day($time:int):int 
			{
				return int($time/24/60/60);
			}
			
			
			
			
			
			
			
			/**
			 * 将秒数转换成小时数
			 * @param	$time
			 */
			public static function  second2hour($time:int):int 
			{
				return int($time/60/60);
			}
			
			/**
			 * 将秒数转换成分钟数
			 * @param	$time
			 */
			public static function  second2minute($time:int):int 
			{
				return int($time/60);
			}
			

		
		
		
		
		//==============================
		//#### DinBoy Say : This Class Is Finish ####
		//==============================
	}

}