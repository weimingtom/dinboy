package ruby.stone
{
	import mx.containers.Canvas;
	import mx.controls.Image;
	
	public class Stone3 extends Canvas
	{
		
		public var img:Image;
		
		public function Stone3()
		{
			img=new Image();
			img.source="stoneImage/s3.png";
			img.scaleX=0.8;
			img.scaleY=0.8;
			this.addChild(img);
		}

	}
}