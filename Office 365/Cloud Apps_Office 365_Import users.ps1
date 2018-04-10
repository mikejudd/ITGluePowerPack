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
        
        default                    {return $skuPartNumber}
    }
}


function addO365Users {
    param (
        [int]$organisationid,
        [int]$flexAssetId
    )
    

    # Initiate variables
    $ITGlueContacts = $null
    $ITGlueAsset = $null
    $O365Users = @{}
    $matchedContacts = @{}
    $translatedSkuWithID = @{}

    # Get email from the asset
    $ITGlueAsset = Get-ITGlueFlexibleAssets -filter_organization_id $organisationid -filter_flexible_asset_type_id $flexAssetId


    # Translate all O365 version to human readable
    Get-AzureADSubscribedSku | ForEach-Object {
        $translatedSkuWithID.Add($_.SkuId, (ITGlueTranslation($_.SkuPartNumber)))
    }

    # Store email with translated O365 version
    Get-AzureADUser | ForEach-Object {
        $currentUser = $_
        if($currentUser.AssignedLicenses.skuid -ne $null) {
            $O365Users.Add($_.UserPrincipalName, ($translatedSkuWithID.($currentUser.AssignedLicenses.skuid)))
        } else {
            # $O365Users.Add($_.UserPrincipalName, "No license")
        }
    }

    # Get all contacts from ITGlue
    $ITGlueContacts = ((Get-ITGlueContacts -page_size ((Get-ITGlueContacts).meta.'total-count')).data | Where-Object { $_.attributes.'organization-id' -eq $organisationid})


    foreach($ITGContact in $ITGlueContacts) {
        $ITGContact.attributes.'contact-emails'.value | ForEach-Object {
            $currentEmail = $_
            if($O365Users.ContainsKey($currentEmail)) {
                $matchedContacts.Add($ITGContact.id, @{"email" = $currentEmail; "OffVersion" = $O365Users.($currentEmail)})
            }
        }
    }

    $O365VersionInUse = $O365Users.Values
    $O365VersionInUse = $O365VersionInUse | Select-Object -Unique
    foreach($officeVersion in $O365VersionInUse) {
        $currentITGlueAsset = $ITGlueAsset.data | Where-Object{$_.attributes.name -eq $officeVersion -and $_.attributes.traits.notes -eq "Do not remove this note."}
        
        $removeTheseContacts = New-Object System.Collections.ArrayList
        foreach($key in $matchedContacts.Keys) {
            # If ID from all contacts is not contained in the flexible asset...
            if ($currentITGlueAsset.attributes.traits.'license-users'.values.id -notcontains $key) {
                # ...make sure it is the correct Office Version...
                if($matchedContacts.($key).OffVersion -eq $OfficeVersion) {
                    # ...see if the email for the current OfficeVersion exists more than once.
                    if (($matchedContacts.Values | where{$_.email -eq $matchedContacts.($key).email -and $_.OffVersion -eq $officeVersion}).count -gt 1) {
                        # This should mean that the email of the current ID ($key) does not exist in the flexible asset but the corresponding email does.
                        $removeTheseContacts.Add($key) > $null
                    }
                }
            }    
        }

        foreach($id in $removeTheseContacts) {
            $matchedContacts.Remove($id)
        }
        
        $matchedContactsForCurrentVersion = @($matchedContacts.GetEnumerator()) | Where-Object {$_.value.OffVersion -eq $officeVersion}

        



        $body = @{
            data = @{
                type = 'flexible_assets'
                attributes = @{
                    organization_id = $organisationid
                    flexible_asset_type_id = $flexAssetId
                    traits = @{
                        "application-name" = $officeVersion
                        "license-users" =  $matchedContactsForCurrentVersion.name # Hash stores in name and value, @() converts to array and ID falles under name.
                        "amount-of-users" = $matchedContactsForCurrentVersion.count
                        "application-url-if-available" = "https://www.office.com/"
                        "application-user-interface" = "Browser, local software and mobile App"
                        "contains-personal-data" = "Yes"
                        notes = "Do not remove this note."
                    }
                }
            }
        }

        if($currentITGlueAsset) {
            Set-ITGlueFlexibleAssets -data $body -id $currentITGlueAsset.id
        } else {
            New-ITGlueFlexibleAssets -data $body
        }
    }

}

$path = "$env:USERPROFILE\UpstreamPowerPack"

if(-not (Test-Path -path $path)) {
    New-Item $path -ItemType Directory | %{$_.Attributes = "hidden"}
    
    $credentials = Get-Credential -Message "Enter your Office 365 credentials. These will be saved for later use."
    $credentials | Export-Clixml -Path $path\credentials.xml
    Write-Host "Credentials saved to $($path)\credentials.xml in secure format.."
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
}

$credential = Import-CliXML -Path "$env:USERPROFILE\UpstreamPowerPack\credentials.xml"

Connect-AzureAD -Credential $credential > $null

Import-Module ITGlueAPI


# Relace with your Organisation ID and Flexible Asset ID.
addO365Users -organisationid 1234 -flexAssetId 5678
