package {
    import flash.display.Sprite;
    import flash.display.Shape;

    public class Graphics_curveToExample2 extends Sprite
    {
        public function Graphics_curveToExample2() {
            var newMoon:Shape = new Shape();
            
            newMoon.graphics.lineStyle(1, 0);
            newMoon.graphics.beginFill(0xFFFFFF);
            newMoon.graphics.moveTo(100, 100); 
            newMoon.graphics.curveTo(30, 10, 100, 200);    
        //    newMoon.graphics.curveTo(10, 150, 100, 200);    
          //  newMoon.graphics.curveTo(50, 150, 100, 100);
            graphics.endFill();
            
            this.addChild(newMoon);
        }
    }
}
