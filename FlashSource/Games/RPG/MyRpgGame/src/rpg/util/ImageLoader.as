/*
 * author: 白连忱
 * email: blianchen@163.com
 * vision: v0.1
 */

package rpg.util
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLRequest;
	
	public class ImageLoader extends EventDispatcher
	{
		private static const IMAGE_NUM:int = 1024;			//图片的最大数量
		private static const IMAGE_PATH:String = "res/";	//文件夹
		
		private static var loadedImage:Array;	//存放已经载入的图片（BitmapData）,索引=图片id


		private var imageId:int;				//图片id
//		private var dispatchTarget:*;			//调用此类的对象；图片载入完成后发送事件给此对象
		private var loader:Loader;
		
		private var imgArray:Array;
		
		public function ImageLoader(imgArray:Array)
		{
			this.imgArray = imgArray;
			
			//如果loadedImage不存在，则创建
			if (loadedImage == null || loadedImage.length < IMAGE_NUM)
			{
				loadedImage = new Array(IMAGE_NUM);
			}
		}
		
		/**
		 * 载入图片，在载入完成后发送给调用对象一个事件通知
		 * @parm imageId 图片id
		 */
		public function loadSyn(imageId:int):void
		{
			if (imageId > IMAGE_NUM)
			{
				return; //error
			}

			this.imageId = imageId;
			
			if (loadedImage[imageId] == null)	//如果图片还没有载入
			{
//				trace("id"+imageId);
				var url:String = IMAGE_PATH + this.imgArray[imageId];
//				trace("url"+url);
				loader = new Loader();
				loader.load(new URLRequest(url));
				
				//监视载入完成事件
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteSyn);
			}
		}
		
		/**
		 * 处理COMPLETE事件的函数
		 */
		private function onCompleteSyn(e:Event):void
		{
			//var loader:Loader = Loader(e.target.loader);
			var image:Bitmap = Bitmap(this.loader.content);
			var bitmapData:BitmapData = image.bitmapData;
			
			//将图像数据存入静态数组loadedImage，索引=类型
			loadedImage[this.imageId] = bitmapData;

			//产生图像载入完成事件
			this.dispatchEvent(new ImageLoadEvent(ImageLoadEvent.LOAD_IMAGE_COMPLETED));
		}
		
		/**
		 * 根据图片id返回图像数据
		 */
		public function getImageData(imageId:int):BitmapData
		{
			return loadedImage[imageId];
		}
		
//		public function getLoadedImage():Array
//		{
//			return loadedImage;
//		}

		/**
		 * 载入图片，并直接返回一个DisplayObject
		 */
		public function loadAsy(imageId:int):*
		{
			this.imageId = imageId;

			if (loadedImage[imageId] == null)	//如果图片还没有载入
			{
				var url:String = IMAGE_PATH + this.imgArray[imageId];
				this.loader = new Loader();
				this.loader.load(new URLRequest(url));
				
				//监视载入完成事件
				this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteAsy);
				
				return this.loader;
			} else {
				return new Bitmap(loadedImage[imageId]);
			}
		}

		/**
		 * 处理COMPLETE事件的函数
		 */
		private function onCompleteAsy(e:Event):void
		{
			if (imageId > IMAGE_NUM)
			{
				return; //error
			}
			
			var image:Bitmap = Bitmap(this.loader.content);
			var bitmapData:BitmapData = image.bitmapData;
			
			//将图像数据存入静态数组loadedImage，索引=类型
			loadedImage[this.imageId] = bitmapData;
		}
	}
}