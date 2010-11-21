/*
 * author: 白连忱
 * email: blianchen@163.com
 * vision: v0.1
 */

package rpg.tmp
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.flash.UIMovieClip;
	
	import rpg.map.Maps;
	import rpg.util.Util;
	
	public class Hero extends Sprite //implements ICell
	{

//		private var currentWalkPath:Array;		//行走路径
//		public var currentTilePoint:Point;	//当前所在网格点
//		private var toTilePoint:Point;			//当前准备走到的下一个网格点
		
//		private var speed:int = 10;		//速度
		
		private var frameCountInDirection:int = 20;	//角色每个方向的总帧数
		private var frameCountInWalk:int = 4;			//行走动画的总帧数


		/********  以下变量，不需提供get/set接口  *********/
		private var map:Maps;
		private var cell:BuildingLayer;
		private var hero:UIMovieClip;
		private var direction:int;			// 行走方向
		private var currentFrame:int = 0;	// 行走动画帧

		private var copyBitmap:Bitmap;
		private var copyBitmapData:BitmapData;
		
		public function Hero(map:Maps, cell:BuildingLayer, xtile:int, ytile:int)
		{
			this.map = map;
			this.cell = cell;
			
			hero = new Hero2();
			hero.gotoAndStop(1);

			copyBitmapData = new BitmapData(hero.width, hero.height, true, 0x00000000);
			copyBitmapData.draw(hero);
			this.copyBitmap = new Bitmap(copyBitmapData);
			this.copyBitmap.x = -hero.width/2;
			this.copyBitmap.y = -hero.height/2;
			
			var currentTilePoint:Point = new Point(xtile, ytile);
			var currentPixelPoint:Point = Util.getPixelPoint(map, currentTilePoint);

//			var loader:Loader = new Loader();
//			loader.load(new URLRequest("res/tile/001.gif"));
			this.x = currentPixelPoint.x;
			this.y = currentPixelPoint.y;
//			this.addChild(hero);

			this.addChild(this.copyBitmap);
		}

		public function moveBySpeed(xSpeed:Number, ySpeed:Number):void
		{
			this.x = this.x + xSpeed;
			this.y = this.y + ySpeed;

			//跳到正确方向的帧
			if (this.currentFrame == this.frameCountInWalk)//该方向上最后一帧，回到开始
			{
				this.currentFrame = 0;
			}
			this.currentFrame = this.currentFrame + 1;
			hero.gotoAndStop(direction*this.frameCountInDirection + this.currentFrame);
			
			this.setAlpha();

		}
		
		private var fbdSource:BitmapData;
		private var fbd:BitmapData;
		
		private function setAlpha():void
		{
			var rect:Rectangle = new Rectangle(0, 0, copyBitmapData.width, copyBitmapData.height);
						
			var building:Buildings = this.cell.getBuilding(0);
			fbdSource = building.imgBitmap.bitmapData;

			this.copyBitmapData.fillRect(rect, 0x00000000);
			copyBitmapData.draw(hero);

			var pt:Point = new Point(0, 0);
			var rect2:Rectangle = new Rectangle(this.x-hero.width/2-building.xp, this.y-hero.height/2-building.yp, copyBitmapData.width, copyBitmapData.height);
			
			fbd = new BitmapData(copyBitmapData.width, copyBitmapData.height);
			fbd.threshold(fbdSource, rect2, pt, ">", 0x00000000, 0x00000000);	//所有不透明的点变为透明
			
			this.copyBitmap.bitmapData.copyPixels(copyBitmapData, rect, pt, fbd, pt, false);
		}
		
		
		/**
		 * 取得行走方向，水平向右为0，顺时针旋转
		 * (注意：在tile的宽=2*高时，右下 左下 左上 右上并非是45度)
		 * 0 -- 右		0度
		 * 1 -- 右下		45度
		 * 2 -- 下		90度
		 * 3 -- 左下		135度
		 * 4 -- 左		180度
		 * 5 -- 左上		-135度
		 * 6 -- 上		-90度
		 * 7 -- 右上		-45度
		 */
		public function setDirection(radians:Number):int
		{
			/**
			角度(degrees)和弧度(radians)之间的转换关系式是：
			radians = (Math.PI / 180) * degrees
			**/
			var degrees:Number = radians * 180 / Math.PI;	//角度
			
			//八方向 360/8=45，左上角为元点，右向为横轴，逆时针角度为负，顺时针为正  
			// 也可用弧度直接算
			direction = Math.round( degrees / 45 );	
			
			if (degrees < 0)	//角度为负
			{
				direction = Math.abs(direction + 8);
			}
			
			return direction;
		}
		

		
		
//		public function getCurrentWalkPath():Array
//		{
//			return this.currentWalkPath;
//		}

//		public function getCurrentTilePoint():Point
//		{
//			return this.currentTilePoint;
//		}

	}
}