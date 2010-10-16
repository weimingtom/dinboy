package 
{
	import com.dinboy.ui.dinBall;
	import com.dinboy.util.DinDisplayUtil;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author 钉崽 - [DinBoy.Com]
	 * @copy    CopyRight © 2010 DinBoy
	 */
	public class Main extends Sprite 
	{
		/**
		 * 最大数量
		 */
		private var $maxNum:int =100;
		
		/**
		 * 最大半周期
		 */
		private var $maxLen:int = 10;
		
		/**
		 * 间隔
		 */
		private var $space:int = 10;
		
		/**
		 * 鼠标点击次数
		 */
		private var $clickNum:int
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.align = StageAlign.TOP; 
			stage.scaleMode = StageScaleMode.NO_SCALE;
			this.graphics.lineStyle(1);
			this.graphics.moveTo(stage.stageWidth >>1 , 0);
			this.graphics.lineTo(stage.stageWidth >> 1, stage.stageHeight);
			
			stage.addEventListener(MouseEvent.CLICK, this.onClick,false,0,true);
			//var i:int;
			//for (i = 0; i < $maxNum ; i++) 
			//{
				//var $ball:dinBall = new dinBall({ color:0xFF0000, alpha:1, x:10, y:10, radius:10 });
				//this.addChild($ball);
				//DinDisplayUtil.SymmetryByCount($ball, i, new Point(stage.stageWidth >> 1, i * 10+10), 5, 10, 5);
				//$ball.text = i.toString();
			//}
			
			//var i:int;
			//for (i = 1; i < this.$maxNum ; i++) 
			//{
				//var $ball:dinBall = new dinBall({ color:0xFF0000, alpha:1, x:10, y:10, radius:10 });
				//this.addChild($ball);
				//if (i/$maxLen>>0 &1)
				//{
					//trace(i,i/$maxLen>>0 &1)
					//$ball.x =	($maxLen - (i % $maxLen)) * ($ball.width + $space);
				//}else 
				//{
					//$ball.x = (i - (i / $maxLen >> 0) * $maxLen) * ($ball.width + $space);
					//trace(i,i/$maxLen>>0 &1,"0")
				//}
				//$ball.y += i * 10;
				//$ball.text = i.toString();
			//}
		}
		
		/**
		 * 鼠标点击次数
		 * @param	evt
		 */
		private function  onClick(evt:MouseEvent):void 
		{
				var $ball:dinBall = new dinBall({ color:0xFF0000, alpha:1, x:10, y:10, radius:10 });
				this.addChild($ball);
				DinDisplayUtil.SymmetryByCount($ball, this.$clickNum, new Point(stage.stageWidth >> 1, this.$clickNum * 10 + 10), 10, -10, 5);
				$ball.text = this.$clickNum.toString();
				this.$clickNum++
		}
		
		/********** [DINBOY] Say: Class The End  ************/	
	}
}