# A self elevating PowerShell script
# Source: https://blogs.msdn.microsoft.com/virtual_pc_guy/2010/09/23/a-self-elevating-powershell-script/

# Get the ID and security principal of the current user account
$myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($myWindowsID)


# Get the security principal for the Administrator role
$adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator

# Check to see if we are currently running "as Administrator"
if ($myWindowsPrincipal.IsInRole($adminRole)) {
    # We are running "as Administrator" - so change the title and background color to indicate this
    $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + "(Elevated)"
    $Host.UI.RawUI.BackgroundColor = "DarkBlue"

    clear-host
} else {
    # We are not running "as Administrator" - so relaunch as administrator

    # Create a new process object that starts PowerShell
    $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";

    # Specify the current script path and name as a parameter
    $newProcess.Arguments = "& '" + $myInvocation.MyCommand.Definition + "'";
    #$newProcess.Arguments = "& '" + $script:MyInvocation.MyCommand.Path + "'"

    # Indicate that the process should be elevated
        $newProcess.Verb = "runas";

    # Start the new process
    [System.Diagnostics.Process]::Start($newProcess);

    # Exit from the current, unelevated, process
    exit
    }

# -- End of self eleveting prompt
# Run your code that needs to be elevated here

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
Write-Host "Deleting $PWD\ITGlueAPI.zip... " -NoNewline
Write-Host 'Complete!'
Write-Host ''

# Import ITGlue API
#Import-Module ITGlueAPI 

# Add Base URI for the API
Add-ITGlueBaseURI

# First time setup
Write-Host "Running Add-ITGlueAPIKey..."
Add-ITGlueAPIKey

# Save API key for user
Write-Host "Exporting settings..." -NoNewline
Export-ITGlueModuleSettings
Write-Host 'Complete!'

Write-Host -NoNewLine "Done, press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")