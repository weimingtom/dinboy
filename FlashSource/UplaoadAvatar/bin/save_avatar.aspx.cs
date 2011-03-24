using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.IO;

namespace dinboy
{
    public partial class save_avatar : System.Web.UI.Page
    {
        
        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {
                try
                {
                    Response.Expires = 0;
                    Response.CacheControl = "private";
                    //这里传过来会有两种类型，一先一后, big和small, 
                    //保存成功后返回一个json字串，客户端会再次post下一个.
                   // string type = Request["type"].Trim();
                   // string pic_id = Request["photoId"].Trim();
                    //string orgin_pic_path = Request["photoServer"].Trim();//原始图片地址，备用.
                    //string from = Request["from"].Trim();//原始图片地址，备用.
                    //生成图片存放路径
                   // string new_avatar_path = "avatar_" + type + "/" + pic_id + "_" + type + ".jpg";

                    string path = "uploadFile/" + DateTime.Now.Year + "/" + DateTime.Now.Month + "/" + DateTime.Now.Day+"/";
                    string creatPath = System.Web.HttpContext.Current.Server.MapPath(path).ToString();
                    if (!Directory.Exists(creatPath))
                        Directory.CreateDirectory(creatPath);
                    string new_avatar_path = path + DateTime.Now.Hour + DateTime.Now.Minute + DateTime.Now.Second + ".jpg";
                    //将POST过来的二进制数据直接写入图片文件.
                    int len = Request.ContentLength;
                    byte[] Imgbtye = Request.BinaryRead(len);
                    MemoryStream buf = new MemoryStream(Imgbtye);
                    System.Drawing.Image save_img = System.Drawing.Image.FromStream(buf, true);
                    
                    save_img.Save(Server.MapPath(new_avatar_path));

                    //原始图片比较大，压缩一下. 效果还是很明显的, 使用80%的压缩率肉眼基本没有什么区别
                    //小图片 不压缩约6K, 压缩后 2K, 大图片约 50K, 压缩后 10K
                    //string avtar_img = imagecreatefromjpeg(SD_ROOT.'./'.$new_avatar_path);
                    //imagejpeg($avtar_img,SD_ROOT.'./'.$new_avatar_path,80);
                    //nix系统下有必要时可以使用 chmod($filename,$permissions);
                    
                    // {"data":{"urls":["\/avatar_test\/avatar_small\/1280381779_small.jpg"]},"status":1,"statusText":"\u4e0a\u4f20\u6210\u529f!"}
                    
                    //string json = "{\"data\":{\"urls\":[\"\\/avatar_test\\/avatar_small\\/1280381779_small.jpg\"]},";
                    //json += "\"status\":1,\"statusText\":\"\u4e0a\u4f20\u6210\u529f!\"}";
                    //Response.Write(json);
                    string xmlResponse;
                    xmlResponse="<?xml version=\"1.0\" encoding=\"utf-8\"?>";
                    xmlResponse+="<data>";
                    xmlResponse+="<filepath><![CDATA[";
                    xmlResponse+=new_avatar_path;
                    xmlResponse+="]]></filepath>";
                    xmlResponse+="<message><![CDATA[";
                    xmlResponse+=Request["dead"]+"<br />"+Request["time"]+"<br />"+Request["address"];
                    xmlResponse+="]]></message>";
                    xmlResponse+="</data>";
                    Response.Write(xmlResponse);
                }
                catch (Exception ex)
                {
                    Response.Write("操作失败：" + ex.Message);
                }
            }
        }
         
        
        /*

//将POST过来的二进制数据直接写入图片文件.
$len = file_put_contents(SD_ROOT.'./'.$new_avatar_path,file_get_contents("php://input"));

//原始图片比较大，压缩一下. 效果还是很明显的, 使用80%的压缩率肉眼基本没有什么区别
//小图片 不压缩约6K, 压缩后 2K, 大图片约 50K, 压缩后 10K
$avtar_img = imagecreatefromjpeg(SD_ROOT.'./'.$new_avatar_path);
imagejpeg($avtar_img,SD_ROOT.'./'.$new_avatar_path,80);
//nix系统下有必要时可以使用 chmod($filename,$permissions);

log_result('图片大小: '.$len);


//输出新保存的图片位置, 测试时注意改一下域名路径, 后面的statusText是成功提示信息.
//status 为1 是成功上传，否则为失败.
$d = new pic_data();
//$d->data->urls[0] = 'http://sns.com/avatar_test/'.$new_avatar_path;
$d->data->urls[0] = '/avatar_test/'.$new_avatar_path;
$d->status = 1;
$d->statusText = '上传成功!';

$msg = json_encode($d);

echo $msg;

log_result($msg);
function  log_result($word) {
	@$fp = fopen("log.txt","a");	
	@flock($fp, LOCK_EX) ;
	@fwrite($fp,$word."：执行日期：".strftime("%Y%m%d%H%I%S",time())."\r\n");
	@flock($fp, LOCK_UN); 
	@fclose($fp);
}
class pic_data
{
	 public $data;
	 public $status;
	 public $statusText;
	public function __construct()
	{
		$this->data->urls = array();
	}
}

?>
         */
    }
}

