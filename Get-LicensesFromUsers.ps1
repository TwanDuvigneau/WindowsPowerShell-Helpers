Import-Module ImportExcel

$ExcelPath = 'C:\temp\userlicenses.xlsx'

Connect-AzureAD
Connect-MsolService

$Sku = @{
	"O365_BUSINESS_ESSENTIALS"		     = "Office 365 Business Essentials"
	"O365_BUSINESS_PREMIUM"			     = "Office 365 Business Premium"
	"DESKLESSPACK"					     = "Office 365 (Plan K1)"
	"DESKLESSWOFFPACK"				     = "Office 365 (Plan K2)"
	"LITEPACK"						     = "Office 365 (Plan P1)"
	"EXCHANGESTANDARD"				     = "Office 365 Exchange Online Only"
	"STANDARDPACK"					     = "Enterprise Plan E1"
	"STANDARDWOFFPACK"				     = "Office 365 (Plan E2)"
	"ENTERPRISEPACK"					 = "Enterprise Plan E3"
	"ENTERPRISEPACKLRG"				     = "Enterprise Plan E3"
	"ENTERPRISEWITHSCAL"				 = "Enterprise Plan E4"
	"STANDARDPACK_STUDENT"			     = "Office 365 (Plan A1) for Students"
	"STANDARDWOFFPACKPACK_STUDENT"	     = "Office 365 (Plan A2) for Students"
	"ENTERPRISEPACK_STUDENT"			 = "Office 365 (Plan A3) for Students"
	"ENTERPRISEWITHSCAL_STUDENT"		 = "Office 365 (Plan A4) for Students"
	"STANDARDPACK_FACULTY"			     = "Office 365 (Plan A1) for Faculty"
	"STANDARDWOFFPACKPACK_FACULTY"	     = "Office 365 (Plan A2) for Faculty"
	"ENTERPRISEPACK_FACULTY"			 = "Office 365 (Plan A3) for Faculty"
	"ENTERPRISEWITHSCAL_FACULTY"		 = "Office 365 (Plan A4) for Faculty"
	"ENTERPRISEPACK_B_PILOT"			 = "Office 365 (Enterprise Preview)"
	"STANDARD_B_PILOT"				     = "Office 365 (Small Business Preview)"
	"VISIOCLIENT"					     = "Visio Pro Online"
	"POWER_BI_ADDON"					 = "Office 365 Power BI Addon"
	"POWER_BI_INDIVIDUAL_USE"		     = "Power BI Individual User"
	"POWER_BI_STANDALONE"			     = "Power BI Stand Alone"
	"POWER_BI_STANDARD"				     = "Power-BI Standard"
	"PROJECTESSENTIALS"				     = "Project Lite"
	"PROJECTCLIENT"					     = "Project Professional"
	"PROJECTONLINE_PLAN_1"			     = "Project Online"
	"PROJECTONLINE_PLAN_2"			     = "Project Online and PRO"
	"ProjectPremium"					 = "Project Online Premium"
	"ECAL_SERVICES"					     = "ECAL"
	"EMS"							     = "Enterprise Mobility Suite"
	"RIGHTSMANAGEMENT_ADHOC"			 = "Windows Azure Rights Management"
	"MCOMEETADV"						 = "PSTN conferencing"
	"SHAREPOINTSTORAGE"				     = "SharePoint storage"
	"PLANNERSTANDALONE"				     = "Planner Standalone"
	"CRMIUR"							 = "CMRIUR"
	"BI_AZURE_P1"					     = "Power BI Reporting and Analytics"
	"INTUNE_A"						     = "Windows Intune Plan A"
	"PROJECTWORKMANAGEMENT"			     = "Office 365 Planner Preview"
	"ATP_ENTERPRISE"					 = "Exchange Online Advanced Threat Protection"
	"EQUIVIO_ANALYTICS"				     = "Office 365 Advanced eDiscovery"
	"AAD_BASIC"						     = "Azure Active Directory Basic"
	"RMS_S_ENTERPRISE"				     = "Azure Active Directory Rights Management"
	"AAD_PREMIUM"					     = "Azure Active Directory Premium"
	"MFA_PREMIUM"					     = "Azure Multi-Factor Authentication"
	"STANDARDPACK_GOV"				     = "Microsoft Office 365 (Plan G1) for Government"
	"STANDARDWOFFPACK_GOV"			     = "Microsoft Office 365 (Plan G2) for Government"
	"ENTERPRISEPACK_GOV"				 = "Microsoft Office 365 (Plan G3) for Government"
	"ENTERPRISEWITHSCAL_GOV"			 = "Microsoft Office 365 (Plan G4) for Government"
	"DESKLESSPACK_GOV"				     = "Microsoft Office 365 (Plan K1) for Government"
	"ESKLESSWOFFPACK_GOV"			     = "Microsoft Office 365 (Plan K2) for Government"
	"EXCHANGESTANDARD_GOV"			     = "Microsoft Office 365 Exchange Online (Plan 1) only for Government"
	"EXCHANGEENTERPRISE_GOV"			 = "Microsoft Office 365 Exchange Online (Plan 2) only for Government"
	"SHAREPOINTDESKLESS_GOV"			 = "SharePoint Online Kiosk"
	"EXCHANGE_S_DESKLESS_GOV"		     = "Exchange Kiosk"
	"RMS_S_ENTERPRISE_GOV"			     = "Windows Azure Active Directory Rights Management"
	"OFFICESUBSCRIPTION_GOV"			 = "Office ProPlus"
	"MCOSTANDARD_GOV"				     = "Lync Plan 2G"
	"SHAREPOINTWAC_GOV"				     = "Office Online for Government"
	"SHAREPOINTENTERPRISE_GOV"		     = "SharePoint Plan 2G"
	"EXCHANGE_S_ENTERPRISE_GOV"		     = "Exchange Plan 2G"
	"EXCHANGE_S_ARCHIVE_ADDON_GOV"	     = "Exchange Online Archiving"
	"EXCHANGE_S_DESKLESS"			     = "Exchange Online Kiosk"
	"SHAREPOINTDESKLESS"				 = "SharePoint Online Kiosk"
	"SHAREPOINTWAC"					     = "Office Online"
	"YAMMER_ENTERPRISE"				     = "Yammer Enterprise"
	"EXCHANGE_L_STANDARD"			     = "Exchange Online (Plan 1)"
	"MCOLITE"						     = "Lync Online (Plan 1)"
	"SHAREPOINTLITE"					 = "SharePoint Online (Plan 1)"
	"OFFICE_PRO_PLUS_SUBSCRIPTION_SMBIZ" = "Office ProPlus"
	"EXCHANGE_S_STANDARD_MIDMARKET"	     = "Exchange Online (Plan 1)"
	"MCOSTANDARD_MIDMARKET"			     = "Lync Online (Plan 1)"
	"SHAREPOINTENTERPRISE_MIDMARKET"	 = "SharePoint Online (Plan 1)"
	"OFFICESUBSCRIPTION"				 = "Office ProPlus"
	"YAMMER_MIDSIZE"					 = "Yammer"
	"DYN365_ENTERPRISE_PLAN1"		     = "Dynamics 365 Customer Engagement Plan Enterprise Edition"
	"ENTERPRISEPREMIUM_NOPSTNCONF"	     = "Enterprise E5 (without Audio Conferencing)"
	"ENTERPRISEPREMIUM"				     = "Enterprise E5 (with Audio Conferencing)"
	"MCOSTANDARD"					     = "Skype for Business Online Standalone Plan 2"
	"PROJECT_MADEIRA_PREVIEW_IW_SKU"	 = "Dynamics 365 for Financials for IWs"
	"STANDARDWOFFPACK_IW_STUDENT"	     = "Office 365 Education for Students"
	"STANDARDWOFFPACK_IW_FACULTY"	     = "Office 365 Education for Faculty"
	"EOP_ENTERPRISE_FACULTY"			 = "Exchange Online Protection for Faculty"
	"EXCHANGESTANDARD_STUDENT"		     = "Exchange Online (Plan 1) for Students"
	"OFFICESUBSCRIPTION_STUDENT"		 = "Office ProPlus Student Benefit"
	"STANDARDWOFFPACK_FACULTY"		     = "Office 365 Education E1 for Faculty"
	"STANDARDWOFFPACK_STUDENT"		     = "Microsoft Office 365 (Plan A2) for Students"
	"DYN365_FINANCIALS_BUSINESS_SKU"	 = "Dynamics 365 for Financials Business Edition"
	"DYN365_FINANCIALS_TEAM_MEMBERS_SKU" = "Dynamics 365 for Team Members Business Edition"
	"FLOW_FREE"						     = "Microsoft Flow Free"
	"POWER_BI_PRO"					     = "Power BI Pro"
	"O365_BUSINESS"					     = "Office 365 Business"
	"DYN365_ENTERPRISE_SALES"		     = "Dynamics Office 365 Enterprise Sales"
	"RIGHTSMANAGEMENT"				     = "Rights Management"
	"PROJECTPROFESSIONAL"			     = "Project Professional"
	"VISIOONLINE_PLAN1"				     = "Visio Online Plan 1"
	"EXCHANGEENTERPRISE"				 = "Exchange Online Plan 2"
	"DYN365_ENTERPRISE_P1_IW"		     = "Dynamics 365 P1 Trial for Information Workers"
	"DYN365_ENTERPRISE_TEAM_MEMBERS"	 = "Dynamics 365 For Team Members Enterprise Edition"
	"CRMSTANDARD"					     = "Microsoft Dynamics CRM Online Professional"
	"EXCHANGEARCHIVE_ADDON"			     = "Exchange Online Archiving For Exchange Online"
	"EXCHANGEDESKLESS"				     = "Exchange Online Kiosk"
	"SPZA_IW"						     = "App Connect"
	"WINDOWS_STORE"					     = "Windows Store for Business"
	"MCOEV"							     = "Microsoft Phone System"
	"VIDEO_INTEROP"					     = "Polycom Skype Meeting Video Interop for Skype for Business"
	"SPE_E5"							 = "Microsoft 365 E5"
	"SPE_E3"							 = "Microsoft 365 E3"
	"ATA"							     = "Advanced Threat Analytics"
	"MCOPSTN2"						     = "Domestic and International Calling Plan"
	"FLOW_P1"						     = "Microsoft Flow Plan 1"
	"FLOW_P2"						     = "Microsoft Flow Plan 2"
	"CRMSTORAGE"						 = "Microsoft Dynamics CRM Online Additional Storage"
	"SMB_APPS"						     = "Microsoft Business Apps"
	"MICROSOFT_BUSINESS_CENTER"		     = "Microsoft Business Center"
	"DYN365_TEAM_MEMBERS"			     = "Dynamics 365 Team Members"
	"STREAM"							 = "Microsoft Stream Trial"
	"EMSPREMIUM"                         = "ENTERPRISE MOBILITY + SECURITY E5"
}

