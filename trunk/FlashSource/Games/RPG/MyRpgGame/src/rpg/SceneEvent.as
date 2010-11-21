/*
 * author: 白连忱
 * email: blianchen@163.com
 * vision: v0.1
 */

package rpg
{
	import flash.events.Event;

	public class SceneEvent extends Event
	{
		//地图初始化完成
		public static const MAP_INIT_COMPLETED:String = "map_init_completed";
		//创建地图完成
		public static const MAP_CREATE_COMPLETED:String = "map_create_completed";
		
		//创建前景层完成
		public static const CELL_CREATE_COMPLETED:String = "cell_create_completed";
		
		
		public static const POSITION_CHANGED:String = "position_changed";
		public static const START_FOLLOW:String = "start_follow";
		
		public static const MOVE_TO_NEXT_TILE:String = "move_to_next_tile";
		
		public function SceneEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=true)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}