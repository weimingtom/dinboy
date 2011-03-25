package util
{
    import flash.display.Sprite;

	/**
	 * 显示控制类
	 */
    public class BasicGemo extends Sprite
    {
		
		/**
		 * 绘制一个剪辑并返回
		 * @param	width			宽度
		 * @param	height		高度
		 * @param	color			颜色
		 * @param	alpha			透明度
		 * @return 绘制完成的剪辑
		 */
        public static function drawRectSprite(width:uint = 50, height:uint = 50, color:uint = 16777215, alpha:Number = 1) : Sprite
        {
            var drawSprite:Sprite = new Sprite();
			drawSprite.graphics.beginFill(color, alpha);
            drawSprite.graphics.drawRect(0, 0, width, height);
            drawSprite.graphics.endFill();
            return drawSprite;
        }
    }
}
