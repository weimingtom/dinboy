package  
{
	import flash.display.Sprite;
	import flash.system.Capabilities;
	import flash.text.Font;
	
	/**
	 * ...
	 * @author Dinboy.com
	 */
	public class OSTest extends Sprite
	{
		/**
		 * 获取客户端系统返回的字符串
		 */
		private var $OS:String = Capabilities.os;
		
		/**
		 * 客户端系统名称前三个字
		 */
		private var $subOS:String;
		
		
		/**
		 * 客户端系统所安装的字体列表
		 */
		private var $FontArray:Array = new Array();
		
		
		/**
		 * 判断是否含有某个字体
		 */
		private var $hasMyFont:Boolean = false;
		
		public function OSTest() 
		{
			
			/**
			 * 以客户端系统来做判断
			 * /
			/*
			this.$subOS = this.$OS.substr(0, 3);
			if (this.$subOS=="Win") 
			{
				switch (this.$OS) 
				{
					case "Window Vista" :
						this.$hasMyFont = true;
						
					break;
					//	... 如下case省略, 如果是Window Vista或者以上 WIN7 系统中默认含有 "微软雅黑" 字体的话就不用加载否则就必须加载
				}
			}
			else if($subOS=="Mac")
			{
				//苹果机
			}
			else 
			{
				//其他系统
			}
			
			this.loadLibrary();
			*/
			
			
			
			/**
			 * 以客户端是否含有某个字体来做判断
			 */
			 this.$FontArray = Font.enumerateFonts(true);
			 var $fontIndex:int;
			for ($fontIndex = 0; $fontIndex < this.$FontArray.length;$fontIndex++ ) 
			{
				trace(this.$FontArray[$fontIndex].fontName);
				if (this.$FontArray[$fontIndex].fontName=="微软雅黑") 
				{
					trace("找到啦~");
					this.$hasMyFont = true;
				}
			}
			this.loadLibrary();
		}
		
		/**
		 * 记载字体
		 */
		private function loadLibrary():void 
		{
				if (this.$hasMyFont) 
			{
				trace("不用再去加载字体库文件了~~~");
				//直接跳过,不用加载字体库的swf
			}else {
				trace("没有字体,看来还是要浪费时间去加载咯~~~");
				//执行加载字体库的swf动作
				}	
		}
		
		/** Class The End **/
	}
}