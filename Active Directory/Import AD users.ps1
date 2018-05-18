$users = New-Object System.Collections.ArrayList

Get-ADUser -Filter * -Property 'msDS-UserPasswordExpiryTimeComputed' | ForEach-Object {
    $users.add((
        New-Object –TypeName PSObject –Property (@{
            'GivenName'=$_.GivenName;
            'Surname'=$_.Surname;
            'ExpiryDate' = ($_.'msDS-UserPasswordExpiryTimeComputed' | Select-Object @{Name='ExpiryDate';Expression={[datetime]::FromFileTime($_.'msDS-UserPasswordExpiryTimeComputed')}}).ExpiryDate
            'AccountExpirationDate' = $_.AccountExpirationDate;
            'AccountLockoutTime' = $_.AccountLockoutTime;
            'AccountNotDelegated' = $_.AccountNotDelegated;
            'CannotChangePassword' = $_.CannotChangePassword;
            'City' = $_.City;
            'CN' = $_.CN;
            'Company' = $_.Company;
            'Created' = $_.Created;
            'createTimeStamp' = $_.createTimeStamp;
            'Deleted' = $_.Deleted;
            'Department' = $_.Department;
            'Description' = $_.Description;
            'DisplayName' = $_.DisplayName;
            'DistinguishedName' = $_.DistinguishedName;
            'Division' = $_.Division;
            'DoesNotRequirePreAuth' = $_.DoesNotRequirePreAuth;
            'EmailAddress' = $_.EmailAddress;
            'EmployeeID' = $_.EmployeeID;
            'EmployeeNumber' = $_.EmployeeNumber;
            'Enabled' = $_.Enabled;
            'HomeDirectory' = $_.HomeDirectory;
            'HomedirRequired' = $_.HomedirRequired;
            'HomeDrive' = $_.HomeDrive;
            'MobilePhone' = $_.MobilePhone;
            'PasswordExpired' = $_.PasswordExpired;
            'PasswordLastSet' = $_.PasswordLastSet;
            'PasswordNeverExpires' = $_.PasswordNeverExpires;
            'PasswordNotRequired' = $_.PasswordNotRequired;
            'SamAccountName' = $_.SamAccountName;
            'UserPrincipalName' = $_.UserPrincipalName;
        })
    )) > $null
}
