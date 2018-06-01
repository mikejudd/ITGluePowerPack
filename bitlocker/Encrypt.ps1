[cmdletbinding(DefaultParameterSetName='ID')]
param(
	[Parameter(ParameterSetName='ID', Mandatory=$true)]
	[int]$OrganizationId,

	[Parameter(ParameterSetName='Name', Mandatory=$true)]
	[String]$OrganizationName,

	[String[]]$MountPoint="G:",
	[String]$ComputerName=$env:COMPUTERNAME,
	[Switch]$CreateConfiguration,
	[String]$Path = "$env:USERPROFILE\UpstreamPowerPack",
	[Switch]$ErrorLog,
	[String]$LogFile = "$Path\Encrypt.ps1_$(Get-Date -Format "yyyy-MM-dd HH:mm:ss").log"
)


Begin {
	if($ErrorLog) {
		Write-Verbose "Error loggning is enabled."
		Write-Verbose "Location: $LogFile"
		Write-Verbose ""
	} else {
		Write-Verbose "Error loggning is disabled."
		Write-Verbose ""
	}

	Write-Verbose "PARAMETERS"
	Write-Verbose "OrganizationId:      $($OrganizationId)"
	Write-Verbose "OrganizationName:    $($OrganizationName)"
	Write-Verbose "MountPoint:          $($MountPoint)"
	Write-Verbose "ComputerName:        $($ComputerName)"
	Write-Verbose "CreateConfiguration: $($CreateConfiguration)"
	Write-Verbose "Path:                $($Path)"
	Write-Verbose "ErrorLog:            $($ErrorLog)"
	Write-Verbose "LogFile:             $($LogFile)"
	Write-Verbose ""

	if($PSCmdlet.ParameterSetName -eq "Name") {
		$OrganizationId = (Get-ITGlueOrganizations -filter_name $OrganizationName).data.id

		if(-not $OrganizationId) {
			Write-Verbose "No Organization Name found."
			Write-Verbose "Exiting."
			exit
		} elseif ($OrganizationId.Lenght -gt 1) {
			Write-Verbose "More than one Organization found."
			Write-Verbose "Please specify more specific."
			Write-Verbose "Exiting."
			exit
		}
	}

	if($OrganizationId) {
		Write-Verbose "Finding configuration..."
		$configuration = Get-ITGlueConfigurations -organization_id $OrganizationId | Where {$_.attributes.name -like "*$ComputerName*"}
		Write-Verbose "Result: $($configuration)"
		Write-Verbose ""

		if(-not $configuration) {
			Write-Verbose "No configuration was found."
			if($CreateConfiguration) {
				Write-Verbose "Creating new configuration."
				#new config
				$properties = @{
					"ConfigName" = $configName
					"ConfigType" = $configType
					"ConfigStatus" = $configStatus
				}
				$object = New-Object -TypeName PSObject -Property $properties
			} else {
				Write-Verbose "Not creating configuration."
				Write-Verbose "Exiting"
				exit
			}
		}
	} else {
		Write-Verbose "No OrganizationId, exiting."
		exit
	}
}
Process {
	Write-Verbose "Encrypting $MountPoint"
	$encryption = Enable-BitLocker -MountPoint $MountPoint -RecoveryPasswordProtector -SkipHardwareTest
	Write-Verbose "Status $encryption"

	$body = {
		data = @(
			
		)
	}
	# $encryption.KeyProtector.KeyProtectorId
	# $encryption.KeyProtector.KeyProtectorType
	# $encryption.KeyProtector.RecoveryPassword
}