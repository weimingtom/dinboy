package com.kerry.page {
	/**
	 * PageSwitch 分页处理类的封装
	 * @author PhoenixKerry（http://blog.sina.com.cn/yyy98）
	 * @version 0.1
	 */
	public class PageSwitch {
		private var viewList:Array;
		private var _listNum:uint;
		private var _data:Array;
		private var _currentPage:uint;
		private var showCallBack:Function;
		
		/**
		 * 构造分页处理类
		 * @param	_data 分页数据
		 * @param	_listNum 每页显示数量
		 * @param	_showCallBack 显示数据回调函数，该函数用于补足显示逻辑
		 */
		public function PageSwitch(_data:Array, _listNum:uint, _showCallBack:Function) {
			this._data = _data;
			this._listNum = _listNum;
			this.showCallBack = _showCallBack;
			
			generateViewList();
		}
		
		/**
		 * @private 生成显示数据数组
		 */
		private function generateViewList():void {
			viewList = new Array();
			for (var i:uint = 0; i < _data.length; i++ ) {
				if (i % _listNum == 0) {
					var subAry:Array = new Array();
					viewList.push(subAry);
				}
				subAry.push(_data[i]);
			}
		}
		
		/**
		 * 获得数据
		 */
		public function get data():Array { 
			return _data;
		}
		
		/**
		 * 设置数据
		 */
		public function set data(value:Array):void {
			_data = value;
			generateViewList();
		}
		
		/**
		 * 获得每页显示数量
		 */
		public function get listNum():uint { 
			return _listNum;
		}
		
		/**
		 * 设置每页显示数量
		 */
		public function set listNum(value:uint):void {
			_listNum = value;
			generateViewList();
		}
		
		/**
		 * 获得当前页页码
		 */
		public function get currentPage():uint {
			if (_currentPage > maxPage) {
				return maxPage;
			} else if (_currentPage < 1) {
				return 1;
			}
			return _currentPage;
		}
		
		/**
		 * 设置当前显示页
		 */
		public function set currentPage(value:uint):void {
			if (value > maxPage) {
				value = maxPage;
			} else if (value < 1) {
				value = 1;
			}
			_currentPage = value;
			showCallBack(viewList[_currentPage -1]);
		}
		
		/**
		 * 获得最大页码
		 */
		public function get maxPage():uint {
			return viewList.length;
		}
		
	}
}