package com.dinboy.net.resource 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.LoaderInfo; 
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author 钉崽 [dinboy]
	 */
	public class Resource extends Object 
	{
		/**
		 * 资源的属性
		 */
		public var type:String;
		
		/**
		 * 资源的加载地址
		 */
        public var url:String;
		
		/**
		 * 资源的数据
		 */
        public var data:Object;
		
		/**
		 * 资源的加载器信息
		 */
        public var loaderInfo:LoaderInfo;
		
		public function Resource() 
		{
			
		}
		
		/**
		 * 摧毁资源
		 */
		public function destroy():void 
		{
			/**
			 * 资源的父级容器
			 */
			var _parent:DisplayObjectContainer = null;
			
			if (data is DisplayObject) 
			{
				_parent = DisplayObject(data).parent;
				
				if (_parent is Loader) 
				{
					if (Loader(_parent).hasOwnProperty("unloadAndStop")) 
					{
						var _cloneParent:* = Loader(_parent) ;
							_cloneParent.Loader(_parent)["unloadAndStop"]();
					}else 
					{
						Loader(_parent).unload();
					}
				}
			}
			
			if (data is MovieClip) 
			{
				if ( !(_parent is Loader)) 
				{
					_parent.removeChild(MovieClip(data))
				}
			}else if(data is Bitmap)
			{
				Bitmap(data).bitmapData.dispose();
				Bitmap(data).bitmapData = null;
			}
			
			url = undefined;
			type = undefined;
			data = null;
			
			/**
			 * 这里是否要注销?
			 */
			_parent = null;
		}
		
	}

}