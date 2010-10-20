package {
	import com.cyy.astar.AStar;
	import com.cyy.astar.AStarGrid;
	import com.cyy.astar.AStarNode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * ...
	 * @author Will Chen
	 * @version 1.0
	 * @email c_youyou@163.com
	 * @msn chenyouyou@live.cn
	 * @description ...
	 */
	public class Main extends Sprite {
		private var player:Sprite;
		private var grid:AStarGrid;
		private var index:int;
		private var path:Array;
		private var speed:Number = 0.5;

		public function Main(){
			player = new Sprite();
			player.graphics.beginFill(0x0000ff);
			player.graphics.drawCircle(0, 0, 5);
			player.graphics.endFill();
			player.x = 310;
			player.y = 310;
			addChild(player);
			grid = new AStarGrid(50, 50);
			for (var i:int = 0; i < 500; i++){
				grid.setNodeEmpty(Math.random() * 50>>0, Math.random() * 50>>0, false);
			}
			drawGrid();
			stage.addEventListener(MouseEvent.CLICK, onStageClickHandler);
		}

		private function drawGrid():void {
			graphics.clear();
			for (var i:int = 0; i < grid.columnNum; i++){
				for (var j:int = 0; j < grid.rowNum; j++){
					graphics.lineStyle(0);
					graphics.beginFill(getColor(grid.getNode(i, j)));
					graphics.drawRect(i * 20, j * 20, 20, 20);
					graphics.endFill();
				}
			}
		}

		private function getColor(node:AStarNode):uint {
			if (!node.isEmpty){
				return 0x000000;
			}
			if (node == grid.startNode || node == grid.endNode){
				return 0x00ff00;
			}
			return 0xffffff;
		}

		private function onStageClickHandler(event:MouseEvent):void {
			var posX:int = Math.floor(mouseX / 20);
			var posY:int = Math.floor(mouseY / 20);
			grid.setEndNode(posX, posY);
			posX = Math.floor(player.x / 20);
			posY = Math.floor(player.y / 20);
			grid.setStartNode(posX, posY);
			drawGrid();
			getPath();
		}

		private function getPath():void {
			var astar:AStar = new AStar();
			if (astar.findPath(grid)){
				path = astar.path;
				index = 1;
				addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			} else {
				trace("not found the path!!!");
			}
		}

		private function onEnterFrameHandler(e:Event):void {
			var pathX:Number = path[index].x * 20 + 20 / 2;
			var pathY:Number = path[index].y * 20 + 20 / 2;
			var dx:Number = pathX - player.x;
			var dy:Number = pathY - player.y;
			var temp:Number = Math.sqrt(dx * dx + dy * dy);
			if (temp < 1){
				index++;
				if (index == path.length){
					removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
				}
			} else {
				player.x += dx * speed;
				player.y += dy * speed;
			}
		}
	}
}
