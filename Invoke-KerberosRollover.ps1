<#
        .SYNOPSIS
            Roll over kerberos keys.

        .DESCRIPTION
            Required AAD Connect to be installed on the host. This process should be initiated every month.
            Requires the Microsoft Azure Active Directory Connect AzureADSSO module, which is installed with AAD Connect.
        
        .AUTHOR
            t.duvigneau@it-value.nl

        .COMPANYNAME
            IT-Value B.V.

        .EXTERNALMODULEDEPENDENCIES
            AzureADSSO

        .VERSION
            1.0
#>

Import-Module 'C:\Program Files\Microsoft Azure Active Directory Connect\AzureADSSO.psd1'

# Set TLS to accept TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = @(
    [Net.SecurityProtocolType]::Tls12
)

New-AzureADSSOAuthenticationContext -CloudCredentials (Get-AutomationPSCredential -Name 'KerberosRollOverAzureADM')
Update-AzureADSSOForest -OnPremCredentials (Get-AutomationPSCredential -Name 'KerberosRollOverLocalADM') -PreserveCustomPermissionsOnDesktopSsoAccount

if (-not $error) {
    Write-Verbose -verbose 'Succesfully rolled over kerberos keys'
} else {
    $error
}
