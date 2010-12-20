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
		 * @param	_TextField 被设置的文本
		 * @param	_object      设置文本的样式属性 使用 textFormat的所有属性 align,bold,color...
		 */
		public static function  setTextFormat(_TextField:TextField,_object:Object,_beginIndex:int = -1, _endIndex:int = -1):void 
		{
			if (_TextField == null) return;
			var _textFormat:TextFormat = new TextFormat();
				  try 
				  {
					  for  (var _Obj:String in _object) 
					  {
						  _textFormat[_Obj] = _object[_Obj];
					  }
				  }
				  catch (err:Error)
				  {
					  trace(DinText,"文本样式属性有误!");
				  }
				   _TextField.setTextFormat(_textFormat, _beginIndex, _endIndex);
				   _textFormat = null;
		}
		
		/**
		 *	设置文本默认样式
		 * @param	_textField			文本框
		 * @param	_object				文本样式
		 */
		public static function setDefaultTextFormat(_textField:TextField,_object:Object):void 
		{
			if (_textField == null) return;
			var _textFormat:TextFormat = new TextFormat();
				  try 
				  {
					  for  (var _Obj:String in _object) 
					  {
						  _textFormat[_Obj] = _object[_Obj];
					  }
				  }
				  catch (err:Error)
				  {
					  trace(DinText,"文本样式属性有误!");
				  }
				  _textField.defaultTextFormat = _textFormat;
				  _textFormat = null;
		}
		
		
		/******** Class The End **********/
		
	}

}