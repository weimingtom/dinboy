package ruby.stone
{
	import mx.containers.Canvas;
	import mx.controls.Image;
	
	
	public class Stone2 extends Canvas
	{
		private var img:Image;
		public function Stone2()
		{
			img=new Image();
			img.source="stoneImage/s2.png";
			img.scaleX=0.8;
			img.scaleY=0.8;
			this.addChild(img);
		}

	}
}