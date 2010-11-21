/*
 * author: 白连忱
 * email: blianchen@163.com
 * vision: v0.1
 */

package rpg.util
{
	import flash.events.Event;

	public class ImageLoadEvent extends Event
	{
		//图片载入完成事件
		public static const LOAD_IMAGE_COMPLETED:String = "load_image_completed";
		
		public function ImageLoadEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}