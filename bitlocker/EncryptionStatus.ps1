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