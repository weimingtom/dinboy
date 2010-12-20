package com.dinboy.util
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
   * @author 钉崽 [DinBoy]
	 */
	public class DinDisplayUtil
	{

	public function DinDisplayUtil() {
      trace("本帅不需要实例化~");
    }

	/**
	 * 对称排列一组显示对象
	 * @param _displayGroup 需要被排列的数组(只能显示对象组)
	 * @param _axis 排列数组的轴心点
	 * @param _fromaxis 距离轴心的距离
	 * @param _space 每个对象的间距
	 * @param _direction 排列方向 H: 横向 V:纵向 
	 * @param _align 对齐方式 H: top,bottom,middle     V:left,right,center
	 */
	public static function  Symmetry(_displayGroup:Array, _axis:Point , _fromaxis:Number = 0, _space:Number = 0,_maxcount:int=0,_direction:String="H",_align:String="bottom" ):void 
	{
		if (_displayGroup==null) 
		{
			trace ("对象组已经是空,您不能继续咯.");
			return;
		}
		var _vector:Vector.<DisplayObject> = new Vector.<DisplayObject>(_displayGroup.length);
			try 
			{
				_vector=Vector.<DisplayObject>(_displayGroup);
			}	
			catch (err:Error)
			{
				trace(err+"\n显示 [对象组] 里面包含非 [显示对象]");
			}
		var _count:int = _vector.length;
		var _i:int ;
		 for (_i = 0; _i <_count ; _i++) 
		{
			var  _displayObject:DisplayObject = _vector[_i];
			DinDisplayUtil.SymmetryByCount(_displayObject, _i, _axis, _fromaxis, _space, _maxcount, _direction,_align);
		}

	}
	
	/**
	 * 根据个数排列在哪个位置
	 * @param	_displayObject 需要被排列的显示对象
	 * @param	_count				排列在第几个
	 * @param	_axis				中心点坐标
	 * @param	_fromaxis		轴心距
	 * @param	_space			间隙
	 * @param	_maxcount		离圆心最大个数
	 * @param	_direction		阵列方向
	 * @param _align 对齐方式 H: top,bottom,middle     V:left,right,center
	 */
	public static  function SymmetryByCount(_displayObject:Object,_count:int, _axis:Point , _fromaxis:Number = 0, _space:Number = 0,_maxcount:int=0,_direction:String="H" ,_align:String="bottom"):void
	{
			/**
			 * 求模
			 */
			var _model:int = _count & 0x1;
			
			//最高个数需要减1
			_maxcount--;
			
		//	_space = Math.abs(_space);
			//由于左右分开,需要同时除以2
			_count = _count >> 1;
			
			/**
			 * 倍数
			 */
			var _multiple:int = _count / _maxcount >> 0;
			
			/**
			 * 倍数的奇偶
			 */
			var _multoddeven:int = _multiple & 0x1;
			
			/**
			 * 数值的差, 最大值减去 当前数值以最大值为基数来求模 (当数值是最大值的奇数倍时)
			 */
			var _maxSubcount:int = _maxcount - (_count & (_maxcount - 1));
			
			/**
			 * 数值的差, 当前值减去 最大值乘以当前值的最大值倍数 (当数值是最大值的偶数倍时)
			 */
			var _countSubmax:int = _count - _multiple * _maxcount;
				if (_direction=="H")
				{
					    if (_align=="bottom") 
						{
							_displayObject.y = _axis.y - _displayObject.height;
						}
						else  if(_align=="top")
						{
							_displayObject.y = _axis.y;
						}
						else if(_align=="middle")
						{
							_displayObject.y = _axis.y + (_displayObject.height / 2);
						}
						else 
						{
							trace("横排无其他对齐方式");
						}
						
						/**
						 * 如果排列的是偶数 也就是在左边
						 */
						if (_model==0) 
						{
						//	_displayObject.x = _axis.x - _fromaxis - (_space + _displayObject.width) * (_count + 1) / 2;
								//当倍数为奇数时
								if (_multoddeven)		_displayObject.x =	_axis.x - _fromaxis - (_maxSubcount+1)* _displayObject.width - _maxSubcount*_space;
								else _displayObject.x = _axis.x - _fromaxis - (_countSubmax+1) * _displayObject.width - _countSubmax*_space;
						}
						if (_model==1)
						{
							if (_multoddeven) _displayObject.x =	_axis.x + _fromaxis +_maxSubcount* (_displayObject.width + _space);
								else 	_displayObject.x = _axis.x + _fromaxis +_countSubmax* (_displayObject.width + _space);
						//	_displayObject.x = _axis.x + _fromaxis + (_space + _displayObject.width) * (_count- 1) / 2;
						}
				}
				else if(_direction=="V")
				{
					if (_align=="left")
						{
							_displayObject.x = _axis.x;
						}
						else  if(_align=="top")
						{
							_displayObject.x = _axis.x-_displayObject.width;
						}
						else if(_align=="center")
						{
							_displayObject.x = _axis.x+(_displayObject.width/2);
						}
						else 
						{
							trace("竖排排无其他对齐方式");
						}
					
					 if (_model==0) 
						{
							if (_multoddeven)	_displayObject.y =	_axis.y - _fromaxis - (_maxSubcount+1)* _displayObject.height - _maxSubcount*_space;
								else _displayObject.y = _axis.y - _fromaxis - (_countSubmax+1) * _displayObject.height - _countSubmax*_space;
						//	_displayObject.y = _axis.y - _fromaxis - (_space + _displayObject.height) * (_count+1) / 2;
						}
						if (_model==1) 
						{
							if (_multoddeven)	_displayObject.y =	_axis.y + _fromaxis + _maxSubcount * (_displayObject.height + _space);
								else 	_displayObject.y =_axis.y + _fromaxis + _countSubmax* (_displayObject.height + _space);
					//		_displayObject.y = _axis.y + _fromaxis + (_space + _displayObject.height) * (_count-1) / 2;
						}
				}

	}
	
	/**
	 * 缩放显示对象
	 * @param	object 对象;
	 * @param	_width 要缩放的参数 width:最大宽度;
	 * @param	_height 要缩放的参数 height:最大宽度;
	 */
	public static function  directRatio(object:Object,_width:Number,_height:Number):Object 
	{
			var _Dwidth:Number = object.width;
			var _Dheight:Number = object.height;
			var _ratio:Number = Math.max(_Dwidth / _width, _Dheight / _height, 1);
			
			object.width = _Dwidth / _ratio;
			object.height = _Dheight / _ratio;
			return object;
	}
	
	/**
	 * 复制显示对象并缩放
	 * @param	_displayObject 被缩放的目标
	 * @param	_Object 要缩放的参数 width:最大宽度 ,height:最大高度
	 * @return 返回新的显示对象,原目标不改变
	 */
	public static function directRatioNew(_displayObject:Object,_Object:Object=null):Sprite 
	{
		var _obj:Object = _Object;
		var _duplicate:Sprite = new Sprite() ;
		var _width:Number=_displayObject.width/_displayObject.scaleX;
		var _height:Number = _displayObject.height/_displayObject.scaleY;
		var _BitmapData:BitmapData = new BitmapData(_width, _height, true, 0x000000);
			   _BitmapData.draw(_displayObject as DisplayObject);
			   _duplicate.graphics.beginBitmapFill(_BitmapData,null,false);
			   _duplicate.graphics.drawRect(0, 0,_width, _height);
			   _duplicate.graphics.endFill();
			   DinDisplayUtil.directRatio(_duplicate, _obj["width"], _obj["height"]);
			   for (var name:String in _obj)
			   {
				   if (name!="width" && name!= "height") 
				   {
					   try 
					   {
						   _duplicate[name] = _obj[name];
					   }catch (err:Error)
					   {
						   trace(DinDisplayUtil,"不存在",name,"这个属性.")
					   }
				   }
			   }
			   _BitmapData = null;
		//if (_obj) 
			//{
				//var _scaled:Number=1;
				//if (_obj["width"]) 
				//{
					//_scaled =  _obj["width"]/_duplicate.width;
					//_duplicate.width = _obj["width"];
					//_duplicate.height *= _scaled;
				//}
				//if (_obj["height"]) 
					//{
					//_scaled = _obj["height"]/_duplicate.height ;
					//_duplicate.height = _obj["height"];
					//_duplicate.width *= _scaled;
					//}
				//if (_obj["maxWidth"]<_duplicate.width) 
				//{
					//_scaled = _obj["maxWidth"] / _duplicate.width ;
					//_duplicate.width = _obj["maxWidth"];
					//_duplicate.height *= _scaled;
				//}
				//if (_obj["maxHeight"]<_duplicate.width) 
				//{
					//_scaled = _obj["maxHeight"] / _duplicate.height ;
					//_duplicate.height = _obj["maxHeight"];
					//_duplicate.width *= _scaled;
				//}
			//}

			return _duplicate;
	}
	
	/**
	 * 复制显示对象
	 * @param	_DisplayObject 被复制者
	 * @return  返回复制者
	 */
	public static function  duplicate(_displayObject:*):* 
	{
		var _targetClass:Class = Object(_displayObject).constructor;
		var _duplicate:* = new _targetClass();
		try 
		{
			 for each (var _item:* in  _displayObject) 
			  {
					throw _item;
				  _duplicate[_item]=_displayObject[_item]
			  }
		}
		catch (err:Error)
		{
							  throw err;
		}
		return _duplicate;
	}
	
	///**
	 //* 去除影片剪辑透明区域鼠标事件
	 //* @param	_displayObject 需要被设置的剪辑
	 //*/
	//public static function ClearPNGTransparent(_displayObject:*):* 
	//{
		//
		///**
		 //* 需要被作为撞击的精灵
		 //*/
		//var _hitSprite:Sprite = new Sprite();
			  //_hitSprite.visible = false;
			  //_hitSprite.mouseEnabled = false;
			  //_displayObject.hitArea = _hitSprite;
			  //try 
			  //{
				  //_displayObject.addChild(_hitSprite);
			  //}
			  //catch (err:Error)
			  //{
				  //trace("对不起,您需要转变的对象不是一个容器");
			  //}
				//
			  //var _bit:BitmapData = new BitmapData(_displayObject.width,_displayObject.height,true,0x00000000); 
					//
				//_bit.draw(_displayObject); 
				//if (_bit!=null)
				//{
						//重绘图象到bit 
						//_hitSprite.graphics.clear(); 
						//_hitSprite.graphics.beginFill(0xFFFFFF,0); 
						//for(var x:uint=0;x<_bit.width;x++) 
						//{
							//for(var y:uint=0;y<_bit.height;y++) 
							//{
								//if(_bit.getPixel32(x,y))_hitSprite.graphics.drawRect(x,y,1,1);
							//} 
						//} 
						//以graphics画出bit的无透明区域 
						//_hitSprite.graphics.endFill();					
				//}
			//return _displayObject;
	//}
	
		/**
		 * 删除掉透明区域
		 */
		public static function clearTransparentArea(object:*):* 
		{
			var _hitArea:Sprite = new Sprite();
					_hitArea.visible = false;
					_hitArea.mouseEnabled = false;
					//mouseChildren = false;
					object.hitArea = _hitArea;
			var	_bitMapdata:BitmapData = new BitmapData(object.width, object.height, true, 0x00000000);
					_bitMapdata.draw(object);

					//重绘图象到bit
						_hitArea.graphics.clear();
						_hitArea.graphics.beginFill(0xFFFFFF);
						
						var x:uint, y:uint;
						for(x=0;x <_bitMapdata.width;x++)
						{
							for(y=0;y<_bitMapdata.height;y++)
							{
								if (_bitMapdata.getPixel32(x, y)) {_hitArea.graphics.drawRect(x, y, 1, 1);}
							}
						}
						//以graphics画出bit的无透明区域 
						_hitArea.graphics.endFill();
						object.addChild(_hitArea);
		}
	
	/**
	 * 将显示对象复制到新的精灵上
	 * @param	_displayObject 被复制者
	 * @return   新的显示对象
	 */
	public static function ToBitSprite(_displayObject:DisplayObject):Sprite
	{
		/*
			var _copySprite:Sprite = new Sprite();
			var _scale:Number = _displayObject.scaleX;
			var _copyBitdat:BitmapData = new BitmapData(_displayObject.width, _displayObject.height, true, 0x000000);
				  _copyBitdat.draw(_displayObject);
				  _copySprite.graphics.beginBitmapFill(_copyBitdat);
				  _copySprite.graphics.drawRect(0, 0, _displayObject.width, _displayObject.height);
				  _copySprite.graphics.endFill();
				  _copySprite.scaleX = _copySprite.scaleY = _scale;	
		*/
		return DinDisplayUtil.directRatioNew(_displayObject,{width:_displayObject.width,height:_displayObject.height}) ;
	}
	
	/**
	 * 根据轴长随机排列.
	 * @param	_displayObject  将要被排列的显示对性
	 * @param   _count			  被排列的个数
	 * @param	_shaftlen			  扣除轴心距后的轴长
	 * @param	_axis				  中心点
	 * @param	_fromaxis		  中心距	
	 * @param	_direction		  排列方向
	 * @param	_align                 对齐方向
	 */
	public static function  randomPlaceByCount(_displayObject:DisplayObject,_count:int,_shaftlen:Number, _axis:Point , _fromaxis:Number = 0, _direction:String="H" ,_align:String="bottom"):void 
	{
		var _model:int = _count % 2;
				if (_direction=="H")
				{
					    if (_align=="bottom") 
						{
							_displayObject.y = _axis.y-_displayObject.height;
						}
						else  if(_align=="top")
						{
							_displayObject.y = _axis.y;
						}
						else if(_align=="middle")
						{
							_displayObject.y = _axis.y + (_displayObject.height / 2);
						}
						else 
						{
							trace("横排无其他对齐方式");
						}
						
						if (_model==0) 
						{
							_displayObject.x = _axis.x - _fromaxis -(Math.random()*_shaftlen>>0);
						}
						if (_model==1) 
						{
							_displayObject.x = _axis.x + _fromaxis + (Math.random()*_shaftlen>>0);
						}
				}
				else if(_direction=="V")
				{
					if (_align=="left") 
						{
							_displayObject.x = _axis.x;
						}
						else  if(_align=="top")
						{
							_displayObject.x = _axis.x-_displayObject.width;
						}
						else if(_align=="center")
						{
							_displayObject.x = _axis.x+(_displayObject.width/2);
						}
						else 
						{
							trace("竖排排无其他对齐方式");
						}
					
					 if (_model==0) 
						{
							_displayObject.y = _axis.y - _fromaxis - (Math.random()*_shaftlen>>0);
						}
						if (_model==1) 
						{
							_displayObject.y = _axis.y + _fromaxis + (Math.random()*_shaftlen>>0);
						}
				}
	}
	
	/**
	 * 根据宽度随机排列显示对象里面的位置
	 * @param	_displayGroup
	 * @param	_point
	 * @param	_weight
	 * @param	_direction
	 * @param	_align
	 */
	public static function randomPlaceByWidth(_displayGroup:Array,_point:Point,_weight:Number,_direction:String="H" ,_align:String="bottom"):void 
	{
		if (_displayGroup==null)
		{
			trace ("对象组已经是空,您不能继续咯.");
			return;
		}
		var _vector:Vector.<DisplayObject> = new Vector.<DisplayObject>(_displayGroup.length);
			try 
			{
				_vector=Vector.<DisplayObject>(_displayGroup);
			}	
			catch (err:Error)
			{
				trace(err+"\n显示 [对象组] 里面包含非 [显示对象]");
			}
		var _len:int = _vector.length;
		var _i:int;
		for (_i = 0; _i < _len; _i++) 
		{
			randomPlace(_vector[_i], _point, _weight, _direction, _align);
		}
	}
	
	/**
	 * 根据目标点和长度随机排列
	 * @param	_displayObject	被排列的位置
	 * @param	_point					目标点
	 * @param	_weight				长度
	 * @param	_direction			排列方向 (默认 "H")
	 * @param	_align					对齐方式 (默认 "bottom")
	 */
	public static function randomPlace(_displayObject:DisplayObject,_point:Point,_weight:Number,_direction:String="H" ,_align:String="bottom"):void 
	{
		var _Rectangle:Rectangle = _displayObject.getBounds(_displayObject);
		trace(_Rectangle);
			if (_direction=="H")
				{
					    if (_align=="bottom") 
						{
							_displayObject.y = _point.y - _Rectangle.height - _Rectangle.y;
						}
						else  if(_align=="top")
						{
							_displayObject.y = _point.y - _Rectangle.y;
						}
						else if(_align=="middle")
						{
							_displayObject.y = _point.y - _Rectangle.y + (_Rectangle.height >> 1);
						}
						else 
						{
							trace("横排无其他对齐方式");
						}
							_displayObject.x = _point.x-_Rectangle.x +(_weight * Math.random()>>0);
				}
				else if(_direction=="V")
				{
					if (_align=="left") 
						{
							_displayObject.x = _point.x - _Rectangle.x;
						}
						else  if(_align=="right")
						{
							_displayObject.x = _point.x - _Rectangle.x - _Rectangle.width;
						}
						else if(_align=="center")
						{
							_displayObject.x = _point.x - _Rectangle.x + (_Rectangle.width >> 1);
						}
						else 
						{
							trace("竖排排无其他对齐方式");
						}
							_displayObject.y = _point.y -_Rectangle.y+  (_weight * Math.random()>>0);
				}
	}
	

	
	
	/**
	 * 创建屏蔽剪辑
	 * @param	_name
	 * @return
	 */
	public static function CreatShieldSprite(_object:Object):Sprite
	{
		var _sprite:Sprite = new Sprite();
			try 
			{
				_sprite.graphics.beginFill(_object["color"], _object["alpha"]);
				_sprite.graphics.drawRect(0, 0, _object["width"], _object["height"]);
				_sprite.graphics.endFill();
			}
			catch (err:Error)
			{
				trace (err.getStackTrace());
			}
				
				
	return _sprite;
	}
	
	/**
	 * 使用自动排列
	 * @param	_displayGroup 被排列的显示对象组
	 * @param	_object 需要的参数 x:X坐标,y:Y坐标,space:每个空隙
	 */
	public static function  SetLocate(_displayGroup:Array,_object:Object):void 
	{
		if (_displayGroup==null) 
		{
			trace ("对象组已经是空,您不能继续咯.");
			return;
		}
		var _vector:Vector.<DisplayObject> = new Vector.<DisplayObject>(_displayGroup.length);
			try 
			{
				_vector=Vector.<DisplayObject>(_displayGroup);
			}	
			catch (err:Error)
			{
				trace(err+"\n显示 [对象组] 里面包含非 [显示对象]");
			}
		var _len:int = _vector.length; 	
		var _single:Boolean = _len% 2 == 1?true:false;
		var _point:Point = new Point(_object["x"], _object["y"]);
		var _i:int;
		var _Rectangle:Rectangle ;
		var _align:String = _object["align"] != null?_object["align"]:"B";
			if (_single)
			{
				for ( _i = 0; _i <_len ; _i++)
				{
					_Rectangle = _vector[_i].getBounds(_vector[_i]);
					_vector[_i].x = _point.x +  ((_len - 1) / 2 - _i) * _object["space"] - _Rectangle.x - (_Rectangle.width >> 1);
					if (_align == "T") _vector[_i].y = _point.y - _Rectangle.y;
					if (_align == "B") _vector[_i].y = _point.y - _Rectangle.y - _Rectangle.height;
				}
			}else 
			{
				for (_i  = 0; _i <_len ; _i++)
				{
					_Rectangle = _vector[_i].getBounds(_vector[_i]);
					_vector[_i].x = _point.x +  ((_len) / 2 - (_i + 0.5)) * _object["space"]  - _Rectangle.x - (_Rectangle.width >> 1);
					if (_align == "T") _vector[_i].y = _point.y - _Rectangle.y;
					if (_align == "B") _vector[_i].y = _point.y - _Rectangle.y - _Rectangle.height;
				}
			}
	}
	
	/**
	 * 设置数组里面的各个元素的显示对象的旋转角度
	 * @param	_displayObject	显示对象数组
	 * @param	_object				agnle:旋转角度 direction:X,Y,Z:旋转的3D坐标轴
	 */
	public static function  setAutoRotation(_displayGroup:Array,_object:Object):void 
	{
		if (_displayGroup==null) 
		{
			trace ("对象组已经是空,您不能继续咯.");
			return;
		}
		var _vector:Vector.<DisplayObject> = new Vector.<DisplayObject>(_displayGroup.length);
			try 
			{
				_vector=Vector.<DisplayObject>(_displayGroup);
			}	
			catch (err:Error)
			{
				trace(err+"\n显示 [对象组] 里面包含非 [显示对象]");
			}
		var _len:int = _vector.length;
		var _single:Boolean = _len % 2 == 1?true:false;
		var _i:int;
			if (_single)
			{
				for ( _i = 0; _i <_len ; _i++)
				{
					resetMatrix(_vector[_i]);
					rotateAt(_vector[_i],((_len - 1) / 2 - _i) * _object["angle"],new Point(_vector[_i].width/2+_vector[_i].x,_vector[_i].height));
				}
			}else 
			{
				for (_i  = 0; _i <_len ; _i++)
				{
					resetMatrix(_vector[_i]);
					rotateAt(_vector[_i],((_len) / 2 - (_i+0.5)) * _object["angle"],new Point(_vector[_i].width/2+_vector[_i].x,_vector[_i].height));
				}
			}
	}
	
	/**
	 * 随机旋转
	 * @param	_displayGroup 需要被旋转的数组里面的所有显示对象
	 * @param	_object			limitMin:最小值  ,limitMax:最大值
	 */
	public static function  setRandomRotation(_displayGroup:Array,_object:Object):void 
	{
		if (_displayGroup==null) 
		{
			trace ("对象组已经是空,您不能继续咯.");
			return;
		}
		var _vector:Vector.<DisplayObject> = new Vector.<DisplayObject>(_displayGroup.length);
			try 
			{
				_vector=Vector.<DisplayObject>(_displayGroup);
			}	
			catch (err:Error)
			{
				trace(err+"\n显示 [对象组] 里面包含非 [显示对象]");
			}
		var _len:int = _vector.length;
		var _i:int;
				for ( _i = 0; _i <_len ; _i++) 
				{
					randomRotation(_vector[_i], { limitMin: _object["limitMin"], limitMax:_object["limitMax"], x:_vector[_i].width / 2 + _vector[_i].x, y:_vector[_i].height } );
				}
	}
	
	/**
	 * 随机旋转显示对象的角度
	 * @param	_displayObject	被旋转的显示对象
	 * @param	_object				limitMin:最小角度 limitMax:最大角度 x:旋转坐标点X轴坐标 y:旋转坐标点Y轴坐标
	 */
	public static function  randomRotation(_displayObject:DisplayObject,_object:Object=null):void 
	{
		resetMatrix(_displayObject);
		rotateAt(_displayObject, Math.random() * ([_object["limitMin"] , _object["limitMax"]][Math.random()*2>>0]), new Point(_object["x"], _object["y"]));
	}
	
	/**
	 * 旋转显示对象
	 * @param	_displayObject 被旋转的显示对象
	 * @param	_angle				旋转角度
	 * @param	_point				旋转的注册点
	 */
	public static function  rotateAt(_displayObject:DisplayObject,_angle:Number,_point:Point ):void
		{
		var _matrix:Matrix = _displayObject.transform.matrix;
				_matrix.translate( -_point.x, -_point.y );
				_matrix.rotate(_angle *  (Math.PI / 180));
				_matrix.translate( _point.x, _point.y );
				_displayObject.transform.matrix = _matrix;
		}
		
		/**
		 * 重新排列显示对象的Matrix
		 * @param	_displayObject
		 */
		public static function  resetMatrix(_displayObject:DisplayObject):void 
		{
			var _a:Number = Math.acos(_displayObject.transform.matrix.a);
			var _b:Number = Math.asin(_displayObject.transform.matrix.b);
			var _c:Number = Math.asin(-_displayObject.transform.matrix.c);
			var _d:Number = Math.acos(_displayObject.transform.matrix.d);
			trace(_a,_b,_c,_d);
				var _matrix:Matrix = new Matrix(_a, _b, _c, _d, _displayObject.transform.matrix.tx, _displayObject.transform.matrix.ty);
					  _displayObject.transform.matrix = _matrix;
		}
	
	
	/********** [DINBOY] Say: Class The End  ************/	
	}
}