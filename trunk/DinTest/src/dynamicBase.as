package  
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @data $_DATA
	 * @author Dinboy.com
	 */
	public dynamic class dynamicBase extends Sprite
	{
		/**
		 * ID
		 */
		private var $id:String;
		public function dynamicBase() 
		{
			
		}
		
		public function  get id():String 
		{
			return this.$id;
		}
		public function  set id($value:String):void 
		{
			this.$id = $value;
		}
		
		
		/********** [DINBOY] Say: Class The End  ************/	
	}

}