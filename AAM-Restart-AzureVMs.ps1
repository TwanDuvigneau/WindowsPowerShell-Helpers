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
	$ServicePrincipalConnection = Get-AutomationConnection -Name ''

	$ConnectAZ = @{
		CertificateThumbprint = $ServicePrincipalConnection.CertificateThumbprint 
		ApplicationID         = $ServicePrincipalConnection.ApplicationID
		Tenant                = $ServicePrincipalConnection.TenantID
		ServicePrincipal      = $true
	}
	Connect-AzAccount

	Set-AzContext -Subscription '897aea9a-c70e-4de2-897d-ed6cd82b6a82'

	Write-Verbose -Verbose "Successfully logged into Azure subscription using Az cmdlets..."

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
				Error    = $_.Exception
			})
		}
		
	}

	Write-Output -InputObject $RestartedMachines
} Catch {
	Throw $_.Exception
}