function Update-StoredCredentials {
    if(-not (Test-Path -path $path)) {
        New-Item $path -ItemType Directory | %{$_.Attributes = "hidden"}
    }

    $credential = Get-Credential -Message "Enter your Office 365 credentials. These will be saved for later use."
    $credential | Export-Clixml -Path $path\o365credentials.xml

    Write-Host "Credentials saved to $($path)\o365credentials.xml in secure format.."
}

if(-not (Get-Module -ListAvailable -Name AzureAD)) {
    Write-Host "Please run the Office 365 install script first."
    $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown') > $null
    exit
}

##start
$path = "$env:USERPROFILE\UpstreamPowerPack"

try {
    Write-Host -NoNewline "Trying with prestored credentials.. "
    $credential = Import-CliXML -Path $path\o365credentials.xml
} catch {
    Write-Host ""
    Write-Host ""
    Write-Host "No credentials was found, to you want to save them for later use now?"
    Write-Host "Credentials will be saved to $($path)\o365credentials.xml."
    Write-Host ""

    $userInput = Read-Host "y/n"
    if ("yes" -match $userInput) {
        Update-StoredCredentials
    } else {
        $credential = Get-Credential -Message "Enter your Office 365credentials. These will NOT be saved for later use."
    }
}


if ("yes" -match $userInput) {
    while($true) {
        try {
            $success = $true
            $credential = Import-CliXML -Path $path\o365credentials.xml
            Connect-AzureAD -Credential $credential > $null
        } catch {
            $success = $false
            Write-Host "Connection failed. Please update your credentials."
            Update-StoredCredentials
        }

        if ($success) {
            break
        }
    }
} else {
    while($true) {
        try {
            $success = $true
            Connect-AzureAD -Credential $credential > $null
        } catch {
            $success = $false
            Write-Host "Connection failed. Please update your credentials."
            $credential = Get-Credential -Message "Enter your Office 365credentials. These will NOT be saved for later use."
        }

        if ($success) {
            break
        }
    }
}


Write-Host ""
$doNext = "find org"
:MistakeLoop
while($true) {
    switch ($doNext) {
        "find org" {
            $organizationName = Read-Host "Organisation name in ITGlue"
            $foundOrgs = New-Object System.Collections.ArrayList

            (Get-ITGlueOrganizations -page_size ((Get-ITGlueOrganizations).meta.'total-count')).data | ForEach-Object {
                if($_.attributes.name -like "*$organizationName*") {
                        $foundOrgs.Add($_) > $null
                }
            }

            if(-not $foundOrgs) {
                Write-Host "No organisation found."
                $doNext = "find org"
            } elseif ($foundOrgs.Count -eq 1) {
                $organizationName = $foundOrgs
                $doNext = "confirm org"
            } elseif ($foundOrgs.Count -gt 1) {
                $doNext = "multi hit handling"
            }
        }

        "multi hit handling" {
            $foundOrgsSorted = New-Object System.Collections.ArrayList
            $foundOrgs.attributes.name | Sort-Object | ForEach-Object {
                $currentName = $_
                $foundOrgsSorted.Add(($foundOrgs | Where-Object {$_.attributes.name -eq $currentName})) > $null
            }

            $count=1
            foreach($org in $foundOrgsSorted) {
                Write-Host "$($count) $($org.attributes.name)"
                $count++
            }

            # Remove one because we always add one more at the end.
            $count--

            Write-Host ""
            Write-Host "Found more than organisation was found."
            # Force a valid input
            do {
                $userInput = Read-Host "Enter the number corresponding to your org or 0 to enter name again"
                $value = $userInput -as [Double]
                # Null if failed to convert
                if($value -eq $null) {
                    Write-Host ""
                    Write-Host "You must enter a numeric value"
                # Cannot be out of array index
                } elseif ($value -gt $count -or $value -lt 0) {
                    Write-Host ""
                    Write-Host "You must enter a number from 1 to $count."
                }
            }
            until (($value -ne $null) -and ($value -le $count))

            Write-Host ""
            if ($value -eq 0) {
                $doNext = "find org"
            } else {
                $organizationName = $foundOrgsSorted[$value - 1]
                $doNext = "confirm org"
            }
        }

        "confirm org" {
            $userInput = Read-Host "Do you want to import into $($organizationName.attributes.name)? (y/n)"
            if("yes" -match $userInput) {
                break MistakeLoop
            } else {
                $doNext = "find org"
            }
        }

    }
}
# Get Organisation from ITGlue

$organisationid = $organizationName.id

$ITGlueContacts = ((Get-ITGlueContacts -page_size ((Get-ITGlueContacts).meta.'total-count')).data | Where-Object {$_.attributes.'organization-id' -eq $organisationid})

Get-AzureADUser | ForEach-Object {
    if($_.AssignedLicenses.skuid -eq $null) {
        Write-Host "$($_.UserPrincipalName) does not have a licens. Add anyway?"
        $userInput = Read-Host "y/n"
        if ("yes" -match $userInput) { } else {
            return
        }

    } elseif($ITGlueContacts.attributes.'contact-emails'.value -contains $_.UserPrincipalName) {
        Write-Host "$($_.UserPrincipalName) already exists. Add anyway?"
        $userInput = Read-Host "y/n"
        if ("yes" -match $userInput) { } else {
            return
        }
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