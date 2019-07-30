## Windows Incident response SRP

This SRP is intended to execute Incident response actions for windows

This version only has feature of executing the command from SM locally

Future planned improvements :
 1. Remote command execution
 2. Better Logging of SRP output ( Understands some time LR wont keep whole output.) 
 
## Best use case

EDR/ Layer 7 firewalls/ Poor mans's EDR (sysmon )   all are expected to give data to SIEM.

If you want to do an investigation during the incident/AIE trigger occurrence  -  the best way to obtain evidences is by automating it.


 
## Parameters

### command - the command to be executed 

The minimal recommended if your AIE hit something malicious on a host : 
 - ipconfig
 - netstat ( -an , -rn ) 
 - cmd time /t
 - cmd date /t
 - netstat -abno
 - tasklist
 - tasklist /v
 
 Running services, local accounts, patch checks  all can be executed :)  - Keeping it open for the hunter
 
 These are expected to produce bit bigger outputs

	- dir /t:a /a /s /o:d c:    		- Gather Last Access Time.
	- dir /t:w /a /s /o:d c:		- Gather Last Modification Time 
	- dir /t:c /a /s /o:d c:		- Gather Last Create Time
 
If you need output in  a log file of SM - Put command parameter with ' >> '

eg:
	ipconfig >> C:\ipconfig.txt  ( path can be UNC if SM has access to it - take care of risks please ) 

### secret - SRP access is available for all global Admins, but this is just a protection, incase if you believe there are some nerds who dont know what he is doing.
 
y3sIkn0wWh@t!md0!ng


### How to configure: 

 1. Import lpi 
 2. Use it



 


