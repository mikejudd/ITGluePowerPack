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

Save-Module -Name PowerShellGet -Path $path

Install-Module AzureADPreview

$credentials = Get-Credential -Message "Enter your Office 365 credentials. These will be saved for later use."

$credentials | Export-Clixml -Path $path\credentials.xml

Write-Host "Credentials saved to $($path) in secure format.."
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')