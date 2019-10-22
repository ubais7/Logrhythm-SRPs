# Send_Mail  by Ubais PK

#Read command
param(
    
    [Parameter(Mandatory=$true)][string]$from,
    [Parameter(Mandatory=$true)][string]$to,
    [Parameter(Mandatory=$true)][string]$cc,
    [Parameter(Mandatory=$true)][string]$htmlpath,
    [Parameter(Mandatory=$true)][string]$subject,
    [Parameter(Mandatory=$true)]
    [ValidateScript({$_ -match [IPAddress]$_ })]$mailserver,
    [string]$pp1,
    [string]$pp2,
    [string]$pp3,
    [string]$pp4,
    [string]$pp5
)

trap [Exception] {
write-error $("TRAPPED: " + $_)
exit 1
}

if($pp1) { $subject=$subject -replace "#param1#",$pp1 } 
if($pp2) { $subject=$subject -replace "#param2#",$pp2 } 
if($pp3) { $subject=$subject -replace "#param3#",$pp3 }
if($pp4) { $subject=$subject -replace "#param4#",$pp4 } 
if($pp5) { $subject=$subject -replace "#param5#",$pp5 } 



$smtp = $mailserver 
 
$body = Get-Content -Path $htmlpath -Raw

if($pp1) { $body=$body -replace "#param1#",$pp1 } 
if($pp2) { $body=$body -replace "#param2#",$pp2 } 
if($pp3) { $body=$body -replace "#param3#",$pp3 }
if($pp4) { $body=$body -replace "#param4#",$pp4 } 
if($pp5) { $body=$body -replace "#param5#",$pp5 } 

 
send-MailMessage -SmtpServer $smtp -To $to -From $from -Cc $cc -Subject $subject -Body $body -BodyAsHtml -Priority high 

Write-Host "mail Send"

Exit 0 