# Send msg to telgram by ubais
param(
    
    [Parameter(Mandatory=$true)][string]$channelid,
    [Parameter(Mandatory=$true)][string]$apikey,
    [Parameter(Mandatory=$true)][string]$message,
    [string]$pp1,
    [string]$pp2,
    [string]$pp3,
    [string]$pp4,
    [string]$proxy,
    [string]$cred
)

trap [Exception] {
write-error $("TRAPPED: " + $_)
exit 1
}

$command=$message

if($pp1) { $command=$command -replace "#param1#",$pp1 } 
if($pp2) { $command=$command -replace "#param2#",$pp2 } 
if($pp3) { $command=$command -replace "#param3#",$pp3 }
if($pp4) { $command=$command -replace "#param4#",$pp4 } 

if($proxy)
{

if($cred -eq "true" )
    {
    $Response = Invoke-RestMethod -Uri "https://api.telegram.org/bot$($apikey)/sendMessage?chat_id=-$($channelid)&text=$($command)" -Proxy "$proxy" -ProxyUseDefaultCredentials
    }
else{
    $Response = Invoke-RestMethod -Uri "https://api.telegram.org/bot$($apikey)/sendMessage?chat_id=-$($channelid)&text=$($command)" -Proxy "$proxy"
    }

}
else {

$Response = Invoke-RestMethod -Uri "https://api.telegram.org/bot$($apikey)/sendMessage?chat_id=$($channelid)&text=$($command)"
    }
Write-Host "Done --   $Response"  

Exit 0 