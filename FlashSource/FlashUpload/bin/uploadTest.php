<?php
/*=======================================================================*\
	此页可获取到的参数有：
	$_GET['oldName'];            原图片名称 不带后缀
	$_GET['newName'];            图片新名称 格式：200911231513105691.jpg （日期+4位随机数）
	
	$_FILES['Filedata'];         File数组

	$_GET['参数名称'];           获取参数
\*=======================================================================*/
//获取名称;
//$oldName_f=$_GET['oldName'];
$newName_f=time().rand(0,10000).".jpg";

//获取自定义的参数 get方式获取地址参数
//$haha=$_GET['haha'];
//$hehe=$_GET['hehe'];

if(empty($_FILES['Filedata'])) {
	echo '<script type="text/javascript">alert("对不起, 图片未上传成功, 请再试一下");</script>';
	exit();
}
//获取file数组
$f=$_FILES['Filedata'];

//设定上传目录
$dir='avatar_origin';

//上传文件临时文件名称
$tmpName=$f['tmp_name'];

//把临时文件以新的名称保存到指定的目录
move_uploaded_file($f['tmp_name'],$dir.'/'.$newName_f);
?>