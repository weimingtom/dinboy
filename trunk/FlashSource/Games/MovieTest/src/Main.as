package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	
	public class Main extends Sprite
	{
		//地图贴图文件
		[Embed(source='back.gif')]
		private var map:Class;
		//游戏地图数组
		private var mapar:Array;
		//角色
		private var role:Sprite;
		//地图贴图
		private var bitdate:Bitmap = new map as Bitmap;
		//贴图加载器
		private var ld:Loader;
		
		public function Main():void
		{
			//初始化地图
			this.InitMap();
			//初始化角色
			this.InitRole();
		}
		
		
		private function InitRole():void
		{
			this.role = new Sprite();
			this.role.graphics.beginFill(0x00ff00, 1);
			this.role.graphics.drawRect(0, 0, 20, 20);
			this.role.graphics.endFill();
			this.role.x = 70;
			this.role.y = 80;
			this.addChild(this.role);
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, OnKeyDown);
		}
		
		private function OnKeyDown(e:KeyboardEvent):void 
		{
				
			if(e.keyCode == 37)
			{
				if (IsStop(-5,0) == true)
				this.role.x -= 5;
			}
			else if (e.keyCode == 38)
			{
				if (IsStop(0,-5) == true)
				this.role.y -= 5;
			}
			else if (e.keyCode == 39)
			{
				if (IsStop(5,0) == true)
				this.role.x += 5;
			}
			else if (e.keyCode == 40)
			{
				if (IsStop(0,5) == true)
				this.role.y += 5;
			}
		}
		
		private function InitMap():void
		{
			this.mapar = [[1, 1, 1, 1, 1], [1, 0, 0, 0, 1], [1, 0, 1, 0, 1], [1, 0, 0, 0, 1], [1, 1, 1, 1, 1]];
			
			
			var x:int = 0;
			var y:int = 0;

			this.graphics.beginBitmapFill(bitdate.bitmapData);
			
			for (var i:int = 0; i < this.mapar.length; i++ )
			{
				var arrtemp:Array = this.mapar[i] as Array;
				for (var j:int = 0; j < arrtemp.length;j++ )
				{
					if (arrtemp[j]==1)
					{
						this.graphics.drawRect(x, y, 50, 50);	
					}
					x += 50;
				}
				x = 0;
				y += 50;
			}
			this.graphics.endFill();
		}
		private function IsStop(_x:int,_y:int):Boolean
		{
			var x1:int = this.role.x+_x;
			var x2:int = x1 + 18;
			var y1:int = this.role.y+_y;
			var y2:int = y1 + 18;
			
			var point1:Point = new Point(Math.floor(x1/50),Math.floor(y1/50));
			var point2:Point = new Point(Math.floor(x2/50),Math.floor(y1/50));
			var point3:Point = new Point(Math.floor(x1/50),Math.floor(y2/50));
			var point4:Point = new Point(Math.floor(x2/50),Math.floor(y2/50));
			
			if (this.mapar[point1.x][point1.y] == 1)
			{
				return false;
			}
			if (this.mapar[point2.x][point2.y] == 1)
			{
				return false;
			}
			if (this.mapar[point3.x][point3.y] == 1)
			{
				return false;
			}
			if (this.mapar[point4.x][point4.y] == 1)
			{
				return false;
			}
			return true;
		}
	}
}