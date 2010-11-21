/*
 * author: 白连忱
 * email: blianchen@163.com
 * vision: v0.1
 */

package rpg.cell
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import rpg.MainScene;
	import rpg.SceneEvent;
	import rpg.map.Maps;
	import rpg.map.Tiles;
	import rpg.util.AStarPathFinder;
	import rpg.util.Util;

	public class Player extends Sprite
	{
		private const widthDis:int = 80;		//人物宽
		private const heightDis:int = 91;		//人物高
		private const wOffset:int = widthDis/2;		//图片偏移量
		private const hOffset:int = heightDis - 10;	//图片偏移量
		
		private var speed:Number = 12;		// 速度
		private var actionTime:Number = 46	//动作动画时间
		
		private var currScene:MainScene;
		private var currMap:Maps;
		private var currCell:BuildingLayer;
		private var frontLayer:Sprite;
		private var xtile:int;
		private var ytile:int;
		
		
		private var imgData:BitmapData;	//人物的所有行走动画
		private var disBitmap:Bitmap;		//显示人物用
		private var disData:BitmapData;	//当前显示部分的
		
		private var rectDis:Rectangle;		//当前显示部分在原图的矩形范围
		private var pointDest:Point;		//拷贝像素的目标点，为0，0
		private var rectDest:Rectangle;	//拷贝像素的目标矩形范围
		private var fbdSource:BitmapData;		//存放遮挡建筑物的
		private var filterData:BitmapData;		//过滤用
		private var rectFilter:Rectangle;		//遮挡建筑物与人物重叠的矩形范围
		
		private var frameCountInWalk:int = 8;	//行走动画的总帧数
		private var currentFrame:int = 2;		//当前行走动画帧
		private var direction:int;				//行走方向
		
		private var currentWalkPath:Array = new Array();	//行走路径
		private var actionTimer:Timer;		//动作计时器
		
		private var walking:Boolean = false;	//当前是否有需要行走的动作
		private var xSpeed:Number;		//x轴向速度
		private var ySpeed:Number;		//y轴向速度
		private var distance:Number;	//与目标点的距离
		private var radians:Number;	//移动弧度
		private var nextPixel:Point;	//目标点 象素坐标
		private var nextTile:Point;	//目标点 网格坐标

		private var disNoPathText:Boolean = false;	//显示是否找到路径文本
		private var pathLine:Shape;		//路径线
		private var noPathText:TextField;	//"没有找到路径"文本
		
		public function Player(id:String)
		{
			//根据id取人物配置信息
		}
		
		public function create():void
		{
			//取数据
			readData();
		}
		
		private function readData():void
		{

			//载入图片
			var imgUrl:String = "res/hero/h1.png";
			var imgLoader:Loader = new Loader();
			imgLoader.load(new URLRequest(imgUrl));
			imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadImg);
		}

		private function loadImg(event:Event):void
		{
			//图片数据
			var imgLoader:Loader = event.target.loader;
			var bmPlayer:Bitmap = Bitmap(imgLoader.content);
			this.imgData = bmPlayer.bitmapData;
			
			//初始化
			init();
		}
		
		private function init():void
		{
			this.actionTimer = new Timer(actionTime);
			this.actionTimer.addEventListener(TimerEvent.TIMER, doAction);
			this.actionTimer.start();

			this.pointDest = new Point(0, 0);
			this.filterData = new BitmapData(this.widthDis, this.heightDis);
			this.rectDest = new Rectangle(0, 0, this.widthDis, this.heightDis);
			this.rectFilter = new Rectangle(0, 0, this.widthDis, this.heightDis);
			
			//初始位置，这里取第3格图片
			this.rectDis = new Rectangle(this.widthDis*2, 0, this.widthDis, this.heightDis);
			this.disData = new BitmapData(this.widthDis, this.heightDis);
			this.disData.copyPixels(this.imgData, this.rectDis, this.pointDest);
			this.disBitmap = new Bitmap(this.disData);
			
			//偏移量，使player的注册点在人物脚下
			this.disBitmap.x = this.disBitmap.x - wOffset;
			this.disBitmap.y = this.disBitmap.y - hOffset;
			
//			var currentTilePoint:Point = new Point(xtile, ytile);
			var currentPixelPoint:Point = Util.getPixelPoint(currMap.getTilePixelWidth(), currMap.getTilePixelHeight(), xtile, ytile);
			this.x = currentPixelPoint.x;
			this.y = currentPixelPoint.y;
			this.addChild(this.disBitmap);
		}
		
		private function doAction(event:Event):void
		{
			this.drawPathLine();
			
			//行走
			this.walk();
			
			//处理遮挡
			this.setAlpha();
			

		}
		
		
		/**
		 * 寻路并行走
		 */
		public function moveOnPath(mousePoint:Point):void
		{
			//停止当前的移动
			this.walking = false;
			this.removeEventListener(SceneEvent.MOVE_TO_NEXT_TILE, moveToNextTile);
			
			//角色当前位置的网格坐标
			var tileOnMap:Point = Util.getTilePoint(this.currMap.getTilePixelWidth(), this.currMap.getTilePixelHeight(), this.x, this.y);
			//鼠标点击点的网格坐标
			var endPoint:Point = Util.getTilePoint(this.currMap.getTilePixelWidth(), this.currMap.getTilePixelHeight(), mousePoint.x, mousePoint.y);
			//寻路
			var pathFinder:AStarPathFinder = new AStarPathFinder(this.currMap);
			this.currentWalkPath = pathFinder.find(tileOnMap, endPoint);
			/***  
			 * 此处如果用数组连接，则可以保存以前的路径，在走完以前的路径后才继续这次的路径
			 * 这样即可以实现类似实时战略游戏那种预先指定多段路径
			if (this.currentWalkPath.length>0)
			{
				tileOnMap = this.currentWalkPath[this.currentWalkPath.length-1];
			}
			this.currentWalkPath = this.currentWalkPath.concat(pathFinder.find(tileOnMap, endPoint));
			***/
			
			//没有找到路径
			if (this.currentWalkPath == null || this.currentWalkPath.length == 0)
			{
				this.disNoPathText = true;
				return;
			}
			
			this.currentWalkPath.splice(0, 1);	//去掉路径开始点，使用角色当前位置作为开始点
			
			this.addEventListener(SceneEvent.MOVE_TO_NEXT_TILE, moveToNextTile);
			this.dispatchEvent(new SceneEvent(SceneEvent.MOVE_TO_NEXT_TILE));
		}

		/**
		 * 移动到行走路径的下一个网格
		 */
		private function moveToNextTile(e:SceneEvent):void
		{
			if (this.currentWalkPath == null || this.currentWalkPath.length == 0)
			{
				this.walking = false;
				return;
			}
			
//			this.cellLayer.dispatchEvent(new SceneEvent(SceneEvent.POSITION_CHANGED));
			
			this.nextTile = this.currentWalkPath.splice(0, 1)[0];
			this.nextPixel = Util.getPixelPoint(this.currMap.getTilePixelWidth(), this.currMap.getTilePixelHeight(), nextTile.x, nextTile.y);

			var dx:Number = nextPixel.x - this.x;
			var dy:Number = nextPixel.y - this.y;
			
			this.distance = Math.sqrt(dx * dx + dy * dy);/** 直角三角形三边 a*a + b*b = c*c */
			
			this.radians = Math.atan2(dy, dx);	/** 正切函数 tanθ=y/x */
			
			this.xSpeed = this.speed * Math.cos(radians); /** 余弦函数 cosθ=x/r */
			this.ySpeed = this.speed * Math.sin(radians); /** 正弦函数 sinθ=y/r */
			
			this.setDirection(this.radians);	//方向
							
			this.walking = true;	//开始行走
		}


		/**
		 * 移动
		 */
		private function walk():void
		{
			if (this.walking == false) return;		//当前没有需要行走的动作，返回
			
			if (this.distance < this.speed)	//与目标网格中心的距离小于速度，则移动到目标点
			{
				this.xSpeed = this.distance * Math.cos(radians);
				this.ySpeed = this.distance * Math.sin(radians);
				
				//移动人物和地图背景
				this.moveToNextFrame();
				this.moveMapAndCell();

				//已经到目标网格，停止移动
				this.walking = false;
				//开始移动到路径的下一个网格（调用moveToNextTile(e:SceneEvent)）
				this.dispatchEvent(new SceneEvent(SceneEvent.MOVE_TO_NEXT_TILE));
							
				return;
			}
			
			//移动人物和地图背景
			this.moveToNextFrame();
			this.moveMapAndCell();
			
			//与目标网格中心的距离
			this.distance = this.distance - this.speed;
		}
		
		/**
		 * 移动到下一个frame
		 */
		private function moveToNextFrame():void
		{
			this.x = this.x + this.xSpeed;
			this.y = this.y + this.ySpeed;

			//取当前帧
			if (this.currentFrame == this.frameCountInWalk)	//该方向上最后一帧，回到开始
			{
				this.currentFrame = -1;
			}
			this.currentFrame = this.currentFrame + 1;
			
			//根据frame和方向取动作图片
			this.rectDis.x = this.currentFrame * this.widthDis;	//在原图片中的像素位置
			this.rectDis.y = this.direction * this.heightDis;		//在原图片中的像素位置
			//拷贝该frame的图片
			this.disData.copyPixels(this.imgData, this.rectDis, this.pointDest);
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
		public function setDirection(radians:Number):void
		{
			/**
			角度(degrees)和弧度(radians)之间的转换关系式是：
			radians = (Math.PI / 180) * degrees
			**/
			var degrees:Number = radians * 180 / Math.PI;	//角度
			
			//八方向 360/8=45，左上角为元点，右向为横轴，逆时针角度为负，顺时针为正  
			// 也可用弧度直接算
			this.direction = Math.round( degrees / 45 );	
			
			if (degrees < 0)	//角度为负
			{
				this.direction = Math.abs(this.direction + 8);
			}
			
			//转成跟图片一致的
			switch (this.direction)
			{
				case 0:
					this.direction = 2;
					break;
				case 1:
					this.direction = 5;
					break;
				case 2:
					this.direction = 0;
					break;
				case 3:
					this.direction = 4;
					break;
				case 4:
					this.direction = 1;
					break;
				case 5:
					this.direction = 6;
					break;
				case 6:
					this.direction = 3;
					break;
				case 7:
					this.direction = 7;
					break;
			}
		}

		/**
		 * 与人物反方向移动背景
		 */
		private function moveMapAndCell():void
		{
			var wMap:int = this.currMap.getMapWidth();	//网格数
			var hMap:int = this.currMap.getMapHeight();	//网格数
			var wTilePixel:int = this.currMap.getTilePixelWidth();	//tile象素
			var hTilePixel:int = this.currMap.getTilePixelHeight();	//tile象素
			
			if (this.x > MainScene.DISPLAY_WIDTH/2 + wTilePixel
				&& this.x < wMap*wTilePixel - MainScene.DISPLAY_WIDTH/2 - wTilePixel/2)
			{
				//
				this.currMap.swapMapTile(this);
				
				this.currMap.x = MainScene.DISPLAY_WIDTH/2 - this.x;
				this.currCell.x = this.currMap.x;
			}
			
			if (this.y > MainScene.DISPLAY_Height/2 + hTilePixel 
				&& this.y < hMap*hTilePixel/2 - MainScene.DISPLAY_Height/2 - hTilePixel/2)
			{
				//
				this.currMap.swapMapTile(this);
				
				this.currMap.y = MainScene.DISPLAY_Height/2 - this.y;
				this.currCell.y = this.currMap.y;
			}
		}
		
		/**
		 * 处理遮挡
		 */
		private function setAlpha():void
		{
			//当前所在tile
			var ct:Point = Util.getTilePoint(this.currMap.getTilePixelWidth(), this.currMap.getTilePixelHeight(), this.x, this.y);
			var tile:Tiles = this.currMap.getTile(ct.x, ct.y);
			
			//当前所在tile的阴影建筑
			var bdArray:Array = tile.getShadowOwners();
			if (bdArray == null || bdArray.length == 0) return;	//没有遮挡，返回
			
			for (var i:int=0; i<bdArray.length; i++)
			{
				var building:Buildings = this.currCell.getBuilding(bdArray[i]);
	//			trace("building.id:"+building.id);
				fbdSource = building.imgBitmap.bitmapData;
				
				//将遮挡建筑物的所有透明色变为不透明，不透明变为透明
				this.rectFilter.x = this.x - this.wOffset - building.xp;
				this.rectFilter.y = this.y - this.hOffset - building.yp;
				this.filterData.fillRect(this.rectDest, 0xff0000ff);	//填充纯色
				//所有不透明的点变为透明
				this.filterData.threshold(fbdSource, this.rectFilter, this.pointDest, ">", 0x00000000, 0x00000000);
				
	//			this.disBitmap.bitmapData = filterData;
				//将与遮挡建筑物不透明区域重叠的地方设为透明
				this.disBitmap.bitmapData.copyPixels(this.disData, this.rectDest, this.pointDest, this.filterData, this.pointDest, false);
			}
		}
		
		
		///////////// todo //////////////////
		private var cntText:int = 0;
		private function drawPathLine():void
		{
			if (this.disNoPathText == true)
			{
				cntText++;
				if (this.noPathText == null)
				{
					this.noPathText = new TextField();
					this.noPathText.mouseEnabled = false;
					this.noPathText.textColor = 0x00ff00;
					this.noPathText.text = "没有找到路径";
					this.noPathText.x = 280;
					this.noPathText.y = 50;
					this.frontLayer.addChild(this.noPathText);
				} else {
					if (cntText > 50)
					{
						this.frontLayer.removeChild(this.noPathText);
						cntText = 0;
						this.noPathText = null;
						this.disNoPathText = false;
					}
				}
			}
				
			//显示路径线
			if (this.currentWalkPath != null && this.currentWalkPath.length > 0)
			{
				if (this.pathLine == null)
				{
					this.pathLine = new Shape();
					this.currCell.addChild(this.pathLine);
				}
				this.pathLine.graphics.clear();
				this.pathLine.graphics.lineStyle(2, 0x0000ff, .5);
					
				this.pathLine.graphics.moveTo(this.x, this.y);
				var ptf:Point = Util.getPixelPoint(this.currMap.getTilePixelWidth(), this.currMap.getTilePixelHeight(), this.nextTile.x, this.nextTile.y);
				var ptt:Point;
				this.pathLine.graphics.lineTo(ptf.x, ptf.y);
				for (var i:int=0; i<this.currentWalkPath.length; i++)
				{
					ptt = Util.getPixelPoint(this.currMap.getTilePixelWidth(), this.currMap.getTilePixelHeight(), this.currentWalkPath[i].x, this.currentWalkPath[i].y);
					this.pathLine.graphics.lineTo(ptt.x, ptt.y);
				}
			}
		}
		///////////// todo //////////////////
		
		
		public function setScene(scene:MainScene):void
		{
			this.currScene = scene;
			this.currMap = scene.currentMap;
			this.currCell = scene.cellLayer;
			this.frontLayer = scene.frontLayer;
		}

		public function setXtile(xtile:int):void
		{
			this.xtile = xtile;
		}
		public function setYtile(ytile:int):void
		{
			this.ytile = ytile;
		}
	}
}