package com.dinboy.game.astar.ui 
{
	import com.dinboy.net.DinLoader;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	

	/**
	 * @author		DinBoy
	 * @copy		钉崽 © 2010
	 * @version		v1.0 [2010-11-15 22:32]
	 */
	public class RPGPlayer extends Sprite
	{
		/**
		 * 人物现在位置 横坐标
		 */
		public var nowX:uint;
		
		/**
		 * 人物现在位置 纵坐标
		 */
		public var nowY:uint;
		
		/**
		 * 人物宽度
		 */
		public var playerW:Number;
		
		/**
		 * 人物高度
		 */
		public var playerH:Number;
		
		/**
		 * 人物加载器
		 */
		private var playerLoader:DinLoader;
		
		/**
		 * 人物行走的动作次数
		 */
		private const PLAYER_STEP:uint = 4;
		
		/**
		 * 存放人物行走的动作数组
		 */
		private var playerBitArray:Array;
		
		/**
		 * 存放玩家位图
		 */
		private var playerBitmap:Bitmap;
		/**
		 * RPG人物
		 * @param	nowX		人物现在位置 横坐标
		 * @param	nowY		人物现在位置 纵坐标
		 * @param	playerW	人物宽度
		 * @param	playerH	人物高度
		 * @param	imgURL	人物图片地址
		 */
		public function RPGPlayer(nX:uint,nY:uint,pW:Number,pH:Number,imgURL:String) 
		{
			nowX = nX;
			nowY = nY;
			playerW = pW;
			playerH = pH;
			
			playerLoader = new DinLoader();
			playerLoader.url = imgURL;
			playerLoader.loadNormal();
			playerLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, playerLoaderComplete, false, 0, true);
		}
		
		
		//============================================
		//===== EventListener Function =====
		//============================================
		/**
		 * 人物图片加载完成时调度
		 * @param	event
		 */
		private function playerLoaderComplete(event:Event):void 
		{
			var __bitmap:Bitmap = event.currentTarget.content as Bitmap;
			var i:uint,j:uint;
			for (i = 0; i < 8; i++)
			{
				var __playHSteps:Array=[];
				for (j = 0; j < PLAYER_STEP ; j++)
				{
					var	__bitmapData:BitmapData = new BitmapData(playerW, playerH);
					var	__matrix:Matrix = new Matrix();
							__matrix.tx = -j * playerW;
							__matrix.ty = -i * playerH;
							__bitmapData.draw(__bitmap, __matrix, null, null, new Rectangle(0, 0, playerW, playerH));
							__playHSteps[j] = __bitmapData;
				}
				playerBitArray[i] = __playHSteps;
			}
			playerBitmap.bitmapData = playerBitArray[0][0];
			addChild(playerBitmap);
		}






	//============================================
	//===== Class[RPGPlayer] Has Finish ======
	//============================================
	}

}