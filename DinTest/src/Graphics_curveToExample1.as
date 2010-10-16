package {
    import flash.display.Sprite;
    import flash.display.Shape;
    
    public class Graphics_curveToExample1 extends Sprite
    {
        public function Graphics_curveToExample1():void
        {
            var roundObject:Shape = new Shape();

            roundObject.graphics.beginFill(0x00FF00);
            roundObject.graphics.moveTo(250, 0);
            roundObject.graphics.curveTo(300, 0, 300, 50);
            roundObject.graphics.curveTo(300, 100, 250, 100);
            roundObject.graphics.curveTo(200, 100, 200, 50);
            roundObject.graphics.curveTo(200, 0, 250, 0);
            roundObject.graphics.endFill();
            
            this.addChild(roundObject);
        }
    }
}
