package util
{
	import flash.display.DisplayObject;
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
        public static function drawRectSprite(width:uint = 50, height:uint = 50, fillColor:uint = 16777215, fillAlpha:Number = 1,lineThickness:Number=NaN,lineColor:uint=0) : Sprite
        {
            var drawSprite:Sprite = new Sprite();
            return Sprite(drawRect(drawSprite, 0, 0, width, height, fillColor, fillAlpha, lineThickness, lineColor));
        }
		
		/**
		 * 为显示对象画矩形框
		 * @param	object					需要画框的对象
		 * @param	x							框的横坐标
		 * @param	y							框的纵坐标
		 * @param	width					框的宽度
		 * @param	height				框的高度
		 * @param	fillColor				填充的颜色
		 * @param	fillAlpha				填充的透明度
		 * @param	lineThickness	线的宽度
		 * @param	lineColor=0		线的颜色
		 */
		public static function drawRect(object:Object,x:Number=0,y:Number=0,width:Number=100,height:Number=100,fillColor:uint=0xFF0000,fillAlpha:Number=1,lineThickness:Number=NaN,lineColor=0):Object 
		{
			if (!(object is DisplayObject)) return object;
			object.graphics.clear();
			object.graphics.lineStyle(lineThickness, lineColor);
			object.graphics.beginFill(fillColor, fillAlpha);
            object.graphics.drawRect(x, y, width, height);
			object.graphics.endFill();
			return object;
		}
    }
}
