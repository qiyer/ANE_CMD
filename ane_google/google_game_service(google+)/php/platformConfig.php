<?php 
error_reporting(0);
$MyServerUrl = "http://localhost:8080/pay";
$MyServerLoginUrl = "http://localhost:8080/login";

$_SERVER['MY_PAY_URL'] = $MyServerUrl;
$_SERVER['MY_LOGIN_URL'] = $MyServerLoginUrl;

function request($Url, $Params, $Method='post',$header=null,$sign=null)
{
    $SS ="?";
	if($sign) $SS = $sign;
	$Curl = curl_init();//初始化curl
	
	if ('get' == $Method){//以GET方式发送请求
		curl_setopt($Curl, CURLOPT_URL, $Url.$SS.$Params);
	}else{//以POST方式发送请求
		curl_setopt($Curl, CURLOPT_URL, $Url);
		curl_setopt($Curl, CURLOPT_POST, 1);//post提交方式
		curl_setopt($Curl, CURLOPT_POSTFIELDS, $Params);//设置传送的参数
		if($header)
		{
		   curl_setopt($Curl, CURLOPT_HTTPHEADER, $header);
		}
	}

	curl_setopt($Curl, CURLOPT_HEADER, false);//设置header
	curl_setopt($Curl, CURLOPT_RETURNTRANSFER, true);//要求结果为字符串且输出到屏幕上
	curl_setopt($Curl, CURLOPT_CONNECTTIMEOUT, 3);//设置等待时间
	curl_setopt($Curl, CURLOPT_SSL_VERIFYPEER, FALSE);//支持https链接
    curl_setopt($Curl, CURLOPT_SSL_VERIFYHOST, false);//支持https链接
	curl_setopt($Curl, CURLOPT_IPRESOLVE, CURL_IPRESOLVE_V4);//设置默认访问IPv4

	$Res = curl_exec($Curl);//运行curl
	$Err = curl_error($Curl);
  	if (false === $Res || !empty($Err)){
  		$Errno = curl_errno($Curl);
  		$Info = curl_getinfo($Curl);
  		curl_close($Curl);
  		return array('result' => false,'errno' => $Errno,'msg' => $Err,'info' => $Info);
  	}
  	curl_close($Curl);
  	return array('result' => true,'msg' => $Res);
  }
  
class AS3
{
    public static $LogNames = 'log';
	public static $IsDebug = true;
	
	public static function trace($Params,$LogName=null)
	{
	  if(self::$IsDebug)
	  {
	    $newName = self::$LogNames;
	    if($LogName)
		$newName = $LogName;
		error_log($Params."\n", 3, '/var/www/html/'.$newName.'.log');
	  }
	}
} 

?>