##Juniper SRX SRP For logrhythm

This SRP for People who got Juniper as perimeter kid.
 
##Parameters

Device Ip - IP of Juniper device

username/password - Credentials which got access to define an address-set

Seconds to wait after commit - Delays based on ur juniper device's commit requirement

Object group name - name of group , this can be later used for any purpose

IP to block - IP to be added into that object ( dont worry about parameter name, action to be decided in juniper as per need )


##What it will do:

It will add IP given to object group defined in SRP .

 

###So:  

You can trigger an alarm during attack ( Say 3 times port scan in a day ) - IPs will be added to  ' LGRTM_BLOCK '

 

###Then :  

tell SRX to block traffic for 'LGRTM_BLOCK'  - If u don’t know commands, NW team can do this

###How to configure: 

 1. Import lpi
 2. Firewall port 22 access from PM/XM/SM to device is needed
 3. Use it
 4. Add deny any rule for group "LGRTM_BLOCK" in srx  / Or what you want to do
 
###V3 Improvements

- Logs will be added to C:/SRX-SRP/logs
- No hardcoded Group name (So can be used for any purpose) 
- Completely portable 
(Old version has dependency of Posh-ssh  fixed path )


###Plugins used
Posh-SSH (https://github.com/darkoperator/Posh-SSH ) 

### Test note:
When you test the script in PM after importing, if the commit delay is more , time out will occur, but still it will execute, check the logs in C:/SRX-SRP/logs after commit wait delay. 

 


