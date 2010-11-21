/*
 * author: 白连忱
 * email: blianchen@163.com
 * vision: v0.1
 */

package rpg
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.*;
	import flash.utils.Timer;
	
	import rpg.cell.BuildingLayer;
	import rpg.cell.Player;
	import rpg.map.Maps;
	
	public class MainScene extends DisplayUseInFlex
	{
		public static const DISPLAY_WIDTH:int = 832;
		public static const DISPLAY_Height:int = 480;

		public var currentMap:Maps;	//场景使用的map
		public var cellLayer:BuildingLayer;
		public var frontLayer:Sprite;
		
		private var hero:Player;

		private var mainTimer:Timer;
		
		private var mapInit:Boolean = false;	//地图初始化完
		private var cellCreated:Boolean = false;
		
		private var configXml:XML;
		
		//图片id和路径数组
		private var imgArray:Array;
		
		public function MainScene()
		{
			this.currentMap = new Maps();	//地图
			this.cellLayer = new BuildingLayer();//前景层
			this.frontLayer = new Sprite();

			this.addChild(this.currentMap);
			this.addChild(this.cellLayer);
			this.addChild(this.frontLayer);
			
			this.mainTimer = new Timer(33);
			this.mainTimer.addEventListener(TimerEvent.TIMER, beginInit);
			this.mainTimer.start();
		}

		public function create(sceneId:String):void
		{
			//读取场景配置文件
			var sceneConfigFileUrl:String = "res/"+sceneId+"/"+sceneId+".sc";
			var configLoader:URLLoader = new URLLoader();
			configLoader.load(new URLRequest(sceneConfigFileUrl));
			configLoader.addEventListener(Event.COMPLETE, loadSceneData);
		}
		
		private function loadSceneData(event:Event):void
		{
			this.configXml = XML(event.target.data);
			var mapFileName:String = configXml.map[0];	//map id

			//图片id和路径数组
			this.imgArray = new Array();
			for each (var imgItem:XML in configXml.item)
			{
				this.imgArray[imgItem.@id] = imgItem.file;
			}
			
			//所有图片的id和路径
			this.currentMap.setImgPathArray(this.imgArray);
			
			//载入map数据
			this.currentMap.create(mapFileName,  4, 8);
			this.currentMap.addEventListener(SceneEvent.MAP_INIT_COMPLETED, mapInitCompleted);
		}
		
		
		private function mapInitCompleted(event:Event):void
		{
			mapInit = true;
			
			//前景层
			this.cellLayer.setImgPathArray(this.imgArray);
			this.cellLayer.setCurrMap(this.currentMap);
			this.cellLayer.create("test.bld", this.configXml);	
			
			this.cellLayer.addEventListener(SceneEvent.CELL_CREATE_COMPLETED, cellCreatecompleted);
		}
		
		private function cellCreatecompleted(event:Event):void
		{
			cellCreated = true;
		}
		
		private function beginInit(event:Event):void
		{
			if (mapInit == true && this.cellCreated == true)
			{
				this.mainTimer.stop();
				this.mainTimer.removeEventListener(TimerEvent.TIMER, beginInit);
				init();
			}
		}
		

		private function init():void
		{

			//主角 NPC 等
			hero = new Player("");
			hero.setScene(this);
			hero.setXtile(4);
			hero.setYtile(8);
			hero.create();
			this.cellLayer.addChild(hero);


//			var enemy:Enemy = new Enemy(this.currentMap, 15,14);
//			this.cellLayer.addChild(enemy);
			

			//位置设为与地图层相同
			//在cell层与地图层的x，y坐标相同时，hero的x，y坐标即是其在地图层上的坐标
			this.cellLayer.x = this.currentMap.x;
			this.cellLayer.y = this.currentMap.y;
			
//			this.cellLayer.addEventListener(SceneEvent.POSITION_CHANGED, changeDepth);
			
			/////////////////////// test ////////////////////////////
			//画十字线
			var line0:Shape = new Shape();
			this.frontLayer.addChild(line0);
			line0.graphics.lineStyle(1, 0xffff00, 1);
			line0.graphics.moveTo(0, DISPLAY_Height/2);
			line0.graphics.lineTo(DISPLAY_WIDTH, DISPLAY_Height/2);	
			line0.graphics.moveTo(DISPLAY_WIDTH/2, 0);
			line0.graphics.lineTo(DISPLAY_WIDTH/2, DISPLAY_Height);
			//外框
			var rect0:Shape = new Shape();
			rect0.graphics.lineStyle(3, 0x00ffff, 1);
			rect0.graphics.drawRect(0, 0, DISPLAY_WIDTH, DISPLAY_Height);
			this.frontLayer.addChild(rect0);
			///////////////////////////////////////////////////////////

			
			//事件
			this.addEventListener(MouseEvent.CLICK, onClick);
			
			//主循环
			this.mainTimer.addEventListener(TimerEvent.TIMER, mainLoop);
			this.mainTimer.start();
		}
		
		private function mainLoop(event:Event):void
		{
			
		}

		/**
		 * 鼠标点击事件
		 */
		private function onClick(e:MouseEvent):void
		{
			this.hero.moveOnPath(new Point(this.currentMap.mouseX, this.currentMap.mouseY));
		}


//		private function changeDepth(e:SceneEvent):void
//		{
////			var currentCell:* = e.target;
//			var currentCell:* = this.hero;
//			var currentIndex:int = this.cellLayer.getChildIndex(currentCell);
//			var maxIndex:int = this.cellLayer.numChildren;
//			var nextCell:* = currentIndex<maxIndex-1?this.cellLayer.getChildAt(currentIndex + 1):currentCell;
//			if (currentCell.y > nextCell.y)
//			{
//				while (currentIndex < maxIndex - 1)
//				{
//					if (currentCell.y > this.cellLayer.getChildAt(currentIndex + 1).y)
//					{
//						this.cellLayer.swapChildrenAt(currentIndex, currentIndex + 1);
//						currentIndex++;
//					} else {
//						break;
//					}
//				}
//			} else {
//				while (currentIndex > 0)
//				{
//					if (currentCell.y < this.cellLayer.getChildAt(currentIndex - 1).y)
//					{
//						this.cellLayer.swapChildrenAt(currentIndex, currentIndex - 1);
//						currentIndex--;
//					} else {
//						break;
//					}
//				}
//			}
//		}
		
		public function getCurrentMap():Maps
		{
			return this.currentMap;
		}
			
	}
}