<#
$LastChangedBy: josullivan $
$LastChangedDate: 2015-02-10 11:07:24 +0000 (Tue, 10 Feb 2015) $
$Revision: 54112 $
#>

######################## Newsweaver API Calls #########################

$config = Import-CliXML nw-config.xml
$verboseMode = $config["VERBOSE_MODE"]

#If data is hosted in European Datacentre do not comment this out
#$base = 'https://api.newsweaver.com/v2/'

#If data is hosted in US Datacentre uncomment next line and comment out previous line
$base = 'https://api.us.newsweaver.com/v2/'

#Finds proxyserver from Regisitry Settings
$proxyAddress = (get-itemproperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings').ProxyServer

if($verboseMode -eq 'true')
{
    $verboseMode = $true
}
else
{
    $verboseMode = $false
}

# Create
Function nw_create($href,$account_code,$user,$password ,$post_data, $timeout, $useProxy=$false)
{    
    $buffer = [System.Text.Encoding]::UTF8.GetBytes($post_data)
	$url = $base + $account_code + $href
	
	#Test labs ONLY!
	#TODO: remove in production
	#[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
	
    [System.Net.HttpWebRequest] $webRequest = [System.Net.WebRequest]::Create($url)
    
	if($useProxy -eq $true) 
	{
		$proxyAddr = $proxyAddress
		$prox = new-object System.net.WebProxy
		$prox.Address = "http://"+$proxyAddr
		$prox.useDefaultCredentials = $true
		$webRequest.Proxy = $prox
	}
	
	# Need to set up HTTP basic authentication this is protected by HTTPS url
	$authInfo = $user + ":" + $password
	$authInfo_64 = convert_base_64 $authInfo
	$webRequest.Headers.Add('Authorization', "Basic " + $authInfo_64)

	$webRequest.Timeout = $timeout
    $webRequest.Method = "POST"
	$webRequest.Accept = "*/*"
	$webRequest.UserAgent = "Poppulo Integrations"
    $webRequest.ContentType = "application/xml ; charset=UTF-8"
    $webRequest.ContentLength = $buffer.Length;
	
    $requestStream = $webRequest.GetRequestStream()
    $requestStream.Write($buffer, 0, $buffer.Length)
    $requestStream.Flush()
    $requestStream.Close()
	
	try {
		[System.Net.HttpWebResponse] $webResponse = $webRequest.GetResponse()
	} 
	catch [System.Net.WebException] {
		$webResponse = $_.Exception.Response
	}

    $streamReader = New-Object System.IO.StreamReader($webResponse.GetResponseStream())
    $response_xml = $streamReader.ReadToEnd()
    $wait = $webResponse.Headers.Get('Retry-After')
	if ($wait) 
	{
		Write-Host "Whoops, hit the api limit. Waiting for $($wait) seconds!"
		Start-Sleep $wait 
	}
    return $response_xml
}

# Read / Get
function nw_get($href,$account_code,$user,$password,$timeout, $useProxy=$false)
{
	$url = $href
	
	#Test labs ONLY!
	#TODO: remove in production
	#[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
    [System.Net.HttpWebRequest] $webRequest = [System.Net.WebRequest]::Create($url)
    
	if($useProxy -eq $true) {
		$proxyAddr = $proxyAddress
		$prox = new-object System.net.WebProxy
		$prox.Address = "http://"+$proxyAddr
		$prox.useDefaultCredentials = $true
		$webRequest.Proxy = $prox
	}
	
	# Need to set up HTTP basic authentication this is protected by HTTPS url
	$authInfo = $user + ":" + $password
	$authInfo_64 = convert_base_64 $authInfo
	$webRequest.Headers.Add('Authorization', "Basic " + $authInfo_64)

    $webRequest.Method = "GET"
	$webRequest.Accept = "*/*"
	$webRequest.UserAgent = "ADSync"
    $webRequest.ContentType = "application/xml ; charset=UTF-8"
    $webRequest.ContentLength = 0

	try {
		[System.Net.HttpWebResponse] $webResponse = $webRequest.GetResponse()
	} 
	catch [System.Net.WebException] {
		$webResponse = $_.Exception.Response
	}

    $streamReader = New-Object System.IO.StreamReader($webResponse.GetResponseStream())
    $response_xml = $streamReader.ReadToEnd()
	$wait = $webResponse.Headers.Get('Retry-After')
	if ($wait) 
	{
		Write-Host "Whoops, hit the api limit. Waiting for $($wait) seconds!"
		Start-Sleep $wait 
	}
    return $response_xml
}

# Update
Function nw_update($href,$account_code,$user,$password ,$put_data, $timeout, $useProxy=$false)
{    
    $buffer = [System.Text.Encoding]::UTF8.GetBytes($put_data)
	$url = $base + $account_code + $href
	
	#Test labs ONLY!
	#TODO: remove in production
	#[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
    [System.Net.HttpWebRequest] $webRequest = [System.Net.WebRequest]::Create($url)
    
	if($useProxy -eq $true) {
		$proxyAddr = $proxyAddress
		$prox = new-object System.net.WebProxy
		$prox.Address = "http://"+$proxyAddr
		$prox.useDefaultCredentials = $true
		$webRequest.Proxy = $prox
	}
	
	# Need to set up HTTP basic authentication this is protected by HTTPS url
	$authInfo = $user + ":" + $password
	$authInfo_64 = convert_base_64 $authInfo
	$webRequest.Headers.Add('Authorization', "Basic " + $authInfo_64)

	$webRequest.Timeout = $timeout
    $webRequest.Method = "PUT"
	$webRequest.Accept = "*/*"
	$webRequest.UserAgent = "ADSync"
    $webRequest.ContentType = "application/xml ; charset=UTF-8"
    $webRequest.ContentLength = $buffer.Length;
	
    $requestStream = $webRequest.GetRequestStream()
    $requestStream.Write($buffer, 0, $buffer.Length)
    $requestStream.Flush()
    $requestStream.Close()
	
	try {
		[System.Net.HttpWebResponse] $webResponse = $webRequest.GetResponse()
	} 
	catch [System.Net.WebException] {
		$webResponse = $_.Exception.Response
	}

    $streamReader = New-Object System.IO.StreamReader($webResponse.GetResponseStream())
    $response_xml = $streamReader.ReadToEnd()
    $wait = $webResponse.Headers.Get('Retry-After')
	if ($wait) 
	{
		Write-Host "Whoops, hit the api limit. Waiting for $($wait) seconds!"
		Start-Sleep $wait 
	}
    return $response_xml
}

# Delete
Function nw_delete($href, $account_code, $user, $password, $delete_data, $timeout, $useProxy=$false)
{    
    $buffer = [System.Text.Encoding]::UTF8.GetBytes($delete_data)
	$url = $base + $account_code + $href
	
	#Test labs ONLY!
	#TODO: remove in production
	#[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
	
    [System.Net.HttpWebRequest] $webRequest = [System.Net.WebRequest]::Create($url)
	
	if($useProxy -eq $true)
	{
		$proxyAddr = $proxyAddress
		$prox = new-object System.net.WebProxy
		$prox.Address = "http://"+$proxyAddr
		$prox.useDefaultCredentials = $true
		$webRequest.Proxy = $prox
	}
	
	# Need to set up HTTP basic authentication this is protected by HTTPS url
	$authInfo = $user + ":" + $password
	$authInfo_64 = convert_base_64 $authInfo
	$webRequest.Headers.Add('Authorization', "Basic " + $authInfo_64)

	$webRequest.Timeout = $timeout
    $webRequest.Method = "DELETE"
	$webRequest.Accept = "*/*"
	$webRequest.UserAgent = "ADSync"
    $webRequest.ContentType = "application/xml ; charset=UTF-8"
    $webRequest.ContentLength = $buffer.Length;
	
    $requestStream = $webRequest.GetRequestStream()
    $requestStream.Write($buffer, 0, $buffer.Length)
    $requestStream.Flush()
    $requestStream.Close()
	
	try {
		[System.Net.HttpWebResponse] $webResponse = $webRequest.GetResponse()
	} 
	catch [System.Net.WebException] {
		$webResponse = $_.Exception.Response
	}

    $streamReader = New-Object System.IO.StreamReader($webResponse.GetResponseStream())
    $response_xml = $streamReader.ReadToEnd()
    $wait = $webResponse.Headers.Get('Retry-After')
	if ($wait) 
	{
		Start-Sleep $wait 
	}
    return $response_xml
}

############################ Utils ##################
# Funtion to convert string to base 
function convert_base_64($data) {
   $data_bytes   = [System.Text.Encoding]::UTF8.GetBytes($data);
   $data_encoded = [System.Convert]::ToBase64String($data_bytes); 
   return $data_encoded;
}