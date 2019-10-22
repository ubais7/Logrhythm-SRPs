## Send mail with custom html content


### Are you in a need of sending custom mails with alarm fields -On time to confirm genuinity of some suspicious Acitivity 

This SRP is for you .

#### Parameters:

##### from/to/cc :  Ofcourse, mail ids -  it should be like (no quotes) :

*Someone lastname \<someone@somewhere.com\>*

Multiple to can be given with a comma (logically, didnt get time to test) :

*Someone1 lastname \<someone1@somewhere.com\> , Someone2 lastname \<someone2@somewhere.com\>*

##### Path to Html: 

give the path for html file ( Use any online html creator, make your mail) for example:

![See](https://raw.githubusercontent.com/ubais7/Logrhythm-SRPs/master/Send_Mail/html.JPG)

On the content:  #param1# ,#param2#  ,#param3#  #param4# #param5# will get replaced with curresponding aralm fields (Which you select in alarm actions )

Save this as an file in PM, give the path

So full freedom on mail writing in html, includes Signature :) 

##### Mail Server:

Ip of the SMTP relay (No ssl, authentication configured in this version )

##### Subject:

Subject of the mail, can use #param1# -#param5# for getting it replaced with alarm fields .


Enjoy SOARing