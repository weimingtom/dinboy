package  
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @data $_DATA
	 * @author Dinboy.com
	 */
	public class XMLExample extends Sprite
	{
		private var $XML:XML=<data>
	<!-- 家族 -->
	<family>
		<!-- name:家族的姓 where:家族所在地 -->
		<name>某</name>
		<where>福建厦门</where>
	</family>

	<!-- 柱子上的对联 -->
	<couplet>
		<!-- left:左边的文字  right:右边的文字-->
		<left>丁兰刻木思亲孝</left>
		<right>孟母断机教子贤</right>
	</couplet>

	<!-- 牌位 -->
	<tablets>
	    <!-- priority:摆放的优先等级(数字越小等级越高) muid:墓地号 mtid:纪念馆号 age:世(某氏一世,某世二世)-->
		<item  priority="0"  muid="123456"  mtid="123456"  age="一"  gene="神" >某公 某某某</item>
		<item  priority="1"  muid="123456"  mtid="123456"  age="一"  gene="神" >某公 某某某</item>
		<item  priority="2"  muid="123456"  mtid="123456"  age="一"  gene="神" >某公 某某某</item>
		<item  priority="3"  muid="123456"  mtid="123456"  age="一"  gene="神" >某公 某某某</item>
		<item  priority="4"  muid="123456"  mtid="123456"  age="一"  gene="神" >某公 某某某</item>
	</tablets>
</data>;
		
		public function XMLExample() 
		{
			for (var i:int = 0; i < this.$XML.tablets.item.length(); i++) 
			{
				var $attr:XMLList = this.$XML.tablets.item[i].attributes();
				//for (var j:int = 0; j < $attr.length() ; j++) 
				//{
				//	trace( this.$XML.tablets.item[i].attributes()[j].name());	
					//trace( $attr["age"]);	
				//}
				for each (var $item:XML in $attr) 
				{
					trace($item.name());
				}
				
			}
		
		}
		
		
		
		/********** [DINBOY] Say: Class The End  ************/	
	}

}