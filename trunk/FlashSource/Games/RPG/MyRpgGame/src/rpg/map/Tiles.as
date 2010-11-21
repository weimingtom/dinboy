/*
 * author: 白连忱
 * email: blianchen@163.com
 * vision: v0.1
 */

package rpg.map
{
	import flash.display.Bitmap;
	
	public class Tiles
	{
		public var walkable:Boolean;	//是否可走
		public var x:int;				//网格坐标x
		public var y:int;				//网格坐标y
		public var image:Bitmap;		//关联的图片
		
		public var tileType:int;			//图片id
		public var relativePath:String;		//相对路径
		
		private var walkableOwners:Array;	//在这个tile上有阴影的对象
		private var shadowOwners:Array;	//在这个tile上有阴影的对象
		
		public function Tiles(x:int, y:int, walkable:Boolean)
		{
			this.x = x;
			this.y = y;
			this.walkable = walkable;
		}
		
		
		/**
		 * 添加一个阻挡对象
		 */
		public function addWalkableOwner(buildingId:int):void
		{
			if (walkableOwners == null)
			{
				walkableOwners = new Array();
			}
			
			for each (var id:int in walkableOwners)
			{
				if (id == buildingId) return;
			}
			
			walkableOwners.push(buildingId);
			
//			this.refreshWalkable();
		}
		
		/**
		 * 删除一个阻挡对象
		 */
		public function delWalkableOwner(buildingId:int):void
		{
			if (walkableOwners == null) return;
			
			for (var i:int=0; i<walkableOwners.length; i++)
			{
				if (walkableOwners[i] == buildingId)
				{
					walkableOwners.splice(i, 1);
				}
			}
			
//			this.refreshWalkable();
		}
		
		public function getWalkableOwners():Array
		{
			return this.walkableOwners;
		}
		
				
		/**
		 * 添加一个阴影对象
		 */
		public function addShadowOwner(buildingId:int):void
		{
			if (shadowOwners == null)
			{
				shadowOwners = new Array();
			}
			
			for each (var id:int in shadowOwners)
			{
				if (id == buildingId) return;
			}
			
			shadowOwners.push(buildingId);
			
//			this.refreshShadow();
		}
		
		/**
		 * 删除一个阴影对象
		 */
		public function delShadowOwner(buildingId:int):void
		{
			if (shadowOwners == null) return;
			
			for (var i:int=0; i<shadowOwners.length; i++)
			{
				if (shadowOwners[i] == buildingId)
				{
					shadowOwners.splice(i, 1);
				}
			}
			
//			this.refreshShadow();
		}
		
		public function getShadowOwners():Array
		{
			return this.shadowOwners;
		}
	}
}
