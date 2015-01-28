<?php

include 'platformConfig.php';
$Url ='https://graph.facebook.com/me';
$PlatformId = 105;
$public_key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAoICWb6WLvyWzl1ZS6Zxy6S3z0eGuFpyEvH5i4xNjGDDHWp4qRe5XSBziD70TL0YKziCF5dYjT1lsdsNSjOAVHjd8URSZFlt3HZyRQJw814K5pZFxW0d2ckgWpiU3JP2lSh9IEQUR8lp04Wa9N2dF08Xt4rmB2K0MvlPxk8NRLs3rg/S2NPM0kJoqQ8z73hDd0QboJAcYWgj85hbW7LNmwD9lEzXClbS2yurAd9yvbWWGLV9JV6LGGPq5MCm51HWezXodv6P7wTTelas7FF2EPiVkXQdZq6z2hb8lncNWbeUxpcFZgPwhbk65nGi0C4u46nDBUNArZH+4r9QN+gfknQIDAQAB";

error_log("fack book  here\n", 3, '/var/www/html/facebook.log');
if ($_GET['Act'] == 4){ //登陆处理
	$SessionId = $_GET['SessionId'];
    //error_log("ss=".$SessionId."\n", 3, '/var/www/html/facebook.log');
	$Res = request($Url, "access_token=".$SessionId, 'get');
	//error_log(print_r($Res,true)."\n", 3, '/var/www/html/facebook.log');
	if (0== $Res['result']){
		$Result = 0;
	}else{
		$Result = json_decode($Res['msg'], true);
		if ($Result['id']){
			$Result = $Result['id'];
			//error_log("uid=".$Result."\n", 3, '/var/www/html/facebook.log');
		}else{
			$Result = 0;
		}
	}
	echo $Result;
}else if (10 == $_GET['app']){
    error_log("Appios comes"."\n", 3, '/var/www/html/facebookTest.log');
    $Uin = $_GET['uid'];
    $ServerId = $_GET['serverID'];
	$ServerId = (int)$ServerId;
	$payMode = $_GET['mode'];
	error_log("uid=".$Uin.",serverId=".$ServerId.",data=".$_GET['data']."\n", 3, '/var/www/html/facebookTest.log');
	error_log("data=".print_r($_GET['data'],true)."\n", 3, '/var/www/html/facebookTest.log');

	$datas = $_GET['data'];
	//$datas = '{"details":{},"purchases":[{"receiptType":"GooglePlay","receipt":{"signedData":"{\"orderId\":\"12999763169054705758.1327984196675375\",\"packageName\":\"com.auer.wu.tw05\",\"productId\":\"auer.gp.xiawu_00600\",\"purchaseTime\":1410449647451,\"purchaseState\":0,\"purchaseToken\":\"aincacfofoaildlkanppcnfd.AO-J1OyNFTTB5rXaAh7BNUOa1Jf8wRtJQgJ92kjUK06xsESVADMNIRwkKwS3xdJ_EZoLjkzQNZqShNIo8a6ktSXVGli0o7ivgM5lHx9ZEzV6-mJUMqJUNzh3XA0Y6YbGjYdrdLDpmHp8\"}","signature":"Cdf8pvQAXlqESFEooAGxphRzfQ6gWxTxuyf6DF9nNSCjmV2IY d0JOkSwnAg0fDKMrRMycMpZ\/R4dZPIvA9PZ4nXoubOUd4ULYdIPZssn8PwpwgGvVSRBXSpGwth8QHPOaLifszw4BNtDQ8Z4AR23 zFntf9sCnXJw86g8qjZPj6ZI2TaXa6Tei4ONAmyWoSnLbabYPykoO6ERTRZhYvdUhCuQTCn xurMxXZpMWexbys Ol7Zoqe4VB\/SyfPYJwP2R0\/l0f17XQbnWPcBdclqxqprurJXM8C85ybdQTOsKxy9ec2 Rjz\/TEaHKuMMCTj15at02hdjjN1uYUpm4luA=="},"productId":"auer.gp.xiawu_00600"}]}';
    //$datas = '{"receiptType":"GooglePlay","receipt":{"signedData":"{\"orderId\":\"12999763169054705758.1343485794944689\",\"packageName\":\"com.auer.wu.tw05\",\"productId\":\"auer.gp.xiawu_00300\",\"purchaseTime\":1410456731475,\"purchaseState\":0,\"purchaseToken\":\"aoilfmiflifeiaacfhkbooll.AO-J1Oxq2HnQ99oRsAH3FOk1deCuXmBMR7-HiiKyh64rDqggIY87l7YhRbyJWBArwPN3yvMhsYVQeBGT7VBvhm_8fQ719ZnXrZMbZXeivOqQxX7k2KRDSbeIBNFJrC_nt5sotioB7dZh\"}","signature":"YAvPkztWIiK2Tj0m\/Iy1CBPxa0lgtmIR84\/kXh5fggotQovIpV5JKqB3fXl5gysL9XCTtqwBWEBAGj5hducGtaTkgmKJzE mWGQ7ezL0VNAC\/mBq7ycxOT99\/6pKsqmbu AwiUmzaiZKecK0KIHrKTzwSvJkLg8KZlf\/VlKb5\/tJeift4veC9 djLLie4l5u01jD7XZ\/QzvRTVTgsAgSkTnkZW\/JPapdQf\/XwOcsPBItHBJc4Y7GJYiY8GqXD5qIi8R7hBltwS5vhW8hj5ifUTCZgKnanUlTrWJLBesGbD6xgUCLCusljUbFhd8nN3xtDVEjqR0iWRAiCa4tgbwYaQ=="},"productId":"auer.gp.xiawu_00300"}';
   
	$count = strpos( $datas, '"details":{},"purchases":[{"receiptType');


	$count1 = strpos( $datas, '"receiptType":"GooglePlay"');

    if ($count1==1) {
         deal_market($datas,$public_key,$Uin,$ServerId,$PlatformId,$MyServerUrl,$payMode);
    }


	if ($count==1) {		

			
		$startIndex = 0;
		$endIndex = 0;
        $nn=0;
		while(strpos($datas,'{"receiptType":') != false){
			$startIndex = strpos($datas,'{"receiptType":');
			if(strpos($datas,'},{')!=false)
			{
				$endIndex = strpos($datas,'},{');
			}else{
				$endIndex = strpos($datas,'}]}');
			}
			$i = substr($datas,$startIndex+1, $endIndex-$startIndex);
			$i = "{".$i;

            deal_market($i,$public_key,$Uin,$ServerId,$PlatformId,$MyServerUrl,$payMode);

	        $datas = str_replace($i, "",$datas);
	        $nn++;
	        if($nn>8) return;
		}
    }
	
}else if (1 == $_GET['app']){
    error_log("Appios comes"."\n", 3, '/var/www/html/facebook.log');
    $Uin = $_GET['uid'];
    $ServerId = $_GET['serverID'];
	$ServerId = (int)$ServerId;
	$payMode = $_GET['mode'];
	error_log("uid=".$Uin.",serverId=".$ServerId.",data=".$_GET['data']."\n", 3, '/var/www/html/facebook.log');
	error_log("data=".print_r($_GET['data'],true)."\n", 3, '/var/www/html/facebook.log');
	$parr = Array(
		"auer.gp.xiawu_00060"=>30,
		"auer.gp.xiawu_00300"=>150,
		"auer.gp.xiawu_00600"=>300,
		"auer.gp.xiawu_01200"=>590,
		"auer.gp.xiawu_01920"=>960,
		"auer.gp.xiawu_04200"=>2090,
		"auer.gp.xiawu_06000"=>2990,
		);
	$data = $_GET['data']; 
	$googleData = json_decode($data,true);
	$ggd = str_replace(" ","+",$googleData['receipt']['signature']);
	$signData = json_decode($googleData['receipt']['signedData'],true);
	error_log("test=".print_r($signData,true)."\n", 3, '/var/www/html/facebook.log');
	$OrderID = $signData['orderId'];
	$prouctID = $googleData['productId'];
	$Money = $parr[$prouctID];
    if($signData['purchaseState']==0)
	{
	   error_log( "pay  verify pass......\n", 3, '/var/www/html/facebook.log');
	   $backs = verify_market_in_app($googleData['receipt']['signedData'],$ggd,$public_key,$Uin,$ServerId,$PlatformId,$OrderID,$Money,$MyServerUrl,$payMode);
	   if($backs==true)
	   {
	      echo "1";
	   }else{
	      echo "0";
	   }
	}else{
	   echo "0";
	}	
}else if (11 == $_GET['app']){
    error_log("Appios comes"."\n", 3, '/var/www/html/facebook.log');
    $Uin = $_GET['uid'];
    $ServerId = $_GET['serverID'];
	$ServerId = (int)$ServerId;
	$payMode = $_GET['mode'];
	error_log("uid=".$Uin.",payMode=".$payMode.",serverId=".$ServerId.",data=".$_GET['data']."\n", 3, '/var/www/html/facebook.log');
	error_log("data=".print_r($_GET['data'],true)."\n", 3, '/var/www/html/facebook.log');

	$datas = $_GET['data'];
	//$datas = '{"details":{},"purchases":[{"receiptType":"GooglePlay","receipt":{"signedData":"{\"orderId\":\"12999763169054705758.1327984196675375\",\"packageName\":\"com.auer.wu.tw05\",\"productId\":\"auer.gp.xiawu_00600\",\"purchaseTime\":1410449647451,\"purchaseState\":0,\"purchaseToken\":\"aincacfofoaildlkanppcnfd.AO-J1OyNFTTB5rXaAh7BNUOa1Jf8wRtJQgJ92kjUK06xsESVADMNIRwkKwS3xdJ_EZoLjkzQNZqShNIo8a6ktSXVGli0o7ivgM5lHx9ZEzV6-mJUMqJUNzh3XA0Y6YbGjYdrdLDpmHp8\"}","signature":"Cdf8pvQAXlqESFEooAGxphRzfQ6gWxTxuyf6DF9nNSCjmV2IY d0JOkSwnAg0fDKMrRMycMpZ\/R4dZPIvA9PZ4nXoubOUd4ULYdIPZssn8PwpwgGvVSRBXSpGwth8QHPOaLifszw4BNtDQ8Z4AR23 zFntf9sCnXJw86g8qjZPj6ZI2TaXa6Tei4ONAmyWoSnLbabYPykoO6ERTRZhYvdUhCuQTCn xurMxXZpMWexbys Ol7Zoqe4VB\/SyfPYJwP2R0\/l0f17XQbnWPcBdclqxqprurJXM8C85ybdQTOsKxy9ec2 Rjz\/TEaHKuMMCTj15at02hdjjN1uYUpm4luA=="},"productId":"auer.gp.xiawu_00600"}]}';
    //$datas = '{"receiptType":"GooglePlay","receipt":{"signedData":"{\"orderId\":\"12999763169054705758.1343485794944689\",\"packageName\":\"com.auer.wu.tw05\",\"productId\":\"auer.gp.xiawu_00300\",\"purchaseTime\":1410456731475,\"purchaseState\":0,\"purchaseToken\":\"aoilfmiflifeiaacfhkbooll.AO-J1Oxq2HnQ99oRsAH3FOk1deCuXmBMR7-HiiKyh64rDqggIY87l7YhRbyJWBArwPN3yvMhsYVQeBGT7VBvhm_8fQ719ZnXrZMbZXeivOqQxX7k2KRDSbeIBNFJrC_nt5sotioB7dZh\"}","signature":"YAvPkztWIiK2Tj0m\/Iy1CBPxa0lgtmIR84\/kXh5fggotQovIpV5JKqB3fXl5gysL9XCTtqwBWEBAGj5hducGtaTkgmKJzE mWGQ7ezL0VNAC\/mBq7ycxOT99\/6pKsqmbu AwiUmzaiZKecK0KIHrKTzwSvJkLg8KZlf\/VlKb5\/tJeift4veC9 djLLie4l5u01jD7XZ\/QzvRTVTgsAgSkTnkZW\/JPapdQf\/XwOcsPBItHBJc4Y7GJYiY8GqXD5qIi8R7hBltwS5vhW8hj5ifUTCZgKnanUlTrWJLBesGbD6xgUCLCusljUbFhd8nN3xtDVEjqR0iWRAiCa4tgbwYaQ=="},"productId":"auer.gp.xiawu_00300"}';
   
	$count = strpos( $datas, '"details":{},"purchases":[{"receiptType');


	$count1 = strpos( $datas, '"receiptType":"GooglePlay"');

    if ($count1==1) {
         deal_market($datas,$public_key,$Uin,$ServerId,$PlatformId,$MyServerUrl,$payMode);
    }


	if ($count==1) {		

			
		$startIndex = 0;
		$endIndex = 0;
        $nn=0;
		while(strpos($datas,'{"receiptType":') != false){
			$startIndex = strpos($datas,'{"receiptType":');
			if(strpos($datas,'},{')!=false)
			{
				$endIndex = strpos($datas,'},{');
			}else{
				$endIndex = strpos($datas,'}]}');
			}
			$i = substr($datas,$startIndex+1, $endIndex-$startIndex);
			$i = "{".$i;

            deal_market11($i,$public_key,$Uin,$ServerId,$PlatformId,$MyServerUrl,$payMode);

	        $datas = str_replace($i, "",$datas);
	        $nn++;
	        if($nn>8) return;
		}
    }
	
}


