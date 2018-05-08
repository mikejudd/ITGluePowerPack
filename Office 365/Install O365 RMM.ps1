<#
.SYNOPSIS
    Installs the AzureAD module in order to connect to Office 365. Requires eleveted shell.
.DESCRIPTION
    This script saves your username and password in -path\o365credentials.xml. $path\ is by default "$env:USERPROFILE\UpstreamPowerPack" unless specified with the -path parameter.
.PARAMETER username
    Your Office 365 username. This will be saved in -path\o365credentials.xml unless specifed not to.
.PARAMETER password
    Your Office 365 password. This will be saved in -path\o365credentials.xml unless specifed not to.
.PARAMETER path
    Default $env:USERPROFILE\UpstreamPowerPack. Set this parameter if you want to store your credentials somewhere else.
.EXAMPLE
    C:\PS> '.\Install O365 Automated version.ps1' -username "user@example.com" -password "weakpassword"
    Installs AzureAD module and exports your credentials to %userprofile%\UpstreamPowerPack\o365credentials.xml.
.EXAMPLE
    C:\PS> '.\Install O365 Automated version.ps1' -username "user@example.com" -password "weakpassword" -path "C:\Office\API"
    Installs AzureAD module and exports your credentials to C:\Office\API\o365credentials.xml.
.EXAMPLE
    C:\PS> '.\Install O365 Automated version.ps1' -SaveCredentials $false
    Only installs AzureAD module.
.NOTES
    Author: Emile Priller
    Date:   08/05/2018
#>
param(
    [string]$username,
    [string]$password,
    [string]$path = "$env:USERPROFILE\UpstreamPowerPack\",
    [boolean]$SaveCredentials = $true
)

if($path.Chars($path.Length - 1) -eq "\") {
        $path = $path.Substring(0, $path.Length - 1)
}

if(-not (Test-Path -path $path)) {
    New-Item $path -ItemType Directory | %{$_.Attributes = "hidden"}
}

Install-PackageProvider -Name NuGet -Force
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module -Name AzureAD -Force
Set-ExecutionPolicy RemoteSigned -Force


if($SaveCredentials) {
    $securepassword = ConvertTo-SecureString $password -AsPlainText -Force
    $credentials = Get-Credential -Credential (New-Object -TypeName PSCredential -ArgumentList $username,$securepassword)
    $credentials | Export-Clixml -Path $path\o365credentials.xml
}