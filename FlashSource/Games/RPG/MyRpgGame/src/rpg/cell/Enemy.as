/*
 * author: 白连忱
 * email: blianchen@163.com
 * vision: v0.1
 */

package rpg.cell
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import mx.flash.UIMovieClip;
	
	import rpg.map.Maps;
	import rpg.util.Util;

	public class Enemy extends Sprite// implements ICell
	{
		
		private var speed:Number = 5;
		private var turnRate:Number = .3;
		private var agroRange:Number = 300;
		
		private var moveX:Number = 0;
		private var moveY:Number = 0;
		
		
		
		private var map:Maps; 
		private var timer:Timer;
		private var target:Hero;
		
		public function Enemy(map:Maps, xtile:int, ytile:int)
		{
			this.map = map;
			
			var enemy:UIMovieClip = new Enemy1();
			
			var currentTilePoint:Point = new Point(xtile, ytile);
			var currentPixelPoint:Point = Util.getPixelPoint(map, currentTilePoint);

//			var loader:Loader = new Loader();
//			loader.load(new URLRequest("res/tile/001.gif"));
			this.x = currentPixelPoint.x;
			this.y = currentPixelPoint.y;
			this.addChild(enemy);
			
			timer = new Timer(40);
			timer.addEventListener(TimerEvent.TIMER, onTime);
			timer.start();
			
			//this.addEventListener(SceneEvent.START_FOLLOW, doFollow);
		}
		
		private function onTime(e:TimerEvent):void
		{
			var p:Sprite = Sprite(this.parent);
			var i:int = p.getChildIndex(this);
			while (i<p.numChildren-1)
			{
				i++;
				if (p.getChildAt(i) is Hero)
				{
					target = Hero(p.getChildAt(i));
					//calculate distance between follower and target
				    var distanceX:Number = target.x - this.x;
				    var distanceY:Number = target.y - this.y;
				    
				    //get total distance as one number
				    var distanceTotal:Number = Math.sqrt(distanceX*distanceX+distanceY*distanceY);

					if (distanceTotal <= this.agroRange)
					{
						timer.stop();
						this.startFollow();
						return;
					}
				}
			}
			while (i>0)
			{
				i--;
				if (p.getChildAt(i) is Hero)
				{
					target = Hero(p.getChildAt(i));
					//calculate distance between follower and target
				    distanceX = target.x - this.x;
				    distanceY = target.y - this.y;
				    
				    //get total distance as one number
				    distanceTotal = Math.sqrt(distanceX*distanceX+distanceY*distanceY);

					if (distanceTotal <= this.agroRange)
					{
						timer.stop();
						this.startFollow();
						return;
					}
				}
			}
		}
		
		private function startFollow():void
		{
			timer.removeEventListener(TimerEvent.TIMER, onTime);
			timer.addEventListener(TimerEvent.TIMER, doFollow);
			timer.start();
		}
		
		//
		// doFollow(follower, target)
		// use ex: doFollow(myEnemyMovieClip, playerMovieClip)
		//
		public function doFollow(e:TimerEvent):void {
		    
		    //calculate distance between follower and target
		    var distanceX:Number = target.x - this.x;
		    var distanceY:Number = target.y - this.y;
		    
		    //get total distance as one number
		    var distanceTotal:Number = Math.sqrt(distanceX*distanceX+distanceY*distanceY);
		    
		    if (distanceTotal > agroRange)
		    {
			    timer.stop();
			    timer.removeEventListener(TimerEvent.TIMER, doFollow);
				timer.addEventListener(TimerEvent.TIMER, onTime);
				timer.start();
		    } else {
			    //check if target is within agro range
			    if(distanceTotal > 20){
			        //calculate how much to move
			        var moveDistanceX:Number = turnRate*distanceX/distanceTotal;
			        var moveDistanceY:Number = turnRate*distanceY/distanceTotal;
			        
			        //increase current speed
			        moveX += moveDistanceX;
			        moveY += moveDistanceY;
			        
			        //get total move distance
			        var totalmove:Number = Math.sqrt(moveX*moveX+moveY*moveY);
			        
			        //apply easing
			        moveX = speed*moveX/totalmove;
			        moveY = speed*moveY/totalmove;
			        
			        //move follower
			        this.x += moveX;
			        this.y += moveY;
			        
			        //rotate follower toward target
			        this.rotation = 180*Math.atan2(moveY, moveX)/Math.PI;
			        
			    }
		    }	
		}

		public function getCurrentWalkPath():Array
		{
			return null;
		}
		
		public function getCurrentTilePoint():Point
		{
			return null;
		}
		
	}
}