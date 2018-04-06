### Office 356 PowerShell Install.ps1  
Run this one first. It will self-elevate to get admin privilages and create a folder in the currents users profile where it will store your Office 365 credentials for later use. If two users in contacts have the same email, this will have to be handled manually the first time.  
  
Do not forget to change 1234 to the organisation ID of the organisation you want the data to be in and the flexible asset id of the flexible asset created by Office 365 as Flexible Asset v1.ps1.  
  
Credentials are stored here: %userprofile%\UpstreamPowerPack\credentials.xml

### Cloud Apps_Office 365_Import users.ps1  
Imports Office 365 users from your companys Office 365 