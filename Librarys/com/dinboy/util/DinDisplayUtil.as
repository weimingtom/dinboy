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
	 * @param $displayGroup 需要被排列的数组(只能显示对象组)
	 * @param $axis 排列数组的轴心点
	 * @param $fromaxis 距离轴心的距离
	 * @param $space 每个对象的间距
	 * @param $direction 排列方向 H: 横向 V:纵向 
	 * @param $align 对齐方式 H: top,bottom,middle     V:left,right,center
	 */
	public static function  Symmetry($displayGroup:Array, $axis:Point , $fromaxis:Number = 0, $space:Number = 0,$maxcount:int=0,$direction:String="H",$align:String="bottom" ):void 
	{
		if ($displayGroup==null) 
		{
			trace ("对象组已经是空,您不能继续咯.");
			return;
		}
		var $vector:Vector.<DisplayObject> = new Vector.<DisplayObject>($displayGroup.length);
			try 
			{
				$vector=Vector.<DisplayObject>($displayGroup);
			}	
			catch (err:Error)
			{
				trace(err+"\n显示 [对象组] 里面包含非 [显示对象]");
			}
		var $count:int = $vector.length;
		var $i:int ;
		 for ($i = 0; $i <$count ; $i++) 
		{
			var  $displayObject:DisplayObject = $vector[$i];
			DinDisplayUtil.SymmetryByCount($displayObject, $i, $axis, $fromaxis, $space, $maxcount, $direction,$align);
		}

	}
	
	/**
	 * 根据个数排列在哪个位置
	 * @param	$displayObject 需要被排列的显示对象
	 * @param	$count				排列在第几个
	 * @param	$axis				中心点坐标
	 * @param	$fromaxis		轴心距
	 * @param	$space			间隙
	 * @param	$maxcount		离圆心最大个数
	 * @param	$direction		阵列方向
	 * @param $align 对齐方式 H: top,bottom,middle     V:left,right,center
	 */
	public static  function SymmetryByCount($displayObject:DisplayObject,$count:int, $axis:Point , $fromaxis:Number = 0, $space:Number = 0,$maxcount:int=0,$direction:String="H" ,$align:String="bottom"):void
	{
			/**
			 * 求模
			 */
			var $model:int = $count & 0x1;
			
			//最高个数需要减1
			$maxcount--;
			
		//	$space = Math.abs($space);
			//由于左右分开,需要同时除以2
			$count = $count >> 1;
			
			/**
			 * 倍数
			 */
			var $multiple:int = $count / $maxcount >> 0;
			
			/**
			 * 倍数的奇偶
			 */
			var $multoddeven:int = $multiple & 0x1;
			
			/**
			 * 数值的差, 最大值减去 当前数值以最大值为基数来求模 (当数值是最大值的奇数倍时)
			 */
			var $maxSubcount:int = $maxcount - ($count & ($maxcount - 1));
			
			/**
			 * 数值的差, 当前值减去 最大值乘以当前值的最大值倍数 (当数值是最大值的偶数倍时)
			 */
			var $countSubmax:int = $count - $multiple * $maxcount;
				if ($direction=="H")
				{
					    if ($align=="bottom") 
						{
							$displayObject.y = $axis.y - $displayObject.height;
						}
						else  if($align=="top")
						{
							$displayObject.y = $axis.y;
						}
						else if($align=="middle")
						{
							$displayObject.y = $axis.y + ($displayObject.height / 2);
						}
						else 
						{
							trace("横排无其他对齐方式");
						}
						
						/**
						 * 如果排列的是偶数 也就是在左边
						 */
						if ($model==0) 
						{
						//	$displayObject.x = $axis.x - $fromaxis - ($space + $displayObject.width) * ($count + 1) / 2;
								//当倍数为奇数时
								if ($multoddeven)		$displayObject.x =	$axis.x - $fromaxis - ($maxSubcount+1)* $displayObject.width - $maxSubcount*$space;
								else $displayObject.x = $axis.x - $fromaxis - ($countSubmax+1) * $displayObject.width - $countSubmax*$space;
						}
						if ($model==1)
						{
							if ($multoddeven) $displayObject.x =	$axis.x + $fromaxis +$maxSubcount* ($displayObject.width + $space);
								else 	$displayObject.x = $axis.x + $fromaxis +$countSubmax* ($displayObject.width + $space);
						//	$displayObject.x = $axis.x + $fromaxis + ($space + $displayObject.width) * ($count- 1) / 2;
						}
				}
				else if($direction=="V")
				{
					if ($align=="left")
						{
							$displayObject.x = $axis.x;
						}
						else  if($align=="top")
						{
							$displayObject.x = $axis.x-$displayObject.width;
						}
						else if($align=="center")
						{
							$displayObject.x = $axis.x+($displayObject.width/2);
						}
						else 
						{
							trace("竖排排无其他对齐方式");
						}
					
					 if ($model==0) 
						{
							if ($multoddeven)	$displayObject.y =	$axis.y - $fromaxis - ($maxSubcount+1)* $displayObject.height - $maxSubcount*$space;
								else $displayObject.y = $axis.y - $fromaxis - ($countSubmax+1) * $displayObject.height - $countSubmax*$space;
						//	$displayObject.y = $axis.y - $fromaxis - ($space + $displayObject.height) * ($count+1) / 2;
						}
						if ($model==1) 
						{
							if ($multoddeven)	$displayObject.y =	$axis.y + $fromaxis + $maxSubcount * ($displayObject.height + $space);
								else 	$displayObject.y =$axis.y + $fromaxis + $countSubmax* ($displayObject.height + $space);
					//		$displayObject.y = $axis.y + $fromaxis + ($space + $displayObject.height) * ($count-1) / 2;
						}
				}

	}
	
	/**
	 * 缩放显示对象
	 * @param	$displayObject 要被显示对象;
	 * @param	$width 要缩放的参数 width:最大宽度;
	 * @param	$height 要缩放的参数 height:最大宽度;
	 */
	public static function  directRatio($displayObject:DisplayObject,$width:Number,$height:Number):void 
	{
			var $Dwidth:Number = $displayObject.width;
			var $Dheight:Number = $displayObject.height;
			var $ratio:Number = Math.max($Dwidth / $width, $Dheight / $height, 1);
			
			$displayObject.width = $Dwidth / $ratio;
			$displayObject.height = $Dheight / $ratio;
	}
	
	/**
	 * 复制显示对象并缩放
	 * @param	$displayObject 被缩放的目标
	 * @param	$Object 要缩放的参数 width:最大宽度 ,height:最大高度
	 * @return 返回新的显示对象,原目标不改变
	 */
	public static function directRatioNew($displayObject:DisplayObject,$Object:Object=null):Sprite 
	{
		var $obj:Object = $Object;
		var $duplicate:Sprite = new Sprite() ;
		var $width:Number=$displayObject.width/$displayObject.scaleX;
		var $height:Number = $displayObject.height/$displayObject.scaleX;
		var $BitmapData:BitmapData = new BitmapData($width, $height, true, 0x000000);
			   $BitmapData.draw($displayObject);
			   $duplicate.graphics.beginBitmapFill($BitmapData);
			   $duplicate.graphics.drawRect(0, 0,$width, $height);
			   $duplicate.graphics.endFill();
			   directRatio($displayObject, $obj["wisth"], $obj["height"]);
		//if ($obj) 
			//{
				//var $scaled:Number=1;
				//if ($obj["width"]) 
				//{
					//$scaled =  $obj["width"]/$duplicate.width;
					//$duplicate.width = $obj["width"];
					//$duplicate.height *= $scaled;
				//}
				//if ($obj["height"]) 
					//{
					//$scaled = $obj["height"]/$duplicate.height ;
					//$duplicate.height = $obj["height"];
					//$duplicate.width *= $scaled;
					//}
				//if ($obj["maxWidth"]<$duplicate.width) 
				//{
					//$scaled = $obj["maxWidth"] / $duplicate.width ;
					//$duplicate.width = $obj["maxWidth"];
					//$duplicate.height *= $scaled;
				//}
				//if ($obj["maxHeight"]<$duplicate.width) 
				//{
					//$scaled = $obj["maxHeight"] / $duplicate.height ;
					//$duplicate.height = $obj["maxHeight"];
					//$duplicate.width *= $scaled;
				//}
			//}

			return $duplicate;
	}
	
	/**
	 * 复制显示对象
	 * @param	$DisplayObject 被复制者
	 * @return  返回复制者
	 */
	public static function  duplicate($displayObject:*):* 
	{
		var $targetClass:Class = Object($displayObject).constructor;
		var $duplicate:* = new $targetClass();
		try 
		{
			 for each (var $item:* in  $displayObject) 
			  {
					throw $item;
				  $duplicate[$item]=$displayObject[$item]
			  }
		}
		catch (err:Error)
		{
							  throw err;
		}
		return $duplicate;
	}
	
	/**
	 * 去除影片剪辑透明区域鼠标事件
	 * @param	$displayObject 需要被设置的剪辑
	 */
	public static function ClearPNGTransparent($displayObject:*):* 
	{
		
		/**
		 * 需要被作为撞击的精灵
		 */
		var $hitSprite:Sprite = new Sprite();
			  $hitSprite.visible = false;
			  $hitSprite.mouseEnabled = false;
			  $displayObject.hitArea = $hitSprite;
			  try 
			  {
				  $displayObject.addChild($hitSprite);
			  }
			  catch (err:Error)
			  {
				  trace("对不起,您需要转变的对象不是一个容器");
			  }
				
			  var $bit:BitmapData = new BitmapData($displayObject.width,$displayObject.height,true,0x00000000); 
					
				$bit.draw($displayObject); 
				if ($bit!=null)
				{
						//重绘图象到bit 
						$hitSprite.graphics.clear(); 
						$hitSprite.graphics.beginFill(0xFFFFFF,0); 
						for(var x:uint=0;x<$bit.width;x++) 
						{
							for(var y:uint=0;y<$bit.height;y++) 
							{
								if($bit.getPixel32(x,y))$hitSprite.graphics.drawRect(x,y,1,1);
							} 
						} 
						//以graphics画出bit的无透明区域 
						$hitSprite.graphics.endFill();					
				}
			return $displayObject;
	}
	
	/**
	 * 将显示对象复制到新的精灵上
	 * @param	$displayObject 被复制者
	 * @return   新的显示对象
	 */
	public static function ToBitSprite($displayObject:DisplayObject):Sprite
	{
		/*
			var $copySprite:Sprite = new Sprite();
			var $scale:Number = $displayObject.scaleX;
			var $copyBitdat:BitmapData = new BitmapData($displayObject.width, $displayObject.height, true, 0x000000);
				  $copyBitdat.draw($displayObject);
				  $copySprite.graphics.beginBitmapFill($copyBitdat);
				  $copySprite.graphics.drawRect(0, 0, $displayObject.width, $displayObject.height);
				  $copySprite.graphics.endFill();
				  $copySprite.scaleX = $copySprite.scaleY = $scale;	
		*/
		return DinDisplayUtil.directRatioNew($displayObject,{width:$displayObject.width,height:$displayObject.height}) ;
	}
	
	/**
	 * 根据轴长随机排列.
	 * @param	$displayObject  将要被排列的显示对性
	 * @param   $count			  被排列的个数
	 * @param	$shaftlen			  扣除轴心距后的轴长
	 * @param	$axis				  中心点
	 * @param	$fromaxis		  中心距	
	 * @param	$direction		  排列方向
	 * @param	$align                 对齐方向
	 */
	public static function  randomPlaceByCount($displayObject:DisplayObject,$count:int,$shaftlen:Number, $axis:Point , $fromaxis:Number = 0, $direction:String="H" ,$align:String="bottom"):void 
	{
		var $model:int = $count % 2;
				if ($direction=="H")
				{
					    if ($align=="bottom") 
						{
							$displayObject.y = $axis.y-$displayObject.height;
						}
						else  if($align=="top")
						{
							$displayObject.y = $axis.y;
						}
						else if($align=="middle")
						{
							$displayObject.y = $axis.y + ($displayObject.height / 2);
						}
						else 
						{
							trace("横排无其他对齐方式");
						}
						
						if ($model==0) 
						{
							$displayObject.x = $axis.x - $fromaxis -(Math.random()*$shaftlen>>0);
						}
						if ($model==1) 
						{
							$displayObject.x = $axis.x + $fromaxis + (Math.random()*$shaftlen>>0);
						}
				}
				else if($direction=="V")
				{
					if ($align=="left") 
						{
							$displayObject.x = $axis.x;
						}
						else  if($align=="top")
						{
							$displayObject.x = $axis.x-$displayObject.width;
						}
						else if($align=="center")
						{
							$displayObject.x = $axis.x+($displayObject.width/2);
						}
						else 
						{
							trace("竖排排无其他对齐方式");
						}
					
					 if ($model==0) 
						{
							$displayObject.y = $axis.y - $fromaxis - (Math.random()*$shaftlen>>0);
						}
						if ($model==1) 
						{
							$displayObject.y = $axis.y + $fromaxis + (Math.random()*$shaftlen>>0);
						}
				}
	}
	
	/**
	 * 根据宽度随机排列显示对象里面的位置
	 * @param	$displayGroup
	 * @param	$point
	 * @param	$weight
	 * @param	$direction
	 * @param	$align
	 */
	public static function randomPlaceByWidth($displayGroup:Array,$point:Point,$weight:Number,$direction:String="H" ,$align:String="bottom"):void 
	{
		if ($displayGroup==null)
		{
			trace ("对象组已经是空,您不能继续咯.");
			return;
		}
		var $vector:Vector.<DisplayObject> = new Vector.<DisplayObject>($displayGroup.length);
			try 
			{
				$vector=Vector.<DisplayObject>($displayGroup);
			}	
			catch (err:Error)
			{
				trace(err+"\n显示 [对象组] 里面包含非 [显示对象]");
			}
		var $len:int = $vector.length;
		var $i:int;
		for ($i = 0; $i < $len; $i++) 
		{
			randomPlace($vector[$i], $point, $weight, $direction, $align);
		}
	}
	
	/**
	 * 根据目标点和长度随机排列
	 * @param	$displayObject	被排列的位置
	 * @param	$point					目标点
	 * @param	$weight				长度
	 * @param	$direction			排列方向 (默认 "H")
	 * @param	$align					对齐方式 (默认 "bottom")
	 */
	public static function randomPlace($displayObject:DisplayObject,$point:Point,$weight:Number,$direction:String="H" ,$align:String="bottom"):void 
	{
		var $Rectangle:Rectangle = $displayObject.getBounds($displayObject);
		trace($Rectangle);
			if ($direction=="H")
				{
					    if ($align=="bottom") 
						{
							$displayObject.y = $point.y - $Rectangle.height - $Rectangle.y;
						}
						else  if($align=="top")
						{
							$displayObject.y = $point.y - $Rectangle.y;
						}
						else if($align=="middle")
						{
							$displayObject.y = $point.y - $Rectangle.y + ($Rectangle.height >> 1);
						}
						else 
						{
							trace("横排无其他对齐方式");
						}
							$displayObject.x = $point.x-$Rectangle.x +($weight * Math.random()>>0);
				}
				else if($direction=="V")
				{
					if ($align=="left") 
						{
							$displayObject.x = $point.x - $Rectangle.x;
						}
						else  if($align=="right")
						{
							$displayObject.x = $point.x - $Rectangle.x - $Rectangle.width;
						}
						else if($align=="center")
						{
							$displayObject.x = $point.x - $Rectangle.x + ($Rectangle.width >> 1);
						}
						else 
						{
							trace("竖排排无其他对齐方式");
						}
							$displayObject.y = $point.y -$Rectangle.y+  ($weight * Math.random()>>0);
				}
	}
	

	
	
	/**
	 * 创建屏蔽剪辑
	 * @param	$name
	 * @return
	 */
	public static function CreatShieldSprite($object:Object):Sprite
	{
		var $sprite:Sprite = new Sprite();
			try 
			{
				$sprite.graphics.beginFill($object["color"], $object["alpha"]);
				$sprite.graphics.drawRect(0, 0, $object["width"], $object["height"]);
				$sprite.graphics.endFill();
			}
			catch (err:Error)
			{
				trace (err.getStackTrace());
			}
				
				
	return $sprite;
	}
	
	/**
	 * 使用自动排列
	 * @param	$displayGroup 被排列的显示对象组
	 * @param	$object 需要的参数 x:X坐标,y:Y坐标,space:每个空隙
	 */
	public static function  SetLocate($displayGroup:Array,$object:Object):void 
	{
		if ($displayGroup==null) 
		{
			trace ("对象组已经是空,您不能继续咯.");
			return;
		}
		var $vector:Vector.<DisplayObject> = new Vector.<DisplayObject>($displayGroup.length);
			try 
			{
				$vector=Vector.<DisplayObject>($displayGroup);
			}	
			catch (err:Error)
			{
				trace(err+"\n显示 [对象组] 里面包含非 [显示对象]");
			}
		var $len:int = $vector.length; 	
		var $single:Boolean = $len% 2 == 1?true:false;
		var $point:Point = new Point($object["x"], $object["y"]);
		var $i:int;
		var $Rectangle:Rectangle ;
		var $align:String = $object["align"] != null?$object["align"]:"B";
			if ($single)
			{
				for ( $i = 0; $i <$len ; $i++)
				{
					$Rectangle = $vector[$i].getBounds($vector[$i]);
					$vector[$i].x = $point.x +  (($len - 1) / 2 - $i) * $object["space"] - $Rectangle.x - ($Rectangle.width >> 1);
					if ($align == "T") $vector[$i].y = $point.y - $Rectangle.y;
					if ($align == "B") $vector[$i].y = $point.y - $Rectangle.y - $Rectangle.height;
				}
			}else 
			{
				for ($i  = 0; $i <$len ; $i++)
				{
					$Rectangle = $vector[$i].getBounds($vector[$i]);
					$vector[$i].x = $point.x +  (($len) / 2 - ($i + 0.5)) * $object["space"]  - $Rectangle.x - ($Rectangle.width >> 1);
					if ($align == "T") $vector[$i].y = $point.y - $Rectangle.y;
					if ($align == "B") $vector[$i].y = $point.y - $Rectangle.y - $Rectangle.height;
				}
			}
	}
	
	/**
	 * 设置数组里面的各个元素的显示对象的旋转角度
	 * @param	$displayObject	显示对象数组
	 * @param	$object				agnle:旋转角度 direction:X,Y,Z:旋转的3D坐标轴
	 */
	public static function  setAutoRotation($displayGroup:Array,$object:Object):void 
	{
		if ($displayGroup==null) 
		{
			trace ("对象组已经是空,您不能继续咯.");
			return;
		}
		var $vector:Vector.<DisplayObject> = new Vector.<DisplayObject>($displayGroup.length);
			try 
			{
				$vector=Vector.<DisplayObject>($displayGroup);
			}	
			catch (err:Error)
			{
				trace(err+"\n显示 [对象组] 里面包含非 [显示对象]");
			}
		var $len:int = $vector.length;
		var $single:Boolean = $len % 2 == 1?true:false;
		var $i:int;
			if ($single)
			{
				for ( $i = 0; $i <$len ; $i++)
				{
					resetMatrix($vector[$i]);
					rotateAt($vector[$i],(($len - 1) / 2 - $i) * $object["angle"],new Point($vector[$i].width/2+$vector[$i].x,$vector[$i].height));
				}
			}else 
			{
				for ($i  = 0; $i <$len ; $i++)
				{
					resetMatrix($vector[$i]);
					rotateAt($vector[$i],(($len) / 2 - ($i+0.5)) * $object["angle"],new Point($vector[$i].width/2+$vector[$i].x,$vector[$i].height));
				}
			}
	}
	
	/**
	 * 随机旋转
	 * @param	$displayGroup 需要被旋转的数组里面的所有显示对象
	 * @param	$object			limitMin:最小值  ,limitMax:最大值
	 */
	public static function  setRandomRotation($displayGroup:Array,$object:Object):void 
	{
		if ($displayGroup==null) 
		{
			trace ("对象组已经是空,您不能继续咯.");
			return;
		}
		var $vector:Vector.<DisplayObject> = new Vector.<DisplayObject>($displayGroup.length);
			try 
			{
				$vector=Vector.<DisplayObject>($displayGroup);
			}	
			catch (err:Error)
			{
				trace(err+"\n显示 [对象组] 里面包含非 [显示对象]");
			}
		var $len:int = $vector.length;
		var $i:int;
				for ( $i = 0; $i <$len ; $i++) 
				{
					randomRotation($vector[$i], { limitMin: $object["limitMin"], limitMax:$object["limitMax"], x:$vector[$i].width / 2 + $vector[$i].x, y:$vector[$i].height } );
				}
	}
	
	/**
	 * 随机旋转显示对象的角度
	 * @param	$displayObject	被旋转的显示对象
	 * @param	$object				limitMin:最小角度 limitMax:最大角度 x:旋转坐标点X轴坐标 y:旋转坐标点Y轴坐标
	 */
	public static function  randomRotation($displayObject:DisplayObject,$object:Object=null):void 
	{
		resetMatrix($displayObject);
		rotateAt($displayObject, Math.random() * ([$object["limitMin"] , $object["limitMax"]][Math.random()*2>>0]), new Point($object["x"], $object["y"]));
	}
	
	/**
	 * 旋转显示对象
	 * @param	$displayObject 被旋转的显示对象
	 * @param	$angle				旋转角度
	 * @param	$point				旋转的注册点
	 */
	public static function  rotateAt($displayObject:DisplayObject,$angle:Number,$point:Point ):void
		{
		var $matrix:Matrix = $displayObject.transform.matrix;
				$matrix.translate( -$point.x, -$point.y );
				$matrix.rotate($angle *  (Math.PI / 180));
				$matrix.translate( $point.x, $point.y );
				$displayObject.transform.matrix = $matrix;
		}
		
		/**
		 * 重新排列显示对象的Matrix
		 * @param	$displayObject
		 */
		public static function  resetMatrix($displayObject:DisplayObject):void 
		{
			var $a:Number = Math.acos($displayObject.transform.matrix.a);
			var $b:Number = Math.asin($displayObject.transform.matrix.b);
			var $c:Number = Math.asin(-$displayObject.transform.matrix.c);
			var $d:Number = Math.acos($displayObject.transform.matrix.d);
			trace($a,$b,$c,$d);
				var $matrix:Matrix = new Matrix($a, $b, $c, $d, $displayObject.transform.matrix.tx, $displayObject.transform.matrix.ty);
					  $displayObject.transform.matrix = $matrix;
		}
	
	
	/********** [DINBOY] Say: Class The End  ************/	
	}
}