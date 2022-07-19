<#
.SYNOPSIS
    Restart a Virtual Machine.

.DESCRIPTION
    This runbook will restart a host or virtual machine without using a hybrid worker

.NOTES
    AUTHOR: Twan Duvigneau
#>

Param
(
	[Parameter (Mandatory= $true)]
	[string[]] $VirtualMachines
)

$RestartedMachines = [Collections.Generic.List[PSCustomObject]]::new()

try {
	$servicePrincipalConnection= Get-AutomationConnection -Name ''

	$AZConnection = @{
		ServicePrincipal      = $true
		TenantId              = $servicePrincipalConnection.TenantId
		ApplicationId         = $servicePrincipalConnection.ApplicationId
		CertificateThumbprint = $servicePrincipalConnection.CertificateThumbprint
	}

	Add-AzAccount @AZConnection
		
	Write-Verbose -Verbose "Successfully logged into Azure subscription using Az cmdlets..."
} Catch {
	Throw $_.Exception
}

ForEach ($VirtualMachineName in $VirtualMachines) {

	$GetVM = @{
		ResourceType = "Microsoft.Compute/VirtualMachines"
		Name         = $VirtualMachineName
	}

	$VM = Get-AzResource @GetVM

	Write-Verbose -Verbose "Processing VM $($VM.Name)..."

	try {
		#Restart-AzVM -id $VM.ResourceID -Force:$true

		$RestartedMachines.Add([PSCustomObject]@{
			Action   = "Restarting Virtual Machine"
			Resource = $($VM.Name)
			Message  = "Succesfully restarted virtual machine $($VM.Name)"
			IsError  = $false
		})

	} catch {
		$RestartedMachines.Add([PSCustomObject]@{
			Action   = "Restarting Virtual Machine"
			Resource = $($VM.Name)
			Message  = "Failed to restart virtual machine $($VM.Name)"
			IsError  = $false
		})

		Throw $_.Exception
	}
	
}

Write-Output -InputObject $RestartedMachines
