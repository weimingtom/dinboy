package com.kerry.effect {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.filters.GradientGlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * Burning 类为显示对象添加火焰燃烧动画特效
	 * @author PhoenixKerry（http://blog.sina.com.cn/yyy98）
	 * @version 0.3
	 */
	public class Burning {
		private var source:DisplayObjectContainer;
		private var speed:Number;
		
		private var flame:BitmapData;
		private var perlinNoise:BitmapData;
		private var perlinSeed:int;
		private var perlinOffsets:Array;
		
		private var offsetX:Number;
		private var offsetY:Number;
		private var stretch:int;
		private var flameBitmap:Bitmap;
		
		public const EXTRA_FLAME_STRETCH_HEIGHT:Number = 50;
		
		/**
		 * 为 source 添加火焰燃烧效果动画
		 * @param	source 要添加燃烧效果动画的显示对象（容器）
		 * @param	stageWidth 舞台宽度
		 * @param	stageHeight 舞台高度
		 * @param	addFlameFilterToDisplayObject 为该显示对象添加火焰滤镜
		 * @param	speed 燃烧速度
		 * @param	stretch 火焰延伸长度 [-20 ~ 20]
		 * @example 以下是该类的使用范例代码，burn_mc 为舞台上一个 MovieClip 实例，flame_mc 是位于 burn_mc 中的一个 MovieClip 实例
			<listing version="3.0">
			new Burning(burn_mc, stage.stageWidth, stage.stageHeight, burn_mc.flame_mc);</listing>
		 */
		public function Burning(source:DisplayObjectContainer, stageWidth:Number, stageHeight:Number, addFlameFilterToDisplayObject:DisplayObject = null, speed:Number = 10, stretch:int = -4) {
			this.source = source;
			this.speed = speed;
			
			flame = new BitmapData(
				stageWidth,
				stageHeight + EXTRA_FLAME_STRETCH_HEIGHT,
				true,
				0x00000000
			);
			
			var startPoint:Point = source.parent.localToGlobal(new Point(source.x, source.y));
			offsetX = startPoint.x;
			offsetY = startPoint.y + EXTRA_FLAME_STRETCH_HEIGHT;
			
			flameBitmap = new Bitmap(flame);
			flameBitmap.x = -offsetX;
			flameBitmap.y = -offsetY;
			source.addChildAt(flameBitmap, 0);
			
			if (addFlameFilterToDisplayObject) {
				addFlameFilterToDisplayObject.filters = [
					new GradientGlowFilter(
						0,
						45,
						[0xFF0000, 0xFFFF00],
						[1, 1],
						[50, 255],
						15,
						15
					)
				];
			}
			
			perlinNoise = flame.clone();
			perlinSeed = 846338099;
			perlinOffsets = [new Point()];
			
			setFlameStretch( stretch );
			
			source.addEventListener(Event.ENTER_FRAME, flameLoop);
			source.addEventListener(Event.REMOVED_FROM_STAGE, removeFlameLoop);
		}
		
		/**
		 * 设置火焰延伸的长度
		 * @param	value 延伸长度值 [-20 ~ 20]
		 */
		public function setFlameStretch(value:int):void {
			stretch = value;
		}
		
		/**
		 * @private
		 */
		private function flameLoop(e:Event):void {
			flame.draw(
				source,
				new Matrix(1, 0, 0, 1, offsetX, offsetY),
				new ColorTransform(.9, .9, .9, .7)
			);
			
			flame.applyFilter(flame, flame.rect, new Point(), new BlurFilter(2, 4));
			flame.scroll(0, stretch);
			
			perlinNoise.perlinNoise(
				20,
				20,
				1,
				perlinSeed,
				false,
				true,
				BitmapDataChannel.RED,
				true,
				perlinOffsets
			);
			
			Point(perlinOffsets[0]).y += speed;
			
			flame.applyFilter(flame, flame.rect, new Point(),
				new DisplacementMapFilter(
					perlinNoise,
					new Point(),
					BitmapDataChannel.RED,
					BitmapDataChannel.RED,
					2,
					8,
					DisplacementMapFilterMode.CLAMP
				)
			);
		}
		
		/**
		 * 删除火焰燃烧动画
		 */
		public function removeFlameLoop(e:Event = null):void {
			source.removeEventListener(Event.ENTER_FRAME, flameLoop);
		}
		
	}
}