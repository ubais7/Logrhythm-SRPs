 
 #create adminapi with readlog access https://duo.com/docs/adminapi
 $apihost='xxxx'
 $apiuri='/admin/v2/logs/authentication'
 $iKey='xxxx'
 $sKey='xxxx'

 #frequency in minutes, so as per your log size, keep accordingly 
 #so run this script in task scheduler for each 5 mins, then keep same frequency to fetch last 5 mins value

 $frequency=5
 #any logrhythm system monitor agent listening for syslog
 $syslogserver="xxxxx"
 #host IP in sylogs message - actually not having any use :p 
 $sysloghost="143.204.113.123"

 #keep none if you dont need proxy to connect internet, or configure as http://proxy:port 

 $proxy="none"

 $time=[int64](([datetime]::UtcNow)-(get-date "1/1/1970")).TotalMilliseconds
 $maxtime=$time
 $mintime=$time- $frequency * 60 * 1000


$HashTable = @{
"maxtime"= $maxtime
"mintime"= $mintime
"limit"="1000"
"sort"="ts:asc"
 }



 function Send-UdpDatagram
{
      Param ([string] $EndPoint, 
      [int] $Port, 
      [string] $Message)

      $IP = [System.Net.Dns]::GetHostAddresses($EndPoint) 
      $Address = [System.Net.IPAddress]::Parse($IP) 
      $EndPoints = New-Object System.Net.IPEndPoint($Address, $Port) 
      $Socket = New-Object System.Net.Sockets.UDPClient 
      $EncodedText = [Text.Encoding]::ASCII.GetBytes($Message) 
      $SendMessage = $Socket.Send($EncodedText, $EncodedText.Length, $EndPoints) 
      $Socket.Close() 
} 


function New-duoRequest(){
    param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
            [ValidateNotNull()]
            $apiHost,
        
        [Parameter(Mandatory=$true,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
            [ValidateNotNull()]
            $apiEndpoint,
        
        [Parameter(Mandatory=$true,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
            [ValidateNotNull()]
            $apiKey,
        
        [Parameter(Mandatory=$true,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
            [ValidateNotNull()]
            $apiSecret,
        
        [Parameter(Mandatory=$false,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
            [ValidateNotNull()]
            $requestMethod = 'GET',
        
        [Parameter(Mandatory=$false,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
            [ValidateNotNull()]
            [System.Collections.Hashtable]$requestParams
    )

    $date = (Get-Date).ToUniversalTime().ToString("ddd, dd MMM yyyy HH:mm:ss -0000")

    $formattedParams = ($requestParams.Keys | Sort-Object | ForEach-Object {$_ + "=" + [uri]::EscapeDataString($requestParams.$_)}) -join "&"
    
    #DUO Params formatted and stored as bytes with StringAPIParams
    $requestToSign = (@(
        $Date.Trim(),
        $requestMethod.ToUpper().Trim(),
        $apiHost.ToLower().Trim(),
        $apiEndpoint.Trim(),
        $formattedParams
    ).trim() -join "`n").ToCharArray().ToByte([System.IFormatProvider]$UTF8)

    #Hash out some secrets 
    $hmacsha1 = New-Object System.Security.Cryptography.HMACSHA1
    $hmacsha1.key=($apiSecret.ToCharArray().ToByte([System.IFormatProvider]$UTF8))
    $hmacsha1.ComputeHash($requestToSign) | Out-Null
    $authSignature = [System.BitConverter]::ToString($hmacsha1.Hash).Replace("-", "").ToLower()

    #Create the Authorization Header
    $authHeader = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(('{0}:{1}' -f $apiKey, $authSignature)))

    #Create our Parameters for the webrequest - Easy @Splatting!
    $httpRequest = @{
        URI         = ('https://{0}{1}' -f $apiHost, $apiEndpoint)
        Headers     = @{
            "X-Duo-Date"    = $Date
            "Authorization" = "Basic: $authHeader"
        }
        Body = $requestParams
        Method      = $requestMethod
        ContentType = 'application/x-www-form-urlencoded'
    }
    
    $httpRequest
}







$EpochStart = Get-Date 1970-01-01T00:00:00


 $Request = New-DuoRequest -apiHost $apihost -apiEndpoint $apiuri -apiKey $iKey -apiSecret $sKey -requestParams $HashTable
 if ($proxy -eq "none"){
 $results=Invoke-RestMethod @Request
 }
 else
 {
 $results=Invoke-RestMethod @Request -Proxy $proxy
 }

 foreach ( $log in $results.response.authlogs )
  {
  $time_of_log=$EpochStart.AddSeconds($log.timestamp)
  $output=$time_of_log.Day.ToString()+" "+ $time_of_log.Month.ToString()+" "+ $time_of_log.Year.ToString()+" "+ $time_of_log.Hour.ToString()+":"+ $time_of_log.Minute.ToString()+":"+ $time_of_log.Second.ToString()+" "+$sysloghost+" utc=`""+$log.timestamp+"`" user=`""+$log.user.name+"`" type=`""+$log.event_type+"`" auth_device_ip=`""+$log.auth_device.ip+"`" factor=`""+$log.factor+"`" reason=`""+$log.reason+"`" result=`""+$log.result+"`" email=`""+$log.email+"`" app=`""+$log.application.name+"`" dhost=`""+$log.auth_device.hostname+"`"`n" 
  Send-UdpDatagram -EndPoint $syslogserver -Port 514 -Message $output
  
  }