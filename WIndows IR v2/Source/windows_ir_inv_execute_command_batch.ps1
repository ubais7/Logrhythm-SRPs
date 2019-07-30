# Windows Incident responder V2  by Ubais PK

#Read command
param(
    
    [Parameter(Mandatory=$true)][string]$file,
    [Parameter(Mandatory=$true)][string]$shahash,
    [Parameter(Mandatory=$true)][string]$secret,
    [string]$pp1,
    [string]$pp2,
    [string]$pp3,
    [string]$pp4,
    [string]$logpath
)

trap [Exception] {
write-error $("TRAPPED: " + $_)
exit 1
}

$fileshash= (Get-FileHash $file -Algorithm SHA256).Hash

if($shahash -ne $fileshash ) { 
        Write-Host "File Hash Missmatch "
        Exit 0 }


if ($secret -ne "y3sIkn0wWh@t!md0!ng")

    {       Write-Host "Wrong secret"  
    Exit 0}



if($logpath) { New-Item -Path $logpath -ItemType directory -Force }


foreach( $fline in Get-Content $file )
{

$command=$fline

if($pp1) { $command=$command -replace "#param1#",$pp1 } 
if($pp2) { $command=$command -replace "#param2#",$pp2 } 
if($pp3) { $command=$command -replace "#param3#",$pp3 }
if($pp4) { $command=$command -replace "#param4#",$pp4 } 





    if ($command[0] -eq '"') 
            { $OutputVariable =iex "& $command" }
    else 
            { $OutputVariable =iex $command }
    
    if($logpath) { 
    $command | Out-File -Append $logpath\$(Get-Date -f yyyy-MM-dd)_log.txt
    "`r`n     " | Out-File -Append $logpath\$(Get-Date -f yyyy-MM-dd)_log.txt
    $OutputVariable | Out-File -Append $logpath\$(Get-Date -f yyyy-MM-dd)_log.txt }

    ForEach ($line in $($OutputVariable -split "`r`n"))
            {  Write-host $Line }

  



}

Exit 0 