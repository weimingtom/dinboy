package  
{
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	

	/**
	 * @author		钉崽[Dinboy]
	 * @copy		2010 © dinboy.com
	 * @version		v1.0 [2011-3-30 16:13]
	 */
	public class MaskTest extends Sprite
	{
		[Embed(source='../lib/imDinboy.jpg')]
		private var DINBOY:Class;
		
		private var _dinboy:Bitmap;
		
		private var _masker:Sprite;
		
		private var _maskerContainer:Sprite;
		public function MaskTest() 
		{
			_dinboy = new DINBOY();
			addChild(_dinboy);
			
			_maskerContainer = new Sprite( );
			_maskerContainer.graphics.beginFill(0, 0.5);
			_maskerContainer.graphics.drawRect(0, 0, 200, 200);
			_maskerContainer.graphics.endFill();
			_maskerContainer.blendMode = BlendMode.LAYER;
			_maskerContainer.x = stage.stageWidth - _maskerContainer.width >> 1;
			_maskerContainer.y = stage.stageHeight - _maskerContainer.height >> 1;
			
			_masker = new Sprite();
			_masker.graphics.beginFill(0, 1);
			_masker.graphics.drawRect(0, 0, 100, 100);
			_masker.graphics.endFill();
			_masker.blendMode = BlendMode.ERASE;
			_masker.x = _maskerContainer.width - _masker.width >> 1;
			_masker.y = _maskerContainer.height - _masker.height >> 1;
			
			
			
			
			_maskerContainer.addChild(_masker);
			addChild(_maskerContainer);
		}






	//============================================
	//===== Class[MaskTest] Has Finish ======
	//============================================
	}

}