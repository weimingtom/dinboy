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
		private static const SIDE:uint = 50;
		
		/**
		 * 水平个数
		 */
		private static const HCOUNT:uint = 50;
		
		/**
		 * 垂直个数
		 */
		private static const VCOUNT:uint = 50;
		
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
		 * 寻找到的路径数组
		 */
		private var _mapPath:Array;
		
		/**
		 * 行走的速度
		 */
		private var _speed:Number;
		
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
			_stepCount = GameConfig.stepCount = 10;
			_cellWidth = GameConfig.cellWidth = SIDE;
			_cellHeight = GameConfig.cellHeight = SIDE;
			GameConfig.horizontalSpeed = SIDE /_stepCount;
			GameConfig.verticalSpeed = SIDE / _stepCount;
			
			
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
			
			_mapPath = [];
			
			_mapDataGrid = new AstarGrid(HCOUNT, VCOUNT);
			_mapBackground = new Sprite();
			addChild(_mapBackground);
			drawBackground();
			
			_player = new RPGPlayer(0, 0, 48, 96, "hero.png");
			addChild(_player);
			_player.addEventListener(PlayerEvent.PLAYER_INITED, playerInitedHandler, false, 0, true);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
		}
		
		/**
		 * 当人物初始化完成时调度
		 * @param	event
		 */
		private function playerInitedHandler(event:PlayerEvent):void 
		{
		//	event.currentTarget.x = event.standX * _cellWidth + (_cellWidth-event.currentTarget.width>>1);
		//	event.currentTarget.y = event.standY * _cellHeight - event.currentTarget.height+(_cellHeight>>1);
			_mapBackground.addEventListener(MouseEvent.CLICK, this.mapClickHandler, false, 0, true);
		}
		
		/**
		 * 绘制背景表格
		 */
		private function  drawBackground():void 
		{
			_mapBackground.graphics.clear();
			_mapBackground.graphics.lineStyle(1);
			_mapBackground.graphics.beginFill(0xFFFFFF, 0);
			var i:int;
			for (i = 0; i < HCOUNT ; i++) 
			{
				var j:int;
				for (j = 0; j < VCOUNT; j++) 
				{
					_mapBackground.graphics.drawRect(i*SIDE, j*SIDE, SIDE, SIDE);
				}
			}
			_mapBackground.graphics.endFill();
			if (_mapPath.length>=0) 
			{
				_mapBackground.graphics.beginFill(0);
				for ( i = 0; i< _mapPath.length ;i++ ) 
				{
					_mapBackground.graphics.drawRect(_mapPath[i].x*SIDE, _mapPath[i].y*SIDE, SIDE, SIDE);
				}
			}
			_mapBackground.graphics.endFill();
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
			var __astar:Astar = new Astar();
					if (__astar.findPath(_mapDataGrid)) 
					{
						_mapPath = __astar.path ;
						_player.walking(_mapPath);
						drawBackground();
					}else 
					{
						trace("Path Can't Found!");
					}
		}
		
	}
}
