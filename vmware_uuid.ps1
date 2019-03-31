######################################################################
#  Get UUID                                                          #
######################################################################
  
#Variables
$vCenter = "1.1.1.1"
$Cluster = "vcenterprod.abc.local"

Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
Set-PowerCLIConfiguration -ProxyPolicy NoProxy -Confirm:$false

  
### Start of Script
# Load VMware Cmdlet and connect to vCenter
Add-PSSnapin vmware.vimautomation.core
connect-viserver -server $vCenter
  
$VMHost = Get-Cluster -Name $Cluster | Get-VMhost
  
# Start SSH Server on a Cluster
ForEach ($VMhost in $Cluster){
Get-VMHost | Select Name,@{n="HostUUID";e={$_.ExtensionData.hardware.systeminfo.uuid}}
}
  

### End of Script
