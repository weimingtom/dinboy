package com.kerry.character {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * Role 类实现角色运动（八方向／四方向）
	 * @author PhoenixKerry（http://blog.sina.com.cn/yyy98）
	 * @version 0.3
	 */
	public class Role extends Sprite {
		private var role:Bitmap;
		private var step:uint;
		private var direction:uint;
		private var moveSpeed:Number;
		private var isEightDirection:Boolean;
		
		private var actionAry:Array;
		private var picColumns:uint;
		
		private var up:uint;
		private var down:uint;
		private var profile:uint;
		private var slopeup:uint;
		private var slopedown:uint;
		
		/**
		 * 创建角色运动对象
		 * @param	pic 角色位图
		 * @param	picRows 位图行数
		 * @param	picColumns 位图列数
		 * @param	moveSpeed 运动速度
		 * @param	isEightDirection 八方向运动为 true，四方向运动为 false
		 * @param	upRow 角色朝上的行数
		 * @param	downRow 角色朝下的行数
		 * @param	profileRow 角色侧面的行数
		 * @param	slopeupRow 角色朝侧上的行数
		 * @param	slopedownRow 角色朝侧下的行数
		 */
		public function Role(pic:BitmapData, picRows:uint, picColumns:uint, moveSpeed:Number, isEightDirection:Boolean = true, 
												upRow:uint = 0, downRow:uint = 1, profileRow:uint = 2, slopeupRow:uint = 3, slopedownRow:uint = 4) {
			
			this.picColumns = picColumns;
			this.moveSpeed = moveSpeed;
			this.isEightDirection = isEightDirection;
			
			up = upRow;
			down = downRow;
			profile = profileRow;
			slopeup = slopeupRow;
			slopedown = slopedownRow;
			
			role = new Bitmap();
			addChild(role);
			
			var roleWidth:Number = Math.floor(pic.width / picColumns);
			var roleHeight:Number = Math.floor(pic.height / picRows);
			
			actionAry = new Array();
			for (var i:uint = 0; i < picRows; i++ ) {
				var subRoleAry:Array = new Array();
				for (var j:uint = 0; j < picColumns; j++ ) {
					var roleBitmapData:BitmapData = new BitmapData(roleWidth, roleHeight, true, 0x00000000);
					roleBitmapData.copyPixels(pic, new Rectangle(j * roleWidth, i * roleHeight, roleWidth, roleHeight), new Point());
					subRoleAry.push(roleBitmapData);
				}
				actionAry.push(subRoleAry);
			}
			
			pic.dispose();
			
			direction = profile;
			step = 0;
			
			role.bitmapData = actionAry[direction][step];
		}
		
		/**
		 * 向角色运动：左(-1,0)，右(1,0)，上(0,-1)，下(0,1)，左上(-1,-1)，右上(1,-1)，左下(-1,1)，右下(1,1)，停留(0,0)
		 * @param	dirX x 轴方向 [-1, 0 ,1]
		 * @param	dirY y 轴方向 [-1, 0 ,1]
		 */
		public function go(dirX:int, dirY:int):void {
			if (dirX == 0 && dirY == 0) {
				step = 0;
			} else {
				if (dirX != 0) {
					direction = profile;
					
					if (dirX == 1) {
						if (role.scaleX == 1) role.x += role.width;
						role.scaleX = -1;
					} else if (dirX == -1) {
						if (role.scaleX == -1) role.x -= role.width;
						role.scaleX = 1;
					}
					
					if (isEightDirection) {
						if (dirY == -1) {
							direction = slopeup;
						} else if (dirY == 1) {
							direction = slopedown;
						}
					}
					
					x += dirX * moveSpeed;
				} else {
					if (dirY == -1) {
						direction = up;
					} else if (dirY == 1) {
						direction = down;
					}
				}
				
				y += dirY * moveSpeed;
				if (++step > picColumns - 1) step = 1;
			}
			
			role.bitmapData = actionAry[direction][step];
		}
		
	}
}