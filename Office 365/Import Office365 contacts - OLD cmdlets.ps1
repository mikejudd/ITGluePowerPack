function FindContacts {
    param($OrganizationId)

    $pageNumber = 1
    $foundContacts = New-Object System.Collections.ArrayList

    while($true) {
        Get-ITGlueContacts -page_number $pageNumber | ForEach-Object {
            $_.data | ForEach-Object {
                if($_.attributes.'organization-id' -eq $OrganizationId) {
                    $person = New-Object psobject
                    $person | Add-Member -Type NoteProperty -Name id -Value $_.id
                    $person | Add-Member -Type NoteProperty -Name name -Value $_.attributes.name
                    $_.attributes.'contact-emails' | ForEach-Object {
                        if($_.primary -eq $true) {
                            $person | Add-Member -Type NoteProperty -Name email -Value $_.value
                        }
                    }
                    $person | Add-Member -Type NoteProperty -Name ITGlueObj -value $_
                                        
                    $foundContacts.Add($person) > $null
                }
            }
            if ($pageNumber -eq $_.meta.'total-pages') {
                break
            }
        }
        $pageNumber++
    }
    
    return $foundContacts
}

function FindOrganisation {
    param([String]$organisationName)
    
    $pageNumber = 1
    $result = New-Object System.Collections.ArrayList
    while($true) {
        Get-ITGlueOrganizations -page_number $pageNumber | ForEach-Object {
            $_.data | ForEach-Object {
                if($_.attributes.name -like "*$organisationName*") {
                    $result.Add($_) > $null
                }
            }

            if ($pageNumber -eq $_.meta.'total-pages') {
                if (!$result[0]) {
                    $result = @("null")
                }
                break
            }
        }
        $pageNumber++
    }
    
    return $result
}

function MultipleOrgHits() {
    param($multipleOrgs)

    $multipleOrgs
    

    $count=0
    foreach($orgName in $multipleOrgs) {
        Write-Host "$($count) $($orgName.attributes.name)"
        $count++
    }

    # Remove one because we always add one more at the end.
    $count--
    
    Write-Host ""
    Write-Host "Found more than organisation was found."
    # Force a valid input
    do {
        $userInput = Read-Host "Enter the number corresponding to your org"
        $value = $userInput -as [Double]
        # Null if failed to convert
        if($value -eq $null) {
            Write-Host ""
            Write-Host "You must enter a numeric value"
        # Cannot be out of array index
        } elseif ($value -gt $count -or $value -lt 0) {
            Write-Host ""
            Write-Host "You must enter a from 0 to $count."
        }
    }
    until (-not ($value -eq $null) -and ($value -le $count))

    Write-Host ""
    Write-Host "You chose $($multipleOrgs[$userInput].attributes.name)"
    $multipleOrgs = $multipleOrgs[$userInput]

    return $multipleOrgs
}



# Get Organisation from ITGlue
$userInput = Read-Host "Organisation name in ITGlue"
$org = FindOrganisation -organisationName $userInput

# Handle more than one hit
if($org[1]) {
    $org = MultipleOrgHits($org)
} elseif ($org[0] -eq "null") {
    Write-Host "No organisation"
}

$id = $org[0].id
$itglueContacts = FindContacts -OrganizationId $id

Get-MsolUser | ForEach-Object {
    if($itglueContacts.email -notcontains $_.UserPrincipalName) {
        if($_.DisplayName.Split().Count -gt 1) {
            $firstname = $_.DisplayName.Replace($_.DisplayName.Split()[$_.DisplayName.Split().Count - 1], "")
            $lastname = $_.DisplayName.Split()[-1]
            if($firstname.EndsWith(" ")) {
                $firstname = $firstname.Substring(0, $firstname.Length - 1)
            }
        } else {
            $firstname = $_.DisplayName
            $lastname = ""
        }
    
        $body = @{
            organization_id = $id
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
    } else {
        Write-Host "Skipping $($_.UserPrincipalName) because user already exists in ITGlue."
    }
}