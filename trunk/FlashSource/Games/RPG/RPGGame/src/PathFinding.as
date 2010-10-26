package  
{
	import com.dinboy.game.astar.AstarGrid;
	import com.dinboy.game.astar.ui.GridViewer;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	

	/**
	 * @author		DinBoy
	 * @copy		钉崽 © 2010
	 * @version		v1.0 [2010-10-26 22:26]
	 */
	public class PathFinding extends Sprite
	{
		/**
		 * 地图数据
		 */
		private var _mapGrid:AstarGrid;
		
		/**
		 * 地图浏览器
		 */
		private var _astarViewer:GridViewer;
		
		public function PathFinding() 
		{
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
				
				_mapGrid = new AstarGrid(5, 8);
				
				_mapGrid.setStartNode(1, 1);
				_mapGrid.setEndNode(4, 4);
				
				_mapGrid.setWalkAble(2, 1, false);
				_mapGrid.setWalkAble(3, 2, false);
				_mapGrid.setWalkAble(4, 3, false);
				_mapGrid.setWalkAble(2, 4, false);
				
				_astarViewer = new GridViewer(_mapGrid);
				addChild(_astarViewer);
				
		}






	//============================================
	//===== Class[PathFinding] Has Finish ======
	//============================================
	}

}