package {
	import com.adobe.images.JPGEncoder;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.net.LocalConnection;
    import flash.text.TextField;
	import flash.utils.ByteArray;

    public class LocalConnectionReceiverExample extends Sprite {
        private var conn:LocalConnection;
        private var output:TextField;
        private var bitmap:Bitmap;
		private var jpgEncode:JPGEncoder
        public function LocalConnectionReceiverExample()     {
            buildUI();
            jpgEncode = new JPGEncoder();
            conn = new LocalConnection();
            conn.client = this;
            try {
                conn.connect("myConnection");
            } catch (error:ArgumentError) {
                trace("Can't connect...the connection name is already being used by another SWF");
            }
        }
        
        public function lcHandler(msg:String):void {
            output.appendText(msg + "\n");
        }
		
		public function getBitmapdata(bit:ByteArray):void 
		{
			bitmap.bitmapData =jpgEncode.decode(bit);
		}
        
        private function buildUI():void {
            output = new TextField();
            output.background = true;
            output.border = true;
            output.wordWrap = true;
            addChild(output);
			
			bitmap = new Bitmap();
			bitmap.y = 110;
			addChild(bitmap);
			
        }
    }
}