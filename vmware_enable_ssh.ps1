######################################################################
# Start SSH Service, change Startup Policy, and Suppress SSH Warning #
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
  
# Start SSH Server on a Cluster
ForEach ($VMhost in $Cluster){
Write-Host -ForegroundColor GREEN "Starting SSH Service on " -NoNewline
Write-Host -ForegroundColor YELLOW "$VMhost"
Get-VMHost | Get-VMHostService | ? {($_.Key -eq "TSM-ssh") -and ($_.Running -eq $False)} | Start-VMHostService
}
  
# Change Startup Policy
ForEach ($VMhost in $Cluster){
Write-Host -ForegroundColor GREEN "Setting Startup Policy on " -NoNewline
Write-Host -ForegroundColor YELLOW "$VMhost"
Get-VMHost | Get-VMHostService | where { $_.key -eq "TSM-SSH" } | Set-VMHostService -Policy "On" -Confirm:$false -ea 1
}
  
# Surpress SSH Warning
ForEach ($VMhost in $Cluster){
Write-Host -ForegroundColor GREEN "Setting UserVar to supress Shell warning on " -NoNewline
Write-Host -ForegroundColor YELLOW "$VMhost"
Get-VMhost | Get-AdvancedSetting | Where {$_.Name -eq "UserVars.SuppressShellWarning"} | Set-AdvancedSetting -Value "1" -Confirm:$false
}

### End of Script
