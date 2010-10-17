package ruby.stone
{
	import mx.containers.Canvas;
	import mx.controls.Image;
	
	public class Stone6 extends Canvas
	{
		public var img:Image;
		public function Stone6()
		{
			img=new Image();
			img.source="stoneImage/s6.png";
			img.scaleX=0.8;
			img.scaleY=0.8;
			this.addChild(img);
		}
	}
}