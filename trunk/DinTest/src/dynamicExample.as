package  
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @data $_DATA
	 * @author Dinboy.com
	 */
	public class dynamicExample extends Sprite
	{
		private var $DY:dynamicBase;
		public function dynamicExample() 
		{
			this.$DY = new dynamicBase();
			this.$DY.id = "4564646";
			trace(this.$DY.id);
			this.$DY.shit = "\"shit\" Translate to Chinese is \"狗屎\" ";
			trace(this.$DY.shit);
		}
		
		
		
		/********** [DINBOY] Say: Class The End  ************/	
	}

}