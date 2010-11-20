package 
{
	import com.dinboy.game.astar.Astar;
	import com.dinboy.game.astar.AstarGrid;
	import com.dinboy.game.astar.core.GameConfig;
	import com.dinboy.game.astar.events.PlayerEvent;
	import com.dinboy.game.astar.ui.MapContainer;
	import com.dinboy.game.astar.ui.RPGPlayer;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	
	
	/**
	 * ...
	 * @author 钉崽 [Dinboy.com]
	 */
	[SWF(width="800",height="600")]
	public class Main extends Sprite 
	{
		/**
		 * 单元格大小
		 */
		private static const SIDE:Number = 40;
		
		/**
		 * 水平个数
		 */
		private static const HCOUNT:uint = 10;
		
		/**
		 * 垂直个数
		 */
		private static const VCOUNT:uint = 10;
		
		/**
		 * 游戏人物加载器
		 */
		private var _player:RPGPlayer
		
		/**
		 * 地图的数据表格
		 */
		private var _mapDataGrid:AstarGrid;
		
		/**
		 * 地图背景
		 */
		private var _mapContainer:MapContainer;
		
		/**
		 * 显示路径的容器
		 */
		//private var _pathContainer:Sprite;
		
		/**
		 * 寻找到的路径数组
		 */
		private var _mapPath:Array;
		
		/**
		 * 行走的速度
		 */
		private var _speed:Number;

		/**
		 * 单元格大小
		 */
		private var _cellSide:Number;
		
		/**
		 * 单元格宽度
		 */
		private var _cellWidth:Number;
		
		/**
		 * 单元格高度
		 */
		private var _cellHeight:Number;
		
		/**
		 * 走动的次数
		 */
		private var _stepCount:uint;
		
		
		public function Main():void 
		{
			GameConfig.speed = 100;
			GameConfig.distance = 10;
			GameConfig.cellWidth = SIDE * 1.4;
			GameConfig.cellHeight = SIDE;
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/**
		 * 初始化
		 * @param	e
		 */
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_mapPath = [];
			
		
			_mapDataGrid = new AstarGrid(HCOUNT, VCOUNT);
			_mapContainer = new MapContainer(_mapDataGrid);
			addChild(_mapContainer);
			//_pathContainer = new Sprite();	
			//_pathContainer.mouseEnabled = false;
			//addChild(_pathContainer);
			_mapContainer.addEventListener(
			if (drawBackground()) 
			{
				_player = new RPGPlayer(0, 0, 48, 96, "hero.png");
				addChild(_player);
				_player.addEventListener(PlayerEvent.PLAYER_INITED, playerInitedHandler, false, 0, true);
			}
			
			
		}
		
		/**
		 * 当人物初始化完成时调度
		 * @param	event
		 */
		private function playerInitedHandler(event:PlayerEvent):void 
		{
			_mapContainer.addEventListener(MouseEvent.CLICK, this.mapClickHandler, false, 0, true);
		}
		
		/**
		 //* 更新路径
		 //*/
		//private function updataPath():void 
		//{
			//if (_mapPath.length <= 0)  return;
			//_pathContainer.graphics.clear();
			//_pathContainer.graphics.beginFill(0);
				//var i:int;
				//for ( i = 0; i< _mapPath.length ;i++ ) 
				//{
					//_pathContainer.graphics.drawRect(_mapPath[i].x*SIDE, _mapPath[i].y*SIDE, SIDE, SIDE);
				//}
				//_pathContainer.graphics.endFill();
		//}
		
		/**
		 * 当鼠标点击时
		 * @param	evt
		 */
		private function mapClickHandler(event:MouseEvent):void
		{
			_mapDataGrid.setStartNode(_player.nowX, _player._nowY);
			_mapDataGrid.setEndNode(event.stageX / _cellWidth+event.stageY/_cellHeight >> 0, event.stageY /_cellHeight-event.stageX/_cellWidth >> 0);
			
			findPath();
		}
		
		/**
		 * 开始寻路
		 */
		private function findPath():void
		{
					if (Astar.findPath(_mapDataGrid)) 
					{
						_mapPath = Astar.path ;
						_player.walking(_mapPath);
					//	updataPath();
					}else 
					{
						trace("Path Can't Found!");
					}
		}
		
	}
}
