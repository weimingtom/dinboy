/**
*存放一些公共的参数 
* @author weni 
**/
package ruby.update
{	
//	import com.ruby888.game.vos.RoomTypeVO;
//	import com.ruby888.game.vos.UserVO;
	
	import flash.desktop.NativeApplication;
	import flash.display.Stage;
	
	public class Param
	{
		public static var stage:Stage;

	 	/**
	 	 *获取版本号 
	 	 * @return 
	 	 */	 	
	 	public static function get appVersion():String
	 	{
	 		var appXml:XML = NativeApplication.nativeApplication.applicationDescriptor; 
			var ns:Namespace = appXml.namespace(); 
			var myVersion:String = appXml.ns::version[0];
			
		//	Logger.debug("appVersion="+myVersion);
			return myVersion;
			
	 	}
	 	
	 	/**
	 	 *获取App filename 
	 	 * @return 
	 	 * 
	 	 */	 	
	 	public static function get appFileName():String
	 	{
	 		var appXml:XML = NativeApplication.nativeApplication.applicationDescriptor; 
			var ns:Namespace = appXml.namespace(); 
			var myFileName:String = appXml.ns::filename[0];
	//		Logger.debug("fileName="+myFileName);
			return myFileName;
	 	}
	 	public static const PLAYER:int = 4;//玩家人数
	 	public static const COUNTS:int = 8;//一将局数
	 	
	 	public static var blackVolue:Number;//音量
	 	
	 	public static var roomProperties:Array = [];
//	 	public static var currentRoomType:RoomTypeVO //= new RoomTypeVO();
//	 	public static var me:UserVO;
	 	public static var tol:Array;
	 	public static var netState:String;
	 	
	 	public static var betMoney:int;    //大厅传来的VIP房主下注金额
	 	public static var roomID:int;      //大厅传来的普通桌房间
	 	public static var roomPass:String;  //大厅传来的VIP房间密码；
	 	
	 	public static var newURL:String = "1";
 		public static var ROOT_URL:String = "http://www.ruby1688.com/download/";
		public static var UPDATE_XML:String = "newRubyTWMJ.xml";
		public static var INSTAL_FILE:String = "newRubyTWMJ.air";
		public static var LOBBY_XML:String = "THRubyLobby.xml";
	 	
		public static var appID:String = "THRubyLobby"; 
		public static var pubID:String = "07C75FBA89E79D51C5D875A5D7F8D3C9F32A5151.1"; 


		public static var SFS_URL:String = "eightnine.sfsruby.com";
		public static var SFS_PORT:int = 9560;
	
	}
}