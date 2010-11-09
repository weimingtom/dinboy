package  
{
	import com.dinboy.controls.Alert;
	import com.dinboy.controls.PromptButton;
	import com.dinboy.events.PromptEvent;
	import flash.display.Sprite;
	

	/**
	 * @author		钉崽[dinboy]
	 * @copy		dinboy © 2010
	 * @version		v1.0 [2010-11-8 16:22]
	 */
	public class AlertTest extends Sprite
	{
		private var _alert:Alert;
		
		private var _alert2:Alert;
		public function AlertTest() 
		{
			Alert.init(this);
			_alert = Alert.message("钉崽钉崽钉崽钉崽钉崽钉崽钉崽钉崽钉崽钉崽钉崽钉崽钉崽");
			_alert.addEventListener(PromptEvent.PROMPT_ClOSE, promptCloseHandler, false, 0, true);
			_alert.dragEnabled = false;
			
			//var bb:PromptButton = new PromptButton();
		//	addChild(bb);
		//	bb.label = "a";
		}
		
		private function promptCloseHandler(e:PromptEvent):void 
		{
			
			_alert.removeEventListener(PromptEvent.PROMPT_ClOSE, promptCloseHandler);
			_alert2 = Alert.message("钉崽钉崽钉崽钉崽钉崽钉崽钉崽钉崽钉崽钉崽钉崽钉崽钉崽");
			_alert2.addEventListener(PromptEvent.PROMPT_ClOSE, promptCloseHandler2, false, 0, true);
			_alert2.dragEnabled = false;
		}
		
		private function promptCloseHandler2(e:PromptEvent):void 
		{
			_alert2.removeEventListener(PromptEvent.PROMPT_ClOSE, promptCloseHandler2);
			_alert = Alert.message("钉崽钉崽钉崽钉崽钉崽钉崽钉崽钉崽钉崽钉崽钉崽钉崽钉崽","钉崽钉崽钉崽钉崽钉崽钉崽钉崽钉崽钉崽钉崽钉崽钉崽钉崽钉崽钉崽钉崽钉崽钉崽钉崽钉崽钉崽钉崽钉崽钉崽钉崽钉崽");
			_alert.addEventListener(PromptEvent.PROMPT_ClOSE, promptCloseHandler, false, 0, true);
			_alert.dragEnabled = false;
		}






	//============================================
	//===== Class[AlertTest] Has Finish ======
	//============================================
	}

}