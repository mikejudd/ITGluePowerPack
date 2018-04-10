function ITGlueTranslation($skuPartNumber) {
    switch($skuPartNumber) {
        "O365_BUSINESS"            {return "Office 365 Business"}
        "O365_BUSINESS_ESSENTIALS" {return "Office 365 Business Essentials"}
        "O365_BUSINESS_PREMIUM"    {return "Office 365 Business Premium"}
        "EMSPREMIUM"               {return "Emspremium"}


        # (Get-AzureADSubscribedSku).SkuPartNumber to see all O365
        # version. Replace "Powershell output" with version add
        # "ITGlue translation" with what you want to see in ITGlue.
        
        # Template for adding more
        # {"Powershell output"}      {return "ITGlue translation"}
        # {"Powershell output"}      {return "ITGlue translation"}
        # {"Powershell output"}      {return "ITGlue translation"}
        # {"Powershell output"}      {return "ITGlue translation"}
        
        default                      {return $skuPartNumber}
    }
}

function importO365Emails {
    param (
        [int]$organisationid,
        [int]$flexAssetId
    )
    

    # Initiate variables
    $O365Users = @{}
    $translatedSkuWithID = @{}

    # Store email with translated O365 version
    Get-AzureADUser | ForEach-Object {
        $currentUser = $_
        if($currentUser.AssignedLicenses.skuid -ne $null) {
            $O365Users.Add($_.UserPrincipalName, ($translatedSkuWithID.($currentUser.AssignedLicenses.skuid)))
        } else {
            # $O365Users.Add($_.UserPrincipalName, "No license")
        }

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
    }

    # Antingen flytta in body och new i loppen eller spara firtname och lastname på annan ort
    $body = @{
        organization_id = $organisationid
        data = @{
            type = 'contacts'
            attributes = @{
                first_name = $firstname
                last_name = $lastname
                notes = "Added via script"
                contact_emails = @(
                    @{
                        value = $_.UserPrincipalName
                        label_name = "Work"
                        primary = $true
                    }
                )
            }
        }
    }

    New-ITGlueContacts -data $body
}