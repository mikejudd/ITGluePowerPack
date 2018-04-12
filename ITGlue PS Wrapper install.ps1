# Code from http://www.expta.com/2017/03/how-to-self-elevate-powershell-script.html
# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
        Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
        Exit
    }
}


# Download required software
Write-Host 'Downloading ITGlueAPI PowerShell wrapper... ' -NoNewline
Invoke-WebRequest 'https://codeload.github.com/itglue/powershellwrapper/zip/master' -OutFile .\ITGlueAPI.zip
Write-Host 'Complete!'

# Extract
Write-Host "Extracting to $PWD\powershellwrapper-master... " -NoNewline
Expand-Archive -Path .\ITGlueAPI.zip -DestinationPath .\ -Force
Write-Host 'Complete!'

# Copy
Write-Host "$env:ProgramFiles\WindowsPowerShell\Modules\ITGlueAPI... " -NoNewline
Copy-Item '.\powershellwrapper-master\ITGlueAPI' "$env:ProgramFiles\WindowsPowerShell\Modules\ITGlueAPI" -Recurse
Write-Host 'Complete!'

# Delete items
Write-Host "Deleting $PWD\ITGlueAPI.zip... " -NoNewline
Remove-Item .\ITGlueAPI.zip
Write-Host 'Complete!'
Remove-Item .\powershellwrapper-master -Recurse
Write-Host "Deleting $PWD\powershellwrapper-master... " -NoNewline
Write-Host 'Complete!'
Write-Host ''

# Import ITGlue API
Import-Module ITGlueAPI 

# Add Base URI for the API
Add-ITGlueBaseURI

# First time setup
# Write-Host "Enter your ITGlue API key when asked to."
Add-ITGlueAPIKey

# Save API key for user
Write-Host "Exporting settings... " -NoNewline
Export-ITGlueModuleSettings
Write-Host 'Complete!'

Write-Host -NoNewLine "Done, press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")