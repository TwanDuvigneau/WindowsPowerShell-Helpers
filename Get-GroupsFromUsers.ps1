#Install-Module ImportExcel
#Install-Module AzureAD

Import-Module ImportExcel

$ExcelPath = 'C:\temp\usergroups.xlsx'

Connect-AzureAD

$Users = Get-AzureADUser -All $true | Where-Object {$_.UserPrincipalName -NotLike '*EXT*'}

$GroupsResults = @()

Foreach ($User in $Users) {

    $Groups = (Get-AzureADUserMembership -ObjectID $User.ObjectID).DisplayName

    $GroupObj = [pscustomobject]@{
        Name          = $User.DisplayName
        UserName      = $User.UserPrincipalName
        Department    = $User.Department
        Function      = $User.Title
        Groups        = $Groups -join ', '
    }

    $GroupsResults += $GroupObj
}

$GroupsResults | Export-Excel -Path $ExcelPath -WorkSheetname 'AzureAD Groups'