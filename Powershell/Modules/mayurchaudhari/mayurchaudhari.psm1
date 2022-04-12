function get-hardwareinfo {
Write-Host "Computer Hardware Inforamtion:"
Get-cimInstance -ClassName Win32_ComputerSystem| format-list
}

function get-myos {
Write-Host "OS Info:"
get-CimInstance -ClassName Win32_operatingsystem | format-list Name, version
}

function get-myprocessor {
Write-Host "Processor Details:"
get-CimInstance -Class win32_processor | fl Description, MaxClockSpeed, NumberOfCores,
@{n="L1CacheSize";e={switch($_.L1CacheSize){$null{$OutputVariable="data unavailable";$OutputVariable}};
if($null -ne $_.L1CacheSize){$_.L1CacheSize}}}, L2CacheSize, L3CacheSize
}

function get-mymem {
Write-Host "RAM info:"
$cinitapacity = 0
get-CimInstance -Class win32_physicalmemory |
foreach {
New-Object -TypeName psobject -Property @{
Manufacturer = $_.Manufacturer
Description = $_.description
"Size(GB)" = $_.Capacity/1gb
Bank = $_.banklabel
Slot = $_.Devicelocator
}
$cinitapacity += $_.capacity/1gb
} |
Format-table Manufacturer, Description, "Size(GB)", Bank, Slot
"Total RAM: ${cinitapacity}GB"
}

function get-mydisks {
Write-Host "Physical drive in Details:"
Get-WmiObject -class Win32_DiskDrive | ? DeviceID -ne $null |
foreach {
$drive = $_
$drive.GetRelated("Win32_DiskPartition")|
foreach {$logicaldisk= $_.GetRelated("win32_LogicalDisk");
if ($logicaldisk.size) {
New-Object -TypeName PSobject -Property @{
Manufacturer = $drive.manufacturer
DriveLetter = $logicaldisk.deviceID
Model = $drive.Model
Size = [string]($logicaldisk.size/1gb -as [int])+"GB"
Free= [String]((($logicaldisk.freespace / $logicaldisk.size) * 100) -as [int]) +"%"
FreeSpace = [string]($logicaldisk.freespace / 1gb -as [int])+ "GB"
}|
ft -AutoSize }}}}

function get-mynetwork {
Write-Host "NETWORK INFORMATION:"
get-ciminstance win32_networkadapterconfiguration |
where { $_.ipenabled -eq "True"} |
Format-table Description, Index, IPAddress, IPSubnet, 
@{n="DNSDomain";
e={switch($_.DNSdomain)
{$null{$OutputVariable1="data unavailable";$OutputVariable1 }};
if($null -ne $_.DNSdomain){$_.DNSdomain }}},
@{n="DNSServerSearchorder";
e={switch($_.DNSServerSearchorder)
{$null{$OutputVariable2="data unavailable";$OutputVariable2 }};
if($null -ne $_.DNSServerSearchorder){$_.DNSServerSearchorder }}}
}

function get-mygpu {
Write-Host "GPU resolution in details:"
$HX=(gwmi -class Win32_videocontroller).CurrentHorizontalResolution -as [String]
$VX=(gwmi -class win32_videocontroller).CurrentVerticalResolution -as [string]
$Bit=(gwmi -class win32_Videocontroller).CurrentBitsPerPixel -as [String]
$sum= $HX + " x " + $VX + " and " + $Bit + " bits"
gwmi win32_videocontroller |
format-list @{n="Video Card Vendor"; e={$_.Adaptercompatibility}},
Description,@{n="Resolution"; e={$sum -as [string]}}
}

function welcome {
write-output "Welcome to planet $env:computername Overlord $env:username"
$now = get-date -format 'HH:MM tt on dddd'
write-output "It is $now."
};
function get-cpuinfoo {
Get-CimInstance -ClassName cim_processor | fl Manufacturer, Name, CurrentClockSpeed, MaxClockSpeed, NumberOfCores
};
function get-mydisk{
Get-PhysicalDisk | ft Manufacturer, Model, SerialNumber, FirmwareVersion, Size
};

function mayurchaudhari-System {
get-myprocessor
get-myos
get-mymem
get-mygpu
}

function mayurchaudhari-Disks {
get-mydisks
}

function mayurchaudhari-Network {
get-mynetwork
}