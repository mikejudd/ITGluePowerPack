$body = @{
    data = @{
        type = "configurations"
        attributes = @{
            model = "$((gwmi win32_ComputerSystem).Manufacturer) $((gwmi win32_ComputerSystem).model)"
            serial_number = (gwmi win32_bios).SerialNumber
            primary_ip = (Get-NetIPAddress | where {$_.AddressFamily -eq "IPv4" -and $_.IPAddress -ne "127.0.0.1"}).IPAddress
            hostname = $env:computername
            mac_address = (get-wmiobject -class "Win32_NetworkAdapterConfiguration"  |Where{$_.IpEnabled -Match "True"}).MACaddress
            operating_system_id = 111
            operating_system_name = "Windows 10"
            configuration_type_name = "Workstation"
        }
    }
}

$organizationid = 2504761

New-ITGlueConfigurations -organization_id $organizationid -data $body