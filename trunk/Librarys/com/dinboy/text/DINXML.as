package com.dinboy.text {

	/**
	 * ...
   * @author 钉崽 [DinBoy]
	 */
	public class DINXML {

		public function DINXML(){
				trace("本帅不需要实例化~");
		}


		/**
		 * 进行XMLList排序
		 * @param	$XmlList	需要排序的XMLLIST
		 * @param	$id		需要
		 * @param	way
		 * @return
		 */
		public static function idSort($XmlList:XMLList, $id:String, way:int = 1):XMLList
			{
			var $xmlArray:Array = new Array();
			var $subXml:XML;
			for each ($subXml in $XmlList){
				$xmlArray.push({id: $subXml.@[$id], data: $subXml});
			}
			for (var i:int = 0; i < $xmlArray.length; i++) {
				for (var j:int = 0; j < $xmlArray.length - i - 1; j++) {
						if (int($xmlArray[j].id) > int($xmlArray[j + 1].id)) {
								var $oldXML:XML = $xmlArray[j].data.copy();
								var $oldID:String = $xmlArray[j].id;
									$xmlArray[j].id = $xmlArray[j + 1].id;
									$xmlArray[j + 1].id = $oldID;
									$xmlArray[j].data = $xmlArray[j + 1].data.copy();
									$xmlArray[j + 1].data = $oldXML.copy();
						}
					}
				}
				var k:int;
				if (way == 1){
						for (k = 0; k < $xmlArray.length; k++){
						$XmlList[k] = $xmlArray[k].data.copy();
						}
				}
				if (way == 2) {
					var m:int = 0;
					for (k = $xmlArray.length - 1; k >= 0; k--) {
						$XmlList[m++] = $xmlArray[k].data.copy();
					}
				}
			return $XmlList;
			}
			
			
			/********* Class The End ****************/
			}
}