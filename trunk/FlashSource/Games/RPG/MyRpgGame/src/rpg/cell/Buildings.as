/*
 * author: 白连忱
 * email: blianchen@163.com
 * vision: v0.1
 */

package rpg.cell
{
	import flash.display.Bitmap;
	
	public class Buildings
	{
		public var id:int;		//编号（对应于数组或显示列表索引）
		
		public var xp:int;		//像素坐标
		public var yp:int;		//像素坐标
//		public var xpOffset:int;	//偏移像素
//		public var ypOffset:int;	//偏移像素
		
		public var imgId:int;		//图片id
		public var imgRelativePath:String;	//图片相对路径
		public var imgBitmap:Bitmap;		//图片对象
		
		public function Buildings(id:int)
		{
			this.id = id;
		}

	}
}