. '.\Function_FindContacts.ps1'
. '.\Function_FindOrganisation.ps1'
. '.\Function_MultipleOrgHits.ps1'



# Get Organisation from ITGlue
$userInput = Read-Host "Organisation"
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