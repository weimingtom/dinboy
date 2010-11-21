/*
 * author: 白连忱
 * email: blianchen@163.com
 * vision: v0.1
 */

package rpg.map
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import rpg.MainScene;
	import rpg.SceneEvent;
	import rpg.cell.Buildings;
	import rpg.util.ImageLoadEvent;
	import rpg.util.ImageLoader;
	import rpg.util.Util;

	/**
	 * 地图数据格式
	 * <地图网格宽度><地图网格高度><一个网格的象素宽><一个网格的象素高>
	 * <图片id><是否可行走>
	 * 		......
	 * <图片id><是否可行走>
	 */
	public class Maps extends Sprite
	{
		public var mapId:String;		//地图id（未使用）
		
		//////////// 地图数据中定义的  /////////////////
		private var mapWidth:int;		//地图网格宽度 
		private var mapHeight:int;		//地图网格高度 
		private var tilePixelWidth:int;		//一个网格的象素宽 
		private var tilePixelHeight:int;		//一个网格的象素高
		//////////////////////////////////////////////
		
		private var imgPathArray:Array;	//图片id与图片路径（图片id即为数组索引）
		
		private var mapImgIdArray:Array;
		private var mapWalkableArray:Array;
		private var tilesArray:Array;
		
		private var imgLoader:ImageLoader;
		
		private var xPixelRole:int;	//角色所在坐标x
		private var yPixelRole:int;	//角色所在坐标y
		
		private var xLeft:int;		//地图左边的网格列
		private var xRight:int;	//地图右边的网格列
		private var yTop:int;		//地图上边的网格行
		private var yBottom:int;	//地图下边的网格行

		private var crI:int;	//当前绘制到的网格列
		private var crJ:int;	//当前绘制到的网格行
		
		//xCell, yCell初始场景人物所在网格坐标
		private var xCell:int;
		private var yCell:int;

		
		public function Maps()
		{
			
		}
		
		/**
		 * 
		 * xCell, yCell初始场景人物所在网格坐标
		 */
		public function create(mapFileName:String, xCell:int, yCell:int):void
		{	
			this.xCell = xCell;
			this.yCell = yCell;
			
			//载入map文件
			var mapUrl:String = "res/map/"+mapFileName;
			var mapLoader:URLLoader = new URLLoader();
			mapLoader.dataFormat = URLLoaderDataFormat.BINARY;
			mapLoader.load(new URLRequest(mapUrl));
			mapLoader.addEventListener(Event.COMPLETE, readMapData);
		}
		
		/**
		 * 读取map文件中的数据
		 */
		private function readMapData(event:Event):void
		{
			var mapByteArray:ByteArray = ByteArray(URLLoader(event.target).data);
			
			//文件头信息
			this.mapWidth = mapByteArray.readShort();
			this.mapHeight = mapByteArray.readShort();
			this.tilePixelWidth = mapByteArray.readShort();
			this.tilePixelHeight = mapByteArray.readShort();
			
			//地图初始化完成事件
			this.dispatchEvent(new SceneEvent(SceneEvent.MAP_INIT_COMPLETED));

			//读取每个tile信息，放入数组
			this.mapImgIdArray = new Array();
			this.mapWalkableArray = new Array();
			var i:int = 0;
			while ((mapByteArray.bytesAvailable > 0))	
			{
				this.mapImgIdArray[i] = mapByteArray.readShort();
				this.mapWalkableArray[i] = mapByteArray.readBoolean();
				i++;
			}
			
			//绘地图
			this.draw();
		}

		/**
		 * 绘地图
		 */
		private function draw():void 
		{
			this.initDisplay(xCell, yCell);
			
			this.imgLoader = new ImageLoader(imgPathArray);
			
			//初始化所有tile
			var cntTile:int = this.mapHeight * this.mapWidth;
			var ipos:int;
			tilesArray = new Array(cntTile);
			for (var i:int=0; i<this.mapHeight; i++)
			{
				for (var j:int=0; j<this.mapWidth; j++)
				{
					ipos = i * this.mapWidth + j;
					this.tilesArray[ipos] = new Tiles(j, i, this.mapWalkableArray[ipos]);
				}
			}
			
			this.imgLoader.addEventListener(ImageLoadEvent.LOAD_IMAGE_COMPLETED, drawMapSyn);
			this.imgLoader.dispatchEvent(new ImageLoadEvent(ImageLoadEvent.LOAD_IMAGE_COMPLETED));
			
			
			//////////////////// test /////////////////////////////////
			//外框			
			var rect0:Shape = new Shape();
			this.addChild(rect0);
			rect0.graphics.lineStyle(3, 0xffff00, 1);
			rect0.graphics.drawRect(0, 0, this.mapWidth*this.tilePixelWidth+this.tilePixelWidth/2, (this.mapHeight+1)*this.tilePixelHeight/2);
			////////////////////////////////////////////////////////////
		}
		
		
		/**
		 * 绘制一个地图，在图片没有载入时，停止绘图
		 * 在收到载入完成事件后继续
		 */
		private function drawMapSyn(e:ImageLoadEvent):void
		{
			for (var n:int=this.crJ; n<this.xRight; n++)
			{
				if (this.drawTile(crI, n)) return;		//需要等待载入，返回
			}
			
			//
			for (var i:int=crI+1; i<this.yBottom; i++)
			{
				for (var j:int=this.xLeft; j<this.xRight; j++)
				{
					if (this.drawTile(i, j)) return;	//需要等待载入，返回
				}
			}
			
			this.imgLoader.removeEventListener(ImageLoadEvent.LOAD_IMAGE_COMPLETED, drawMapSyn);
			//创建地图完成事件
			this.dispatchEvent(new SceneEvent(SceneEvent.MAP_CREATE_COMPLETED));
		}
		
		/**
		 * 绘制一个tile，在图片没有载入时，载入图片，并返回
		 * @parm  i 行
 		 * @parm  j 列 
		 * return  是否需要等待载入图片数据
		 * 			true	-- 	图片数据还没有，需要等待载入
		 * 		  	false	--	图片数据已有
		 */
		private function drawTile(i:int, j:int):Boolean
		{
			var bitMap:Bitmap;
			var iposition:int = i * this.mapWidth + j;
			var imageData:BitmapData = this.imgLoader.getImageData(this.mapImgIdArray[iposition]);
			if (imageData == null)	//图片数据还没有载入
			{
				this.crI = i;
				this.crJ = j;
				this.imgLoader.loadSyn(this.mapImgIdArray[iposition]);		//载入图片 -- 地图数据中定义图片id
				//退出
				return true;
			} else {
				bitMap = new Bitmap(imageData);
			}
			bitMap.x = j * this.tilePixelWidth + (i&1) * this.tilePixelWidth / 2;
			bitMap.y = i * this.tilePixelHeight / 2;
			
			this.addChild(bitMap);
			
			//tile信息 
			this.tilesArray[iposition].tileType = this.mapImgIdArray[iposition];
			this.tilesArray[iposition].image = bitMap;
//			this.tilesArray[iposition].walkable = this.mapWalkableArray[iposition];	//是否可行走
			this.tilesArray[iposition].relativePath = this.imgPathArray[iposition];

			return false;		
		}
		
		/**
		 * 根据人物位置设置地图初始位置（屏幕外均留一行/列的tile）
		 * xTile, yTile 人物的网格坐标
		 */
		private function initDisplay(xTile:int, yTile:int):void
		{
			//地图宽，高
			var wMapPixel:int = this.mapWidth*this.tilePixelWidth+this.tilePixelWidth/2;
			var hMapPixel:int = (this.mapHeight+1)*this.tilePixelHeight/2;
			
			//人物相对于地图左上角的坐标
			var centerPixel:Point = Util.getPixelPoint(this.tilePixelWidth, this.tilePixelHeight, xTile, yTile);
			
			//角色初始位置
			this.xPixelRole = centerPixel.x;
			this.yPixelRole = centerPixel.y;
			
			var wHalfDisplay:int = int(MainScene.DISPLAY_WIDTH/2);	//显示屏幕宽度的一半
			var hHalfDisplay:int = int(MainScene.DISPLAY_Height/2);	//显示屏幕高度的一半
			
			//默认显示范围(显示全部地图)
			this.xLeft = 0;					//地图左边的网格列
			this.xRight = this.mapWidth;	//地图右边的网格列
			this.yTop = 0;					//地图上边的网格行
			this.yBottom = this.mapHeight;	//地图下边的网格行
			
			var leftHalf:int;
			var rightHalf:int;
			
			if (centerPixel.x >= wHalfDisplay + this.tilePixelWidth 
				&& centerPixel.x <= wMapPixel - this.tilePixelWidth - wHalfDisplay)
			{	//人物位置距屏幕左边和屏幕右边均大于屏幕宽度的一半
				this.x = wHalfDisplay - centerPixel.x;	//地图初始坐标
				
				/*********** 显示范围 ************/
				//从第几列
				leftHalf = Math.floor((centerPixel.x - wHalfDisplay)/this.tilePixelWidth*2);
				this.xLeft = Math.floor(leftHalf/2) - 1;
				this.crJ = this.xLeft;
				//到第几列
				rightHalf = Math.ceil((centerPixel.x + wHalfDisplay + this.tilePixelWidth)/this.tilePixelWidth*2);
				this.xRight = Math.floor(rightHalf/2);
			}
			else if (centerPixel.x < wHalfDisplay + this.tilePixelWidth) 
			{	//人物位置距屏幕左边小于屏幕宽度的一半
				this.x = -this.tilePixelWidth;	//地图初始坐标
				
				rightHalf = Math.ceil( (MainScene.DISPLAY_WIDTH + this.tilePixelWidth*2)/this.tilePixelWidth*2 );
				this.xRight = Math.floor(rightHalf/2);
				
				//角色初始位置
				this.xPixelRole = wHalfDisplay + this.tilePixelWidth;
			}
			else 
			{	//人物位置距屏幕右边小于屏幕宽度的一半
				this.x = -(wMapPixel - this.tilePixelWidth - MainScene.DISPLAY_WIDTH);	//地图初始坐标
				
				leftHalf = Math.floor((wMapPixel - MainScene.DISPLAY_WIDTH - this.tilePixelWidth)/this.tilePixelWidth*2);
				this.xLeft = Math.floor(leftHalf/2) - 1;
				this.crJ = this.xLeft;
				
				//角色初始位置
				this.xPixelRole = wMapPixel - wHalfDisplay - this.tilePixelWidth;
			}
			
			if (centerPixel.y >= hHalfDisplay + this.tilePixelHeight 
				&& centerPixel.y <= hMapPixel - this.tilePixelHeight - hHalfDisplay)
			{	//人物位置距屏幕上边和屏幕下边均大于屏幕高度的一半
				this.y = hHalfDisplay - centerPixel.y;	//地图初始坐标
				
				/*********** 显示范围 ************/
				//从第几行
				this.yTop = Math.floor((centerPixel.y - hHalfDisplay - this.tilePixelHeight)/this.tilePixelHeight*2);
				this.crI = this.yTop;
				//到第几行
				this.yBottom = Math.floor((centerPixel.y + hHalfDisplay)/this.tilePixelHeight*2) + 1;
			} 
			else if (centerPixel.y < hHalfDisplay + this.tilePixelHeight) 
			{	//人物位置距屏幕上边小于屏幕高度的一半
				this.y = -this.tilePixelHeight;		//地图初始坐标
				
				this.yBottom = Math.floor((MainScene.DISPLAY_Height + this.tilePixelHeight)/this.tilePixelHeight*2) + 1;
				
				//角色初始位置
				this.yPixelRole = hHalfDisplay + this.tilePixelHeight;
			} 
			else 
			{	//人物位置距屏幕下边小于屏幕高度的一半
				this.y = -(hMapPixel - this.tilePixelHeight - MainScene.DISPLAY_Height);	//地图初始坐标
				
				this.yTop = Math.floor((hMapPixel - MainScene.DISPLAY_Height - this.tilePixelHeight*2)/this.tilePixelHeight*2);
				this.crI = this.yTop;
				
				//角色初始位置
				this.yPixelRole = hMapPixel - hHalfDisplay - this.tilePixelHeight;
			}
		}
		
		/**
		 * 地图移动时，显示和删除显示区域外的tile
		 */
		public function swapMapTile(obj:DisplayObject):void
		{

			if (obj.x < this.xPixelRole)	//向左，地图右移
			{
				if (obj.x < this.xPixelRole - this.tilePixelWidth/2 - 1)
				{
					if (this.xLeft > 0)
					{
						this.xLeft -= 1;
						this.xRight -= 1;
						this.crI = this.yTop;
						this.isDrawCol = true;
						this.drawCol = this.xLeft;
						
						this.addEventListener(ImageLoadEvent.LOAD_IMAGE_COMPLETED, drawTileInSwap);
						this.dispatchEvent(new ImageLoadEvent(ImageLoadEvent.LOAD_IMAGE_COMPLETED));
						
						this.delTileInSwap(this.xRight);
						
						this.xPixelRole -= this.tilePixelWidth;
					}
				}
			}
			else if (obj.x > this.xPixelRole)	//向右，地图左移
			{
				if (obj.x > this.xPixelRole + this.tilePixelWidth/2 + 1)
				{
					if (this.xRight < this.mapWidth)
					{
						
						this.crI = this.yTop;
						this.isDrawCol = true;
						this.drawCol = this.xRight;
						
						this.addEventListener(ImageLoadEvent.LOAD_IMAGE_COMPLETED, drawTileInSwap);
						this.dispatchEvent(new ImageLoadEvent(ImageLoadEvent.LOAD_IMAGE_COMPLETED));
						
						this.delTileInSwap(this.xLeft);
						
						this.xPixelRole += this.tilePixelWidth;
						this.xLeft += 1;
						this.xRight += 1;
					}
				}
			}
			
			//row
			if (obj.y < this.yPixelRole)	//向上，地图下移
			{
				if (obj.y < this.yPixelRole - this.tilePixelHeight/4 - 1)
				{
					if (this.yTop > 0)
					{
						this.yTop -= 1;
						this.yBottom -= 1;
						this.crJ = this.xLeft;
						this.isDrawCol = false;
						this.drawRow = this.yTop;
						
						this.addEventListener(ImageLoadEvent.LOAD_IMAGE_COMPLETED, drawTileInSwap);
						this.dispatchEvent(new ImageLoadEvent(ImageLoadEvent.LOAD_IMAGE_COMPLETED));
						
						this.delTileInSwap(this.yBottom);
						
						this.yPixelRole -= this.tilePixelHeight/2;
					}
				}
			}
			else if (obj.y > this.yPixelRole)	//向下，地图上移
			{
				if (obj.y > this.yPixelRole + this.tilePixelHeight/4 + 1)
				{
					if (this.yBottom < this.mapHeight)
					{
//						trace("向下，地图上移");
						this.crJ = this.xLeft;
						this.isDrawCol = false;
						this.drawRow = this.yBottom;
						
						this.addEventListener(ImageLoadEvent.LOAD_IMAGE_COMPLETED, drawTileInSwap);
						this.dispatchEvent(new ImageLoadEvent(ImageLoadEvent.LOAD_IMAGE_COMPLETED));
						
						this.delTileInSwap(this.yTop);
						
						this.yPixelRole += this.tilePixelHeight/2;
						this.yTop += 1;
						this.yBottom += 1;
					}
				}
			}
		}
		
		private var isDrawCol:Boolean = true;	//true=处理列；false=处理行
		private var drawCol:int;
		private var drawRow:int;
		private function drawTileInSwap(e:ImageLoadEvent):void
		{
			if (this.isDrawCol)
			{
				for (var i:int=crI; i<this.yBottom; i++)
				{
					if (this.drawTile(i, this.drawCol)) return;	//需要等待载入，返回
				}
			}
			else 
			{
				for (var j:int=this.crJ; j<this.xRight; j++)
				{
					if (this.drawTile(this.drawRow, j)) return;	//需要等待载入，返回
				}
			}
			
			this.removeEventListener(ImageLoadEvent.LOAD_IMAGE_COMPLETED, drawTileInSwap);
		}
		
		private function delTileInSwap(cnt:int):void
		{
			if (this.isDrawCol)
			{
				for (var i:int=this.yTop; i<this.yBottom; i++)
				{
					this.removeChild(this.tilesArray[i * this.mapWidth + cnt].image);
				}
			}
			else 
			{
				for (var j:int=this.xLeft; j<this.xRight; j++)
				{
					this.removeChild(this.tilesArray[cnt * this.mapWidth + j].image);
				}
			}
		}
		
		
		/**
		 * 
		 * originPX, originPY	建筑物元点在地图坐标系中的像素坐标
		 * building				
		 * walkable 			是否可行走
		 */
		public function drawWalkableBuilding(building:Buildings, xmlBld:XML, originPX:int, originPY:int, wb:Boolean):void
		{
			var walkableStr:String = xmlBld.walkable;
			var wa:Array = walkableStr.split(",");
			if (wa == null || wa.length < 2) return;
			
			var xtmp:int, ytmp:int;
			for (var i:int=0; i<wa.length; i+=2)
			{
				ytmp = originPY + int(wa[i+1]);
				xtmp = originPX + int(wa[i]);

				var pt:Point = Util.getTilePoint(this.tilePixelWidth, this.tilePixelHeight, xtmp, ytmp);
				var ip:int = pt.y * this.mapWidth + pt.x;
				var tile:Tiles = this.tilesArray[ip];
//				trace(tile);
				if (tile == null) continue;
				
				if (wb == false)		//增加阻挡
				{
//					trace("pt.x:pt.y"+pt.x+"|"+pt.y);
					tile.walkable = false;
					tile.addWalkableOwner(building.id);
				}
			}

		}
		
		/**
		 * 
		 * originPX, originPY	建筑物元点在地图坐标系中的像素坐标
		 * building				
		 * shadow 			
		 */
		public function drawShadowBuilding(building:Buildings, xmlBld:XML, originPX:int, originPY:int, shadow:Boolean):void
		{
			var shadowStr:String = xmlBld.shadow;
			var sa:Array = shadowStr.split(",");
			if (sa == null || sa.length < 2) return;
			
			var xtmp:int, ytmp:int;
			for (var i:int=0; i<sa.length; i+=2)
			{
				ytmp = originPY + int(sa[i+1]);
				xtmp = originPX + int(sa[i]);

				var pt:Point = Util.getTilePoint(this.tilePixelWidth, this.tilePixelHeight, xtmp, ytmp);
				var ip:int = pt.y * this.mapWidth + pt.x;
				var tile:Tiles = this.tilesArray[ip];
				if (tile == null) continue;
				
				if (shadow == false)		//增加阴影
				{
					tile.addShadowOwner(building.id);
				}
			}
		}
	

		public function getWalkable(xtile:int, ytile:int):Boolean
		{
			var tile:Tiles = this.tilesArray[ytile*this.mapWidth + xtile];
//			trace(tile.walkable);
			return tile.walkable;
//			return this.mapWalkableArray[ytile*this.mapWidth + xtile];
		}

		public function setImgPathArray(imgPathArray:Array):void
		{
			this.imgPathArray = imgPathArray;
		}
		
		public function getXMapStart():int
		{
			return this.xLeft;
		}
		
		public function getYMapStart():int
		{
			return this.yTop;
		}
		
		/**
		 * 显示部分的地图宽度
		 */
		public function getMapDisWidth():int
		{
			return this.xRight;
		}
		
		/**
		 * 显示部分的地图高度
		 */
		public function getMapDisHeight():int
		{
			return this.yBottom;
		}
		
		public function getMapWidth():int
		{
			return this.mapWidth;
		}
		
		public function getMapHeight():int
		{
			return this.mapHeight;
		}
		
		public function getTilePixelWidth():int
		{
			return this.tilePixelWidth;
		}
		
		public function getTilePixelHeight():int
		{
			return this.tilePixelHeight;
		}
		
		public function getTile(x:int, y:int):Tiles
		{
			return this.tilesArray[y * this.mapWidth + x];
		}
		

//		public function create():void 
//		{
//			
//			this.mapWidth = maps[0].length;
//			this.mapHeight = maps.length;
//			
//			var walkable:Boolean;
//			for (var i:int=0; i<this.mapHeight; i++)
//			{
//				for (var j:int=0; j<this.mapWidth; j++)
//				{
//					//从地图数据中取出该网格是否可行走
//					walkable = true;
//					if (maps[i][j] == 1 || maps[i][j] == 2)
//					{
//						walkable = false;
//					}
//					
//					var tile:Tiles = new Tiles(maps[i][j], walkable);
//					tile.x = j * this.tilePixelWidth + (i&1) * this.tilePixelWidth / 2;
//					tile.y = i * this.tilePixelHeight / 2;
//					addChild(tile);
//					
//					//////////////// 显示地图坐标 /////////////////////////
////					var myText:TextField = new TextField();
////					myText.textColor = 0xffffff;
////					myText.height = 16;
////					myText.width = 30;
////					myText.text = i + "," + j;
////					myText.x = tile.x + 16;
////					myText.y = tile.y + 5;
////					addChild(myText);
//					//////////////////////////////////////////////////
//				}
//			}

			/** 使用一个整图作为地图，不使用tile **/
//			var loader:Loader = new Loader();
//			loader.load(new URLRequest("res/tile/93.jpg"));
//			this.addChild(loader);
//		}

	}
}