function deal_market11($data,$public_key,$Uin,$ServerId,$PlatformId,$MyServerUrl,$payMode)
{
	$parr = Array(
		"auer.gp.xiawu_00060"=>30,
		"auer.gp.xiawu_00300"=>150,
		"auer.gp.xiawu_00600"=>300,
		"auer.gp.xiawu_01200"=>590,
		"auer.gp.xiawu_01920"=>960,
		"auer.gp.xiawu_04200"=>2090,
		"auer.gp.xiawu_06000"=>2990,
		);
	error_log("data=".$data."\n", 3, '/var/www/html/facebook.log');
	$googleData = json_decode($data,true);
	error_log("test=".print_r($googleData,true)."\n", 3, '/var/www/html/facebook.log');
	$ggd = str_replace(" ","+",$googleData['receipt']['signature']);

	//$ggd = str_replace(" ","+",$googleData['receipt']['signature']);
	$signData = json_decode($googleData['receipt']['signedData'],true);
	error_log("test=".print_r($signData,true)."\n", 3, '/var/www/html/facebook.log');
	$OrderID = $signData['orderId'];
	$prouctID = $googleData['productId'];
	$Money = $parr[$prouctID];
    if($signData['purchaseState']==0)
	{
	   error_log( "pay  verify pass......\n", 3, '/var/www/html/facebook.log');
	   $backs = verify_market_in_app($googleData['receipt']['signedData'],$ggd,$public_key,$Uin,$ServerId,$PlatformId,$OrderID,$Money,$MyServerUrl,$payMode);
	   if($backs==true)
	   {
	   	  error_log( "back:".$data."\n", 3, '/var/www/html/facebook.log');
	      echo $data;
	   }else{
	      error_log( "back:0"."\n", 3, '/var/www/html/facebook.log');
	      echo "0";
	   }
	}else{
	   error_log( "back:1"."\n", 3, '/var/www/html/facebook.log');
	   echo "0";
	}
}

