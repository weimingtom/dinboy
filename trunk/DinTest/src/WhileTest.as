package  
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Dinboy 钉崽
	 */
	public class WhileTest extends Sprite 
	{
		private var _list:Array;
		private var _xml:XML =<data>
												<list>
													<material url="http://appimg3.qq.com/restaurant/Main_v_163.swf" statusText="主程序" size="0" />
													<material url="http://appimg3.qq.com/restaurant/Main_v_163.swf" statusText="主程序" size="0" />
													<material url="http://appimg3.qq.com/restaurant/Main_v_163.swf" statusText="主程序" size="0" />
													<material url="http://appimg3.qq.com/restaurant/Main_v_163.swf" statusText="主程序" size="0" />
												</list>
											</data>;
		public function WhileTest() 
		{
			_list = ["a", "b", "c", "d"];
			
			var _material:XMLList = _xml.list.material;
			
			var i:int = 0;
			while ( _material in i ) 
			{
				trace(i);
				trace(_material[i]);
			}
			trace(i);
			
		}
		
	}

}