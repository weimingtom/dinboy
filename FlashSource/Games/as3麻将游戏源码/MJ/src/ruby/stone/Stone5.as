package ruby.stone
{
	import mx.containers.Canvas;
	import mx.controls.Image;
	
	public class Stone5 extends Canvas
	{
		
		public var img:Image;
		
		
		public function Stone5()
		{
			img=new Image();
			img.source="stoneImage/s5.png";
			img.scaleX=0.8;
			img.scaleY=0.8;
			this.addChild(img);
		}

	}
}