$Users = Get-MsolUser -All | Where-Object { $_.isLicensed -eq "TRUE" }

$LicenseResults = @()

Foreach ($User in $Users) {

    $Licenses = ((Get-MsolUser -UserPrincipalName $User.UserPrincipalName).Licenses).AccountSkuID

    Foreach ($License in $Licenses) {
        $LicenseItem = ($License -split ':')[1]
        $TextLic = $Sku.Item("$LicenseItem")

        If (!($TextLic)) {
            $TextLic = $LicenseItem
        }

        $LicObj = @{
            Name          = $User.DisplayName
            UserName      = $User.UserPrincipalName
            Department    = $User.Department
            Function      = $User.Title
            "$($TextLic)" = $true
        }

        $LicenseResults += $LicObj

    }
}

[System.Collections.ArrayList]$LicenseKeys = $LicenseResults.keys | Sort-Object -Unique

$LicenseKeys.RemoveAt($LicenseKeys.IndexOf('Name'))
$LicenseKeys.RemoveAt($LicenseKeys.IndexOf('UserName'))

ForEach($license in $LicenseKeys) {
   
    $licenseTable = $LicenseResults | Where-Object {$_.$license}

    $Licensetocsv = @()
    
    $licenseTable | ForEach-Object {
        $Licensetocsv += [pscustomobject] @{
            UserName   = $_.UserName
            Name       = $_.Name
            Department = $_.Department
            Function   = $_.Function
            License    = $license
        }
    }

    $LicenseTableCSV = $Licensetocsv.GetEnumerator() | Convertto-csv -NoTypeInformation

    ConvertFrom-Csv $LicenseTableCSV | Export-Excel -Path $ExcelPath -WorkSheetname $license
    
}
