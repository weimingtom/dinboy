package  
{
	import fl.controls.Button;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.ByteArray;
	
	
	
	
	
		
	/**
	 * @copy     版权所有 © 2010
	 * @author  钉崽 - [dinboy.Com]
	 	*/
	public class amfphpExample extends Sprite
	{
		
		private const  $hostName:String = "http://FL.Services/amfphp/";
		private var  $gatewayUrl:String = $hostName + "gateway.php";
		private var  $bitmapData:BitmapData;
		
		private var $sprite:Sprite=new Sprite();
		
		private var $byteArray:ByteArray=new ByteArray();
		private var $netConnection:NetConnection;
		
		private var $button:Button = new Button();
		
		//private var $button:=new 
		//[Embed(source = "../lib/mj.jpg")]
		//private var MJ:Class;
		
		public function amfphpExample()
		{
			/*
			this.$sprite.graphics.beginFill(0x000000, 1);
			this.$sprite.graphics.drawRect(100,100, 50,50);
			this.$sprite.graphics.endFill();
			*/
			/*
			var $bar:* = new MJ();
			this.$sprite.addChild($bar);
			this.addChild(this.$sprite);
			this.$bitmapData = new BitmapData(this.$sprite.width, this.$sprite.height,false);
			this.$bitmapData.draw(this.$sprite);
			//this.$pngEncoder = new JPGEncoder(100);
			//this.$byteArray = this.$pngEncoder.encode(this.$bitmapData);
			*/
			
	//		this.$byteArray.position = 0;
			this.$netConnection = new NetConnection();
			this.$netConnection.connect(this.$gatewayUrl);
		//	this.$netConnection.client = this;
			this.$button.label = "发送到服务器上去";
			this.$button.move(200, 200);
			this.addChild(this.$button);
			
			this.$button.addEventListener(MouseEvent.CLICK, this.ClickHandle, false, 0, true);
		}
		
		
		private function ClickHandle(e:MouseEvent):void 
		{
	//		this.$byteArray = PNGEncoder.encode(this.$bitmapData);
			
			this.$netConnection.call("Dinboy.DinTest.helloworld", new Responder(this.onResult, this.onFault), "Shit");
		//	this.$netConnection.call("amfphp.SavePic.save", new Responder(onResult, onFault), this.$byteArray);
		}
						
		private function onResult(re:Object):void
			{
			trace(re);
			}
			
		private function onFault(re:Object):void
			{
				for(var i:String in re)
				trace(i+"=>"+re[i]);
			}

	/*************** Class The End ****************/
	}

}