Connect-AzureAD

$Config = @{
    SkuIDLicense = '3b555118-da6a-4418-894f-7df1e2096870'
    OutFile = @{
        Enabled = $TRUE
        Path    = "C:\temp"
    }
}

class LicenseRemovalLog {
    [string]$Username
    [string]$DisplayName
    [string]$License
    [boolean]$RemovedLicense
    [string]$Log;

    LicenseRemovalLog(
        [string]$Username,
        [string]$DisplayName,
        [string]$License,
        [boolean]$RemovedLicense,
        [string]$Log
    ){
        $this.Username = $Username
        $this.DisplayName = $DisplayName
        $this.License = $License
        $this.RemovedLicense = $RemovedLicense
        $this.Log = $Log
    }
}

$LicGroup        = Get-AzureADGroup -SearchString 'LIC_Microsoft_365_Business_Premium'
$LicGroupMembers = Get-AzureADGroupMember -ObjectId $licGroup.ObjectId

$Licensesrequest = [Microsoft.Open.AzureAD.Model.AssignedLicenses]::new()
$Licensesrequest.RemoveLicenses = $Config.SkuIDLicense

ForEach($Member in $LicGroupMembers) {

    $licenses = Get-AzureADUserLicenseDetail -ObjectID $member.ObjectID
    
    if ($Config.SkuIDLicense -in $Licenses.SkuId) {
        Write-Verbose -Verbose "REMOVE: Business Basic license from $($Member.DisplayName) - $($Member.UserPrincipalNam)"
        try {
            Set-AzureADUserLicense -ObjectId $Member.ObjectID -AssignedLicenses $Licensesrequest

            $LicenseLog += @([LicenseRemovalLog]::new($Member.UserPrincipalName,$Member.DisplayName,$Config.SkuIDLicense,$True,"Succesfully removed"))

        } catch {
            Write-Error "Failed to remove license from $($Member.DisplayName) - $($Member.UserPrincipalNam)"
            $LicenseLog += @([LicenseRemovalLog]::new($Member.UserPrincipalName,$Member.DisplayName,$Config.SkuIDLicense,$False,"Failed to removed"))
        }

    } else {
        Write-Verbose -Verbose "NOT: User has no business basic license $($Member.DisplayName) - $($Member.UserPrincipalNam)"
        $LicenseLog += @([LicenseRemovalLog]::new($Member.UserPrincipalName,$Member.DisplayName,$Config.SkuIDLicense,$False,"Skipped remove succesfully"))
    }

}

If ($Config.OutFile.Enabled) {
    try {
        $CSV = $LicenseLog | ConvertTo-Csv -NoTypeInformation
    } catch {

    } finally {
        $CSV | Out-File -FilePath "$($Config.OutFile.Path)\LicenseRemoval-$($Config.SkuIDLicense).csv" -Force
    }
}

$LicenseLog

$LicenseLog.Clear()

Disconnect-AzureAD
