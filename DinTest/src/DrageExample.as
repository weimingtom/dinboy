package  
{
	import com.dinboy.ui.dinBall;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	

	/**
	 * @author		钉崽[dinboy]
	 * @copy		dinboy © 2010
	 * @version		v1.0 [2010-12-1 15:00]
	 */
	public class DrageExample extends Sprite
	{
		private var _ball_1:dinBall;
		private var _ball_2:dinBall;
		public function DrageExample() 
		{
			_ball_1 = new dinBall({ color:0xFF0000, alpha:1, x:10, y:10, radius:10 });
			_ball_2 = new dinBall( { color:0xFF0000, alpha:1, x:10, y:10, radius:10 } );
							//var $ball:dinBall = new dinBall({ color:0xFF0000, alpha:1, x:10, y:10, radius:10 });
				//this.addChild($ball);
			_ball_1.x = _ball_1.y = 200;
			
			addChild(_ball_2);
			addChild(_ball_1);
			
			_ball_1.addEventListener(MouseEvent.MOUSE_DOWN, downMouseHandler, false, 0, true);
			_ball_1.addEventListener(MouseEvent.MOUSE_UP, upMouseHandler, false, 0, true);
			
		}
		
		private function upMouseHandler(e:MouseEvent):void 
		{
			_ball_1.startDrag();
			//trace(_ball_1.dropTarget);
		}
		
		private function downMouseHandler(e:MouseEvent):void 
		{
			_ball_1.stopDrag()
			trace(_ball_1.dropTarget);
		}






	//============================================
	//===== Class[DrageExample] Has Finish ======
	//============================================
	}

}