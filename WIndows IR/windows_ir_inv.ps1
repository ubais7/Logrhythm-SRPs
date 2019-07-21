# Windows Incident responder  by Ubais PK

#Read command
param(
    
    [Parameter(Mandatory=$true)][string]$command,
    [Parameter(Mandatory=$true)][string]$secret
)

trap [Exception] {
write-error $("TRAPPED: " + $_)
exit 1
}


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