function deal_market($data,$public_key,$Uin,$ServerId,$PlatformId,$MyServerUrl,$payMode)
{
	$parr = Array(
		"auer.gp.xiawu_00060"=>30,
		"auer.gp.xiawu_00300"=>150,
		"auer.gp.xiawu_00600"=>300,
		"auer.gp.xiawu_01200"=>590,
		"auer.gp.xiawu_01920"=>960,
		"auer.gp.xiawu_04200"=>2090,
		"auer.gp.xiawu_06000"=>2990,
		);
	error_log("data=".$data."\n", 3, '/var/www/html/facebookTest.log');
	$googleData = json_decode($data,true);
	error_log("test=".print_r($googleData,true)."\n", 3, '/var/www/html/facebookTest.log');
	$ggd = str_replace(" ","+",$googleData['receipt']['signature']);

	//$ggd = str_replace(" ","+",$googleData['receipt']['signature']);
	$signData = json_decode($googleData['receipt']['signedData'],true);
	error_log("test=".print_r($signData,true)."\n", 3, '/var/www/html/facebookTest.log');
	$OrderID = $signData['orderId'];
	$prouctID = $googleData['productId'];
	$Money = $parr[$prouctID];
    if($signData['purchaseState']==0)
	{
	   error_log( "pay  verify pass......\n", 3, '/var/www/html/facebookTest.log');
	   $backs = verify_market_in_app($googleData['receipt']['signedData'],$ggd,$public_key,$Uin,$ServerId,$PlatformId,$OrderID,$Money,$MyServerUrl,$payMode);
	   if($backs==true)
	   {
	      echo $data;
	   }else{
	      echo "0";
	   }
	}else{
	   echo "0";
	}
}

