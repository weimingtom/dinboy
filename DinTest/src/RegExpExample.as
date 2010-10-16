package  
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Dinboy.com
	 * @copy CopyRight © 2010 DinBoy
	 */
	public class RegExpExample extends Sprite
	{
		private var $regexp:RegExp =/^http:\/\/.*localhost.*$/i;
		
		private var $testStr:String = "http://localhost/Temple/localtemple.aspx?id=130";
		public function RegExpExample() 
		{
			
			return;
			trace("dsada");
			trace($regexp.test(this.$testStr));
		}
		
		
		
		/********** [DINBOY] Say: Class The End  ************/	
	}

}