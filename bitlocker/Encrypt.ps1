param(
	[String]$MountPoint="G:"
)


$BitlockerResult = manage-bde -on $MountPoint -RecoveryPassword -SkipHardwareTest