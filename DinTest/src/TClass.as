package {
  import flash.display.*;
  import flash.text.*;
  public class TClass extends  MovieClip{		
    public function TClass() {
      var tf:TextFormat = new TextFormat();
      tf.size = 20;
      tf.font = "宋体";
      var tt:TextField = new TextField();
      tt.defaultTextFormat = tf;
      tt.text = "我xxx";
      tt.x = 200;
      tt.y = 200;
      addChild(tt);
      trace(tt.x);
    }
  }
}