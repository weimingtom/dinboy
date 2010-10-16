package com.dinboy.crypto{  
          
        import com.dinboy.util.StringUtil;  
         
        public class XXTEA{  
                  
                public function XXTEA(){  
                        throw new Error("XXTEA class is static container only");  
                }  
                
				/**
				 * 将长整形转换成字符串
				 * @param	v 长整形数组
				 * @param	w
				 * @return  转换完成的字符串
				 */
                private static function long2str(v:Array,w:Boolean):String {  
                        var vl:uint = v.length;  
                        var sl:uint = v[vl - 1] & 0xffffffff;  
                        for (var i:uint = 0; i < vl; i++){  
                                v[i] = String.fromCharCode(v[i] & 0xff,  
                                                           v[i] >>> 8 & 0xff,  
                               v[i] >>> 16 & 0xff,  
                                v[i] >>> 24 & 0xff);  
                        }  
                        if(w){  
                              return v.join('').substring(0, sl);  
                        }  
                        else {  
                                return v.join('');  
                        }  
                }  
                 
				/**
				 * 将字符串转换成长整形
				 * @param	s 需要转换的字符串
				 * @param	w 
				 * @return 转换完成的数组
				 */
               private static function str2long(s:String,w:Boolean):Array {  
                       var len:uint = s.length;  
                        var v:Array = new Array();  
                        for (var i:uint = 0; i < len; i += 4){  
                               v[i >> 2] = s.charCodeAt(i)  
                                | s.charCodeAt(i + 1) << 8  
                                | s.charCodeAt(i + 2) << 16  
                                | s.charCodeAt(i + 3) << 24;  
                        }  
                        if (w) {  
                                v[v.length] = len;  
                        }  
                        return v;  
                }  
                 
				 /**
				  * 加密函数
				  * @param	char 需要加密的字符串
				  * @param	key	加密使用密匙
				  * @return 返回加密好的字符串
				  */
                public static function encrypt(char:String,key:String):String{  
                        if(char == ""){  
                                return "";  
                        }  
                        var v:Array = str2long(StringUtil.utf16to8(char), true);  
                       var k:Array = str2long(key, false);  
                        var n:uint = v.length - 1;  
                          
                        var z:Number = v[n];  
                        var y:Number = v[0];  
                        var delta:Number = 0x9E3779B9;  
                        var mx:Number;  
                        var q:Number = Math.floor(6 + 52 / (n + 1))  
                        var sum:Number = 0;  
                        while (q-- > 0) {  
                                sum = sum + delta & 0xffffffff;  
                                var e:Number = sum >>> 2 & 3;  
                                for (var p:uint = 0; p < n; p++) {  
                                        y = v[p + 1];  
                                        mx = (z >>> 5 ^ y << 2) + (y >>> 3 ^ z << 4) ^ (sum ^ y) + (k[p & 3 ^ e] ^ z);  
                                        z = v[p] = v[p] + mx & 0xffffffff;  
                                }  
                                y = v[0];  
                                mx = (z >>> 5 ^ y << 2) + (y >>> 3 ^ z << 4) ^ (sum ^ y) + (k[p & 3 ^ e] ^ z);  
                                z = v[n] = v[n] + mx & 0xffffffff;  
                        }  
                        return long2str(v, false);  
                }  
                  
				/**
				 * 解密函数
				 * @param	char 需要解密的字符串
				 * @param	key 解密需要的密匙
				 * @return 返回解密好的字符串
				 */
                public static function decrypt(char:String,key:String):String{  
                        if (char == "") {  
                                return "";  
                        }  
                        var v:Array = str2long(char, false);  
                        var k:Array = str2long(key, false);  
                        var n:uint = v.length - 1;  
                          
                        var z:Number = v[n - 1];  
                        var y:Number = v[0];  
                        var delta:Number = 0x9E3779B9;  
                        var mx:Number;  
                        var q:Number = Math.floor(6 + 52 / (n + 1));  
                        var sum:Number = q * delta & 0xffffffff;  
                     while (sum != 0) {  
                                var e:Number = sum >>> 2 & 3;  
                                for (var p:uint = n; p > 0; p--) {  
                                        z = v[p - 1];  
                                       mx = (z >>> 5 ^ y << 2) + (y >>> 3 ^ z << 4) ^ (sum ^ y) + (k[p & 3 ^ e] ^ z);  
                                        y = v[p] = v[p] - mx & 0xffffffff;  
                                }  
                                z = v[n];  
                                mx = (z >>> 5 ^ y << 2) + (y >>> 3 ^ z << 4) ^ (sum ^ y) + (k[p & 3 ^ e] ^ z);  
                                y = v[0] = v[0] - mx & 0xffffffff;  
                                sum = sum - delta & 0xffffffff;  
                        }  
                          
                       return StringUtil.utf8to16(long2str(v, true));  
                }  
        }  
}  