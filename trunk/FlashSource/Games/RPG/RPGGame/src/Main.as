package 
{
	import com.dinboy.game.astar.Astar;
	import com.dinboy.game.astar.AstarGrid;
	import com.dinboy.game.astar.core.GameConfig;
	import com.dinboy.game.astar.events.PlayerEvent;
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
		private static const SIDE:Number = 10;
		
		/**
		 * 水平个数
		 */
		private static const HCOUNT:uint = 100;
		
		/**
		 * 垂直个数
		 */
		private static const VCOUNT:uint = 100;
		
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
		private var _mapBackground:Sprite;
		
		/**
		 * 显示路径的容器
		 */
		private var _pathContainer:Sprite;
		
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
		 * 走动的次数
		 */
		private var _stepCount:uint;
		
		/**
		 * A※算法实例
		 */
		private var _astarer:Astar;
		
		
		
		public function Main():void 
		{
			_stepCount = GameConfig.stepCount = 2;
			_cellSide = GameConfig.cellSide = SIDE;
			GameConfig.speed = SIDE /_stepCount>>0;
			
			
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
			_astarer = new Astar();
			
		
			_mapDataGrid = new AstarGrid(HCOUNT, VCOUNT);
			_mapBackground = new Sprite();
			addChild(_mapBackground);
			_pathContainer = new Sprite();	
			_pathContainer.mouseEnabled = false;
			addChild(_pathContainer);
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
			_mapBackground.addEventListener(MouseEvent.CLICK, this.mapClickHandler, false, 0, true);
		}
		
		/**
		 * 绘制背景表格
		 */
		private function  drawBackground():Boolean 
		{
			_mapBackground.graphics.clear();
			_mapBackground.graphics.lineStyle(1);
			_mapBackground.graphics.beginFill(0xFFFFFF);
			_mapBackground.graphics.drawRect(0, 0, HCOUNT * SIDE, VCOUNT * SIDE);
			var i:uint,__gridWidth:Number,__gridHeight:Number;
			__gridWidth = HCOUNT * SIDE;
			__gridHeight = VCOUNT * SIDE;
			for (i = 0; i <= HCOUNT ; i++) 
			{
					_mapBackground.graphics.moveTo(0, i*SIDE);
					_mapBackground.graphics.lineTo(__gridWidth,i*SIDE);
			}
			for (i = 0; i <= VCOUNT; i++) 
			{
				_mapBackground.graphics.moveTo(i * SIDE, 0);
				_mapBackground.graphics.lineTo(i * SIDE, __gridHeight);
				}
			_mapBackground.graphics.endFill();

			return true;
		}
		
		/**
		 * 更新路径
		 */
		private function updataPath():void 
		{
			if (_mapPath.length <= 0)  return;
			_pathContainer.graphics.clear();
			_pathContainer.graphics.beginFill(0);
				var i:int;
				for ( i = 0; i< _mapPath.length ;i++ ) 
				{
					_pathContainer.graphics.drawRect(_mapPath[i].x*SIDE, _mapPath[i].y*SIDE, SIDE, SIDE);
				}
				_pathContainer.graphics.endFill();
		}
		
		/**
		 * 当鼠标点击时
		 * @param	evt
		 */
		private function mapClickHandler(event:MouseEvent):void
		{
			_mapDataGrid.setStartNode(_player.nowX,_player._nowY);
			_mapDataGrid.setEndNode(event.localX / SIDE >> 0, event.localY / SIDE >> 0);
			
			//	 1 	 1		 1	 	 1
			//	上	下	左	右
			//if (_heroAngle>157.5 && _heroAngle<=180 || _heroAngle>-180&&_heroAngle<-157.5) 
			//{
				//_keyCodeString = "0010";
			//}
			//else if (_heroAngle>-157.5&&_heroAngle<=-112.5) 
			//{
				//_keyCodeString = "1010";
			//}
			//else if (_heroAngle>-112.5&&_heroAngle<=-67.5) 
			//{
				//_keyCodeString = "1000";
			//}
			//else if (_heroAngle>-67.5&&_heroAngle<=-22.5) 
			//{
				//_keyCodeString = "1001";
			//}
			//else if (_heroAngle>-22.5&& _heroAngle<=22.5) 
			//{
				//_keyCodeString = "0001";
			//}
			//else if (_heroAngle>22.5&&_heroAngle<=67.5) 
			//{
				//_keyCodeString = "0101";
			//}
			//else if (_heroAngle>67.5&&_heroAngle<=112.5)
			//{
				//_keyCodeString = "0100";
				//}
			//else if (_heroAngle>112.5&&_heroAngle<=157.5) 
			//{
				//_keyCodeString = "0110";
			//}
			findPath();

		}
		
		/**
		 * 开始寻路
		 */
		private function findPath():void
		{
					if (_astarer.findPath(_mapDataGrid)) 
					{
						_mapPath = _astarer.path ;
						_player.walking(_mapPath);
					//	updataPath();
					}else 
					{
						trace("Path Can't Found!");
					}
		}
		
	}
}
