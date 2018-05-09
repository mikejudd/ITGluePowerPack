param(
    [string]$APIKey
    [boolean]$ExportAPIKey = $true
)

# Download required software
Invoke-WebRequest 'https://codeload.github.com/itglue/powershellwrapper/zip/master' -OutFile .\ITGlueAPI.zip

# Extract
Expand-Archive -Path .\ITGlueAPI.zip -DestinationPath .\ -Force

# Copy
Copy-Item '.\powershellwrapper-master\ITGlueAPI' "$env:ProgramFiles\WindowsPowerShell\Modules\ITGlueAPI" -Recurse -Force

# Delete items
Remove-Item .\ITGlueAPI.zip
Remove-Item .\powershellwrapper-master -Recurse

# Import ITGlue API
Import-Module ITGlueAPI

# Add Base URI for the API
Add-ITGlueBaseURI

if($ExportAPIKey) {
	# Add ITGlueAPI Key
	$x_api_key = $APIKey
	Set-Variable -Name "ITGlue_API_Key"  -Value $x_api_key -Option ReadOnly -Scope global -Force

	# Save API key for user
	Export-ITGlueModuleSettings
}