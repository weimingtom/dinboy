package  
{
	import flash.display.Sprite;
	import flash.display.GradientType;
	import flash.geom.Matrix;
	
	/**
	 * ...
	 * @data $_DATA
	 * @author Dinboy.com
	 */
	public class MatrixExample extends Sprite
	{
		/**
		 * 新的Matrix
		 */
		private var $matrix:Matrix;
		
		private var $colorArray:Array;
		
		private var $alphas:Array;
		
		private var $ratios:Array;
		
		public function MatrixExample()
		{
			this.$matrix = new Matrix();
			this.$matrix.createGradientBox(200, 40, Math.PI / 2, 0, 0);
			
			this.$colorArray = [0xFFFFFF, 0xF9F9F9];
			this.$alphas = [100, 100];
			this.$ratios = [0x33, 0xFF];

			this.graphics.beginGradientFill(GradientType.LINEAR, this.$colorArray, this.$alphas, this.$ratios, this.$matrix);
			this.graphics.lineStyle(1, 0xDDDDDD, 0.5);
			this.graphics.drawRoundRect(10, 10, 200, 40, 5, 5);
			this.graphics.endFill();
				
		}
		
		
		/********** [DINBOY] Say: Class The End  ************/	
	}

}