package  
{
	import com.dinboy.display.AlertTip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Dinboy.com
	 * @copy CopyRight © 2010 DinBoy
	 */
	public class AlertTipExample extends Sprite
	{
		
		public function AlertTipExample() 
		{
			AlertTip.init(this);
			AlertTip.autoShow = true;
			AlertTip.autoClose = false;
			
	//		stage.align = StageAlign.TOP_LEFT;
	//		stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(MouseEvent.CLICK, this.onClick, false, 0, true);
		}
		
		/**
		 * 当点击是 弹出对话框
		 * @param	evt
		 */
		private function  onClick(evt:MouseEvent):void 
		{
			AlertTip.text = "package \n {	\nimport com.dinboy.display.AlertTip;\n	import flash.display.Sprite;	\nimport flash.display.StageAlign;\n	import flash.display.StageScaleMode;	\nimport flash.events.MouseEvent;\n/** \n* ...	 \n* @author Dinboy.com	 \n* @copy CopyRight © 2010 DinBoy	 \n*/	\npublic class AlertTipExample extends Sprite	\n{		\npublic function AlertTipExample() 		\n{			\nAlertTip.init(this);			\nAlertTip.autoShow = true;			\nAlertTip.autoClose = false;\n	//		stage.align = StageAlign.TOP_LEFT;	\n//		stage.scaleMode = StageScaleMode.NO_SCALE;			\nstage.addEventListener(MouseEvent.CLICK, this.onClick, false, 0, true);		\n}				\n/**		 \n* 当点击是 弹出对话框		 \n* @param	evt		 \n*/		\nprivate function  onClick(evt:MouseEvent):void 		\n{	\n		AlertTip.text = \"CopyRight © 2010 DinBoyCopyRight © 2010 DinBoyCopyRight © 2010 DinBoyCopyRight © 2010 DinBoyCopyRight © 2010 DinBoyCopyRight © 2010 DinBoyCopyRight © 2010 DinBoyCopyRight © 2010 DinBoyCopyRight © 2010 DinBoyCopyRight © 2010 DinBoyCopyRight © 2010 DinBoyCopyRight © 2010 DinBoyCopyRight © 2010 DinBoy\";	\n	}	\n	/********** [DINBOY] Say: Class The End  ************/\n		}\n}";
		}
		
		
		/********** [DINBOY] Say: Class The End  ************/	
	}

}