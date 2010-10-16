package  
{
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.events.NetStatusEvent;
    import flash.net.SharedObject;
    import flash.net.SharedObjectFlushStatus;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFieldType;
		
	/**
	 * @copy     版权所有 © 2010
	 * @author  钉崽 - [dinboy.Com]
	 	*/
	public class SharedObjectExample extends Sprite
	{
		
		private var mySo:SharedObject;
        
        public function SharedObjectExample() {
            buildUI();
            saveBtn.addEventListener(MouseEvent.CLICK, saveValue);
            clearBtn.addEventListener(MouseEvent.CLICK, clearValue);
            readBtn.addEventListener(MouseEvent.CLICK, readValue);
            
            mySo = SharedObject.getLocal(this.name);
            output.appendText("SharedObject loaded...\n");
            output.appendText("loaded value: " + mySo.data.savedValue + "\n\n");
        }

         private function saveValue(event:MouseEvent):void {
            output.appendText("saving value...\n");
            mySo.data.savedValue = input.text;
            
            var flushStatus:String = null;
            try {
                flushStatus = mySo.flush(10000);
            } catch (error:Error) {
                output.appendText("Error...Could not write SharedObject to disk\n");
            }
            if (flushStatus != null) {
                switch (flushStatus) {
                    case SharedObjectFlushStatus.PENDING:
                        output.appendText("Requesting permission to save object...\n");
                        mySo.addEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
                        break;
                    case SharedObjectFlushStatus.FLUSHED:
                        output.appendText("Value flushed to disk.\n");
                        break;
                }
            }
            output.appendText("\n");
        }
        
        private function clearValue(event:MouseEvent):void {
            output.appendText("Cleared saved value...Reload SWF and the value should be \"undefined\".\n\n");
            delete mySo.data.savedValue;
        }        
		
		private function readValue(event:MouseEvent):void {
			//output.text = "";
            output.text=(mySo.data.savedValue);
        //    delete mySo.data.savedValue;
        }
        
        private function onFlushStatus(event:NetStatusEvent):void {
            output.appendText("User closed permission dialog...\n");
            switch (event.info.code) {
                case "SharedObject.Flush.Success":
                    output.appendText("User granted permission -- value saved.\n");
                    break;
                case "SharedObject.Flush.Failed":
                    output.appendText("User denied permission -- value not saved.\n");
                    break;
            }
            output.appendText("\n");

            mySo.removeEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
        }
        
        // UI elements
        private var inputLbl:TextField;
        private var input:TextField;
        private var output:TextField;
        private var saveBtn:Sprite;
        private var clearBtn:Sprite;
		private var readBtn:Sprite;
        private function buildUI():void {
            // input label
            inputLbl = new TextField();
            addChild(inputLbl);
            inputLbl.x = 10;
            inputLbl.y = 10;
            inputLbl.text = "Value to save:";
            
            // input TextField
            input = new TextField();
            addChild(input);
            input.x = 80;
            input.y = 10;
            input.width = 100;
            input.height = 20;
            input.border = true;
            input.background = true;
            input.type = TextFieldType.INPUT;
            
            // output TextField
            output = new TextField();
            addChild(output);
            output.x = 10;
            output.y = 35;
            output.width = 250;
            output.height = 250;
            output.multiline = true;
            output.wordWrap = true;
            output.border = true;
            output.background = true;
            
            // Save button
            saveBtn = new Sprite();
            addChild(saveBtn);
            saveBtn.x = 190;
            saveBtn.y = 10;
            saveBtn.useHandCursor = true;
            saveBtn.graphics.lineStyle(1);
            saveBtn.graphics.beginFill(0xcccccc);
            saveBtn.graphics.drawRoundRect(0, 0, 30, 20, 5, 5);
            var saveLbl:TextField = new TextField();
            saveBtn.addChild(saveLbl);
            saveLbl.text = "Save";
            saveLbl.selectable = false;
            
            // Clear button
            clearBtn = new Sprite();
            addChild(clearBtn);
            clearBtn.x = 230;
            clearBtn.y = 10;
            clearBtn.useHandCursor = true;
            clearBtn.graphics.lineStyle(1);
            clearBtn.graphics.beginFill(0xcccccc);
            clearBtn.graphics.drawRoundRect(0, 0, 30, 20, 5, 5);
            var clearLbl:TextField = new TextField();
            clearBtn.addChild(clearLbl);
            clearLbl.text = "Clear";
            clearLbl.selectable = false;
			
			// Read button
            readBtn = new Sprite();
            addChild(readBtn);
            readBtn.x = 270;
            readBtn.y = 10;
            readBtn.useHandCursor = true;
            readBtn.graphics.lineStyle(1);
            readBtn.graphics.beginFill(0xcccccc);
            readBtn.graphics.drawRoundRect(0, 0, 30, 20, 5, 5);
            var readLbl:TextField = new TextField();
            readBtn.addChild(readLbl);
            readLbl.text = "Read";
            readLbl.selectable = false;
			
        }

	/*************** Class The End ****************/
	}

}