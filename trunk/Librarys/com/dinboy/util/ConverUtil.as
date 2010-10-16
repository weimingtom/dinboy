package com.dinboy.util
{
	
	/**
	 * ...
	 * @data 2010 © 钉崽
	 * @author Dinboy.com
	 */
	
	/**
	 * 转换类
	 */
	public class ConverUtil 
	{
		
		public function  ConverUtil()
		{
			  throw new Error("TransformUtil class is static container only");  
		}
		
		
		/**
		 * 将对象转换成XML
		 * @param	$obj 被转换的对象
		 * @return  转换完成的XML
		 */
		public static function obj2XML($obj:Object):XML
        {
            var $xml:XML = new XML("<data></data>");
            var $tempXML:XML;
            for (var $key:String in $obj)
            {
                $tempXML = new XML("<" + $key + ">" + $obj[$key] + "</" + $key + ">");
                $xml.appendChild($tempXML);
            }
            return $xml;
        }
		
		
		/**
		 * 将参数转换成 XML
		 * @param	$key      需要转换成XML的子项名
		 * @param	$value   子项的内容
		 * @return	 转换完成的XML
		 */
		public static function toXML($key:String, $value:String):XML
        {
           	var $xml:XML = XML("<data><" + $key + ">" + $value + "</"+ $key + "></data>");
            return $xml;
        }
		
		/********** [DINBOY] Say: Class The End  ************/			
	}
}