function verify_market_in_app($signed_data, $signature, $public_key_base64,$Uin,$ServerId,$PlatformId,$OrderID,$Money,$MyServerUrl,$payMode) 
{

    error_log( $signed_data."\n", 3, '/var/www/html/facebookTest.log');
	error_log( $signature."\n", 3, '/var/www/html/facebookTest.log');
	error_log( $public_key_base64."\n", 3, '/var/www/html/facebookTest.log');
	$key =	"-----BEGIN PUBLIC KEY-----\n".
		chunk_split($public_key_base64, 64,"\n").
		'-----END PUBLIC KEY-----';   
	//using PHP to create an RSA key
	$key = openssl_get_publickey($key);
	//$signature should be in binary format, but it comes as BASE64. 
	//So, I'll convert it.
	$signature = base64_decode($signature);   
	//using PHP's native support to verify the signature
	$result = openssl_verify(
			$signed_data,
			$signature,
			$key,
			OPENSSL_ALGO_SHA1);

	error_log( 'result:'.$result."\n", 3, '/var/www/html/facebookTest.log');
	if (0 === $result) 
	{
		return false;
	}
	else if (1 !== $result)
	{
		return false;
	}
	else 
	{
		$yuanbao = Array(
			"30"=>60,
			"150"=>315,
			"300"=>630,
			"590"=>1300,
			"960"=>2115,
			"2090"=>4810,
			"2990"=>6900
		);
	    $mon2 =  $yuanbao[$Money];
		$Money = $Money*100;
		$Params = "true,pay_1.3.0,".$Uin.",".$ServerId.",".$PlatformId.",".$OrderID.",".$mon2.",".$Money.",".$payMode.",android";
		error_log( $Params."\n", 3, '/var/www/html/facebook.log');
		$Params = trim($Params);
		$Res = request($MyServerUrl, $Params, 'get'); // 通知列表服务�?有人充�?
		if (false === $Res['result']){
		   return false;
		}else{
			if ("ok" === $Res['msg']){
				return true;
			}else{
				return false;
			}
		}
		
	}
} 

?>