package com.dinboy.text 
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author 钉崽 [DinBoy]
	 */
	public class DinText
	{
		
		public function DinText() 
		{
			trace("本帅不需要实例化~");
		}
				
		/**
		 * 设置文本样式
		 * @param	$TextField 被设置的文本
		 * @param	$object      设置文本的样式属性 使用 textFormat的所有属性 align,bold,color...
		 */
		public static function  setTextFormat($TextField:TextField,$object:Object,$beginIndex:int = -1, $endIndex:int = -1):void 
		{
			var $textFormat:TextFormat = new TextFormat();

				  try 
				  {
					  for  (var $Obj:String in $object) 
					  {
						  $textFormat[$Obj] = $object[$Obj];
					  }
					  $TextField.setTextFormat($textFormat);
				  }
				  catch (err:Error)
				  {
					  trace("文本样式属性有误!");
				  }
		}
		
		
		/******** Class The End **********/
		
	}

}