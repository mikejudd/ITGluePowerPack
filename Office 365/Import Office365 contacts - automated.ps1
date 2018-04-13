function importO365Emails {
    param (
        [int]$organisationid
    )
    

    # Get all contacts from ITGlue
    $ITGlueContacts = ((Get-ITGlueContacts -page_size ((Get-ITGlueContacts).meta.'total-count')).data | Where-Object {$_.attributes.'organization-id' -eq $organisationid})


    Get-AzureADUser | ForEach-Object {
        if($_.AssignedLicenses.skuid -eq $null) {
            # Remove "return" to import unlicensed users.
            return
        } elseif($ITGlueContacts.attributes.'contact-emails'.value -contains $_.UserPrincipalName) {
            # Skip existing emails
            return
        }

        $currentUser = $_

        # Clean up name
        if($currentUser.DisplayName.Split().Count -gt 1) {
            $firstname = $currentUser.DisplayName.Replace($currentUser.DisplayName.Split()[$currentUser.DisplayName.Split().Count - 1], "")
            $lastname = $currentUser.DisplayName.Split()[-1]
            if($firstname.EndsWith(" ")) {
                $firstname = $firstname.Substring(0, $firstname.Length - 1)
            }
        } else {
            $firstname = $currentUser.DisplayName
            $lastname = ""
        }
        
        $body = @{
            organization_id = $organisationid
            data = @{
                type = 'contacts'
                attributes = @{
                    first_name = $firstname
                    last_name = $lastname
                    notes = "Office 365 user"
                    contact_emails = @(
                        @{
                            value = $currentUser.UserPrincipalName
                            label_name = "Work"
                            primary = $true
                        }
                    )
                }
            }
        }

        New-ITGlueContacts -data $body
    }
}

if(-not (Get-Module -ListAvailable -Name AzureAD)) {
    Write-Host "Please run the Office 365 install script first."
    $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown') > $null
    exit
}


$path = "$env:USERPROFILE\UpstreamPowerPack"

if(-not (Test-Path -path $path\o365credentials.xml)) {
    # If you did not save your Office 365 credentials via installation script, you need to enter them here.
    $username = "YOUR OFFICE 365 EMAIL GOES HERE"
    $password = ConvertTo-SecureString "YOUR OFFICE 365 PASSWORD GOES HERE"  -AsPlainText -Force

    if($username -eq "YOUR OFFICE 365 EMAIL GOES HERE") {
        exit
    } else {
        $credential = New-Object System.Management.Automation.PSCredential ($username, $password)
        Connect-AzureAD -Credential $credential > $null
    }

} else {
    $credential = Import-CliXML -Path $path\o365credentials.xml
    Connect-AzureAD -Credential $credential > $null
}


importO365Emails -organisationid 2504761