######################################################################
# Enable MOB                                                         #
######################################################################
  
#Variables
$vCenter = "1.1.1.1"
$Cluster = "vcenter.abc.local"



Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
Set-PowerCLIConfiguration -ProxyPolicy NoProxy  -Confirm:$false

### Start of Script
# Load VMware Cmdlet and connect to vCenter
Add-PSSnapin vmware.vimautomation.core
connect-viserver -server $vCenter
  
$VMHost = Get-Cluster -Name $Cluster | Get-VMhost
  
# Enable MOB
ForEach ($VMhost in $Cluster){
Get-VMHost | Set-VMHostAdvancedConfiguration -Name Config.HostAgent.plugins.solo.enableMob -Value True
}

### End of Script
