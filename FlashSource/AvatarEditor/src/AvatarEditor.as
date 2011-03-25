package  
{

	import events.SnapEvent;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import ui.EditWindow;
	import ui.IButton;
	import ui.PrevWindow;

	/**
	 * @author		钉崽[Dinboy]
	 * @copy		2010 © dinboy.com
	 * @version		v1.0 [2011-3-4 17:27]
	 */
	public class AvatarEditor extends Sprite
	{
		/**
		 * 头像编辑窗口
		 */
		private var _editWindow:EditWindow;
		
		/**
		 * 小的预览窗口
		 */
		private var _smallPrevWindow:PrevWindow;
		
		/**
		 * 大的预览窗口
		 */
		private var _bigPrevWindow:PrevWindow;
		
		/**
		 * 小的按钮,浏览文件用
		 */
		private var _smallButton:IButton;
		
		/**
		 * 大的按钮,生成头像用
		 */
		private var _bigButton:IButton;
		
		/**
		 * 选择文件
		 */
		private var _loadFile:FileReference;
		
		/**
		 * 图片加载器
		 */
		private var _bitmapLoader:Loader;
		
		public function AvatarEditor() 
		{
			setupUI();
			setupEventListener();
			
			
		}
		
		/**
		 * 设置UI
		 */
		private function setupUI():void 
		{
			//编辑窗口
			_editWindow = new EditWindow(null, 258, 284, 160, 160);
			_editWindow.x = 27;
			_editWindow.y = 66;
			addChild(_editWindow);
			
			_smallPrevWindow = new PrevWindow(50, 50);
			_smallPrevWindow.x = 306;
			_smallPrevWindow.y = 66;
			addChild(_smallPrevWindow);
			
			_bigPrevWindow = new PrevWindow(140, 140);
			_bigPrevWindow.x = 306;
			_bigPrevWindow.y = 189;
			addChild(_bigPrevWindow);
			
			_smallButton = smallButton;
			_bigButton = bigButton;
			
			_loadFile = new FileReference();
			
			_bitmapLoader = new Loader();
			
		}
		
		/**
		 * 添加事件侦听器
		 */
		private function setupEventListener():void 
		{
			_editWindow.addEventListener(SnapEvent.SNAPED, editWindowSnapHandler, false, 0, true);
			
			_smallButton.addEventListener(MouseEvent.CLICK, smallButtonClickHandler, false, 0, true);
			_bigButton.addEventListener(MouseEvent.CLICK, bigButtonClickHandler, false, 0, true);
			
			_loadFile.addEventListener(Event.SELECT, loadFileSelectHandler, false, 0, true);
			_loadFile.addEventListener(Event.COMPLETE, loadFileCompleteHandler, false, 0, true);
			
			_bitmapLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, bitmapLoaderCompleteHandler, false, 0, true);
		}


		/**
		 * 小按钮点击
		 * @param	event
		 */
		private function smallButtonClickHandler(event:MouseEvent):void 
		{
			_loadFile.browse([new FileFilter("图片文件(*.jpg;*.gif,*.png,*.jpeg)","*.jpg;*.gif,*.png,*.jpeg")])
			
		}
		
		/**
		 * 大按钮点击
		 * @param	e
		 */
		private function bigButtonClickHandler(event:MouseEvent):void 
		{
			
		}
		
		/**
		 * 当文件被选择时调度
		 * @param	event
		 */
		private function loadFileSelectHandler(event:Event):void 
		{
			_loadFile.load();
		}
		
		private function loadFileCompleteHandler(event:Event):void 
		{
			var _byteArray:ByteArray = event.currentTarget.data;
					_bitmapLoader.loadBytes(_byteArray);
		}
		
		/**
		 * 图片加载器加载完成时调度
		 * @param	event
		 */
		private function bitmapLoaderCompleteHandler(event:Event):void 
		{
			_editWindow.source = Bitmap(event.currentTarget.content).bitmapData;
			editWindowSnapHandler(null);
		}
		
				
		/**
		 * 编辑窗口更新时调度
		 * @param	event
		 */
		private function editWindowSnapHandler(event:SnapEvent):void 
		{
			_smallPrevWindow.source = _editWindow.snapSource;
			_bigPrevWindow.source = _editWindow.snapSource;
		}




	//============================================
	//===== Class[AvatarEditor] Has Finish ======
	//============================================
	}

}