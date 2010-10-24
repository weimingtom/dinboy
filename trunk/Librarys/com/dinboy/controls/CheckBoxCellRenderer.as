package com.dinboy.controls 
{
	import fl.controls.CheckBox;
	import fl.controls.listClasses.ICellRenderer;
	import fl.controls.listClasses.ListData;

	/**
	 * @author		Dinboy
	 * @copy		钉崽 dinboy
	 * @version		v1.0.0 [2010-10-24 2:22]
	 */
	public class CheckBoxCellRenderer extends CheckBox implements ICellRenderer
	{
		private var _listData:ListData;
        private var _data:Object;
		
		public function CheckBoxCellRenderer() 
		{
			
		}
		
		public function set data(d:Object):void {
            _data=d;
            label=d.label;
        }
        public function get data():Object {
            return _data;
        }
        public function set listData(ld:ListData):void {
            _listData=ld;
        }
        public function get listData():ListData {
            return _listData;
        }






	//============================================
	//===== Class[CheckBoxCellRenderer] Has Finish ======
	//============================================
	}

}