Param ( [switch]$System, [switch]$Disks,
        [switch]$Network)

Import-Module mayurchaudhari

if ($System -eq $false -and $Disks -eq $false -and $Network -eq $false) {
      mayurchaudhari-System; mayurchaudhari-Disks; mayurchaudhari-Network;
} else {
      if ($System) {mayurchaudhari-System;}
      if ($Disks) {mayurchaudhari-Disks;}
      if ($Network) {mayurchaudhari-Network;}
}