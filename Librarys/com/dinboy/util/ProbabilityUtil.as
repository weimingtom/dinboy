package com.dinboy.util {
	import adobe.utils.CustomActions;

	/**
	 * ...
	 * @author Dinboy.com
	 * @copy CopyRight © 2010 DinBoy
	 */


	/**
	 * 
	   trace(Random.boolean+"（随机一个布尔值）");
	   trace(Random.color()+"（随机一个RGB颜色值）");
	   trace(Random.color("153-255","0-100","0-100")+"（随机一个偏红的RGB颜色值）");
	   trace(Random.wave+"（随机一个波动值）");
	   trace(Random.string()+"（随机一个字符）");
	   trace(Random.integer(4)+"（随机一个int值）");
	   trace(Random.randNumber(4)+"（随机一个Number值）");
	   trace(Random.string("a-z,A-Z")+"（在一个范围随机字符）");
	   trace(Random.string("我,你,他")+"（在一个范围随机中文字符）");
	   trace(Random.ranges(5,4,3,-1,-10,-14,true)+"（在多个指定范围随机数值）");
	   trace(Random.range(4,9)+"（在一个指定范围随机数值）");
	   trace(Random.bit(8)+"（随机一个八位的字符串）");
	   trace(Random.bit(16,"0-1")+"（随机一个十六位的二进制）");
	   trace("…………")

	   //生成一个偏红的颜色色块
	   var sh:Shape = new Shape();
	   var rgb:uint = Random.color("204-255","0-153","0-153");
	   trace(rgb1.toString(16));
	   sh.graphics.beginFill(rgb);
	   sh.graphics.drawRect(100,100,100,100);
	   addChild(sh);

	   //生成一个颜色偏深或者偏淡的颜色色块
	   var sh1:Shape = new Shape();
	   var rgb1:uint = Random.color("0-20,240-255","0-20,240-255","0-20,240-255");
	   trace(rgb1.toString(16));
	   sh1.graphics.beginFill(rgb1);
	   sh1.graphics.drawRect(200,100,100,100);
	   addChild(sh1);
	 */


	public class ProbabilityUtil {

		public function ProbabilityUtil(){
			trace("本帅不需要实例化~");
		}

		//==============================================
		//==================   静态方法   ====================
		//==============================================


		/**
		 * 获取一个随机的布尔值
		 */
		public static function get boolean():Boolean {
			return Boolean(integer(2));
		}

		/**
		 * 获取一个正负波动值
		 */
		public static function get wave():int {
			return integer(2) * 2 - 1;
		}

		/**
		 * 获取一个随机的范围整数值
		 * @param	$num 需要转换成整数的随机数
		 * @return	返回该随机数的整数形式
		 */
		public static function integer($num:Number):int {
			return randNumber($num) >> 0;
		}

		/**
		 * 获取一个随机的范围Number值
		 * @param	$num 需要随机的范围值
		 * @return	返回该范围的一个随机数
		 */
		public static function randNumber($num:Number):Number {
			return Math.random() * $num;
		}

		/**
		 * 在一个范围内获取一个随机值，返回结果范围：$numMax >= $num > $numMin
		 * @param	$numMax					最大值
		 * @param	$numMin					最小值
		 * @param	$isInt					是否以整数形式返回
		 * @return	返回随机数
		 */
		public static function range($numMax:Number, $numMin:Number, $isInt:Boolean = true):Number {
			if ($numMax<=$numMin) throw new Error("参数错误,最大值竟然比最小值小?");
			var $num:Number = randNumber($numMin - $numMax) + $numMax;
			if ($isInt)
				$num = ($num >> 0);
			return $num;
		}

		/**
		 * 在多个范围获取随机值
		 * @param	... args	多个范围 如:0,10,90
		 * @return
		 */
		public static function ranges(... args):Number {
			var $isInt:Boolean = args[args.length - 1] is Boolean ? args.pop() : true;
			var $num:Number = randomRange(args);
			if (!$isInt)
				$num += Math.random();
			return $num;
		}
		
		/**
		 * 获取范围之内的不相等的 $count个数.	$numMax >= $num > $numMin
		 * @param	$count				需要获取的个数
		 * @param	$numMax				最大值
		 * @param	$numMin				最小值
		 * @param	$isInt				是否转换成整形
		 * @param	$sort				排序方式 0:无排序;-1:降序;1:升序.
		 * @return 	返回一个存放多个随机数的数组
		 */
		public static function rangeNoEqual($count:int=1,$numMax:Number=1,$numMin:Number=0,$isInt:Boolean=true,$sort:int=0):Array 
		{
			if ($numMax<=$numMin) throw new Error("参数错误,最大值竟然比最小值小?");
			if ($isInt)
			{
				var $allCount:int =$numMax-$numMin>>0;
				if ($count>=$allCount) throw new Error("超过了索引界限,随机个数比总数多."); 
			}
			var $randArray:Array = [];
			var $i:int=0;
				while ($i<$count)
				{
					$randArray[$i] = range($numMax, $numMin, $isInt);
					var $j:int;
					var $equal:Boolean = false;
					for ($j = 0; $j <$i ; $j++) 
					{
						if ($randArray[$i] == $randArray[$j]) {
							$equal = true;
							break;
						}
					}
					if (!$equal) $i++;
				}
			return $randArray.sort($sort);
		}
		
		/**
		 * 获取一个随机字符，默认随机范围为数字+大小写字母，也可以指定范围，格式：a-z,A-H,5-9
		 * @param	$str				需要随机的字符串.需使用逗号","隔开.
		 * @return	返回一个当中的字符串.
		 */
		public static function string($str:String = "0-9,A-Z,a-z"):String {
			return String.fromCharCode(randomRange(explain($str)));
		}

		/**
		 * 生成指定位数的随机字符串
		 * @param	$num	需要抽取的字符串长度
		 * @param	$str		字符串.需使用逗号","隔开.
		 * @return	返回$num个长度的字符串
		 */
		public static function bit($num:int, $str:String = "0-9,A-Z,a-z"):String {
			var $reStr:String = "";
			var $i:int;
			for ($i=0; $i < $num; $i++)
				$reStr += string($str);
			return $reStr;
		}
		
		/**
		 * 获取一个随机的颜色值
		 * @param	$red						红色范围  0x00~0xFF
		 * @param	$green					绿色范围  0x00~0xFF
		 * @param	$blue						蓝色范围  0x00~0xFF
		 * @return 	随机颜色值
		 */
		public static function color($red:String = "0-255", $green:String = "0-255", $blue:String = "0-255"):uint {
			return Number("0x" + transform(randomRange(explain($red, false))) + transform(randomRange(explain($green, false))) + transform(randomRange(explain($blue, false))));
		}
		
		/**
		 * 将10进制的RGB色转换为2位的16进制
		 * @param	$num	十进制的RGB颜色值
		 * @return	2位的16进制
		 */
		private static function transform($num:uint):String {
			var $reStr:String = $num.toString(16);
			if ($reStr.length != 2)
				$reStr = "0" + $reStr;
			return $reStr;
		}
		
		
		/**
		 * 字符串解析
		 * @param	$str						需要解析的字符串
		 * @param	$isCodeAt			是否以16 位整数字符代码来解析
		 * @return	返回解析好的数数值范围的数组.
		 */
		private static function explain($str:String, $isCodeAt:Boolean = true):Array {
			var $argAr:Array = new Array;
			var $tmpAr:Array = $str.split(",");
			var $i:int ;
			for ($i = 0; $i < $tmpAr.length; $i++) {
				var $ar:Array = $tmpAr[$i].split("-");
				if ($ar.length == 2){
					var $arPush0:String = $ar[0];
					var $arPush1:String = $ar[1];
					if ($isCodeAt){
						$arPush0 = $arPush0.charCodeAt().toString();
						$arPush1 = $arPush1.charCodeAt().toString();
					}
					//此处如果不加1，将不会随机ar[1]所表示字符，因此需要加上1，随机范围才是对的
					$argAr.push(Number($arPush0), Number($arPush1) + 1);
				} else if ($ar.length == 1){
					var $arPush:String = $ar[0];
					if ($isCodeAt)
						$arPush = $arPush.charCodeAt().toString();
					//如果范围是1-2，那么整型随机必定是1，因此拿出第一个参数后，把范围定在参数+1，则就是让该参数参加随机
					$argAr.push(Number($arPush), Number($arPush) + 1);
				}
				else trace("参数不对哦~~~");
				$ar = null;
			}
			$tmpAr = null;
			return $argAr;
		}
		
		
		/**
		 * 获取随机范围
		 * @param	$ar			范围之间的数组
		 * @return
		 */
		private static function randomRange($ar:Array):Number {
			var $tmpAr:Array = new Array;
			var $length:int = $ar.length;
			var $i:int;
			if ($length & 1 != 0 || $length == 0)
				throw new Error("参数错误！无法获取指定范围！");
			//将所有可能出现的随机数存入数组，然后进行随机
			
			for ($i = 0; $i < ($length >>1); $i++){
				var $i1:int = $ar[$i <<1];
				var $i2:int = $ar[($i <<1) + 1];
				if ($i1 > $i2){
					var $tmp:Number = $i1;
					$i1 = $i2;
					$i2 = $tmp;
				}
				for ($i1; $i1 < $i2; $i1++)
					$tmpAr.push($i1);
			}
			var $num:Number = $tmpAr[integer($tmpAr.length)];
			$tmpAr = null;
			$ar = null;
			return $num;
		}
		
		//==============================================
		//==================Getter/Setter====================
		//==============================================
		
		/**
		 * 获取随机值
		 */
		public static function get random():Number {
			return Math.random();
		}

	/********** [DINBOY] Say: Class The End  ************/
	}

}