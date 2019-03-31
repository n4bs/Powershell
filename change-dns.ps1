
###############################
#
# This script is to change DNS of computer in one OU or in a imput file
#
###############################


Import-Module ActiveDirectory
Set-PSDebug -Strict
Set-StrictMode -version latest

$Computers = Get-ADComputer -Server 1.1.1.1 -SearchBase "OU=N4BS,DC=nslab,DC=local" -Filter {(Enabled -eq $True)} |select DNSHostName 
#$Computers = get-content "C:\everIT\maquinas_dns.txt"

 

function Update-DNSServer {
    param (
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]$Computer,
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]$DNSServers
    )
 
 
 
    if ((Test-Connection $Computer -count 1 -ea 0 -quiet) -eq $true)
    {
        # Get all network adapters with enabled TCP/IP protocol
        $IPEnabledAdapters = get-wmiobject -Computer $Computer Win32_NetworkAdapterConfiguration -filter "ipenabled='true'"
 
        # Loop through each network adapter
        foreach ($Adapter in $IPEnabledAdapters) { 
     
            # Check if Adapter has DNS servers configured (to skip Multihomed Cluster Adapters/Servers)
            if ($Adapter.DNSServerSearchOrder -ne $null) {
                    Write-Host ($Computer + " Configured " + $Adapter.Caption + " with specified DNS Servers")
                    $result = $Adapter.setDNSServerSearchOrder($DNSServers)
                     
                    # if an error occured display the error code
                    if ($result.ReturnValue -ne 0)
                    {
                        Write-Error ("Error occured in setDNSServerSearchOrder() - error code " + $result.ReturnValue)
                    }
             }
          
             # No DNS servers configured for adapter
             else {
                Write-Warning ($Adapter.Caption + " has no DNS Server configured")
             }
        } 
    }
 
    else
    {
        Write-Warning ("Computer " + $Computer + " does not respond to ping requests - Ignoring")
    }
 
}


foreach ($Computer in $Computers)
{
    #Uncoment next line if you are using one input file   
    #Update-DNSServer -Computer $Computer -DNSServers @("10.5.1.11","10.5.59.4")
    #Uncoment nxt line if you are query AD
    #Update-DNSServer -Computer $Computer.DNSHostName -DNSServers @("10.5.1.11","10.5.59.4")
}
