package com.dinboy.ui 
{
	import flash.display.Sprite;
	import flash.events.Event;
	

	/**
	 * @author		钉崽[Dinboy]
	 * @copy		2010 © dinboy.com
	 * @version		v1.0 [2011-3-24 14:31]
	 */
	public class FollowerBase extends Sprite implements IFollower
	{
		protected var _vx:Number=0;
		
		protected var _vy:Number=0;
		
		/**
		 * 摩擦力
		 */
		protected var _friction:Number;
		
		/**
		 * 重力
		 */
		protected var _gravity:Number ;
		
		/**
		 * 弹力
		 */
		protected var _spring:Number ;
		
		protected var _dx:Number;
		
		protected var _dy:Number;
		
		protected var _ax:Number;
		
		protected var _ay:Number;
		
		/**
		 * 跟随的基本组件
		 * @param	_ftiction	摩擦力基数
		 * @param	_gravity	重力基数
		 * @param	_spring	弹力基数
		 */
		public function FollowerBase(_ftiction:Number=0.95,_gravity:Number=5,_spring:Number=0.1) 
		{
			super();
			this._friction = _ftiction;
			this._gravity = _gravity;
			this._spring = _spring;
		}
		
		/**
		 * 开始跟随
		 * @param	_dx		跟随的X坐标
		 * @param	_dy		跟随的Y坐标
		 */
		public function following(_dx:Number,_dy:Number):void 
		{
			
						this._dx = _dx-x;
                        this._dy = _dy-y;
                         _ax = this._dx * _spring;
                         _ay = this._dy * _spring;
                         _vx += _ax;
                         _vy += _ay;
                         _vy += _gravity;
                         _vx *= _friction;
                         _vy *= _friction;
						
						 x += _vx;
						 y += _vy;
						 
						 
		}
		
		
		/**
		 * 设置/获取	摩擦力
		 */
		public function get friction():Number 
		{
			return _friction;
		}
		
		public function set friction(value:Number):void 
		{
			_friction = value;
		}
		
		/**
		 * 设置/获取	重力
		 */
		public function get gravity():Number 
		{
			return _gravity;
		}
		
		public function set gravity(value:Number):void 
		{
			_gravity = value;
		}
		
		/**
		 * 设置/获取	弹力
		 */
		public function get spring():Number 
		{
			return _spring;
		}
		
		public function set spring(value:Number):void 
		{
			_spring = value;
		}

		
		






	//============================================
	//===== Class[FollowerBase] Has Finish ======
	//============================================
	}

}