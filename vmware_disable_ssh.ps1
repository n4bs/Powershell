######################################################################
# Stop SSH Service, change Startup Policy                            #
######################################################################
  
#Variables
$vCenter = "1.1.1.1"
$Cluster = "vcenterprod.abc.local"


Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
Set-PowerCLIConfiguration -ProxyPolicy NoProxy  -Confirm:$false

### Start of Script
# Load VMware Cmdlet and connect to vCenter
Add-PSSnapin vmware.vimautomation.core
connect-viserver -server $vCenter
  
$VMHost = Get-Cluster -Name $Cluster | Get-VMhost
  
# Stop SSH Server on a Cluster
ForEach ($VMhost in $Cluster){
Write-Host -ForegroundColor GREEN "Stop SSH Service on " -NoNewline
Write-Host -ForegroundColor YELLOW "$VMhost"
Get-VMHost | Get-VMHostService | ? {($_.Key -eq "TSM-ssh") -and ($_.Running -eq $False)} | Stop-VMHostService
}
  
# Change Startup Policy
ForEach ($VMhost in $Cluster){
Write-Host -ForegroundColor GREEN "Setting Startup Policy off " -NoNewline
Write-Host -ForegroundColor YELLOW "$VMhost"
Get-VMHost | Get-VMHostService | where { $_.key -eq "TSM-SSH" } | Set-VMHostService -Policy "Off" -Confirm:$false -ea 1
}



### End of Script
