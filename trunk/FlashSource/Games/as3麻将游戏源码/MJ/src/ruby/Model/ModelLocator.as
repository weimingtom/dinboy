package ruby.Model
{
	import flash.events.EventDispatcher;

    [Bindable]
	public class ModelLocator extends EventDispatcher
	{
		private static var _instance:ModelLocator;
		public var m_userName:String;
		public var m_userPwd:String;
		
		public var m_ID:int;////自家风位
		public var m_pai:Array;////自家玩家的牌
		public var m_szs:Array;////骰子点数
		
		public var m_js:String;/////局数
		public var m_qs:String;/////圈数
	    public var m_money:Array=new Array(4);/////四个玩家余额
		
		public var m_Zbank:Array=new Array(4);////坐庄情况  ////四个元素 
		public var m_bu:Array; ////补花信息	二维，[0]：要补的牌，[1]：花牌信息
		public var m_lbc:int; ////连庄数
		public var m_jh:String;///////将号 
		public var m_juhao:String; //////一将中的第几局
		public var m_begin:Boolean;////是否第一次开局
		
		public var m_bu1:Array;    //////下玩家的花牌
		public var m_bu2:Array;    /////对家玩家的花牌
		public var m_bu3:Array;    //////上家玩家的花牌
		public var m_hand:int;		// 当前操作的玩家
		public var m_utw:int;	//玩家输赢
		public var m_isDelay:Boolean;
		public var m_again:Array=new Array(4);
		
		public var SFS_URL:String;
		public var _PORT:int;
		
		public static function getInstance():ModelLocator
		{
			if(_instance==null)
				_instance=new ModelLocator();
			return _instance;	
		}
	}
}