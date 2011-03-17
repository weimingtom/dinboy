<?php
/**
头像数据将使用ByteArrayPost到这个页面 , 然后该页面使用系统函数进行数据重组, 输入到图片文件.
图片生成后生成XML数据,
	filepath:图片的路径(如:uploadFile / 20110309085814553.jpg)
	message:返回需要输出的信息(如:创建日期<br/>创建者<br />)
	photoid:图片的ID号
*/
@header("Expires: 0");
@header("Cache-Control: private, post-check=0, pre-check=0, max-age=0", FALSE);
@header("Pragma: no-cache");
$dead = $_GET['dead'];
$time=$_GET['time'];
$address=$_GET['address'];
$uploaddir = 'uploadFile/';
$filename = date("Ymdhis").rand(100, 999).".jpg";
$new_avatar_path=$uploaddir.$filename;
$len = file_put_contents($new_avatar_path,file_get_contents("php://input"));
if($len) {
@header("Content-Type: text/xml");
echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>
<data>
	<filepath><![CDATA[$new_avatar_path]]></filepath>
    <message><![CDATA[$dead<br />$time<br />$address]]></message>
    <photoid><![CDATA[00]]></photoid>
</data>";
}
?>