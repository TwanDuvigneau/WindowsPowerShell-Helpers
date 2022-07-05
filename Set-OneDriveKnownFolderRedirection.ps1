<#
    .SYNOPSIS
        This script redirects known folders to onedrive

    .NOTES
        Author: Twan Duvigneau.
        Version: 2
#>

#
#region Config
#

Enum KnownFolderList {
    AddNewPrograms
    AdminTools
    AppUpdates
    CDBurning
    ChangeRemovePrograms
    CommonAdminTools
    CommonOEMLinks
    CommonPrograms
    CommonStartMenu
    CommonStartup
    CommonTemplates
    ComputerFolder
    ConflictFolder
    ConnectionsFolder
    Contacts
    ControlPanelFolder
    Cookies
    Desktop
    Documents
    Downloads
    Favorites
    Fonts
    Games
    GameTasks
    History
    InternetCache
    InternetFolder
    Links
    LocalAppData
    LocalAppDataLow
    LocalizedResourcesDir
    Music
    NetHood
    NetworkFolder
    OriginalImages
    PhotoAlbums
    Pictures
    Playlists
    PrintersFolder
    PrintHood
    Profile
    ProgramData
    ProgramFiles
    ProgramFilesX64
    ProgramFilesX86
    ProgramFilesCommon
    ProgramFilesCommonX64
    ProgramFilesCommonX86
    Programs
    Public
    PublicDesktop
    PublicDocuments
    PublicDownloads
    PublicGameTasks
    PublicMusic
    PublicPictures
    PublicVideos
    QuickLaunch
    Recent
    RecycleBinFolder
    ResourceDir
    RoamingAppData
    SampleMusic
    SamplePictures
    SamplePlaylists
    SampleVideos
    SavedGames
    SavedSearches
    SEARCH_CSC
    SEARCH_MAPI
    SearchHome
    SendTo
    SidebarDefaultParts
    SidebarParts
    StartMenu
    Startup
    SyncManagerFolder
    SyncResultsFolder
    SyncSetupFolder
    System
    SystemX86
    Templates
    TreeProperties
    UserProfiles
    UsersFiles
    Videos
    Windows
}

$RegistryItems = @(
    @{
        RegistryPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders'
        Key          = '{374DE290-123F-4565-9164-39C4925E467B}'
        Value        = '%USERPROFILE%\Onedrive\Downloads'
        Force        = $TRUE
        Type         = 'ExpandString'
    },
    @{
        RegistryPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders'
        Key          = '{7D83EE9B-2244-4E70-B1F5-5393042AF1E4}'
        Value        = '%USERPROFILE%\Onedrive\Downloads'
        Force        = $TRUE
        Type         = 'ExpandString'
    }
)

$FolderRedirection = @(
    @{
        Folder = 'Downloads'
        Path   = "$($env:USERPROFILE)\Onedrive\Downloads"
        MoveFiles = $True
    }
)
#

#
#region Config
#

