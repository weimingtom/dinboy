package ruby.Event
{
	import mx.messaging.channels.StreamingHTTPChannel;
	
	public class EventCMD
	{
		public static const LOGIN:String="login";
		public static const ConfigTable:String="configTable";
		public static const ConfigPai:String="configpai";
		public static const questPai:String="questPai";////要求要牌
		public static const GetUserMessage:String="GetUserMessage";
		public static const InitStage:String="InitStage";/////初始化场景
		public static const Begin:String="Begin";
		
		/**自家操作**/
		public static const OutPai:String="OutPai";
		public static const CHI:String="chi";
		public static const PEN:String="pen";
		public static const GANG:String="gang";
		public static const Cancel:String="Cancel";
		public static const again:String="again";
		public static const nest:String="nest";
		public static const myEat:String="myEat";
		public static const myPen:String="myPen";
		public static const myGang:String="myGang";
		public static const myCancel:String="myCancel";
		public static const myOut:String="myOut";
		public static const myHandler:String="myHandler";////我应该做的操作
		
		/**别家操作**/
		public static const otherMoPai:String="otherMoPai";	// 摸
		public static const otherOutPai:String="otherOutPai";	// 打牌
		public static const otherCHI:String="otherCHI";	// 吃牌
		public static const otherPEN:String="otherPEN";	// 碰牌
		public static const otherGANG:String="otherGANG";	// 杠牌
		public static const otherBuHua:String="otherBuHua";	// 补牌
		public static const repairFlower:String="repairFlower";
		public static const otherAgain:String="otherAgain";
		public static const MyEye:String="MyEye";
		public static const SysDelay:String="SysDelay";
		
		public static const WinTabel:String="WinTabel";///赢计表
		public static const Eye:String="Eye";
		
		public static const sendMsg:String="sendMessage";
		public static const receiveMsg:String="receiveMsg";
		
		public static const sysKeYsend:String="sysKeYsend";
		public function EventCMD()
		{
		}

	}
}