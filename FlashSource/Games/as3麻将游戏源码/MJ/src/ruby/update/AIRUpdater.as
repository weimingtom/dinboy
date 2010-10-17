package ruby.update
{
	
	import flash.desktop.Updater;
	import flash.display.*;
	import flash.errors.IllegalOperationError;
	import flash.events.*;
	import flash.filesystem.*;
	import flash.net.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import flash.xml.*;
	
	import mx.controls.Alert;
	import mx.core.UIComponent;
	import mx.events.CloseEvent; 
	
	
	public class AIRUpdater extends UIComponent
	{
		public var version:String;  
		private var updataRequest:URLRequest;   
		private var updataRequest2:URLRequest;
		
		private var updataLoader:URLLoader=new URLLoader();  
		private var updataLoader2:URLLoader = new URLLoader();
		 
		private var newVersion:String;   
		private var airURLString:String;   
		private var urlReq:URLRequest;   
		private var urlStream:URLStream;   
		private var fileData:ByteArray;   
		private var baseSprite:Sprite=new Sprite();   
		private var tipText:TextField=new TextField();  
		private var downText:TextField = new TextField();
		private var setfont:TextFormat = new TextFormat();
		
		private var timeload1:Date;
		private var timeload2:Date;
		private var temploadtime:Number  = 0;
		private var temploadtimeHM1:Number  = 0;
		private var temploadtimeM1:Number = 0;
		private var temploadtimeHM2:Number  = 0;
		private var temploadtimeM2:Number = 0;
		private var time:int = 0;
		public function AIRUpdater()
		{
//			baseSprite.graphics.beginFill(0X666565,0.95);    
//			baseSprite.graphics.lineStyle(2,0X333333,0);   
//			baseSprite.graphics.drawRoundRect(0,0,363,167,10);     
//			baseSprite.graphics.endFill();   
//			baseSprite.y = 1024;
			/*add base*/  
//			setfont.size = 18;
//			setfont.bold = false;
//			tipText.width=300;   
//			tipText.height=30;   
//			tipText.x=tipText.y=-50;   
//			tipText.autoSize="center";    
//			tipText.textColor=0xFFFF00;   
//			tipText.text="正在下载新版本，请等候！\n \n Update Loading ! Please Wait !";  
//			tipText.setTextFormat(setfont);
//			baseSprite.addChild(tipText);   
//			downText.width = 50;
//			downText.height = 30;
//			downText.x = 140;
//			downText.y = 40;	
//			downText.textColor=0xFFFF00;  
//			downText.text = "0%";
//			downText.setTextFormat(setfont);   
//			baseSprite.addChild(downText);   	 
		}   
		 
		public function updateMyApp(updataURL:String):void 
		{   
			Logger.debug("updataURL :"+updataURL)
			updataRequest = new URLRequest(updataURL); 

			updataLoader.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);   
			updataLoader.addEventListener(Event.COMPLETE,loaderCompleteHandler);  
			updataLoader.load(updataRequest);   
		}   
		 
		public	function loaderCompleteHandler(event:Event):void 
		{ 
//			updataLoader2.removeEventListener(Event.COMPLETE,loaderCompleteHandler2)
			Logger.debug("进入下载点--A--")
			try 
			{   
				var result:XML=new XML(updataLoader.data);   
				if (version != result.version)
				{   
		//			Login.instance.myLoading.gotoAndStop(2);
		//			Login.instance.myLoading.m_loaded.text = "";
		//			Login.instance.myLoading.m_loaded.visible = true;
					newVersion=result.version;   
					
					if(Param.newURL =="1")
					{
						airURLString = result.lastpublic1
					}
					if(Param.newURL == "2")
					{
						airURLString = result.lastpublic2
					}
					if(Param.newURL == "3")
					{
						airURLString = result.lastpublic3
					}
					
//					airURLString=result.lastpublic; 
//					airURLString=  Param.ROOT_URL + "THEightNine.air"
					Logger.debug("***下载点地址*** ："+airURLString);
					Logger.debug("有新的更新"); 
					  
	//				Logger.debug("baseSprite :"+baseSprite+" stage :"+this.stage+" EightNineStage:"+EightNine.instance);
					
					
					addChild(baseSprite);   

//					baseSprite.x=(stage.stageWidth-baseSprite.width)/2;   
//					baseSprite.y=(stage.stageHeight-baseSprite.height)/2+ 55;   

	//				baseSprite.x=(EightNine.instance.width-baseSprite.width)/2;   
	//				baseSprite.y=(EightNine.instance.height-baseSprite.height)/2+ 55;   

					updateBtHandler();
					
				}
				else
				{
				//	EightNine.instance.startPlay();
				}   
			} 
			catch (e:TypeError) //更新配置文件有誤，請重試
			{   
				
				Logger.debug(e.getStackTrace());
				Logger.debug(e.toString()+" "+e.message);
				Logger.debug("Updata Application Error:Could not parse the XML file.");
				Alert.show("The network is busy, please try again","Updata Error",4,null,quit);    
				

			}   
		}
		
		
//		public	function loaderCompleteHandler2(event:Event):void 
//		{ 
//			
//			updataLoader.removeEventListener(Event.COMPLETE,loaderCompleteHandler)
//			Logger.debug("进入下载点--B--")
//			try 
//			{   
//				var result:XML=new XML(updataLoader2.data);   
//				if (version != result.version)
//				{   
//					newVersion=result.version;   
//					airURLString=result.lastpublic;   
//					//Logger.debug("马上更新到最新版吗？" + "有新的更新"); 
//					  
//					addChild(baseSprite);   
//					baseSprite.x=(stage.stageWidth-baseSprite.width)/2;   
//					baseSprite.y=(stage.stageHeight-baseSprite.height)/2+ 55;   
//					
//					updateBtHandler(); 
//				}
//				else
//				{
//					EightNine.instance.startPlay();
//				}   
//			} 
//			catch (e:TypeError) //更新配置文件有誤，請重試
//			{   
//				//Logger.debug("Updata Application Error:Could not parse the XML file.");
//				Alert.show("The network is busy, please try again","Updata Error",4,null,quit);    
//			}   
//		}
		
		   
		 
		private function errorHandler(e:IOErrorEvent):void //網絡有誤，請重試
		{   
			Logger.debug("2")
			//Logger.debug("Updata Application Error:Had problem loading the XML File.");
//			Alert.show("The network is busy, please try again","Updata Error",4,null,quit);
			time++;
			trace(time+"@!@!@!@!@")
			if(time>=2){
					Alert.show("The network is busy, please try again","Updata Error",4,null,quit);    
			}else{
				Param.newURL = "3"
				updateMyApp("http://www1.ruby1688.com/download/eightNineUpdate.xml")
				
			}
			 
		}   
		  
		private function updateBtHandler():void 
		{   
			urlReq=new URLRequest(airURLString);   
			urlStream=new URLStream();   
			fileData=new ByteArray();   
			urlStream.addEventListener(Event.COMPLETE,loaded);   
			urlStream.addEventListener(ProgressEvent.PROGRESS,onProgress);   
			urlStream.addEventListener(IOErrorEvent.IO_ERROR,eehandler);
			urlStream.load(urlReq);   
		}   
		
		public function eehandler(eve:ErrorEvent):void//找不到更新程序，請重試
		{
			Logger.debug("3")
   			Alert.show("The network is busy, please try again","Update Error",4,null,quit);
		}

		private function onProgress(evt:ProgressEvent):void
		{
			var downNum:int = evt.bytesLoaded / evt.bytesTotal * 100;
			downText.text = downNum + "%";
//			downText.setTextFormat(setfont); 
//			Login.instance.myLoading.m_loaded.text = downNum + "%";
		}
		
		private function removeBtHandler(event:MouseEvent):void 
		{   
			removeChild(baseSprite);   
		}   
		
		private function loaded(event:Event):void
		{   
			urlStream.readBytes(fileData,0,urlStream.bytesAvailable);   
			writeAirFile();   
		}   
		
		private function writeAirFile():void 
		{   
			var file:File=File.documentsDirectory.resolvePath("newRubyTWMJ.air");   
			var fileStream:FileStream=new FileStream();   
			fileStream.addEventListener(Event.CLOSE,fileClosed);   
			fileStream.openAsync(file,FileMode.WRITE);   
			fileStream.writeBytes(fileData,0,fileData.length);   
			fileStream.close();   
		} 
		  
		private function fileClosed(event:Event):void 
		{   
			//Logger.debug("The AIR file is written.");   
			var updater:Updater=new Updater();   
	
			var airFile:File=File.documentsDirectory.resolvePath("newRubyTWMJ.air");   
			try
			{
				updater.update(airFile,newVersion); 
			}
			catch(e:IllegalOperationError) 
			{
               // Logger.debug(e);不能在調試環境下運行
                Alert.show("This environment is error","Updata Error",4,null,quit);
            }
		}   
		private function quit(evt:CloseEvent):void//关闭
		{
			this.stage.nativeWindow.close();
		}
	}
}