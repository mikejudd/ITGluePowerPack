### Office 356 PowerShell Install.ps1  
Run this one first. It will self-elevate to get admin privilages and create a folder in the currents users profile where it will store your Office 365 credentials for later use.   
  
Credentials are stored here: %userprofile%\UpstreamPowerPack\credentials.xml

### Cloud Apps_Office 365_Import users.ps1  
Imports Office 365 users from your companys Office 365 portal (NOT parter portal). If two users in contacts have the same email, this will have to be handled manually the first time.  
  
Do not forget to change 1234 to the organisation you want to import to and 5678 to the id of the flexible asset created by "Office 365 as Flexible Asset v1.ps1". 

### Office 365 as Flexible Asset v1.ps1  
To be used with Cloud Apps_Office 365_Import users.ps1.

### Office 365 as Flexible Asset v2.ps1  
Another version intended to be used with parter portal and this script: https://gcits.com/knowledge-base/sync-office-365-tenant-info-itglue/

### Office 365 as Flexible Asset v3.ps1  
A short version for compact use.