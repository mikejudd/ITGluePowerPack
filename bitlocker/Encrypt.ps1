[cmdletbinding(DefaultParameterSetName='ID')]
param(
	[Parameter(ParameterSetName='ID')]
	[Parameter(Mandatory=$true)]
	[int]$OrganizationId,

	[Parameter(ParameterSetName='Name')]
	[Parameter(Mandatory=$true)]
	[String]$OrganizationName,

	[Parameter(ParameterSetName='ID')]
	[Parameter(ParameterSetName='Name')]
	[String]$MountPoint="G:",

	[Parameter(ParameterSetName='ID')]
	[Parameter(ParameterSetName='Name')]
	[String]$ComputerName=$env:COMPUTERNAME,

	[Parameter(ParameterSetName='ID')]
	[Parameter(ParameterSetName='Name')]
	[Switch]$CreateConfiguration
)



$encryption = Enable-BitLocker -MountPoint $MountPoint -RecoveryPasswordProtector -SkipHardwareTest
$encryption.KeyProtector.KeyProtectorId
$encryption.KeyProtector.KeyProtectorType
$encryption.KeyProtector.RecoveryPassword

#ParameterSet ID
if($PSCmdlet.ParameterSetName -eq "ID") {
	$configuration = Get-ITGlueConfigurations -filter_organization_id $OrganizationId | Where {$_.attributes.name -eq $ComputerName}

	if(-not $configuration -and $CreateConfiguration) {
		#new config
		$configName=""
		$configType=""
		$configStatus=""
	}

#ParameterSet Name
} elseif($PSCmdlet.ParameterSetName -eq "Name") {
	Get-ITGlueConfigurations | Where {$_.attributes.hostname -like $ComputerName}
}