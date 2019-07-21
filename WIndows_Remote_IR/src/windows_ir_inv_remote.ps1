# Windows Incident responder remote  by Ubais PK

#Read command
param(
    
    [Parameter(Mandatory=$true)][string]$command,
    [Parameter(Mandatory=$true)][string]$secret,
    [Parameter(Mandatory=$true)][ValidateScript({$_ -match [IPAddress]$_ })][string]$deviceip,
    [Parameter(Mandatory=$true)][string]$username,
    [Parameter(Mandatory=$true)][string]$password
    
)

trap [Exception] {
write-error $("TRAPPED: " + $_)
exit 1
}

$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path

if( $username -eq "1" -AND $password -eq "1") 
    { $command="`"$ScriptDir\PsExec64.exe`" \\$deviceip $command" }
else
    { $command="`"$ScriptDir\PsExec64.exe`" -u $username -p $password \\$deviceip $command" }



if ($secret -eq "y3sIkn0wWh@t!md0!ng")
    {


    if ($command[0] -eq '"') 
            { $OutputVariable =iex "& $command" }
    else 
            { $OutputVariable =iex $command }

    ForEach ($line in $($OutputVariable -split "`r`n"))
            {   Write-host $Line }

     }
else
    {       Write-Host "Wrong secret"    }

Exit 0 