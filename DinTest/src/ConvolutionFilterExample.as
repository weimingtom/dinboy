package {
    import flash.display.DisplayObject;
    import flash.display.Loader;
    import flash.display.Sprite;
    import flash.events.*;
    import flash.filters.BitmapFilter;
    import flash.filters.ConvolutionFilter;
    import flash.net.URLRequest;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;

    public class ConvolutionFilterExample extends Sprite {
        private var size:uint = 140;
        private var url:String = "../lib/imDinboy.jpg";

        public function ConvolutionFilterExample() {
            buildChild(applyNothing);
            buildChild(applyBrightness);
            buildChild(applySharpness);
            buildChild(applyOutline);
        }

        private function buildChild(loadHandler:Function):void {
            var loader:Loader = new Loader();
            loader.x = numChildren * size;
            loader.y = size;
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            if(loadHandler != null) {
                loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadHandler);
            }

            var request:URLRequest = new URLRequest(url);
            loader.load(request);
            addChild(loader);
        }

        private function applyNothing(event:Event):void {
            var child:DisplayObject = DisplayObject(event.target.loader);
            applyLabel(child, "no filter");
        }

        private function applyBrightness(event:Event):void {
            var child:DisplayObject = DisplayObject(event.target.loader);
            var matrix:Array = [5, 5, 5,
                                5, 0, 5,
                                5, 5, 5];
            applyFilter(child, matrix);
            applyLabel(child, "brightness");
        }

        private function applySharpness(event:Event):void {
            var child:DisplayObject = DisplayObject(event.target.loader);
            var matrix:Array = [0, -1, 0,
                               -1, 20, -1,
                                0, -1, 0];
            applyFilter(child, matrix);
            applyLabel(child, "sharpness");
        }

        private function applyOutline(event:Event):void {
            var child:DisplayObject = DisplayObject(event.target.loader);
            var matrix:Array = [-30, 30, 0,
                                -30, 30, 0,
                                -30, 30, 0];
            applyFilter(child, matrix);
            applyLabel(child, "outline");
        }

        private function applyFilter(child:DisplayObject, matrix:Array):void {
            var matrixX:Number = 3;
            var matrixY:Number = 3;
            var divisor:Number = 9;
            var filter:BitmapFilter = new ConvolutionFilter(matrixX, matrixY, matrix, divisor);
            var filters:Array = new Array();
            filters.push(filter);
            child.filters = filters;
        }

        private function applyLabel(child:DisplayObject, label:String):void {
            var tf:TextField = new TextField();
            tf.x = child.x;
            tf.y = child.height;
            tf.autoSize = TextFieldAutoSize.LEFT;
            tf.text = label;
            addChild(tf);
        }

        private function ioErrorHandler(event:IOErrorEvent):void {
            trace("Unable to load image: " + url);
        }
    }
}