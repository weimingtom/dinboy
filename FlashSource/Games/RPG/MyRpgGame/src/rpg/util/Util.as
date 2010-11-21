/*
 * author: 白连忱
 * email: blianchen@163.com
 * vision: v0.1
 */

package rpg.util
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Point;
	
	public class Util
	{

//		/**
//		 * 根据网格坐标取得象素坐标
//		 * map 使用的地图
//		 * tilePoint 网格坐标的点
//		 * return 象素坐标的点
//		 */
//		public static function getPixelPoint(map:Maps, tilePoint:Point):Point
//		{
//			if (map == null) return null;
//			
//			var tileWidth:int = map.getTilePixelWidth();	//tile的象素宽
//	        var tileHeight:int = map.getTilePixelHeight();	//tile的象素高
//	        
//			//偶数行tile中心
//			var tileCenter:int = (tilePoint.x * tileWidth) + tileWidth/2;
//			// x象素  如果为奇数行加半个宽
//			var xPixel:int = tileCenter + (tilePoint.y&1) * tileWidth/2;
//			
//			// y象素
//			var yPixel:int = (tilePoint.y + 1) * tileHeight/2;
//			
//			return new Point(xPixel, yPixel);
//		}
//
//		/**
//		 * 根据屏幕象素坐标取得网格的坐标
//		 * map 使用的地图
//		 * pixelPoint 象素坐标的点
//		 * return 网格坐标的点
//		 */
//		public static function getTilePoint(map:Maps, pixelPoint:Point):Point
//		{
//			if (map == null) return null;
//			
//			var tileWidth:int = map.getTilePixelWidth();	//tile的象素宽
//	        var tileHeight:int = map.getTilePixelHeight();	//tile的象素高
//	        
//			var xtile:int = 0;	//网格的x坐标
//			var ytile:int = 0;	//网格的y坐标
//	
//	        var cx:int, cy:int, rx:int, ry:int;
//	        cx = int(pixelPoint.x / tileWidth) * tileWidth + tileWidth/2;	//计算出当前X所在的以tileWidth为宽的矩形的中心的X坐标
//	        cy = int(pixelPoint.y / tileHeight) * tileHeight + tileHeight/2;//计算出当前Y所在的以tileHeight为高的矩形的中心的Y坐标
////			trace("cx::"+cx);
////			trace("cy::"+cy);
//	
//	        rx = (pixelPoint.x - cx) * tileHeight/2;
//	        ry = (pixelPoint.y - cy) * tileWidth/2;
////	        trace("rx::"+rx);
////			trace("ry::"+ry);
//	
//	        if (Math.abs(rx)+Math.abs(ry) <= tileWidth * tileHeight/4)
//	        {
//				//xtile = int(pixelPoint.x / tileWidth) * 2;
//				xtile = int(pixelPoint.x / tileWidth);
//				ytile = int(pixelPoint.y / tileHeight) * 2;
//	        }
//	        else
//	        {
//				pixelPoint.x = pixelPoint.x - tileWidth/2;
//				//xtile = int(pixelPoint.x / tileWidth) * 2 + 1;
//				xtile = int(pixelPoint.x / tileWidth) + 1;
//				
//				pixelPoint.y = pixelPoint.y - tileHeight/2;
//				ytile = int(pixelPoint.y / tileHeight) * 2 + 1;
//			}
//			
////			trace("xtilextilextile:::"+xtile);
////			trace("(ytile&1)(ytile&1)::"+(ytile&1));
//			return new Point(xtile - (ytile&1), ytile);
//		}
		
		
		/**
		 * 根据网格坐标取得象素坐标
		 * tileWidth  tile的象素宽
		 * tileHeight tile的象素高
		 * tx 网格坐标x
		 * ty 网格坐标x
		 * return 象素坐标的点
		 */
		public static function getPixelPoint(tileWidth:int, tileHeight:int, tx:int, ty:int):Point
		{
			//偶数行tile中心
			var tileCenter:int = (tx * tileWidth) + tileWidth/2;
			// x象素  如果为奇数行加半个宽
			var xPixel:int = tileCenter + (ty&1) * tileWidth/2;
			
			// y象素
			var yPixel:int = (ty + 1) * tileHeight/2;
			
			return new Point(xPixel, yPixel);
		}

		/**
		 * 根据屏幕象素坐标取得网格的坐标
		 * tileWidth  tile的象素宽
		 * tileHeight tile的象素高
		 * px 象素坐标x
		 * py 象素坐标x
		 * return 网格坐标的点
		 */
		public static function getTilePoint(tileWidth:int, tileHeight:int, px:int, py:int):Point
		{
			var xtile:int = 0;	//网格的x坐标
			var ytile:int = 0;	//网格的y坐标
	
	        var cx:int, cy:int, rx:int, ry:int;
	        cx = int(px / tileWidth) * tileWidth + tileWidth/2;	//计算出当前X所在的以tileWidth为宽的矩形的中心的X坐标
	        cy = int(py / tileHeight) * tileHeight + tileHeight/2;//计算出当前Y所在的以tileHeight为高的矩形的中心的Y坐标
	
	        rx = (px - cx) * tileHeight/2;
	        ry = (py - cy) * tileWidth/2;
	
	        if (Math.abs(rx)+Math.abs(ry) <= tileWidth * tileHeight/4)
	        {
				//xtile = int(pixelPoint.x / tileWidth) * 2;
				xtile = int(px / tileWidth);
				ytile = int(py / tileHeight) * 2;
	        }
	        else
	        {
				px = px - tileWidth/2;
				//xtile = int(pixelPoint.x / tileWidth) * 2 + 1;
				xtile = int(px / tileWidth) + 1;
				
				py = py - tileHeight/2;
				ytile = int(py / tileHeight) * 2 + 1;
			}
			trace(xtile - (ytile&1),ytile);
			return new Point(xtile - (ytile&1), ytile);
		}
		
		public static function getWalkableSignMap(tilePixelWidth:int, tilePixelHeight:int):BitmapData
		{
			//菱形
			var shape:Shape = new Shape();
			//外框
			shape.graphics.lineStyle(1, 0xff0000, 0.6);
			shape.graphics.moveTo(0, tilePixelHeight/2);
			shape.graphics.lineTo(tilePixelWidth/2, 0);
			shape.graphics.lineTo(tilePixelWidth, tilePixelHeight/2);
			shape.graphics.lineTo(tilePixelWidth/2, tilePixelHeight);
			shape.graphics.lineTo(0, tilePixelHeight/2);
			//里框
			var hoff:Number = tilePixelHeight/4;
			var woff:Number = hoff * tilePixelWidth / tilePixelHeight;
			shape.graphics.moveTo(woff, tilePixelHeight/2);
			shape.graphics.lineTo(tilePixelWidth/2, hoff);
			shape.graphics.lineTo(tilePixelWidth-woff, tilePixelHeight/2);
			shape.graphics.lineTo(tilePixelWidth/2, tilePixelHeight-hoff);
			shape.graphics.lineTo(woff, tilePixelHeight/2);
			//交叉线
			shape.graphics.moveTo(0, tilePixelHeight/2);
			shape.graphics.lineTo(tilePixelWidth, tilePixelHeight/2);
			shape.graphics.moveTo(tilePixelWidth/2, 0);
			shape.graphics.lineTo(tilePixelWidth/2, tilePixelHeight);
			
			//保存到BitmapData
			var wb:BitmapData = new BitmapData(tilePixelWidth, tilePixelHeight, true, 0x00000000);
			wb.draw(shape);
			
			return wb;
		}
		
		public static function getShadowSignMap(tilePixelWidth:int, tilePixelHeight:int):BitmapData
		{
			//菱形
			var shape:Shape = new Shape();
			shape.graphics.lineStyle(1, 0x0000ff, 0.5);
			shape.graphics.beginFill(0xffff00, 0.2);
			shape.graphics.moveTo(0, tilePixelHeight/2);
			shape.graphics.lineTo(tilePixelWidth/2, 0);
			shape.graphics.lineTo(tilePixelWidth, tilePixelHeight/2);
			shape.graphics.lineTo(tilePixelWidth/2, tilePixelHeight);
			shape.graphics.endFill();

			//保存到BitmapData
			var wb:BitmapData = new BitmapData(tilePixelWidth, tilePixelHeight, true, 0x00000000);
			wb.draw(shape);
			
			return wb;
		}
	}
}