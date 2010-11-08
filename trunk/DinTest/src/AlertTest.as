package  
{
	import com.dinboy.controls.Alert;
	import com.dinboy.controls.PromptButton;
	import flash.display.Sprite;
	

	/**
	 * @author		钉崽[dinboy]
	 * @copy		dinboy © 2010
	 * @version		v1.0 [2010-11-8 16:22]
	 */
	public class AlertTest extends Sprite
	{
		
		public function AlertTest() 
		{
			Alert.init(this);
			Alert.message("我是神,不是人,更不是东西!真的.我是神,不是人,更不是东西!真的.我是神,不是人,更不是东西!真的.我是神,不是人,更不是东西!真的.我是神,不是人,更不是东西!真的.我是神,不是人,更不是东西!真的.我是神,不是人,更不是东西!真的.我是神,不是人,更不是东西!真的.我是神,不是人,更不是东西!真的.我是神,不是人,更不是东西!真的.");
			var bb:PromptButton = new PromptButton();
			addChild(bb);
			bb.label = "a";
		}






	//============================================
	//===== Class[AlertTest] Has Finish ======
	//============================================
	}

}