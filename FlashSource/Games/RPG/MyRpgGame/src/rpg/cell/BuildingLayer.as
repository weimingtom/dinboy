/*
 * author: 白连忱
 * email: blianchen@163.com
 * vision: v0.1
 */

package rpg.cell
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import rpg.SceneEvent;
	import rpg.map.Maps;
	import rpg.util.ImageLoadEvent;
	import rpg.util.ImageLoader;
	import rpg.util.Util;

	public class BuildingLayer extends Sprite
	{
		private var cellId:String;	//id（未使用）
				
		private var imgPathArray:Array;	//图片id与图片路径（图片id即为数组索引）
		
//		private var buildingArray:Array;	//所有building数组，数组索引对应building id
		
		private var configXml:XML;
		private var byteArrayBld:ByteArray;
		
		private var bldArray:Array;
		private var imgLoader:ImageLoader;
		private var drawPosition:int = 0;
		
		private var currMap:Maps;
		
		public function BuildingLayer()
		{
		}
		
		public function create(cellFileName:String, configXml:XML):void
		{
			this.configXml = configXml; // .sc文件

			//载入配置文件
			var cfgPath:String = "res/cell/" + cellFileName;
			var urlLoad:URLLoader = new URLLoader();
			urlLoad.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoad.load(new URLRequest(cfgPath));
			urlLoad.addEventListener(Event.COMPLETE, readDataCompleted);
		}
		
		private function readDataCompleted(event:Event):void
		{
			this.byteArrayBld = ByteArray(event.target.data);
			
			this.draw();
		}
		
		
		private function draw():void
		{
			this.imgLoader = new ImageLoader(this.imgPathArray);

			//从bld文件中读取数据初始化buildingArray
			this.bldArray = new Array();
			var bld:Buildings;
			var i:int = 0;
			while (this.byteArrayBld.bytesAvailable)
			{
				bld = new Buildings(i);
				bld.xp = this.byteArrayBld.readShort();
				bld.yp = this.byteArrayBld.readShort();
				bld.imgId = this.byteArrayBld.readShort();
				
				this.bldArray.push(bld);
				
				i++;
			}
			
			this.byteArrayBld = null;
			
			this.imgLoader.addEventListener(ImageLoadEvent.LOAD_IMAGE_COMPLETED, drawCellsSyn);
			this.imgLoader.dispatchEvent(new ImageLoadEvent(ImageLoadEvent.LOAD_IMAGE_COMPLETED));
		}
		
		/**
		 * 同步（阻塞）绘制，在图片载入未完成时会等待
		 */
		private function drawCellsSyn(event:Event):void
		{
			var bld:Buildings;
			var xml:XML;
			for (drawPosition; drawPosition<this.bldArray.length; drawPosition++)
			{
				bld = this.bldArray[drawPosition];
				xml = this.configXml.item.(@id==bld.imgId)[0];
				if (this.drawBuilding(bld, xml) == true) return;
			}
			
			//创建完成事件
			this.dispatchEvent(new SceneEvent(SceneEvent.CELL_CREATE_COMPLETED));
		}
		
		/**
		 * 绘制一个建筑物
		 */
		private function drawBuilding(bld:Buildings, xmlBld:XML):Boolean
		{
			// 先判断已经载入的图片中有没有该图片，有则直接取得图片数据
			// 如果没有则载入图片，并返回true
			var bitMap:Bitmap;
			var imgId:int = bld.imgId;

			var imageData:BitmapData = this.imgLoader.getImageData(imgId);
			if (imageData == null)	//图片数据还没有载入
			{
				this.imgLoader.loadSyn(imgId);		//载入图片 -- 地图数据中定义图片id
				//退出
				return true;
			} else {
				bitMap = new Bitmap(imageData);
			}
			
			//显示图片
			bitMap.x = bld.xp;
			bitMap.y = bld.yp;
			this.addChild(bitMap);
			
			bld.imgBitmap = bitMap;
			bld.imgRelativePath = this.imgPathArray[imgId];
			
			//building对象的阻挡和阴影 
			this.placeSign(bld, xmlBld);

			return false;
		}
		
		private function placeSign(bld:Buildings, xmlBld:XML):void
		{
			var tilePixelWidth:int = this.currMap.getTilePixelWidth();
			var tilePixelHeight:int = this.currMap.getTilePixelHeight();
			
			//阻挡和阴影标记
			var tilePoint:Point = Util.getTilePoint(tilePixelWidth, tilePixelHeight, bld.xp, bld.yp);
			var pt:Point = Util.getPixelPoint(tilePixelWidth, tilePixelHeight, tilePoint.x, tilePoint.y);

			var originPX:int = pt.x - int(xmlBld.@xoffset);
			var originPY:int = pt.y - int(xmlBld.@yoffset);

			this.currMap.drawWalkableBuilding(bld, xmlBld, originPX, originPY, false);
			this.currMap.drawShadowBuilding(bld, xmlBld, originPX, originPY, false);
		}
		
		
		public function setImgPathArray(imgPathArray:Array):void
		{
			this.imgPathArray = imgPathArray;
		}
		
		public function setCurrMap(currMap:Maps):void
		{
			this.currMap = currMap;
		}
		
		public function getBuilding(buildingId:int):Buildings
		{
			return this.bldArray[buildingId];
		}
	}
}

 