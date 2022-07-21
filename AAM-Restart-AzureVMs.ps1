<#
	.SYNOPSIS
		Restart a Virtual Machine.

	.DESCRIPTION
		This runbook will restart a host or virtual machine without using a hybrid worker
	
	.NOTES
		AUTHOR: Twan Duvigneau

	.COMPANYNAME
        IT-Value B.V.

	.VERSION
        1.0
#>

Param
(
	[Parameter (Mandatory= $true)]
	[string[]] $VirtualMachines,

	[Parameter(Mandatory= $false)]
	[bool] $dryRun = $true
)

Import-Module Az.Accounts

$RestartedMachines = [Collections.Generic.List[PSCustomObject]]::new()

try {
	$ServicePrincipalConnection = Get-AutomationConnection -Name 'acc-restartvm'

	$ConnectAZ = @{
		CertificateThumbprint = $ServicePrincipalConnection.CertificateThumbprint 
		ApplicationID         = $ServicePrincipalConnection.ApplicationID
		Tenant                = $ServicePrincipalConnection.TenantID
		ServicePrincipal      = $true
	}

	[void](Connect-AzAccount @ConnectAZ)

	Write-Verbose -Verbose "Successfully logged into Azure subscription using Az cmdlets..."

	ForEach ($VirtualMachineName in $VirtualMachines) {

		Write-Verbose -Verbose "Processing VM $($VirtualMachineName)..."

		try {
			$VM = Get-AzVM -Name $VirtualMachineName
			
			if ($Null -eq $VM) {
				Throw "Could not find virtual machine for lookup value $($VirtualMachineName), check if the user principal has sufficient privileges"
			}

			if (-Not($dryRun -eq $True)) { 
				[void](Restart-AzVM -id $VM.id)
			} else {
				write-verbose -verbose "Restart-AzVM -id $($VM.id)" -NoWait:$true
			}

			$RestartedMachines.Add([PSCustomObject]@{
				Action   = "Restarting Virtual Machine"
				Resource = $VM.Name
				Message  = "Succesfully restarted virtual machine $($VM.Name)"
				IsError  = $false
			})

		} catch {
			$RestartedMachines.Add([PSCustomObject]@{
				Action   = "Restarting Virtual Machine"
				Resource = $VM.Name
				Message  = "Failed to restart virtual machine $($VM.Name)"
				IsError  = $false
				Error    = $_.Exception
			})
		}
		
	}

	Write-Output -InputObject $RestartedMachines
} Catch {
	Throw $_.Exception
}
