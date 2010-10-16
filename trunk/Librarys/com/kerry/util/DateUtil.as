package com.kerry.util {
	/**
	 * DateUtil 用于处理日期和时间的工具类
	 * @author PhoenixKerry（http://blog.sina.com.cn/yyy98）
	 * @version 0.1
	 */
	public class DateUtil {
		/**
		 * 该方法将数值时间（以秒或毫秒为单位）转换为时间戳，不足两位数的自动补零，并进行格式化
		 * @param	time 数值时间，以秒或毫秒为单位均可
		 * @param	formatExp 格式化表达式，默认：XXXX年XX月XX日 XX时XX分XX秒
		 * @return     格式化后的时间戳
		 * @example 以下是该类使用范例
			<listing version="3.0">
			var phpTimeResult:String = DateUtil.convertToTimeStamp(1251443675);
			trace("已秒为单位的数值时间：" + phpTimeResult); //已秒为单位的数值时间：2009年08月28日 15时14分35秒

			var asTimeResult:String = DateUtil.convertToTimeStamp(1251443585703);
			trace("已秒为单位的数值时间：" + asTimeResult); //已秒为单位的数值时间：2009年08月28日 15时13分05秒
			
			var asTimeResultFormatted:String = DateUtil.convertToTimeStamp(1251443585703, "%M-%D %h:%m");
			trace("格式化后的时间戳：" + asTimeResultFormatted); //格式化后的时间戳：08-28 15:13 </listing>
		 */
		public static function convertToTimeStamp(time:Number, formatExp:String = "%Y年%M月%D日 %h时%m分%s秒"):String {
			if (time.toString().length == 10) time *= 1000;
			var date:Date = new Date(time);
			formatExp = formatExp.replace("%Y", date.fullYear);
			formatExp = formatExp.replace("%M", formatter(date.month + 1));
			formatExp = formatExp.replace("%D", formatter(date.date));
			formatExp = formatExp.replace("%h", formatter(date.hours));
			formatExp = formatExp.replace("%m", formatter(date.minutes));
			formatExp = formatExp.replace("%s", formatter(date.seconds));
			return formatExp;
		}
		
		/**
		 * @private
		 */
		private static function formatter(time:uint):String {
			if (time < 10) {
				return String("0" + time);
			}
			return time.toString();
		}
	}
}