package com.dinboy.net.resource 
{
	/**
	 * ...
	 * @author 钉崽 [dinboy]
	 */
	public class ResourceType extends Object
    {
		/**
		 * 图片类型文件
		 */
        public static const TYPE_BITMAP:String = "type_bitmap";
		
		/**
		 * XML类型文件
		 */
        public static const TYPE_XML:String = "type_xml";
		
		/**
		 * CSS样式类型文件
		 */
        public static const TYPE_CSS:String = "type_css";
		
		/**
		 * 文本类型文件
		 */
        public static const TYPE_TEXT:String = "type_text";
		
		/**
		 * SWF类型文件
		 */
        public static const TYPE_SWF:String = "typr_swf";
		
		/**
		 * MP3类型文件
		 */
        public static const TYPE_MP3:String = "type_mp3";
		
		/**
		 * 未知类型文件
		 */
        public static const TYPE_UNKNOWN:String = "type_unknown";
		
		/**
		 * 二进制类型文件
		 */
        public static const TYPE_BINARY:String = "type_binary";
		
		/**
		 * 图片正则判断
		 */
		private static var bitmapRegExp:RegExp = /(.*?).(jpg|jpeg|png|gif)/i;
		
		/**
		 * XML正则判断
		 */
        private static var xmlRegExp:RegExp = /(.*?).(xml)/i;
		
		/**
		 * CSS正则判断
		 */
        private static var cssRegExp:RegExp = /(.*?).(css)/i;
		
		/**
		 * 文本正则判断
		 */
        private static var textRegExp:RegExp = /(.*?).(txt|rtf)/i;
		
		/**
		 * SWF正则判断
		 */
        private static var swfRegExp:RegExp = /(.*?).(swf)/i;
		
		/**
		 * MP3正则判断
		 */
        private static var mp3RegExp:RegExp = /(.*?).(mp3)/i;

		
		
		/**
		 * 资源的属性
		 */
        public function ResourceType()
        {
           throw new Error("You Can't Instance Me");
        }

		/**
		 * 根据地址获取文件文件的类型
		 * @param	url	文件的地址
		 * @return 文件的类型
		 */
        public static function getType(url:String) : String
        {

            if (bitmapRegExp.test(url))
            {
                return ResourceType.TYPE_BITMAP;
            }
            if (xmlRegExp.test(url))
            {
                return ResourceType.TYPE_XML;
            }
            if (cssRegExp.test(url))
            {
                return ResourceType.TYPE_CSS;
            }
            if (textRegExp.test(url))
            {
                return ResourceType.TYPE_TEXT;
            }
            if (swfRegExp.test(url))
            {
                return ResourceType.TYPE_SWF;
            }
            if (mp3RegExp.test(url))
            {
                return ResourceType.TYPE_MP3;
            }
            return ResourceType.TYPE_UNKNOWN;
        }

    }

}