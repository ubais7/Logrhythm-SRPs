 # Juniper SRX block IP v3 by Ubais PK

#Read command line arguments. Device IP, username , password , commitdelay , groupname , ip to block
param(
    [Parameter(Mandatory=$true)]
    [ValidateScript({$_ -match [IPAddress]$_ })]
    [string]$serverip,

    [Parameter(Mandatory=$true)][string]$username,
    [Parameter(Mandatory=$true)][string]$password,
    
    [Parameter(Mandatory=$true)][int]$commitdelay,
    [Parameter(Mandatory=$true)][string]$groupname,

    [Parameter(Mandatory=$true)]
    [ValidateScript({$_ -match [IPAddress]$_ })]
    [string]$toblock
)

trap [Exception] {
write-error $("TRAPPED: " + $_)
exit 1
}

#Making Posh-SSH Module Portable

$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module $ScriptDir\Posh-SSH
#Import-Module Posh-SSH

#SRP each stage Logging to system as $output

New-Item -Path c:\SRX_SRP\logs -ItemType directory -Force
$output="`n Result `n"+$toblock

$output | Out-File c:\SRX_SRP\logs\ip-$toblock-on-$serverip.txt



$loginPasswd = ConvertTo-SecureString $password -AsPlainText -Force                                                                                     
$loginCreds = New-Object System.Management.Automation.PSCredential ($username, $loginPasswd)                                                                 

Try {
  New-SSHSession -ComputerName $serverip -AcceptKey:$true -Credential $loginCreds -ErrorAction Stop | out-null
}
Catch {
  Write-Host "ERROR: Problem connecting to IP $serverip`n "
  Write-Host $_.Exception.Message

  #Updating log

  $output=$output+"ERROR: Problem connecting to IP $serverip`n "+ " `r`n "
  $output | Out-File c:\SRX_SRP\logs\ip-$toblock-on-$serverip.txt


  Exit 1
}

$session = Get-SSHSession -Index 0
$stream = $session.Session.CreateShellStream("dumb", 0, 0, 0, 0, 1000)
sleep 5

$stream.Write("`n")

$output=$output+$stream.Read().Trim()+ " `r`n "

Write-Host $stream.Read().Trim()

Write-Host "`nSUCCESS: Connected, attempting edit mode`n"
$output=$output+"`nSUCCESS: Connected, attempting edit mode`n"+ " `r`n "

$stream.Write("edit`n")
sleep 5
$stream.Write("`n")
$stream.Write("`n")

Write-Host $stream.Read().Trim()

sleep 1
$output=$output+$stream.Read().Trim()+ " `r`n "

Write-Host $stream.Read().Trim()
$stream.Write("`n")
Write-Host $stream.Read().Trim()
$stream.Write("`n")
Write-Host $stream.Read().Trim()

Write-Host "`r`nExecuting : set security zones security-zone Internet-Zone address-book address Host_$toblock $toblock/32 `r`n"
$a="set security zones security-zone Internet-Zone address-book address Host_$toblock $toblock/32`n"
$stream.Write($a)


$output=$output+"`r`nExecuting : set security zones security-zone Internet-Zone address-book address Host_$toblock $toblock/32 `r`n"+ " `r`n "


sleep 1
Write-Host "`r`nExecuting: set security zones security-zone Internet-Zone address-book address-set $groupname address Host_$toblock`r`n"
$stream.Write("set security zones security-zone Internet-Zone address-book address-set $groupname address Host_$toblock`n")
sleep 3


$output=$output+"`r`nExecuting: set security zones security-zone Internet-Zone address-book address-set $groupname address Host_$toblock`r`n"+ " `r`n "


#commit , some overloaded devices needs even 5-10 mins to finish committing

$stream.Write("commit`n")


sleep 4
Write-Host "Executing: commit`n"
$output=$output+"Executing: commit`n"+ " `r`n "

$stream.Write("`n")
$stream.Write("`n")
sleep $commitdelay

$output=$output+"Done Waiting $commitdelay"+ " `r`n "
$output=$output+$stream.Read().Trim()+ " `r`n "

Write-Host $stream.Read().Trim()


$stream.Write("exit")

$output=$output+"Exiting... "+ " `r`n "

#writing to log file

$output | Out-File c:\SRX_SRP\logs\ip-$toblock-on-$serverip.txt

sleep 1
Write-Host "SUCCESS"

Remove-SSHSession -SSHsession $session | out-null
Exit 0 