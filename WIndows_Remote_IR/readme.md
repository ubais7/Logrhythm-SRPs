## Windows Incident response SRP

This SRP is intended to execute Incident response actions for windows remotely

This version is under devolepment. 
Still working  ( SRP execution status will be failure, but still it can execute commands remotly) 
 
## Pre-req

SM ( from where the SRP being executed)  to remote machine access

	1. Windows admin priv credentials
	2. Network port 445

## Considerations

This SRP uses PsExec module ( https://docs.microsoft.com/en-us/sysinternals/downloads/psexec ) 

incase if the credentials doesnt have enough privilage or Network level access , It will fail

Mostly AD will be having 445 access to all domain joined Desktops ( not 100% ) - Use this logic wisly if you have access troubles
 

 
## Parameters

### command - 

Read detailed examples from : https://github.com/ubais7/Logrhythm-SRPs/tree/master/WIndows%20IR description. 

### secret - SRP access is available for all global Admins, but this is just a protection, incase if you believe there are some nerds who dont know what he is doing.
 
y3sIkn0wWh@t!md0!ng

### Device IP - 

Ip of host where you want to execute command

### Username & Password 

Credentials which has priv to execute command on remote PC
( Put username as 1 and password as 1 - incase you want to use user running SM service ) 



### How to configure: 

 1. Import lpi 
 2. Use it



 


