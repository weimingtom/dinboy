﻿package com.kerry.effect {	import flash.display.BitmapData;	import flash.geom.Point;	import flash.filters.DisplacementMapFilter;	import flash.display.Sprite;	import flash.display.DisplayObject;	import flash.display.Bitmap;	import flash.events.Event;	/**	 * PerlinDistort 类为显示对象添加扭曲动画效果	 * @author PhoenixKerry（http://blog.sina.com.cn/yyy98）	 * @version 0.2	 */	public class PerlinDistort {		private var perlinOffset:Array;		private var randCount:Number;				private var source:DisplayObject;		private var bmp:BitmapData;		private var dmf:DisplacementMapFilter;				/**		 * 为 source 显示对象添加扭曲动画		 * @param	source 添加扭曲动画的显示对象		 * @param	scaleX 横向扭曲范围		 * @param	scaleY 纵向扭曲范围		 * @example 以下是该类的使用范例代码：			<listing version="3.0">			var pDist:PerlinDistort = new PerlinDistort(sourceMc, 20, 20);			</listing>		 */		public function PerlinDistort(source:DisplayObject, scaleX:Number, scaleY:Number) {			this.source = source;			randCount = Math.random() * 25;			perlinOffset = new Array(new Point(55, 34), new Point(20, 33));						bmp = new BitmapData(source.width + 100, source.height + 100, false);			bmp.draw(source);			dmf = new DisplacementMapFilter(bmp, new Point(0, 0), 1, 1, scaleX, scaleY, "color", 0xFFFFFF, 0);			source.addEventListener(Event.ENTER_FRAME, noiseOn);		}				private function noiseOn(e:Event):void {			perlinOffset[0].y -= 8;			perlinOffset[0].x -= 5;			perlinOffset[1].x += 8;			perlinOffset[1].y += 5;			bmp.perlinNoise(100, 100, 3, randCount, false, true, 1, true, perlinOffset);			source.filters = [dmf];		}				/**		 * 移除扭曲动画		 */		public function removeNoise():void {			source.removeEventListener(Event.ENTER_FRAME, noiseOn);			source.filters = [];		}	}}