<#
    .SYNOPSIS
        This script can push registry key(s) while running as User.

    .DESCRIPTION
        Items in the hash table array $RegistryItems will be written to the registry, fill this variable as follows:
            RegistryPath: The path to the registry key (excluding key name), start with KHCU: or HKLM:
            Key: Name of the registry key to create or set
            Value: Value to be written to the registry key
            Force: Set to $TRUE if the registry key needs to be created, set to $FALSE if it only needs to be updates
            Type: Specify the registry key type, following types are available:
                    String
                    ExpandedString
                    Binary
                    DWord
                    MultiString
                    QWord
                    Unknown

    .NOTES
        Author: Twan Duvigneau.
        Version: 1
#>

#
#region Start
#

$RegistryItems = @(
    @{
        RegistryPath = 'HKCU:\Software\Microsoft\Office\Outlook\Addins\DocumentBuilderMicrosoftOfficeAddin.AddinModule'
        Key          = 'LoadBehavior'
        Value        = 3
        Force        = $FALSE
        Type         = 'DWord'
    }
)

#
#endregion Start
#

#
#region Process
#

$RegistryItems | ForEach-Object {
    if (Test-Path $_.RegistryPath) {

        $ItemProperties = Get-ItemProperty -Path $_.RegistryPath
        
        if ((Get-Member -InputObject $ItemProperties -Name $_.Key -ErrorAction SilentlyContinue) -or $_.Force) {
            
            try {
                Set-ItemProperty -Path $_.RegistryPath -Name $_.Key -Value $_.Value -Force:$_.Force -Type $_.Type
                write-verbose -verbose "Registry key with the name $($_.Key) has been succesfully set"
            }
            catch {
                Throw $_
            }
        } 
        else {
            Throw "Registry key does not exist: $($_.Key)"
        }
        
    } 
    else {
        Throw "Registry path does not exist: $($_.RegistryPath)"
    }
}

#
#endregion Process
#