#
#region Functions
#
Function Set-KnownFolderPath {
    
    [CmdletBinding()]
    [OutputType([System.String])]
    Param (
            [Parameter(
                Mandatory = $true
            )]
            [ValidateNotNullOrEmpty()]
            [KnownFolderList]
            $KnownFolder,

            [Parameter(
                Mandatory = $true
            )]
            [ValidateNotNullOrEmpty()]
            [System.String]
            $Path,

            [Parameter(
                Mandatory = $false
            )]
            [System.Boolean]
            $MoveFiles = $true
    )

    Begin
    {
        $KnownFolders = @{
            [KnownFolderList]::AddNewPrograms = 'de61d971-5ebc-4f02-a3a9-6c82895e5c04'
            [KnownFolderList]::AdminTools = '724EF170-A42D-4FEF-9F26-B60E846FBA4F'
            [KnownFolderList]::AppUpdates = 'a305ce99-f527-492b-8b1a-7e76fa98d6e4'
            [KnownFolderList]::CDBurning = '9E52AB10-F80D-49DF-ACB8-4330F5687855'
            [KnownFolderList]::ChangeRemovePrograms = 'df7266ac-9274-4867-8d55-3bd661de872d'
            [KnownFolderList]::CommonAdminTools = 'D0384E7D-BAC3-4797-8F14-CBA229B392B5'
            [KnownFolderList]::CommonOEMLinks = 'C1BAE2D0-10DF-4334-BEDD-7AA20B227A9D'
            [KnownFolderList]::CommonPrograms = '0139D44E-6AFE-49F2-8690-3DAFCAE6FFB8'
            [KnownFolderList]::CommonStartMenu = 'A4115719-D62E-491D-AA7C-E74B8BE3B067'
            [KnownFolderList]::CommonStartup = '82A5EA35-D9CD-47C5-9629-E15D2F714E6E'
            [KnownFolderList]::CommonTemplates = 'B94237E7-57AC-4347-9151-B08C6C32D1F7'
            [KnownFolderList]::ComputerFolder = '0AC0837C-BBF8-452A-850D-79D08E667CA7'
            [KnownFolderList]::ConflictFolder = '4bfefb45-347d-4006-a5be-ac0cb0567192'
            [KnownFolderList]::ConnectionsFolder = '6F0CD92B-2E97-45D1-88FF-B0D186B8DEDD'
            [KnownFolderList]::Contacts = '56784854-C6CB-462b-8169-88E350ACB882'
            [KnownFolderList]::ControlPanelFolder = '82A74AEB-AEB4-465C-A014-D097EE346D63'
            [KnownFolderList]::Cookies = '2B0F765D-C0E9-4171-908E-08A611B84FF6'
            [KnownFolderList]::Desktop = @('B4BFCC3A-DB2C-424C-B029-7FE99A87C641')
            [KnownFolderList]::Documents = @('FDD39AD0-238F-46AF-ADB4-6C85480369C7','f42ee2d3-909f-4907-8871-4c22fc0bf756')
            [KnownFolderList]::Downloads = @('374DE290-123F-4565-9164-39C4925E467B','7d83ee9b-2244-4e70-b1f5-5393042af1e4')
            [KnownFolderList]::Favorites = '1777F761-68AD-4D8A-87BD-30B759FA33DD'
            [KnownFolderList]::Fonts = 'FD228CB7-AE11-4AE3-864C-16F3910AB8FE'
            [KnownFolderList]::Games = 'CAC52C1A-B53D-4edc-92D7-6B2E8AC19434'
            [KnownFolderList]::GameTasks = '054FAE61-4DD8-4787-80B6-090220C4B700'
            [KnownFolderList]::History = 'D9DC8A3B-B784-432E-A781-5A1130A75963'
            [KnownFolderList]::InternetCache = '352481E8-33BE-4251-BA85-6007CAEDCF9D'
            [KnownFolderList]::InternetFolder = '4D9F7874-4E0C-4904-967B-40B0D20C3E4B'
            [KnownFolderList]::Links = 'bfb9d5e0-c6a9-404c-b2b2-ae6db6af4968'
            [KnownFolderList]::LocalAppData = 'F1B32785-6FBA-4FCF-9D55-7B8E7F157091'
            [KnownFolderList]::LocalAppDataLow = 'A520A1A4-1780-4FF6-BD18-167343C5AF16'
            [KnownFolderList]::LocalizedResourcesDir = '2A00375E-224C-49DE-B8D1-440DF7EF3DDC'
            [KnownFolderList]::Music = @('4BD8D571-6D19-48D3-BE97-422220080E43','a0c69a99-21c8-4671-8703-7934162fcf1d')
            [KnownFolderList]::NetHood = 'C5ABBF53-E17F-4121-8900-86626FC2C973'
            [KnownFolderList]::NetworkFolder = 'D20BEEC4-5CA8-4905-AE3B-BF251EA09B53'
            [KnownFolderList]::OriginalImages = '2C36C0AA-5812-4b87-BFD0-4CD0DFB19B39'
            [KnownFolderList]::PhotoAlbums = '69D2CF90-FC33-4FB7-9A0C-EBB0F0FCB43C'
            [KnownFolderList]::Pictures = @('33E28130-4E1E-4676-835A-98395C3BC3BB','0ddd015d-b06c-45d5-8c4c-f59713854639')
            [KnownFolderList]::Playlists = 'DE92C1C7-837F-4F69-A3BB-86E631204A23'
            [KnownFolderList]::PrintersFolder = '76FC4E2D-D6AD-4519-A663-37BD56068185'
            [KnownFolderList]::PrintHood = '9274BD8D-CFD1-41C3-B35E-B13F55A758F4'
            [KnownFolderList]::Profile = '5E6C858F-0E22-4760-9AFE-EA3317B67173'
            [KnownFolderList]::ProgramData = '62AB5D82-FDC1-4DC3-A9DD-070D1D495D97'
            [KnownFolderList]::ProgramFiles = '905e63b6-c1bf-494e-b29c-65b732d3d21a'
            [KnownFolderList]::ProgramFilesX64 = '6D809377-6AF0-444b-8957-A3773F02200E'
            [KnownFolderList]::ProgramFilesX86 = '7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E'
            [KnownFolderList]::ProgramFilesCommon = 'F7F1ED05-9F6D-47A2-AAAE-29D317C6F066'
            [KnownFolderList]::ProgramFilesCommonX64 = '6365D5A7-0F0D-45E5-87F6-0DA56B6A4F7D'
            [KnownFolderList]::ProgramFilesCommonX86 = 'DE974D24-D9C6-4D3E-BF91-F4455120B917'
            [KnownFolderList]::Programs = 'A77F5D77-2E2B-44C3-A6A2-ABA601054A51'
            [KnownFolderList]::Public = 'DFDF76A2-C82A-4D63-906A-5644AC457385'
            [KnownFolderList]::PublicDesktop = 'C4AA340D-F20F-4863-AFEF-F87EF2E6BA25'
            [KnownFolderList]::PublicDocuments = 'ED4824AF-DCE4-45A8-81E2-FC7965083634'
            [KnownFolderList]::PublicDownloads = '3D644C9B-1FB8-4f30-9B45-F670235F79C0'
            [KnownFolderList]::PublicGameTasks = 'DEBF2536-E1A8-4c59-B6A2-414586476AEA'
            [KnownFolderList]::PublicMusic = '3214FAB5-9757-4298-BB61-92A9DEAA44FF'
            [KnownFolderList]::PublicPictures = 'B6EBFB86-6907-413C-9AF7-4FC2ABF07CC5'
            [KnownFolderList]::PublicVideos = '2400183A-6185-49FB-A2D8-4A392A602BA3'
            [KnownFolderList]::QuickLaunch = '52a4f021-7b75-48a9-9f6b-4b87a210bc8f'
            [KnownFolderList]::Recent = 'AE50C081-EBD2-438A-8655-8A092E34987A'
            [KnownFolderList]::RecycleBinFolder = 'B7534046-3ECB-4C18-BE4E-64CD4CB7D6AC'
            [KnownFolderList]::ResourceDir = '8AD10C31-2ADB-4296-A8F7-E4701232C972'
            [KnownFolderList]::RoamingAppData = '3EB685DB-65F9-4CF6-A03A-E3EF65729F3D'
            [KnownFolderList]::SampleMusic = 'B250C668-F57D-4EE1-A63C-290EE7D1AA1F'
            [KnownFolderList]::SamplePictures = 'C4900540-2379-4C75-844B-64E6FAF8716B'
            [KnownFolderList]::SamplePlaylists = '15CA69B3-30EE-49C1-ACE1-6B5EC372AFB5'
            [KnownFolderList]::SampleVideos = '859EAD94-2E85-48AD-A71A-0969CB56A6CD'
            [KnownFolderList]::SavedGames = '4C5C32FF-BB9D-43b0-B5B4-2D72E54EAAA4'
            [KnownFolderList]::SavedSearches = '7d1d3a04-debb-4115-95cf-2f29da2920da'
            [KnownFolderList]::SEARCH_CSC = 'ee32e446-31ca-4aba-814f-a5ebd2fd6d5e'
            [KnownFolderList]::SEARCH_MAPI = '98ec0e18-2098-4d44-8644-66979315a281'
            [KnownFolderList]::SearchHome = '190337d1-b8ca-4121-a639-6d472d16972a'
            [KnownFolderList]::SendTo = '8983036C-27C0-404B-8F08-102D10DCFD74'
            [KnownFolderList]::SidebarDefaultParts = '7B396E54-9EC5-4300-BE0A-2482EBAE1A26'
            [KnownFolderList]::SidebarParts = 'A75D362E-50FC-4fb7-AC2C-A8BEAA314493'
            [KnownFolderList]::StartMenu = '625B53C3-AB48-4EC1-BA1F-A1EF4146FC19'
            [KnownFolderList]::Startup = 'B97D20BB-F46A-4C97-BA10-5E3608430854'
            [KnownFolderList]::SyncManagerFolder = '43668BF8-C14E-49B2-97C9-747784D784B7'
            [KnownFolderList]::SyncResultsFolder = '289a9a43-be44-4057-a41b-587a76d7e7f9'
            [KnownFolderList]::SyncSetupFolder = '0F214138-B1D3-4a90-BBA9-27CBC0C5389A'
            [KnownFolderList]::System = '1AC14E77-02E7-4E5D-B744-2EB1AE5198B7'
            [KnownFolderList]::SystemX86 = 'D65231B0-B2F1-4857-A4CE-A8E7C6EA7D27'
            [KnownFolderList]::Templates= 'A63293E8-664E-48DB-A079-DF759E0509F7'
            [KnownFolderList]::TreeProperties = '5b3749ad-b49f-49c1-83eb-15370fbd4882'
            [KnownFolderList]::UserProfiles = '0762D272-C50A-4BB0-A382-697DCD729B80'
            [KnownFolderList]::UsersFiles = 'f3ce0f7c-4901-4acc-8648-d5d44b04ef8f'
            [KnownFolderList]::Videos = @('18989B1D-99B5-455B-841C-AB7C74E4DDFC','35286a68-3c57-41a1-bbb1-0eae73d76c95')
            [KnownFolderList]::Windows = 'F38BF404-1D43-42F2-9305-67DE0B28FC23'
        }
    
        $Type = ([System.Management.Automation.PSTypeName]'KnownFolders').Type
        If (-not $Type) {
            $Signature = @'
[DllImport("shell32.dll")]
public extern static int SHSetKnownFolderPath(ref Guid folderId, uint flags, IntPtr token, [MarshalAs(UnmanagedType.LPWStr)] string path);
'@
            $Type = Add-Type -MemberDefinition $Signature -Name 'KnownFolders' -Namespace 'SHSetKnownFolderPath' -PassThru
        }

    }

    Process
    {
        $CurrentLocation = if($KnownFolder -eq "Downloads"){
            (New-Object -ComObject Shell.Application).NameSpace("shell:Downloads").Self.Path
        }else{
            [Environment]::GetFolderPath($KnownFolder)
        }

        if (-not (Test-Path $Path -PathType Container)) {
	        New-Item -Path $Path -Type Directory -Force -Verbose
        }

        if (Test-Path $Path -PathType Container) {
            ForEach ($guid in $KnownFolders[[KnownFolderList]$KnownFolder]) {
                $result = $Type::SHSetKnownFolderPath([ref]$guid, 0, 0, $Path)
                if ($result -ne 0) {
                    Throw "Error redirecting $($KnownFolder). Return code $($result) = $((New-Object System.ComponentModel.Win32Exception($result)).message)"
                } else {
                    Write-Verbose -verbose "Succesfull set SHSetKnownFolderPath for $($KnownFolder): $($guid)"
                }
            }
        } else {
            Throw New-Object System.IO.DirectoryNotFoundException "Could not find part of the path $Path."
        }

        if ($MoveFiles) {
            Write-verbose -verbose "Moving files from $($CurrentLocation) to $($Path)"
            Get-ChildItem -Path $CurrentLocation -ErrorAction Continue | Copy-Item -Destination $Path -Recurse -Container -Force -Confirm:$False -ErrorAction SilentlyContinue
        }

        Attrib +h $KnownFolder

        [Environment]::SetEnvironmentVariable($KnownFolder, $Path, "User")
        
    }
}
#
#endregion Functions
#

#
#region Process
#
$FolderRedirection | ForEach-Object {
    $SetKnownFolder = @{
        KnownFolder = $_.Folder
        Path = $_.Path
        MoveFiles = $_.MoveFiles
    }
    Set-KnownFolderPath @SetKnownFolder
}


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
