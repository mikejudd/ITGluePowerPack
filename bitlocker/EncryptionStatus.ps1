param(
	[String]$MountPoint="G:"
)


$idAndPassword = @(
	(manage-bde -protectors -get $MountPoint | Select -Index 9).Replace(" ","")
)