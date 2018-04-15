 # Code from http://www.expta.com/2017/03/how-to-self-elevate-powershell-script.html
# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
        Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
        Exit
    }
}

$path = "$env:USERPROFILE\UpstreamPowerPack"

if(-not (Test-Path -path $path)) {
    New-Item $path -ItemType Directory | %{$_.Attributes = "hidden"}
}

Install-Module AzureAD

$credentials = Get-Credential -Message "Enter your Office 365 credentials. These will be saved for later use."
$credentials | Export-Clixml -Path $path\o365credentials.xml

while($true) {
    try {
        $success = $true
        $credential = Import-CliXML -Path $path\o365credentials.xml
        Connect-AzureAD -Credential $credential > $null
    } catch {
        $success = $false
        Write-Host "Connection failed. Please update your credentials."
        $credential = Get-Credential -Message "Enter your Office 365 credentials. These will be saved for later use."
    }

    if ($success) {
        break
    }
}

$credentials | Export-Clixml -Path $path\o365credentials.xml

Write-Host "Credentials saved to $($path) in secure format.."
Write-Host "Press any key to exit."
$Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown') > $null