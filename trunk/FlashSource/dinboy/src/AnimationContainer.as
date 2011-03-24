package  
{
	import com.dinboy.ui.Follower;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	

	/**
	 * @author		钉崽[Dinboy]
	 * @copy		2010 © dinboy.com
	 * @version		v1.0 [2011-3-24 15:13]
	 */
	public class AnimationContainer extends Sprite
	{
		
		[Embed(source='../lib/dinboy_head.png')]
		private var DINBOY_HEAD:Class;
		private var _dinboyHead:Follower;
		
		[Embed(source = '../lib/dinboy_hand_right.png')]
		private var DINBOY_HAND_RIGHT:Class;
		private var _dinboyHandRight:Follower;
		
		[Embed(source = '../lib/dinboy_hand_left.png')]
		private var DINBOY_HAND_LEFT:Class;
		private var _dinboyHandLeft:Follower;
		
		[Embed(source = '../lib/dinboy_face.png')]
		private var DINBOY_FACE:Class;
		private var _dinboyFcae:Follower;
		
		[Embed(source = '../lib/dinboy_body.png')]
		private var DINBOY_BODY:Class;
		private var _dinboyBody:Follower;
		
		/**
		 * 舞台
		 */
		private var _stage:Stage;
		
		public function AnimationContainer(_stage:DisplayObject) 
		{
				if (_stage == null) return;
				else {
					if (!(_stage is Stage)) this._stage = _stage.stage;
					else this._stage = _stage as Stage;
				}
				setupUI();
				setupEventListener();
		}
		
		
		/**
		 * 配置UI对象
		 */
		private function setupUI():void 
		{
				_dinboyHead = new Follower(new DINBOY_HEAD());
				_dinboyFcae = new Follower(new DINBOY_FACE());
				_dinboyBody = new Follower(new DINBOY_BODY());
				_dinboyHandLeft = new Follower(new DINBOY_HAND_LEFT());
				_dinboyHandRight = new Follower(new DINBOY_HAND_RIGHT());

				_dinboyHead.friction = _dinboyHead.friction - 0.1
				_dinboyFcae.friction = _dinboyFcae.friction - 0.075;
				_dinboyBody.friction = _dinboyBody.friction - 0.05;
				_dinboyHandLeft.friction = _dinboyHandLeft.friction - 0.025;
				_dinboyHandRight.friction = _dinboyHandRight.friction - 0.025;
				
				addChild(_dinboyHead);
				addChild(_dinboyFcae);
				addChild(_dinboyBody);
				addChild(_dinboyHandLeft);
				addChild(_dinboyHandRight);
		}
		
		/**
		 * 配置事件侦听
		 */
		private function setupEventListener():void 
		{
			_stage.addEventListener(Event.ENTER_FRAME, stageEnterFrameHandler, false, 0, true);
		}
		
		/**
		 * 实时监听舞台
		 * @param	event
		 */
		private function stageEnterFrameHandler(event:Event):void 
		{
			_dinboyBody.following(_stage.mouseX-_dinboyBody.width/2, _stage.mouseY+52);
			_dinboyFcae.following(_stage.mouseX-_dinboyFcae.width/2, _stage.mouseY+36);
			_dinboyHandLeft.following(_stage.mouseX-31, _stage.mouseY+68);
			_dinboyHandRight.following(_stage.mouseX+22, _stage.mouseY+68);
			_dinboyHead.following(_stage.mouseX-_dinboyHead.width/2, _stage.mouseY);
		}






	//============================================
	//===== Class[AnimationContainer] Has Finish ======
	//============================================
	}

}