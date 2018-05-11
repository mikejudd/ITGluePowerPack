$users = New-Object System.Collections.ArrayList

Get-ADUser -Filter * -Property 'msDS-UserPasswordExpiryTimeComputed' | ForEach-Object {
    $users.add((
        New-Object –TypeName PSObject –Property (@{
            'GivenName'=$_.GivenName;
            'Surname'=$_.Surname;
            'ExpiryDate' = ($_.'msDS-UserPasswordExpiryTimeComputed' | Select-Object @{Name='ExpiryDate';Expression={[datetime]::FromFileTime($_.'msDS-UserPasswordExpiryTimeComputed')}}).ExpiryDate
        })
    )) > $null
}
