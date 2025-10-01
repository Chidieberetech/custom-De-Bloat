<#
.SYNOPSIS
.Removes bloat from a fresh Windows build
.DESCRIPTION
.Removes AppX Packages
.Disables Cortana
.Removes McAfee
.Removes HP Bloat
.Removes Dell Bloat
.Removes Lenovo Bloat
.Windows 10 and Windows 11 Compatible
.Removes any unwanted installed applications
.Removes unwanted services and tasks
.Removes Edge Surf Game

.INPUTS
.OUTPUTS
C:\ProgramData\Debloat\Debloat.log
.NOTES
  Version:        5.1.28
  Purpose/Change: Initial script development
  Change: 12/08/2022 - Added additional HP applications
  Change 23/09/2022 - Added Clipchamp (new in W11 22H2)
  Change 28/10/2022 - Fixed issue with Dell apps
  Change 23/11/2022 - Added Teams Machine wide to exceptions
  Change 27/11/2022 - Added Dell apps
  Change 07/12/2022 - Whitelisted Dell Audio and Firmware
  Change 19/12/2022 - Added Windows 11 start menu support
  Change 20/12/2022 - Removed Gaming Menu from Settings
  Change 18/01/2023 - Fixed Scheduled task error and cleared up $null posistioning
  Change 22/01/2023 - Re-enabled Telemetry for Endpoint Analytics
  Change 30/01/2023 - Added Microsoft Family to removal list
  Change 31/01/2023 - Fixed Dell loop
  Change 08/02/2023 - Fixed HP apps thanks to gerryhampsoncm
  Change 08/02/2023 - Removed reg keys for Teams Chat
  Change 14/02/2023 - Added HP Sure Apps
  Change 07/03/2023 - Enabled Location tracking (with commenting to disable)
  Change 08/03/2023 - Teams chat fix
  Change 10/03/2023 - Dell array fix
  Change 29/04/2023 - Removes News Feed
  Change 26/05/2023 - Added Set-ACL
  Change 26/05/2023 - Added multi-language support for Set-ACL commands
  Change 30/05/2023 - Logic to check if gamepresencewriter exists before running Set-ACL to stop errors on re-run
  Change 25/07/2023 - Added Lenovo apps (Thanks to Simon Lilly and Philip Jorgensen)
  Change 31/07/2023 - Added LenovoAssist
  Change 21/09/2023 - Remove Windows backup for Win10
  Change 28/09/2023 - Enabled Diagnostic Tracking for Endpoint Analytics
  Change 02/10/2023 - Lenovo Fix
  Change 06/10/2023 - Teams chat fix
  Change 09/10/2023 - Dell Command Update change
  Change 11/10/2023 - Grab all uninstall strings and use native uninstaller instead of uninstall-package
  Change 14/10/2023 - Updated HP Audio package name
  Change 01/11/2023 - Added fix for Windows backup removing Shell Components
  Change 06/11/2023 - Removes Windows CoPilot
  Change 07/11/2023 - HKU fix
  Change 13/11/2023 - Added CoPilot removal to .Default Users
  Change 14/11/2023 - Added logic to stop errors on HP machines without HP docs installed
  Change 14/11/2023 - Added logic to stop errors on Lenovo machines without some installers
  Change 15/11/2023 - Code Signed for additional security
  Change 02/12/2023 - Added extra logic before app uninstall to check if a user has logged in
  Change 04/01/2024 - Added Dropbox and DevHome to AppX removal
  Change 05/01/2024 - Added MSTSC to whitelist
  Change 25/01/2024 - Added logic for LenovoNow/LenovoWelcome
  Change 25/01/2024 - Updated Dell app list (thanks Hrvoje in comments)
  Change 29/01/2024 - Changed /I to /X in Dell command
  Change 30/01/2024 - Fix Lenovo Vantage version
  Change 31/01/2024 - McAfee fix and Dell changes
  Change 01/02/2024 - Dell fix
  Change 01/02/2024 - Added logic around appxremoval to stop failures in logging
  Change 05/02/2024 - Added whitelist parameters
  Change 16/02/2024 - Added wildcard to dropbox
  Change 23/02/2024 - Added Lenovo SmartMeetings
  Change 06/03/2024 - Added Lenovo View and Vantage
  Change 08/03/2024 - Added Lenovo Smart Noise Cancellation
  Change 13/03/2024 - Added updated McAfee
  Change 20/03/2024 - Dell app fixes
  Change 02/04/2024 - Stopped it removing Intune Management Extension!
  Change 03/04/2024 - Switched Win32 removal from whitelist to blacklist
  Change 10/04/2024 - Office uninstall string fix
  Change 11/04/2024 - Added Office support for multi-language
  Change 17/04/2024 - HP Apps update
  Change 19/04/2024 - HP Fix
  Change 24/04/2024 - Switched provisionedpackage and appxpackage arround
  Change 02/05/2024 - Fixed notlike to notin
  Change 03/05/2024 - Change $uninstallprograms
  Change 19/05/2024 - Disabled feeds on Win11
  Change 21/05/2024 - Added QuickAssist to removal after security issues
  Change 25/05/2024 - Whitelist array fix
  Change 29/05/2025 - Uninstall fix
  Change 31/05/2024 - Re-write for manufacturer bloat
  Change 03/06/2024 - Added function for removing Win32 apps
  Change 03/06/2024 - Added registry key to block "Tell me about this picture" icon
  Change 06/06/2024 - Added keys to block Windows Recall
  Change 07/06/2024 - New fixes for HP and McAfee (thanks to Keith Hay)
  Change 24/06/2024 - Added Microsoft.SecHealthUI to whitelist
  Change 26/06/2024 - Fix when run outside of ESP
  Change 04/07/2024 - Dell fix for "|"
  Change 08/07/2024 - Made whitelist more standard across platforms and removed bloat list to use only whitelisting
  Change 08/07/2024 - Added start.bin
  Change 12/07/2024 - Added logic around start.bin
  Change 15/07/2024 - Removed Lenovo bookmarks
  Change 18/07/2024 - Updated detection for removing Office Home
  Change 23/07/2024 - Lenovo camera fix for E14
  Change 25/07/2024 - Added MS Teams to whitelist
  Change 07/08/2024 - Lenovo fix
  Change 14/08/2024 - Whitelisted any language packs
  Change 19/08/2024 - Added version to log for troubleshooting
  Change 19/08/2024 - Added blacklist and whitelist for further protection
  Change 22/08/2024 - Added Poly Lens for HP
  Change 02/09/2024 - Added all possible languages to Office Home removal
  Change 04/09/2024 - Lenovo updates
  Change 17/09/2024 - Added HP Wolf Security
  Change 18/09/2024 - Removed ODT for office removal to speed up script
  Change 24/09/2024 - Fixed uninstall for HP Wolf Security
  Change 25/09/2024 - Removed locales as Teams is now combined
  Change 08/10/2024 - ODT Fix
  Change 04/11/2024 - Block games in search bar
  Change 03/12/2024 - Fix for HP AppxPackage Removal
  Change 07/01/2025 - Added spotlight removal keys
  Change 10/01/2025 - Added Lenovo Now
  Change 21/01/2025 - Edge Surf game fix
  Change 27/01/2025 - Added Logitech Download assistant
  Change 27/01/2025 - Converted from CRLF to LF
  Change 06/02/2025 - Added the t back to transcrip(t)
  Change 10/02/2025 - Fixed logic for Logitech Registry key
  Change 07/03/2025 - commented out Logitech pending further testing
  Change 10/03/2025 - Fix for Windows backup version number
  Change 15/03/2025 - Added McAfee AppX package
  Change 25/03/2025 - Fixed typo to stop the transcript
  Change 01/04/2025 - Changed WMIC to CIM
  Change 02/04/2025 - Removed duplicate camera
  Change 03/04/2025 - Added Codecs to whitelist
  Change 04/04/2025 - Removed store from blacklist
  Change 06/04/2025 - PR Merge to remove duplicates
  Change 15/04/2025 - PR Merge to fix reg flush/close
  Change 16/04/2025 - PR merge with option to remove all office apps
  Change 22/04/2025 - Added HP Performance Advisor
  Change 24/04/2025 - Added HP Presence Video and re-shuffled Wolf to remove in corect order
  Change 30/04/2025 - PR Merge to add time checks
  Change 01/05/2025 - Removed StorePurchaseApp from bloat
  Change 09/05/2025 - Added TrackPoint Quick Menu (Lenovo)
  Change 13/05/2025 - Fixed TrackPoint (hopefully)
  Change 04/06/2025 - Addex X-Rite for Lenovo
  Change 14/07/2025 - Added GameDVR Popup fix
  Change 13/08/2025 - Blocked consumer scheduled tasks
  Change 13/08/2025 - Added option to add your own tasks via parameter
  Change 20/08/2025 - Removed win32_product commands and changed HP wolf
  Change 29/08/2025 - Fixed issue with Copilot registry key
  Change 09/09/2025 - AHopefully fixed HP apps
N/A
#>

############################################################################################################
#                                         Initial Setup                                                    #
#                                                                                                          #
############################################################################################################
param (
    [string[]]$customwhitelist,
    [string[]]$TasksToRemove  # Add this parameter for scheduled tasks to remove
)

##Elevate if needed

If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    write-output "You didn't run this script as an Administrator. This script will self elevate to run as an Administrator and continue."
    Start-Sleep 1
    write-output "                                               3"
    Start-Sleep 1
    write-output "                                               2"
    Start-Sleep 1
    write-output "                                               1"
    Start-Sleep 1
    #Start-Process powershell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`" -WhitelistApps {1}" -f $PSCommandPath, ($WhitelistApps -join ',')) -Verb RunAs
    Start-Process powershell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`" -customwhitelist {1} -TasksToRemove {2}" -f $PSCommandPath, ($customwhitelist -join ','), ($TasksToRemove -join ',')) -Verb RunAs
    Exit
}

#Get the Current start time in UTC format, so that Time Zone Changes don't affect total runtime calculation
$startUtc = [datetime]::UtcNow
#no errors throughout
$ErrorActionPreference = 'silentlycontinue'
#no progressbars to slow down powershell transfers
$OrginalProgressPreference = $ProgressPreference
$ProgressPreference = 'SilentlyContinue'


#Create Folder
$DebloatFolder = "C:\ProgramData\Debloat"
If (Test-Path $DebloatFolder) {
    Write-Output "$DebloatFolder exists. Skipping."
}
Else {
    Write-Output "The folder '$DebloatFolder' doesn't exist. This folder will be used for storing logs created after the script runs. Creating now."
    Start-Sleep 1
    New-Item -Path "$DebloatFolder" -ItemType Directory
    Write-Output "The folder $DebloatFolder was successfully created."
}

Start-Transcript -Path "C:\ProgramData\Debloat\Debloat.log"

# Add logging for version tracking
write-output "Starting Debloat Script Version 5.1.28"
write-output "Script Start Time: $((Get-Date).ToString('yyyy-MM-dd HH:mm:ss'))"

# Initialize the $allstring variable for Win32 app removal
write-output "Initializing Win32 application list..."
$allstring = @()
$registryPaths = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
)

foreach ($path in $registryPaths) {
    try {
        $apps = Get-ItemProperty -Path $path -ErrorAction SilentlyContinue |
                Where-Object { $_.DisplayName -and $_.UninstallString } |
                Select-Object DisplayName, UninstallString, QuietUninstallString, @{Name="Name"; Expression={$_.DisplayName}}, @{Name="String"; Expression={$_.UninstallString}}
        $allstring += $apps
    }
    catch {
        write-output "Warning: Could not access registry path: $path"
    }
}
write-output "Found $($allstring.Count) installed Win32 applications"

# Define the UninstallAppFull function
function UninstallAppFull {
    param (
        [string]$appName
    )

    if (-not $appName) {
        write-output "Warning: No app name provided to UninstallAppFull"
        return
    }

    write-output "Attempting to uninstall Win32 app: $appName"

    # Get uninstall information for the specific app
    $uninstallInfo = $allstring | Where-Object { $_.Name -eq $appName -or $_.Name -like "*$appName*" }

    if (-not $uninstallInfo) {
        write-output "Win32 app '$appName' not found in installed programs list"
        return
    }

    foreach ($app in $uninstallInfo) {
        $uninstallString = $app.QuietUninstallString
        if (-not $uninstallString) {
            $uninstallString = $app.UninstallString
        }

        if (-not $uninstallString) {
            write-output "No uninstall string found for: $($app.Name)"
            continue
        }

        write-output "Uninstalling: $($app.Name)"
        write-output "Using uninstall string: $uninstallString"

        try {
            if ($uninstallString -match "msiexec") {
                # Handle MSI uninstalls
                $uninstallString = $uninstallString -replace "msiexec.exe", ""
                $uninstallString = $uninstallString -replace "/I", "/X"
                $uninstallString = $uninstallString.Trim()

                if ($uninstallString -notmatch "/quiet") {
                    $uninstallString += " /quiet /norestart"
                }

                Start-Process "msiexec.exe" -ArgumentList $uninstallString -Wait -NoNewWindow -ErrorAction Stop
                write-output "Successfully uninstalled (MSI): $($app.Name)"
            }
            else {
                # Handle EXE uninstalls
                $uninstallParts = $uninstallString -split ' ', 2
                $uninstallExe = $uninstallParts[0].Trim('"')
                $uninstallArgs = if ($uninstallParts.Count -gt 1) { $uninstallParts[1] } else { "" }

                # Add silent parameters if not present
                if ($uninstallArgs -notmatch "/S|/silent|/quiet|--silent") {
                    $uninstallArgs += " /S /silent"
                }

                if (Test-Path $uninstallExe) {
                    Start-Process -FilePath $uninstallExe -ArgumentList $uninstallArgs -Wait -NoNewWindow -ErrorAction Stop
                    write-output "Successfully uninstalled (EXE): $($app.Name)"
                }
                else {
                    write-output "Uninstaller not found: $uninstallExe"
                }
            }
        }
        catch {
            write-output "Failed to uninstall $($app.Name): $($_.Exception.Message)"
        }
    }
}

function Remove-CustomScheduledTasks {
    param (
        [string[]]$TaskNames
    )

    Write-Output "Removing specified scheduled tasks..."

    foreach ($taskName in $TaskNames) {
        Write-Output "Attempting to remove task: $taskName"

        # Check if the task exists
        $task = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue

        if ($task) {
            try {
                # First disable the task
                Disable-ScheduledTask -TaskName $taskName -ErrorAction Stop | Out-Null

                # Then unregister (remove) the task
                Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction Stop
                Write-Output "Successfully removed scheduled task: $taskName"
            }
            catch {
                Write-Output "Failed to remove scheduled task: $taskName. Error: $_"
            }
        }
        else {
            Write-Output "Scheduled task not found: $taskName"
        }
    }
}


############################################################################################################
#                                        Remove AppX Packages                                              #
#                                                                                                          #
############################################################################################################

#Removes AppxPackages
$WhitelistedApps = @(
    'Microsoft.WindowsNotepad',
    'Microsoft.CompanyPortal',
    'Microsoft.ScreenSketch',
    'Microsoft.Paint3D',
    'Microsoft.WindowsCalculator',
    'Microsoft.WindowsStore',
    'Microsoft.Windows.Photos',
    'CanonicalGroupLimited.UbuntuonWindows',
    'Microsoft.MicrosoftStickyNotes',
    'Microsoft.MSPaint',
    'Microsoft.WindowsCamera',
    '.NET Framework',
    'Microsoft.HEIFImageExtension',
    'Microsoft.StorePurchaseApp',
    'Microsoft.VP9VideoExtensions',
    'Microsoft.WebMediaExtensions',
    'Microsoft.WebpImageExtension',
    'Microsoft.DesktopAppInstaller',
    'WindSynthBerry',
    'MIDIBerry',
    'Slack',
    'Microsoft.SecHealthUI',
    'WavesAudio.MaxxAudioProforDell2019',
    'Dell Optimizer Core',
    'Dell SupportAssist Remediation',
    'Dell SupportAssist OS Recovery Plugin for Dell Update',
    'Dell Pair',
    'Dell Display Manager 2.0',
    'Dell Display Manager 2.1',
    'Dell Display Manager 2.2',
    'Dell Peripheral Manager',
    'MSTeams',
    'Microsoft.Paint',
    'Microsoft.OutlookForWindows',
    'Microsoft.WindowsTerminal',
    'Microsoft.MicrosoftEdge.Stable'
    'Microsoft.MPEG2VideoExtension',
    'Microsoft.HEVCVideoExtension',
    'Microsoft.AV1VideoExtension'
)
##If $customwhitelist is set, split on the comma and add to whitelist
if ($customwhitelist) {
    $customWhitelistApps = $customwhitelist -split ","
    foreach ($whitelistapp in $customwhitelistapps) {
        ##Add to the array
        $WhitelistedApps += $whitelistapp
    }
}

#NonRemovable Apps that where getting attempted and the system would reject the uninstall, speeds up debloat and prevents 'initalizing' overlay when removing apps
$NonRemovable = @(
    '1527c705-839a-4832-9118-54d4Bd6a0c89',
    'c5e2524a-ea46-4f67-841f-6a9465d9d515',
    'E2A4F912-2574-4A75-9BB0-0D023378592B',
    'F46D4000-FD22-4DB4-AC8E-4E1DDDE828FE',
    'InputApp',
    'Microsoft.AAD.BrokerPlugin',
    'Microsoft.AccountsControl',
    'Microsoft.BioEnrollment',
    'Microsoft.CredDialogHost',
    'Microsoft.ECApp',
    'Microsoft.LockApp',
    'Microsoft.MicrosoftEdgeDevToolsClient',
    'Microsoft.MicrosoftEdge',
    'Microsoft.PPIProjection',
    'Microsoft.Win32WebViewHost',
    'Microsoft.Windows.Apprep.ChxApp',
    'Microsoft.Windows.AssignedAccessLockApp',
    'Microsoft.Windows.CapturePicker',
    'Microsoft.Windows.CloudExperienceHost',
    'Microsoft.Windows.ContentDeliveryManager',
    'Microsoft.Windows.Cortana',
    'Microsoft.Windows.NarratorQuickStart',
    'Microsoft.Windows.ParentalControls',
    'Microsoft.Windows.PeopleExperienceHost',
    'Microsoft.Windows.PinningConfirmationDialog',
    'Microsoft.Windows.SecHealthUI',
    'Microsoft.Windows.SecureAssessmentBrowser',
    'Microsoft.Windows.ShellExperienceHost',
    'Microsoft.Windows.XGpuEjectDialog',
    'Microsoft.XboxGameCallableUI',
    'Windows.CBSPreview',
    'windows.immersivecontrolpanel',
    'Windows.PrintDialog',
    'Microsoft.VCLibs.140.00',
    'Microsoft.Services.Store.Engagement',
    'Microsoft.UI.Xaml.2.0',
    'Microsoft.AsyncTextService',
    'Microsoft.UI.Xaml.CBS',
    'Microsoft.Windows.CallingShellApp',
    'Microsoft.Windows.OOBENetworkConnectionFlow',
    'Microsoft.Windows.PrintQueueActionCenter',
    'Microsoft.Windows.StartMenuExperienceHost',
    'MicrosoftWindows.Client.CBS',
    'MicrosoftWindows.Client.Core',
    'MicrosoftWindows.UndockedDevKit',
    'NcsiUwpApp',
    'Microsoft.NET.Native.Runtime.2.2',
    'Microsoft.NET.Native.Framework.2.2',
    'Microsoft.UI.Xaml.2.8',
    'Microsoft.UI.Xaml.2.7',
    'Microsoft.UI.Xaml.2.3',
    'Microsoft.UI.Xaml.2.4',
    'Microsoft.UI.Xaml.2.1',
    'Microsoft.UI.Xaml.2.2',
    'Microsoft.UI.Xaml.2.5',
    'Microsoft.UI.Xaml.2.6',
    'Microsoft.VCLibs.140.00.UWPDesktop',
    'MicrosoftWindows.Client.LKG',
    'MicrosoftWindows.Client.FileExp',
    'Microsoft.WindowsAppRuntime.1.5',
    'Microsoft.WindowsAppRuntime.1.3',
    'Microsoft.WindowsAppRuntime.1.1',
    'Microsoft.WindowsAppRuntime.1.2',
    'Microsoft.WindowsAppRuntime.1.4',
    'Microsoft.Windows.OOBENetworkCaptivePortal',
    'Microsoft.Windows.Search'
)

##Combine the two arrays
$appstoignore = $WhitelistedApps += $NonRemovable

##Bloat list for future reference
$Bloatware = @(
    #Unnecessary Windows 10/11 AppX Apps
    "*ActiproSoftwareLLC*"
    "*AdobeSystemsIncorporated.AdobePhotoshopExpress*"
    "*BubbleWitch3Saga*"
    "*CandyCrush*"
    "*DevHome*"
    "*Disney*"
    "*Dolby*"
    "*Duolingo-LearnLanguagesforFree*"
    "*EclipseManager*"
    "*Facebook*"
    "*Flipboard*"
    "*gaming*"
    "*Minecraft*"
    "*Office*"
    "*PandoraMediaInc*"
    "*Royal Revolt*"
    "*Speed Test*"
    "*Sway*"
    "*Twitter*"
    "*Wunderlist*"
    "AD2F1837.HPPrinterControl"
    "AppUp.IntelGraphicsExperience"
    "C27EB4BA.DropboxOEM*"
    "Disney.37853FC22B2CE"
    "DolbyLaboratories.DolbyAccess"
    "DolbyLaboratories.DolbyAudio"
    "E0469640.SmartAppearance"
    "Microsoft.549981C3F5F10"
    "Microsoft.AV1VideoExtension"
    "Microsoft.BingNews"
    "Microsoft.BingSearch"
    "Microsoft.BingWeather"
    "Microsoft.GetHelp"
    "Microsoft.Getstarted"
    "Microsoft.GamingApp"
    "Microsoft.Messaging"
    "Microsoft.Microsoft3DViewer"
    "Microsoft.MicrosoftEdge.Stable"
    "Microsoft.MicrosoftJournal"
    "Microsoft.MicrosoftOfficeHub"
    "Microsoft.MicrosoftSolitaireCollection"
    "Microsoft.MixedReality.Portal"
    "Microsoft.MPEG2VideoExtension"
    "Microsoft.News"
    "Microsoft.Office.Lens"
    "Microsoft.Office.Sway"
    "Microsoft.OneConnect"
    "Microsoft.People"
    "Microsoft.PowerAutomateDesktop"
    "Microsoft.PowerAutomateDesktopCopilotPlugin"
    "Microsoft.Print3D"
    "Microsoft.SkypeApp"
    "Microsoft.SysinternalsSuite"
    "Microsoft.Windows.DevHome"
    "Microsoft.windowscommunicationsapps"
    "Microsoft.WindowsFeedbackHub"
    "Microsoft.WindowsMaps"
    "Microsoft.Xbox.TCUI"
    "Microsoft.XboxApp"
    "Microsoft.XboxGameOverlay"
    "Microsoft.XboxGamingOverlay"
    "Microsoft.XboxGamingOverlay_5.721.10202.0_neutral_~_8wekyb3d8bbwe"
    "Microsoft.XboxIdentityProvider"
    "Microsoft.XboxSpeechToTextOverlay"
    "Microsoft.ZuneMusic"
    "Microsoft.ZuneVideo"
    "MicrosoftCorporationII.MicrosoftFamily"
    "MicrosoftCorporationII.QuickAssist"
    "MicrosoftWindows.CrossDevice"
    "MirametrixInc.GlancebyMirametrix"
    "RealtimeboardInc.RealtimeBoard"
    "5A894077.McAfeeSecurity"
    "5A894077.McAfeeSecurity_2.1.27.0_x64__wafk5atnkzcwy"
)


$provisioned = Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -in $Bloatware -and $_.DisplayName -notin $appstoignore -and $_.DisplayName -notlike 'MicrosoftWindows.Voice*' -and $_.DisplayName -notlike 'Microsoft.LanguageExperiencePack*' -and $_.DisplayName -notlike 'MicrosoftWindows.Speech*' }
foreach ($appxprov in $provisioned) {
    $packagename = $appxprov.PackageName
    $displayname = $appxprov.DisplayName
    write-output "Removing $displayname AppX Provisioning Package"
    try {
        Remove-AppxProvisionedPackage -PackageName $packagename -Online -ErrorAction SilentlyContinue
        write-output "Removed $displayname AppX Provisioning Package"
    }
    catch {
        write-output "Unable to remove $displayname AppX Provisioning Package"
    }

}


$appxinstalled = Get-AppxPackage -AllUsers | Where-Object { $_.Name -in $Bloatware -and $_.Name -notin $appstoignore -and $_.Name -notlike 'MicrosoftWindows.Voice*' -and $_.Name -notlike 'Microsoft.LanguageExperiencePack*' -and $_.Name -notlike 'MicrosoftWindows.Speech*' }
foreach ($appxapp in $appxinstalled) {
    $packagename = $appxapp.PackageFullName
    $displayname = $appxapp.Name
    write-output "$displayname AppX Package exists"
    write-output "Removing $displayname AppX Package"
    try {
        Remove-AppxPackage -Package $packagename -AllUsers -ErrorAction SilentlyContinue
        write-output "Removed $displayname AppX Package"
    }
    catch {
        write-output "$displayname AppX Package does not exist"
    }



}


############################################################################################################
#                                        Remove Registry Keys                                              #
#                                                                                                          #
############################################################################################################

##We need to grab all SIDs to remove at user level
$UserSIDs = Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList" | Select-Object -ExpandProperty PSChildName


#These are the registry keys that it will delete.

$Keys = @(

    #Remove Background Tasks
    "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y"
    "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
    "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe"
    "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
    "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
    "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"

    #Windows File
    "HKCR:\Extensions\ContractId\Windows.File\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"

    #Registry keys to delete if they aren't uninstalled by RemoveAppXPackage/RemoveAppXProvisionedPackage
    "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y"
    "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
    "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
    "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
    "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"

    #Scheduled Tasks to delete
    "HKCR:\Extensions\ContractId\Windows.PreInstalledConfigTask\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe"

    #Windows Protocol Keys
    "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
    "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
    "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
    "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"

    #Windows Share Target
    "HKCR:\Extensions\ContractId\Windows.ShareTarget\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
)

#This writes the output of each key it is removing and also removes the keys listed above.
ForEach ($Key in $Keys) {
    write-output "Removing $Key from registry"
    Remove-Item $Key -Recurse
}


#Disables Windows Feedback Experience
write-output "Disabling Windows Feedback Experience program"
$Advertising = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
If (!(Test-Path $Advertising)) {
    New-Item $Advertising
}
If (Test-Path $Advertising) {
    Set-ItemProperty $Advertising Enabled -Value 0
}

#Stops Cortana from being used as part of your Windows Search Function
write-output "Stopping Cortana from being used as part of your Windows Search Function"
$Search = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
If (!(Test-Path $Search)) {
    New-Item $Search
}
If (Test-Path $Search) {
    Set-ItemProperty $Search AllowCortana -Value 0
}

#Disables Web Search in Start Menu
write-output "Disabling Bing Search in Start Menu"
$WebSearch = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
If (!(Test-Path $WebSearch)) {
    New-Item $WebSearch
}
Set-ItemProperty $WebSearch DisableWebSearch -Value 1
##Loop through all user SIDs in the registry and disable Bing Search
foreach ($sid in $UserSIDs) {
    $WebSearch = "Registry::HKU\$sid\SOFTWARE\Microsoft\Windows\CurrentVersion\Search"
    If (!(Test-Path $WebSearch)) {
        New-Item $WebSearch
    }
    Set-ItemProperty $WebSearch BingSearchEnabled -Value 0
}

Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" BingSearchEnabled -Value 0


#Stops the Windows Feedback Experience from sending anonymous data
write-output "Stopping the Windows Feedback Experience program"
$Period = "HKCU:\Software\Microsoft\Siuf\Rules"
If (!(Test-Path $Period)) {
    New-Item $Period
}
Set-ItemProperty $Period PeriodInNanoSeconds -Value 0

##Loop and do the same
foreach ($sid in $UserSIDs) {
    $Period = "Registry::HKU\$sid\Software\Microsoft\Siuf\Rules"
    If (!(Test-Path $Period)) {
        New-Item $Period
    }
    Set-ItemProperty $Period PeriodInNanoSeconds -Value 0
}

##Disables games from showing in Search bar
write-output "Adding Registry key to stop games from search bar"
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
If (!(Test-Path $registryPath)) {
    New-Item $registryPath
}
Set-ItemProperty $registryPath EnableDynamicContentInWSB -Value 0

#Prevents bloatware applications from returning and removes Start Menu suggestions
write-output "Adding Registry key to prevent bloatware apps from returning"
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
$registryOEM = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
If (!(Test-Path $registryPath)) {
    New-Item $registryPath
}
Set-ItemProperty $registryPath DisableWindowsConsumerFeatures -Value 1

If (!(Test-Path $registryOEM)) {
    New-Item $registryOEM
}
Set-ItemProperty $registryOEM  ContentDeliveryAllowed -Value 0
Set-ItemProperty $registryOEM  OemPreInstalledAppsEnabled -Value 0
Set-ItemProperty $registryOEM  PreInstalledAppsEnabled -Value 0
Set-ItemProperty $registryOEM  PreInstalledAppsEverEnabled -Value 0
Set-ItemProperty $registryOEM  SilentInstalledAppsEnabled -Value 0
Set-ItemProperty $registryOEM  SystemPaneSuggestionsEnabled -Value 0

##Loop through users and do the same
foreach ($sid in $UserSIDs) {
    $registryOEM = "Registry::HKU\$sid\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
    If (!(Test-Path $registryOEM)) {
        New-Item $registryOEM
    }
    Set-ItemProperty $registryOEM  ContentDeliveryAllowed -Value 0
    Set-ItemProperty $registryOEM  OemPreInstalledAppsEnabled -Value 0
    Set-ItemProperty $registryOEM  PreInstalledAppsEnabled -Value 0
    Set-ItemProperty $registryOEM  PreInstalledAppsEverEnabled -Value 0
    Set-ItemProperty $registryOEM  SilentInstalledAppsEnabled -Value 0
    Set-ItemProperty $registryOEM  SystemPaneSuggestionsEnabled -Value 0
}

#Preping mixed Reality Portal for removal
write-output "Setting Mixed Reality Portal value to 0 so that you can uninstall it in Settings"
$Holo = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Holographic"
If (Test-Path $Holo) {
    Set-ItemProperty $Holo  FirstRunSucceeded -Value 0
}

##Loop through users and do the same
foreach ($sid in $UserSIDs) {
    $Holo = "Registry::HKU\$sid\Software\Microsoft\Windows\CurrentVersion\Holographic"
    If (Test-Path $Holo) {
        Set-ItemProperty $Holo  FirstRunSucceeded -Value 0
    }
}

#Disables Wi-fi Sense
write-output "Disabling Wi-Fi Sense"
$WifiSense1 = "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting"
$WifiSense2 = "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots"
$WifiSense3 = "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config"
If (!(Test-Path $WifiSense1)) {
    New-Item $WifiSense1
}
Set-ItemProperty $WifiSense1  Value -Value 0
If (!(Test-Path $WifiSense2)) {
    New-Item $WifiSense2
}
Set-ItemProperty $WifiSense2  Value -Value 0
Set-ItemProperty $WifiSense3  AutoConnectAllowedOEM -Value 0

#Disables live tiles
write-output "Disabling live tiles"
$Live = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications"
If (!(Test-Path $Live)) {
    New-Item $Live
}
Set-ItemProperty $Live  NoTileApplicationNotification -Value 1

##Loop through users and do the same
foreach ($sid in $UserSIDs) {
    $Live = "Registry::HKU\$sid\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications"
    If (!(Test-Path $Live)) {
        New-Item $Live
    }
    Set-ItemProperty $Live  NoTileApplicationNotification -Value 1
}

#Turns off Data Collection via the AllowTelemtry key by changing it to 0
# This is needed for Intune reporting to work, uncomment if using via other method
write-output "Turning off Data Collection"
$DataCollection1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
$DataCollection2 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
$DataCollection3 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
If (Test-Path $DataCollection1) {
    Set-ItemProperty $DataCollection1  AllowTelemetry -Value 1
}
If (Test-Path $DataCollection2) {
    Set-ItemProperty $DataCollection2  AllowTelemetry -Value 1
}
If (Test-Path $DataCollection3) {
    Set-ItemProperty $DataCollection3  AllowTelemetry -Value 1
}


###Enable location tracking for "find my device", uncomment if you don't need it

#Disabling Location Tracking
write-output "Disabling Location Tracking"
$SensorState = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}"
$LocationConfig = "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration"
If (!(Test-Path $SensorState)) {
    New-Item $SensorState
}
Set-ItemProperty $SensorState SensorPermissionState -Value 1
If (!(Test-Path $LocationConfig)) {
    New-Item $LocationConfig
}
Set-ItemProperty $LocationConfig Status -Value 1

#Disables People icon on Taskbar
write-output "Disabling People icon on Taskbar"
$People = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People'
If (Test-Path $People) {
    Set-ItemProperty $People -Name PeopleBand -Value 0
}

##Loop through users and do the same
foreach ($sid in $UserSIDs) {
    $People = "Registry::HKU\$sid\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People"
    If (Test-Path $People) {
        Set-ItemProperty $People -Name PeopleBand -Value 0
    }
}

write-output "Disabling Cortana"
$Cortana1 = "HKCU:\SOFTWARE\Microsoft\Personalization\Settings"
$Cortana2 = "HKCU:\SOFTWARE\Microsoft\InputPersonalization"
$Cortana3 = "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore"
If (!(Test-Path $Cortana1)) {
    New-Item $Cortana1
}
Set-ItemProperty $Cortana1 AcceptedPrivacyPolicy -Value 0
If (!(Test-Path $Cortana2)) {
    New-Item $Cortana2
}
Set-ItemProperty $Cortana2 RestrictImplicitTextCollection -Value 1
Set-ItemProperty $Cortana2 RestrictImplicitInkCollection -Value 1
If (!(Test-Path $Cortana3)) {
    New-Item $Cortana3
}
Set-ItemProperty $Cortana3 HarvestContacts -Value 0

##Loop through users and do the same
foreach ($sid in $UserSIDs) {
    $Cortana1 = "Registry::HKU\$sid\SOFTWARE\Microsoft\Personalization\Settings"
    $Cortana2 = "Registry::HKU\$sid\SOFTWARE\Microsoft\InputPersonalization"
    $Cortana3 = "Registry::HKU\$sid\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore"
    If (!(Test-Path $Cortana1)) {
        New-Item $Cortana1
    }
    Set-ItemProperty $Cortana1 AcceptedPrivacyPolicy -Value 0
    If (!(Test-Path $Cortana2)) {
        New-Item $Cortana2
    }
    Set-ItemProperty $Cortana2 RestrictImplicitTextCollection -Value 1
    Set-ItemProperty $Cortana2 RestrictImplicitInkCollection -Value 1
    If (!(Test-Path $Cortana3)) {
        New-Item $Cortana3
    }
    Set-ItemProperty $Cortana3 HarvestContacts -Value 0
}


#Removes 3D Objects from the 'My Computer' submenu in explorer
write-output "Removing 3D Objects from explorer 'My Computer' submenu"
$Objects32 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
$Objects64 = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
If (Test-Path $Objects32) {
    Remove-Item $Objects32 -Recurse
}
If (Test-Path $Objects64) {
    Remove-Item $Objects64 -Recurse
}

##Removes the Microsoft Feeds from displaying
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds"
$Name = "EnableFeeds"
$value = "0"

if (!(Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
    New-ItemProperty -Path $registryPath -Name $name -Value $value -PropertyType DWORD -Force | Out-Null
}

else {
    New-ItemProperty -Path $registryPath -Name $name -Value $value -PropertyType DWORD -Force | Out-Null
}

##Kill Cortana again
Get-AppxPackage Microsoft.549981C3F5F10 -allusers | Remove-AppxPackage



############################################################################################################
#                                        Remove Learn about this picture                                   #
#                                                                                                          #
############################################################################################################

#Turn off Learn about this picture
write-output "Disabling Learn about this picture"
$picture = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel'
If (Test-Path $picture) {
    Set-ItemProperty $picture -Name "{2cc5ca98-6485-489a-920e-b3e88a6ccce3}" -Value 1
}

##Loop through users and do the same
foreach ($sid in $UserSIDs) {
    $picture = "Registry::HKU\$sid\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"
    If (Test-Path $picture) {
        Set-ItemProperty $picture -Name "{2cc5ca98-6485-489a-920e-b3e88a6ccce3}" -Value 1
    }
}


############################################################################################################
#                                     Disable Consumer Experiences                                         #
#                                                                                                          #
############################################################################################################

#Disabling consumer experience
write-output "Disabling consumer experience"
$consumer = 'HKLM:\\SOFTWARE\Policies\Microsoft\Windows\CloudContent'
If (Test-Path $consumer) {
    Set-ItemProperty $consumer -Name "DisableWindowsConsumerFeatures" -Value 1
}

#Stop them coming back
#Disable-ScheduledTask -TaskName "Microsoft\Windows\CloudExperienceHost\CreateObjectTask"
#Disable-ScheduledTask -TaskName "Microsoft\Windows\Consumer Experiences\CleanUpTemporaryState"
#Disable-ScheduledTask -TaskName "Microsoft\Windows\Consumer Experiences\StartupAppTask"

############################################################################################################
#                                                   Disable Spotlight                                      #
#                                                                                                          #
############################################################################################################

write-output "Disabling Windows Spotlight on lockscreen"
$spotlight = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager'
If (Test-Path $spotlight) {
    Set-ItemProperty $spotlight -Name "RotatingLockScreenOverlayEnabled" -Value 0
    Set-ItemProperty $spotlight -Name "RotatingLockScreenEnabled" -Value 0
}

##Loop through users and do the same
foreach ($sid in $UserSIDs) {
    $spotlight = "Registry::HKU\$sid\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
    If (Test-Path $spotlight) {
        Set-ItemProperty $spotlight -Name "RotatingLockScreenOverlayEnabled" -Value 0
        Set-ItemProperty $spotlight -Name "RotatingLockScreenEnabled" -Value 0
    }
}

write-output "Disabling Windows Spotlight on background"
$spotlight = 'HKCU:\Software\Policies\Microsoft\Windows\CloudContent'
If (Test-Path $spotlight) {
    Set-ItemProperty $spotlight -Name "DisableSpotlightCollectionOnDesktop" -Value 1
    Set-ItemProperty $spotlight -Name "DisableWindowsSpotlightFeatures" -Value 1
}

##Loop through users and do the same
foreach ($sid in $UserSIDs) {
    $spotlight = "Registry::HKU\$sid\Software\Policies\Microsoft\Windows\CloudContent"
    If (Test-Path $spotlight) {
        Set-ItemProperty $spotlight -Name "DisableSpotlightCollectionOnDesktop" -Value 1
        Set-ItemProperty $spotlight -Name "DisableWindowsSpotlightFeatures" -Value 1
    }
}

############################################################################################################
#                                       Fix for Gaming Popups                                              #
#                                                                                                          #
############################################################################################################

write-output "Adding GameDVR Fix"
$gamedvr = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR'
If (Test-Path $gamedvr) {
    Set-ItemProperty $gamedvr -Name "AppCaptureEnabled" -Value 0
    Set-ItemProperty $gamedvr -Name "NoWinKeys" -Value 1
}

##Loop through users and do the same
foreach ($sid in $UserSIDs) {
    $gamedvr = "Registry::HKU\$sid\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR"
    If (Test-Path $gamedvr) {
        Set-ItemProperty $gamedvr -Name "AppCaptureEnabled" -Value 0
        Set-ItemProperty $gamedvr -Name "NoWinKeys" -Value 1
    }
}

$gameconfig = 'HKCU:\System\GameConfigStore'
If (Test-Path $gameconfig) {
    Set-ItemProperty $gameconfig -Name "GameDVR_Enabled" -Value 0
}

##Loop through users and do the same
foreach ($sid in $UserSIDs) {
    $gameconfig = "Registry::HKU\$sid\System\GameConfigStore"
    If (Test-Path $gameconfig) {
        Set-ItemProperty $gameconfig -Name "GameDVR_Enabled" -Value 0
    }
}

############################################################################################################
#                                        Remove Scheduled Tasks                                            #
#                                                                                                          #
############################################################################################################

#Disables scheduled tasks that are considered unnecessary
write-output "Disabling scheduled tasks"
$task1 = Get-ScheduledTask -TaskName XblGameSaveTaskLogon -ErrorAction SilentlyContinue
if ($null -ne $task1) {
    Get-ScheduledTask  XblGameSaveTaskLogon | Disable-ScheduledTask -ErrorAction SilentlyContinue
}
$task2 = Get-ScheduledTask -TaskName XblGameSave -ErrorAction SilentlyContinue
if ($null -ne $task2) {
    Get-ScheduledTask  XblGameSave | Disable-ScheduledTask -ErrorAction SilentlyContinue
}
$task3 = Get-ScheduledTask -TaskName Consolidator -ErrorAction SilentlyContinue
if ($null -ne $task3) {
    Get-ScheduledTask  Consolidator | Disable-ScheduledTask -ErrorAction SilentlyContinue
}
$task4 = Get-ScheduledTask -TaskName UsbCeip -ErrorAction SilentlyContinue
if ($null -ne $task4) {
    Get-ScheduledTask  UsbCeip | Disable-ScheduledTask -ErrorAction SilentlyContinue
}
$task5 = Get-ScheduledTask -TaskName DmClient -ErrorAction SilentlyContinue
if ($null -ne $task5) {
    Get-ScheduledTask  DmClient | Disable-ScheduledTask -ErrorAction SilentlyContinue
}
$task6 = Get-ScheduledTask -TaskName DmClientOnScenarioDownload -ErrorAction SilentlyContinue
if ($null -ne $task6) {
    Get-ScheduledTask  DmClientOnScenarioDownload | Disable-ScheduledTask -ErrorAction SilentlyContinue
}
############################################################################################################
#                                             Disable Scheduled Tasks                                      #
#                                                                                                          #
############################################################################################################

# Remove specified scheduled tasks if provided
if ($TasksToRemove -and $TasksToRemove.Count -gt 0) {
    Write-Output "Processing custom scheduled tasks removal..."
    Remove-CustomScheduledTasks -TaskNames $TasksToRemove
}

############################################################################################################
#                                        Windows 11 Specific                                               #
#                                                                                                          #
############################################################################################################
#Windows 11 Customisations
write-output "Removing Windows 11 Customisations"


##Disable Feeds
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Dsh"
If (!(Test-Path $registryPath)) {
    New-Item $registryPath
}
Set-ItemProperty $registryPath "AllowNewsAndInterests" -Value 0
write-output "Disabled Feeds"

############################################################################################################
#                                           Windows Backup App                                             #
#                                                                                                          #
############################################################################################################
$version = Get-CimInstance Win32_OperatingSystem | Select-Object -ExpandProperty Caption
if ($version -like "*Windows 10*") {
    write-output "Removing Windows Backup"
    $filepath = "C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\WindowsBackup\Assets"
    if (Test-Path $filepath) {

        $packagename = Get-WindowsPackage -Online | Where-Object { $_.PackageName -like "*Microsoft-Windows-UserExperience-Desktop-Package*" } | Select-Object -ExpandProperty PackageName
        Remove-WindowsPackage -Online -PackageName $packagename

        ##Add back snipping tool functionality
        write-output "Adding Windows Shell Components"
        DISM /Online /Add-Capability /CapabilityName:Windows.Client.ShellComponents~~~~0.0.1.0
        write-output "Components Added"
    }
    write-output "Removed"
}

############################################################################################################
#                                           Windows CoPilot                                                #
#                                                                                                          #
############################################################################################################
$version = Get-CimInstance Win32_OperatingSystem | Select-Object -ExpandProperty Caption
if ($version -like "*Windows 11*") {
    write-output "Removing Windows Copilot"
    # Define the registry key and value
    $registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot"
    $propertyName = "TurnOffWindowsCopilot"
    $propertyValue = 1

    # Check if the registry key exists
    If (!(Test-Path $registryPath)) {
        # If the registry key doesn't exist, create it
        New-Item -Path $registryPath -Force | Out-Null
    }

    # Get the property value
    $currentValue = Get-ItemProperty -Path $registryPath -Name $propertyName -ErrorAction SilentlyContinue

    # Check if the property exists and if its value is different from the desired value
    if ($null -eq $currentValue -or $currentValue.$propertyName -ne $propertyValue) {
        # If the property doesn't exist or its value is different, set the property value
        Set-ItemProperty -Path $registryPath -Name $propertyName -Value $propertyValue -Type DWord
    }


    ##Grab the default user as well
    $registryPath = "Registry::HKEY_USERS\.DEFAULT\Software\Policies\Microsoft\Windows\WindowsCopilot"
    $propertyName = "TurnOffWindowsCopilot"
    $propertyValue = 1

    # Check if the registry key exists
    if (!(Test-Path $registryPath)) {
        # If the registry key doesn't exist, create it
        New-Item -Path $registryPath -Force | Out-Null
    }

    # Get the property value
    $currentValue = Get-ItemProperty -Path $registryPath -Name $propertyName -ErrorAction SilentlyContinue

    # Check if the property exists and if its value is different from the desired value
    if ($null -eq $currentValue -or $currentValue.$propertyName -ne $propertyValue) {
        # If the property doesn't exist or its value is different, set the property value
        Set-ItemProperty -Path $registryPath -Name $propertyName -Value $propertyValue -Type DWord
    }


    ##Load the default hive from c:\users\Default\NTUSER.dat
    reg load HKU\temphive "c:\users\default\ntuser.dat"
    $registryPath = "registry::hku\temphive\Software\Policies\Microsoft\Windows\WindowsCopilot"
    $propertyName = "TurnOffWindowsCopilot"
    $propertyValue = 1

    # Check if the registry key exists
    if (!(Test-Path $registryPath)) {
        # If the registry key doesn't exist, create it
        [Microsoft.Win32.RegistryKey]$HKUCoPilot = [Microsoft.Win32.Registry]::Users.CreateSubKey("temphive\Software\Policies\Microsoft\Windows\WindowsCopilot", [Microsoft.Win32.RegistryKeyPermissionCheck]::ReadWriteSubTree)
        $HKUCoPilot.SetValue($propertyName, $propertyValue, [Microsoft.Win32.RegistryValueKind]::DWord)

        $HKUCoPilot.Flush()
        $HKUCoPilot.Close()
    }

    [gc]::Collect()
    [gc]::WaitForPendingFinalizers()
    reg unload HKU\temphive


    write-output "Removed"


    foreach ($sid in $UserSIDs) {
        $registryPath = "Registry::HKU\$sid\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot"
        $propertyName = "TurnOffWindowsCopilot"
        $propertyValue = 1

        # Check if the registry key exists
        if (!(Test-Path $registryPath)) {
            # If the registry key doesn't exist, create it
            New-Item -Path $registryPath -Force | Out-Null
        }

        # Get the property value
        $currentValue = Get-ItemProperty -Path $registryPath -Name $propertyName -ErrorAction SilentlyContinue

        # Check if the property exists and if its value is different from the desired value
        if ($null -eq $currentValue -or $currentValue.$propertyName -ne $propertyValue) {
            # If the property doesn't exist or its value is different, set the property value
            Set-ItemProperty -Path $registryPath -Name $propertyName -Value $propertyValue
        }
    }
}
############################################################################################################
#                                              Remove Recall                                               #
#                                                                                                          #
############################################################################################################

#Turn off Recall
write-output "Disabling Recall"
$recall = "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsAI"
If (!(Test-Path $recall)) {
    New-Item $recall
}
Set-ItemProperty $recall DisableAIDataAnalysis -Value 1


$recalluser = 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\WindowsAI'
If (!(Test-Path $recalluser)) {
    New-Item $recalluser
}
Set-ItemProperty $recalluser DisableAIDataAnalysis -Value 1

##Loop through users and do the same
foreach ($sid in $UserSIDs) {
    $recallusers = "Registry::HKU\$sid\SOFTWARE\Policies\Microsoft\Windows\WindowsAI"
    If (!(Test-Path $recallusers)) {
        New-Item $recallusers
    }
    Set-ItemProperty $recallusers DisableAIDataAnalysis -Value 1
}


############################################################################################################
#                                             Clear Start Menu                                             #
#                                                                                                          #
############################################################################################################
write-output "Clearing Start Menu"
#Delete layout file if it already exists

##Check windows version
$version = Get-CimInstance Win32_OperatingSystem | Select-Object -ExpandProperty Caption
if ($version -like "*Windows 10*") {
    write-output "Windows 10 Detected"
    write-output "Removing Current Layout"
    If (Test-Path C:\Windows\StartLayout.xml) {

        Remove-Item C:\Windows\StartLayout.xml

    }
    write-output "Creating Default Layout"
    #Creates the blank layout file

    Write-Output "<LayoutModificationTemplate xmlns:defaultlayout=""http://schemas.microsoft.com/Start/2014/FullDefaultLayout"" xmlns:start=""http://schemas.microsoft.com/Start/2014/StartLayout"" Version=""1"" xmlns=""http://schemas.microsoft.com/Start/2014/LayoutModification"">" >> C:\Windows\StartLayout.xml

    Write-Output " <LayoutOptions StartTileGroupCellWidth=""6"" />" >> C:\Windows\StartLayout.xml

    Write-Output " <DefaultLayoutOverride>" >> C:\Windows\StartLayout.xml

    Write-Output " <StartLayoutCollection>" >> C:\Windows\StartLayout.xml

    Write-Output " <defaultlayout:StartLayout GroupCellWidth=""6"" />" >> C:\Windows\StartLayout.xml

    Write-Output " </StartLayoutCollection>" >> C:\Windows\StartLayout.xml

    Write-Output " </DefaultLayoutOverride>" >> C:\Windows\StartLayout.xml

    Write-Output "</LayoutModificationTemplate>" >> C:\Windows\StartLayout.xml
}
if ($version -like "*Windows 11*") {
    write-output "Windows 11 Detected"
    write-output "Removing Current Layout"
    If (Test-Path "C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml") {

        Remove-Item "C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml"

    }

    $blankjson = @'
{
    "pinnedList": [
{ "desktopAppId": "MSEdge" },
{ "packagedAppId": "Microsoft.WindowsStore_8wekyb3d8bbwe!App" },
{ "packagedAppId": "desktopAppId":"Microsoft.Windows.Explorer" }
    ]
}
'@

    $blankjson | Out-File "C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml" -Encoding utf8 -Force
    $intunepath = "HKLM:\SOFTWARE\Microsoft\IntuneManagementExtension\Win32Apps"
    $intunecomplete = @(Get-ChildItem $intunepath).count
    $userpath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList"
    $userprofiles = Get-ChildItem $userpath | ForEach-Object { Get-ItemProperty $_.PSPath }

    $nonAdminLoggedOn = $false
    foreach ($user in $userprofiles) {
        if ($user.PSChildName -ne '.DEFAULT' -and $user.PSChildName -ne 'S-1-5-18' -and $user.PSChildName -ne 'S-1-5-19' -and $user.PSChildName -ne 'S-1-5-20' -and $user.PSChildName -notmatch 'S-1-5-21-\d+-\d+-\d+-500') {
            $nonAdminLoggedOn = $true
            break
        }
    }

    if ($nonAdminLoggedOn -eq $false) {
        MkDir -Path "C:\Users\Default\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState" -Force -ErrorAction SilentlyContinue | Out-Null
        $starturl = "https://github.com/Chidieberetech/custom-De-Bloat/raw/main/De-Bloat/start2.bin"
        invoke-webrequest -uri $starturl -outfile "C:\Users\Default\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\Start2.bin"
    }
}


############################################################################################################
#                                              Remove Xbox Gaming                                          #
#                                                                                                          #
############################################################################################################

New-ItemProperty -Path "HKLM:\System\CurrentControlSet\Services\xbgm" -Name "Start" -PropertyType DWORD -Value 4 -Force
Set-Service -Name XblAuthManager -StartupType Disabled
Set-Service -Name XblGameSave -StartupType Disabled
Set-Service -Name XboxGipSvc -StartupType Disabled
Set-Service -Name XboxNetApiSvc -StartupType Disabled
$task = Get-ScheduledTask -TaskName "Microsoft\XblGameSave\XblGameSaveTask" -ErrorAction SilentlyContinue
if ($null -ne $task) {
    Set-ScheduledTask -TaskPath $task.TaskPath -Enabled $false
}

##Check if GamePresenceWriter.exe exists
if (Test-Path "$env:WinDir\System32\GameBarPresenceWriter.exe") {
    write-output "GamePresenceWriter.exe exists"
    #Take-Ownership -Path "$env:WinDir\System32\GameBarPresenceWriter.exe"
    $NewAcl = Get-Acl -Path "$env:WinDir\System32\GameBarPresenceWriter.exe"
    # Set properties
    $identity = "$builtin\Administrators"
    $fileSystemRights = "FullControl"
    $type = "Allow"
    # Create new rule
    $fileSystemAccessRuleArgumentList = $identity, $fileSystemRights, $type
    $fileSystemAccessRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $fileSystemAccessRuleArgumentList
    # Apply new rule
    $NewAcl.SetAccessRule($fileSystemAccessRule)
    Set-Acl -Path "$env:WinDir\System32\GameBarPresenceWriter.exe" -AclObject $NewAcl
    Stop-Process -Name "GameBarPresenceWriter.exe" -Force
    Remove-Item "$env:WinDir\System32\GameBarPresenceWriter.exe" -Force -Confirm:$false

}
else {
    write-output "GamePresenceWriter.exe does not exist"
}

New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\GameDVR" -Name "AllowgameDVR" -PropertyType DWORD -Value 0 -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "SettingsPageVisibility" -PropertyType String -Value "hide:gaming-gamebar;gaming-gamemode;gaming-xboxnetworking" -Force
Remove-Item C:\Windows\Temp\SetACL.exe -recurse

############################################################################################################
#                                        Disable Edge Surf Game                                            #
#                                                                                                          #
############################################################################################################
$surf = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
If (!(Test-Path $surf)) {
    New-Item $surf
}
New-ItemProperty -Path $surf -Name 'AllowSurfGame' -Value 0 -PropertyType DWord



############################################################################################################
#                                        Remove Manufacturer Bloat                                         #
#                                                                                                          #
############################################################################################################
##Check Manufacturer
write-output "Detecting Manufacturer"
$details = Get-CimInstance -ClassName Win32_ComputerSystem
$manufacturer = $details.Manufacturer

if ($manufacturer -like "*HP*") {
    write-output "HP detected"
    #Remove HP bloat


    ##HP Specific
    $UninstallPrograms = @(
        "Poly Lens"
        "HP Client Security Manager"
        "HP Notifications"
        "HP Security Update Service"
        "HP System Default Settings"
        "HP Wolf Security"
        "HP Wolf Security - Console"
        "HP Wolf Security Application Support for Sure Sense"
        "HP Wolf Security Application Support for Windows"
        "HP Wolf Security Application Support for Chrome 122.0.6261.139"
        "AD2F1837.HPPCHardwareDiagnosticsWindows"
        "AD2F1837.HPPowerManager"
        "AD2F1837.HPPrivacySettings"
        "AD2F1837.HPQuickDrop"
        "AD2F1837.HPSupportAssistant"
        "AD2F1837.HPSystemInformation"
        "AD2F1837.myHP"
        "RealtekSemiconductorCorp.HPAudioControl",
        "HP Sure Recover",
        "HP Sure Run Module"
        "RealtekSemiconductorCorp.HPAudioControl_2.39.280.0_x64__dt26b99r8h8gj"
        "Windows Driver Package - HP Inc. sselam_4_4_2_453 AntiVirus  (11/01/2022 4.4.2.453)"
        "HP Insights"
        "HP Insights Analytics"
        "HP Insights Analytics - Dependencies"
        "HP Performance Advisor"
        "HP Presence Video"
    )



    $UninstallPrograms = $UninstallPrograms | Where-Object { $appstoignore -notcontains $_ }

    # Removed potentially dangerous commented lines that could remove apps too broadly

    $InstalledPrograms = $allstring | Where-Object { $UninstallPrograms -contains $_.Name }
    foreach ($app in $UninstallPrograms) {

        if (Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $app -ErrorAction SilentlyContinue) {
            Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $app | Remove-AppxProvisionedPackage -Online
            write-output "Removed provisioned package for $app."
        }
        else {
            write-output "Provisioned package for $app not found."
        }

        if (Get-AppxPackage -allusers -Name $app -ErrorAction SilentlyContinue) {
            Get-AppxPackage -allusers -Name $app | Remove-AppxPackage -AllUsers
            write-output "Removed $app."
        }
        else {
            write-output "$app not found."
        }

        UninstallAppFull -appName $app


    }





    ##Belt and braces, remove via CIM too
    #foreach ($program in $UninstallPrograms) {
    #    Get-CimInstance -Classname Win32_Product | Where-Object Name -Match $program | Invoke-CimMethod -MethodName Uninstall
    #}


    #Remove HP Documentation if it exists
    if (test-path -Path "C:\Program Files\HP\Documentation\Doc_uninstall.cmd") {
        Start-Process -FilePath "C:\Program Files\HP\Documentation\Doc_uninstall.cmd" -Wait -passthru -NoNewWindow
    }

    ##Remove HP Connect Optimizer if setup.exe exists
    if (test-path -Path 'C:\Program Files (x86)\InstallShield Installation Information\{6468C4A5-E47E-405F-B675-A70A70983EA6}\setup.exe') {
        invoke-webrequest -uri "https://raw.githubusercontent.com/Chidieberetech/custom-De-Bloat/main/De-Bloat/HPConnOpt.iss" -outfile "C:\Windows\Temp\HPConnOpt.iss"

        &'C:\Program Files (x86)\InstallShield Installation Information\{6468C4A5-E47E-405F-B675-A70A70983EA6}\setup.exe' @('-s', '-f1C:\Windows\Temp\HPConnOpt.iss')
    }
    ##Remove HP Data Science Stack Manager
    if (test-path -Path 'C:\Program Files\HP\Z By HP Data Science Stack Manager\Uninstall Z by HP Data Science Stack Manager.exe') {
        &'C:\Program Files\HP\Z By HP Data Science Stack Manager\Uninstall Z by HP Data Science Stack Manager.exe' @('/allusers', '/S')
    }


    ##Remove other crap
    if (Test-Path -Path "C:\Program Files (x86)\HP\Shared" -PathType Container) { Remove-Item -Path "C:\Program Files (x86)\HP\Shared" -Recurse -Force }
    if (Test-Path -Path "C:\Program Files (x86)\Online Services" -PathType Container) { Remove-Item -Path "C:\Program Files (x86)\Online Services" -Recurse -Force }
    if (Test-Path -Path "C:\ProgramData\HP\TCO" -PathType Container) { Remove-Item -Path "C:\ProgramData\HP\TCO" -Recurse -Force }
    if (Test-Path -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Amazon.com.lnk" -PathType Leaf) { Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Amazon.com.lnk" -Force }
    if (Test-Path -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Angebote.lnk" -PathType Leaf) { Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Angebote.lnk" -Force }
    if (Test-Path -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\TCO Certified.lnk" -PathType Leaf) { Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\TCO Certified.lnk" -Force }
    if (Test-Path -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Booking.com.lnk" -PathType Leaf) { Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Booking.com.lnk" -Force }
    if (Test-Path -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Adobe offers.lnk" -PathType Leaf) { Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Adobe offers.lnk" -Force }
    if (Test-Path -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Miro Offer.lnk" -PathType Leaf) { Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Miro offer.lnk" -Force }

    ##Remove Wolf Security
    Get-CimInstance -ClassName Win32_Product | Where-Object { $_.Name -eq 'HP Wolf Security' } | Invoke-CimMethod -MethodName Uninstall
    Get-CimInstance -ClassName Win32_Product | Where-Object { $_.Name -eq 'HP Wolf Security - Console' } | Invoke-CimMethod -MethodName Uninstall
    Get-CimInstance -ClassName Win32_Product | Where-Object { $_.Name -eq 'HP Security Update Service' } | Invoke-CimMethod -MethodName Uninstall

    # Main execution
    Write-Log "Starting HP security package uninstallation process"

    # Define packages and criteria
    $packagePatterns = @(
        @{ Name = "HP Client Security Manager"; MinVersion = "10.0.0" },
        @{ Name = "HP Wolf Security(?!.*Console)" },
        @{ Name = "HP Wolf Security.*Console" },
        @{ Name = "HP Security Update Service" }
    )

# Process each package pattern
foreach ($pattern in $packagePatterns) {
    $patternName = $pattern.Name
    $minVersion = $pattern.MinVersion
    Write-Output "Checking for packages matching pattern: $patternName"

    # Search for matching packages in the registry
    $matchingPackages = @()

    # Check in 32-bit and 64-bit registry locations
    $registryPaths = @(
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
    )

    foreach ($registryPath in $registryPaths) {
        $packages = Get-ItemProperty -Path $registryPath -ErrorAction SilentlyContinue |
                    Where-Object { $_.DisplayName -match $patternName }

        # Filter by minimum version if specified
        if ($minVersion -and $packages) {
            $packages = $packages | Where-Object {
                if ($_.DisplayVersion) {
                    try {
                        [version]$_.DisplayVersion -ge [version]$minVersion
                    } catch {
                        # If version comparison fails, include it anyway for safety
                        $true
                    }
                } else {
                    # If no version information, include it for safety
                    $true
                }
            }
        }

        $matchingPackages += $packages
    }

    if ($matchingPackages.Count -eq 0) {
        Write-Output "No packages found matching pattern: $patternName"
        continue
    }

    Write-Output "Found $($matchingPackages.Count) package(s) matching pattern: $patternName"

    # Process each matching package
    foreach ($package in $matchingPackages) {
        $displayName = $package.DisplayName
        $uninstallString = $package.UninstallString
        $quietUninstallString = $package.QuietUninstallString
        $version = $package.DisplayVersion

        Write-Output "Attempting to uninstall: $displayName (Version: $version)"

        # Try to use the UninstallAppFull function first
        Write-Output "Trying to uninstall via UninstallAppFull..."
        UninstallAppFull -appName $displayName

        # If UninstallAppFull doesn't work, fall back to direct uninstallation
        # Check if uninstall string exists and attempt uninstall
        if ($quietUninstallString) {
            Write-Output "Using quiet uninstall string: $quietUninstallString"
            try {
                if ($quietUninstallString -match "msiexec") {
                    # For MSI-based uninstalls, add /quiet
                    $uninstallCommand = $quietUninstallString + " /quiet"
                    Start-Process "cmd.exe" -ArgumentList "/c $uninstallCommand" -Wait -NoNewWindow
                } else {
                    # For EXE-based uninstalls
                    $uninstallParts = $quietUninstallString -split ' ', 2
                    $uninstallExe = $uninstallParts[0].Trim('"')
                    $uninstallArgs = if ($uninstallParts.Count -gt 1) { $uninstallParts[1] } else { "" }

                    Start-Process -FilePath $uninstallExe -ArgumentList $uninstallArgs -Wait -NoNewWindow
                }
                Write-Output "Quiet uninstall completed for: $displayName"
            } catch {
                Write-Output "Error during quiet uninstall: $_"
            }
        } elseif ($uninstallString) {
            Write-Output "Using standard uninstall string: $uninstallString"
            try {
                if ($uninstallString -match "msiexec") {
                    # For MSI-based uninstalls, add /quiet
                    if ($uninstallString -match "/I{") {
                        # Change /I to /X for uninstall if needed
                        $uninstallString = $uninstallString -replace "/I", "/X"
                    }
                    $uninstallCommand = $uninstallString + " /quiet"
                    Start-Process "cmd.exe" -ArgumentList "/c $uninstallCommand" -Wait -NoNewWindow
                } else {
                    # For EXE-based uninstalls
                    $uninstallParts = $uninstallString -split ' ', 2
                    $uninstallExe = $uninstallParts[0].Trim('"')
                    $uninstallArgs = if ($uninstallParts.Count -gt 1) { $uninstallParts[1] } else { "" }

                    # Add silent parameters for common installers
                    if ($uninstallString -match "uninstall.exe|uninst.exe|setup.exe|installer.exe") {
                        $uninstallArgs += " /S /silent /quiet /uninstall"
                    }

                    Start-Process -FilePath $uninstallExe -ArgumentList $uninstallArgs -Wait -NoNewWindow
                }
                Write-Output "Standard uninstall completed for: $displayName"
            } catch {
                Write-Output "Error during standard uninstall: $_"
            }
        } else {
            Write-Output "No uninstall string found for: $displayName"
        }
    }
}

    write-output "Removed HP bloat"
}



if ($manufacturer -like "*Dell*") {
    write-output "Dell detected"
    #Remove Dell bloat

    ##Dell

    $UninstallPrograms = @(
        "Dell Optimizer"
        "Dell Power Manager"
        "DellOptimizerUI"
        "Dell SupportAssist OS Recovery"
        "Dell SupportAssist"
        "Dell Optimizer Service"
        "Dell Optimizer Core"
        "DellInc.PartnerPromo"
        "DellInc.DellOptimizer"
        "DellInc.DellCommandUpdate"
        "DellInc.DellPowerManager"
        "DellInc.DellDigitalDelivery"
        "DellInc.DellSupportAssistforPCs"
        "DellInc.PartnerPromo"
        "Dell Command | Update"
        "Dell Command | Update for Windows Universal"
        "Dell Command | Update for Windows 10"
        "Dell Command | Power Manager"
        "Dell Digital Delivery Service"
        "Dell Digital Delivery"
        "Dell Peripheral Manager"
        "Dell Power Manager Service"
        "Dell SupportAssist Remediation"
        "SupportAssist Recovery Assistant"
        "Dell SupportAssist OS Recovery Plugin for Dell Update"
        "Dell SupportAssistAgent"
        "Dell Update - SupportAssist Update Plugin"
        "Dell Core Services"
        "Dell Pair"
        "Dell Display Manager 2.0"
        "Dell Display Manager 2.1"
        "Dell Display Manager 2.2"
        "Dell SupportAssist Remediation"
        "Dell Update - SupportAssist Update Plugin"
        "DellInc.PartnerPromo"
    )



    $UninstallPrograms = $UninstallPrograms | Where-Object { $appstoignore -notcontains $_ }


    foreach ($app in $UninstallPrograms) {

        if (Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $app -ErrorAction SilentlyContinue) {
            Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $app | Remove-AppxProvisionedPackage -Online
            write-output "Removed provisioned package for $app."
        }
        else {
            write-output "Provisioned package for $app not found."
        }

        if (Get-AppxPackage -allusers -Name $app -ErrorAction SilentlyContinue) {
            Get-AppxPackage -allusers -Name $app | Remove-AppxPackage -AllUsers
            write-output "Removed $app."
        }
        else {
            write-output "$app not found."
        }

        UninstallAppFull -appName $app


    }

    ##Belt and braces, remove via CIM too
    #foreach ($program in $UninstallPrograms) {
    #    Get-CimInstance -Classname Win32_Product | Where-Object Name -Match $program | Invoke-CimMethod -MethodName Uninstall
    #}

    ##Manual Removals

    ##Dell Optimizer
    $dellSA = Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall, HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Where-Object { $_.DisplayName -like "Dell*Optimizer*Core" } | Select-Object -Property UninstallString

    ForEach ($sa in $dellSA) {
        If ($sa.UninstallString) {
            try {
                cmd.exe /c $sa.UninstallString -silent
            }
            catch {
                Write-Warning "Failed to uninstall Dell Optimizer"
            }
        }
    }


    ##Dell Dell SupportAssist Remediation
    $dellSA = Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall, HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Where-Object { $_.DisplayName -match "Dell SupportAssist Remediation" } | Select-Object -Property QuietUninstallString

    ForEach ($sa in $dellSA) {
        If ($sa.QuietUninstallString) {
            try {
                cmd.exe /c $sa.QuietUninstallString
            }
            catch {
                Write-Warning "Failed to uninstall Dell Support Assist Remediation"
            }
        }
    }

    ##Dell Dell SupportAssist OS Recovery Plugin for Dell Update
    $dellSA = Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall, HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Where-Object { $_.DisplayName -match "Dell SupportAssist OS Recovery Plugin for Dell Update" } | Select-Object -Property QuietUninstallString

    ForEach ($sa in $dellSA) {
        If ($sa.QuietUninstallString) {
            try {
                cmd.exe /c $sa.QuietUninstallString
            }
            catch {
                Write-Warning "Failed to uninstall Dell Support OS Recovery Plugin"
            }
        }
    }



    ##Dell Display Manager
    $dellSA = Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall, HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Where-Object { $_.DisplayName -like "Dell*Display*Manager*" } | Select-Object -Property UninstallString

    ForEach ($sa in $dellSA) {
        If ($sa.UninstallString) {
            try {
                cmd.exe /c $sa.UninstallString /S
            }
            catch {
                Write-Warning "Failed to uninstall Dell Display Manager"
            }
        }
    }

    ##Dell Peripheral Manager

    try {
        start-process c:\windows\system32\cmd.exe '/c "C:\Program Files\Dell\Dell Peripheral Manager\Uninstall.exe" /S'
    }
    catch {
        Write-Warning "Failed to uninstall Dell Peripheral Manager"
    }


    ##Dell Pair

    try {
        start-process c:\windows\system32\cmd.exe '/c "C:\Program Files\Dell\Dell Pair\Uninstall.exe" /S'
    }
    catch {
        Write-Warning "Failed to uninstall Dell Pair"
    }

}


if ($manufacturer -like "Lenovo") {
    write-output "Lenovo detected"


    ##Lenovo Specific
    # Function to uninstall applications with .exe uninstall strings

    function UninstallApp {

        param (
            [string]$appName
        )

        # Get a list of installed applications from Programs and Features
        $installedApps = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* |
        Where-Object { $_.DisplayName -like "*$appName*" }

        # Loop through the list of installed applications and uninstall them

        foreach ($app in $installedApps) {
            $uninstallString = $app.UninstallString
            $displayName = $app.DisplayName
            write-output "Uninstalling: $displayName"
            Start-Process $uninstallString -ArgumentList "/VERYSILENT" -Wait
            write-output "Uninstalled: $displayName" -ForegroundColor Green
        }
    }

    ##Stop Running Processes

    $processnames = @(
        "SmartAppearanceSVC.exe"
        "UDClientService.exe"
        "ModuleCoreService.exe"
        "ProtectedModuleHost.exe"
        "*lenovo*"
        "FaceBeautify.exe"
        "McCSPServiceHost.exe"
        "mcapexe.exe"
        "MfeAVSvc.exe"
        "mcshield.exe"
        "Ammbkproc.exe"
        "AIMeetingManager.exe"
        "DADUpdater.exe"
        "CommercialVantage.exe"
    )

    foreach ($process in $processnames) {
        write-output "Stopping Process $process"
        Get-Process -Name $process | Stop-Process -Force
        write-output "Process $process Stopped"
    }

    $UninstallPrograms = @(
        "E046963F.AIMeetingManager"
        "E0469640.SmartAppearance"
        "MirametrixInc.GlancebyMirametrix"
        "E046963F.LenovoCompanion"
        "E0469640.LenovoUtility"
        "E0469640.LenovoSmartCommunication"
        "E046963F.LenovoSettingsforEnterprise"
        "E046963F.cameraSettings"
        "4505Fortemedia.FMAPOControl2_2.1.37.0_x64__4pejv7q2gmsnr"
        "ElevocTechnologyCo.Ltd.SmartMicrophoneSettings_1.1.49.0_x64__ttaqwwhyt5s6t"
        "Lenovo User Guide"
        "TrackPoint Quick Menu"
        "E0469640.TrackPointQuickMenu"
    )


    $UninstallPrograms = $UninstallPrograms | Where-Object { $appstoignore -notcontains $_ }



    $InstalledPrograms = $allstring | Where-Object { (($_.Name -in $UninstallPrograms)) }


    foreach ($app in $UninstallPrograms) {

        if (Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $app -ErrorAction SilentlyContinue) {
            Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $app | Remove-AppxProvisionedPackage -Online
            write-output "Removed provisioned package for $app."
        }
        else {
            write-output "Provisioned package for $app not found."
        }

        if (Get-AppxPackage -allusers -Name $app -ErrorAction SilentlyContinue) {
            Get-AppxPackage -allusers -Name $app | Remove-AppxPackage -AllUsers
            write-output "Removed $app."
        }
        else {
            write-output "$app not found."
        }

        UninstallAppFull -appName $app


    }


    ##Belt and braces, remove via CIM too
    #foreach ($program in $UninstallPrograms) {
    #    Get-CimInstance -Classname Win32_Product | Where-Object Name -Match $program | Invoke-CimMethod -MethodName Uninstall
    #}

    # Get Lenovo Vantage service uninstall string to uninstall service
    $lvs = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*", "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*" | Where-Object DisplayName -eq "Lenovo Vantage Service"
    if (!([string]::IsNullOrEmpty($lvs.QuietUninstallString))) {
        $uninstall = "cmd /c " + $lvs.QuietUninstallString
        write-output $uninstall
        Invoke-Expression $uninstall
    }

    # Uninstall Lenovo Smart
    UninstallApp -appName "Lenovo Smart"

    # Uninstall Ai Meeting Manager Service
    UninstallApp -appName "Ai Meeting Manager"

    # Uninstall ImController service
    ##Check if exists
    $path = "c:\windows\system32\ImController.InfInstaller.exe"
    if (Test-Path $path) {
        write-output "ImController.InfInstaller.exe exists"
        $uninstall = "cmd /c " + $path + " -uninstall"
        write-output $uninstall
        Invoke-Expression $uninstall
    }
    else {
        write-output "ImController.InfInstaller.exe does not exist"
    }
    ##Invoke-Expression -Command 'cmd.exe /c "c:\windows\system32\ImController.InfInstaller.exe" -uninstall'

    # Remove vantage associated registry keys
    Remove-Item 'HKLM:\SOFTWARE\Policies\Lenovo\E046963F.LenovoCompanion_k1h2ywk1493x8' -Recurse -ErrorAction SilentlyContinue
    Remove-Item 'HKLM:\SOFTWARE\Policies\Lenovo\ImController' -Recurse -ErrorAction SilentlyContinue
    Remove-Item 'HKLM:\SOFTWARE\Policies\Lenovo\Lenovo Vantage' -Recurse -ErrorAction SilentlyContinue
    #Remove-Item 'HKLM:\SOFTWARE\Policies\Lenovo\Commercial Vantage' -Recurse -ErrorAction SilentlyContinue

    # Uninstall AI Meeting Manager Service
    $path = 'C:\Program Files\Lenovo\Ai Meeting Manager Service\unins000.exe'
    $params = "/SILENT"
    if (test-path -Path $path) {
        Start-Process -FilePath $path -ArgumentList $params -Wait
    }


    # Uninstall Lenovo Now
    $path = 'C:\Program Files (x86)\Lenovo\LenovoNow\unins000.exe'
    $params = "/SILENT"
    if (test-path -Path $path) {
        Start-Process -FilePath $path -ArgumentList $params -Wait
    }

    # Uninstall Lenovo Vantage
    $pathname = (Get-ChildItem -Path "C:\Program Files (x86)\Lenovo\VantageService").name
    $path = "C:\Program Files (x86)\Lenovo\VantageService\$pathname\Uninstall.exe"
    $params = '/SILENT'
    if (test-path -Path $path) {
        Start-Process -FilePath $path -ArgumentList $params -Wait
    }

    ##Uninstall Smart Appearance
    $path = 'C:\Program Files\Lenovo\Lenovo Smart Appearance Components\unins000.exe'
    $params = '/SILENT'
    if (test-path -Path $path) {
        try {
            Start-Process -FilePath $path -ArgumentList $params -Wait
        }
        catch {
            Write-Warning "Failed to start the process"
        }
    }
    $lenovowelcome = "c:\program files (x86)\lenovo\lenovowelcome\x86"
    if (Test-Path $lenovowelcome) {
        # Remove Lenovo Now
        Set-Location "c:\program files (x86)\lenovo\lenovowelcome\x86"

        # Update $PSScriptRoot with the new working directory
        $PSScriptRoot = (Get-Item -Path ".\").FullName
        try {
            invoke-expression -command .\uninstall.ps1 -ErrorAction SilentlyContinue
        }
        catch {
            write-output "Failed to execute uninstall.ps1"
        }

        write-output "All applications and associated Lenovo components have been uninstalled." -ForegroundColor Green
    }

    $lenovonow = "c:\program files (x86)\lenovo\LenovoNow\x86"
    if (Test-Path $lenovonow) {
        # Remove Lenovo Now
        Set-Location "c:\program files (x86)\lenovo\LenovoNow\x86"

        # Update $PSScriptRoot with the new working directory
        $PSScriptRoot = (Get-Item -Path ".\").FullName
        try {
            invoke-expression -command .\uninstall.ps1 -ErrorAction SilentlyContinue
        }
        catch {
            write-output "Failed to execute uninstall.ps1"
        }

        write-output "All applications and associated Lenovo components have been uninstalled." -ForegroundColor Green
    }


    $filename = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\User Guide.lnk"

    if (Test-Path $filename) {
        Remove-Item -Path $filename -Force
    }

    ##Camera fix for Lenovo E14
    $model = Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object -ExpandProperty Model
    if ($model -eq "21E30001MY") {
        $keypath = "HKLM:\SOFTWARE\\Microsoft\Windows Media Foundation\Platform"
        $keyname = "EnableFrameServerMode"
        $value = 0
        if (!(Test-Path $keypath)) {
            New-Item -Path $keypath -Force
        }
        Set-ItemProperty -Path $keypath -Name $keyname -Value $value -Type DWord -Force

        $keypath2 = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows Media Foundation\Platform"
        if (!(Test-Path $keypath2)) {
            New-Item -Path $keypath2 -Force
        }
        Set-ItemProperty -Path $keypath2 -Name $keyname -Value $value -Type DWord -Force
    }


    ##Remove Lenovo theme and background image
    $registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes"

    # Check and remove ThemeName if it exists
    if (Get-ItemProperty -Path $registryPath -Name "ThemeName" -ErrorAction SilentlyContinue) {
        Remove-ItemProperty -Path $registryPath -Name "ThemeName"
    }

    # Check and remove DesktopBackground if it exists
    if (Get-ItemProperty -Path $registryPath -Name "DesktopBackground" -ErrorAction SilentlyContinue) {
        Remove-ItemProperty -Path $registryPath -Name "DesktopBackground"
    }

    ##Remove X-Rite if it exists
    $xritePath = "C:\Program Files (x86)\X-Rite Color Assistant\unins000.exe"
    if (Test-Path $xritePath) {
        Start-Process -FilePath $xritePath -ArgumentList "/SILENT" -Wait
        write-output "X-Rite Color Assistant uninstalled."
    }
    else {
        write-output "X-Rite Color Assistant uninstaller not found."
    }

}


############################################################################################################
#                                        Remove Any other installed crap                                   #
#                                                                                                          #
############################################################################################################

#McAfee

write-output "Detecting McAfee"
$mcafeeinstalled = "false"
$InstalledSoftware = Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall"
foreach ($obj in $InstalledSoftware) {
    $name = $obj.GetValue('DisplayName')
    if ($name -like "*McAfee*") {
        $mcafeeinstalled = "true"
    }
}

$InstalledSoftware32 = Get-ChildItem "HKLM:\Software\WOW6432NODE\Microsoft\Windows\CurrentVersion\Uninstall"
foreach ($obj32 in $InstalledSoftware32) {
    $name32 = $obj32.GetValue('DisplayName')
    if ($name32 -like "*McAfee*") {
        $mcafeeinstalled = "true"
    }
}

if ($mcafeeinstalled -eq "true") {
    write-output "McAfee detected"
    #Remove McAfee bloat
    ##McAfee
    ### Download McAfee Consumer Product Removal Tool ###
    write-output "Downloading McAfee Removal Tool"
    # Download Source
    $URL = 'https://github.com/Chidieberetech/custom-De-Bloat/raw/main/De-Bloat/mcafeeclean.zip'

    # Set Save Directory
    $destination = 'C:\ProgramData\Debloat\mcafee.zip'

    #Download the file
    Invoke-WebRequest -Uri $URL -OutFile $destination -Method Get

    Expand-Archive $destination -DestinationPath "C:\ProgramData\Debloat" -Force

    write-output "Removing McAfee"
    # Automate Removal and kill services
    start-process "C:\ProgramData\Debloat\Mccleanup.exe" -ArgumentList "-p StopServices,MFSY,PEF,MXD,CSP,Sustainability,MOCP,MFP,APPSTATS,Auth,EMproxy,FWdiver,HW,MAS,MAT,MBK,MCPR,McProxy,McSvcHost,VUL,MHN,MNA,MOBK,MPFP,MPFPCU,MPS,SHRED,MPSCU,MQC,MQCCU,MSAD,MSHR,MSK,MSKCU,MWL,NMC,RedirSvc,VS,REMEDIATION,MSC,YAP,TRUEKEY,LAM,PCB,Symlink,SafeConnect,MGS,WMIRemover,RESIDUE -v -s"
    write-output "McAfee Removal Tool has been run"

    ###New MCCleanup
    ### Download McAfee Consumer Product Removal Tool ###
    write-output "Downloading McAfee Removal Tool"
    # Download Source
    $URL = 'https://github.com/Chidieberetech/custom-De-Bloat/raw/main/De-Bloat/mcafeeclean.zip'

    # Set Save Directory
    $destination = 'C:\ProgramData\Debloat\mcafeenew.zip'

    #Download the file
    Invoke-WebRequest -Uri $URL -OutFile $destination -Method Get

    New-Item -Path "C:\ProgramData\Debloat\mcnew" -ItemType Directory
    Expand-Archive $destination -DestinationPath "C:\ProgramData\Debloat\mcnew" -Force

    write-output "Removing McAfee"
    # Automate Removal and kill services
    start-process "C:\ProgramData\Debloat\mcnew\Mccleanup.exe" -ArgumentList "-p StopServices,MFSY,PEF,MXD,CSP,Sustainability,MOCP,MFP,APPSTATS,Auth,EMproxy,FWdiver,HW,MAS,MAT,MBK,MCPR,McProxy,McSvcHost,VUL,MHN,MNA,MOBK,MPFP,MPFPCU,MPS,SHRED,MPSCU,MQC,MQCCU,MSAD,MSHR,MSK,MSKCU,MWL,NMC,RedirSvc,VS,REMEDIATION,MSC,YAP,TRUEKEY,LAM,PCB,Symlink,SafeConnect,MGS,WMIRemover,RESIDUE -v -s"
    write-output "McAfee Removal Tool has been run"

    $InstalledPrograms = $allstring | Where-Object { ($_.Name -like "*McAfee*") }
    $InstalledPrograms | ForEach-Object {

        write-output "Attempting to uninstall: [$($_.Name)]..."
        $uninstallcommand = $_.String

        Try {
            if ($uninstallcommand -match "^msiexec*") {
                #Remove msiexec as we need to split for the uninstall
                $uninstallcommand = $uninstallcommand -replace "msiexec.exe", ""
                $uninstallcommand = $uninstallcommand + " /quiet /norestart"
                $uninstallcommand = $uninstallcommand -replace "/I", "/X "
                #Uninstall with string2 params
                Start-Process 'msiexec.exe' -ArgumentList $uninstallcommand -NoNewWindow -Wait
            }
            else {
                #Exe installer, run straight path
                $string2 = $uninstallcommand
                start-process $string2
            }
            #$A = Start-Process -FilePath $uninstallcommand -Wait -passthru -NoNewWindow;$a.ExitCode
            #$Null = $_ | Uninstall-Package -AllVersions -Force -ErrorAction Stop
            write-output "Successfully uninstalled: [$($_.Name)]"
        }
        Catch { Write-Warning -Message "Failed to uninstall: [$($_.Name)]" }
    }

    ##Remove Safeconnect
    $safeconnects = Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall, HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Where-Object { $_.DisplayName -match "McAfee Safe Connect" } | Select-Object -Property UninstallString

    ForEach ($sc in $safeconnects) {
        If ($sc.UninstallString) {
            cmd.exe /c $sc.UninstallString /quiet /norestart
        }
    }

    ##
    ##remove some extra leftover Mcafee items from StartMenu-AllApps and uninstall registry keys
    ##
    if (Test-Path -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\McAfee") {
        Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\McAfee" -Recurse -Force
    }
    if (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\McAfee.WPS") {
        Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\McAfee.WPS" -Recurse -Force
    }
    #Interesting emough, this producese an error, but still deletes the package anyway
    get-appxprovisionedpackage -online | sort-object displayname | format-table displayname, packagename
    get-appxpackage -allusers | sort-object name | format-table name, packagefullname
    Get-AppxProvisionedPackage -Online | Where-Object DisplayName -eq "McAfeeWPSSparsePackage" | Remove-AppxProvisionedPackage -Online -AllUsers
}



# Only attempt Office removal if Office retail products are actually detected
write-output "Checking for Office retail installations..."
$officeDetected = $false

# Check for retail Office installations
$officeRetailProducts = @(
    "*O365HomePremRetail*",
    "*HomeStudent*Retail*",
    "*HomeBusiness*Retail*",
    "*Professional*Retail*",
    "*VisioStdRetail*",
    "*VisioProRetail*",
    "*ProjectStdRetail*",
    "*ProjectProRetail*"
)

foreach ($pattern in $officeRetailProducts) {
    $found = $allstring | Where-Object { $_.Name -like $pattern }
    if ($found) {
        $officeDetected = $true
        write-output "Found retail Office product: $($found.Name)"
        break
    }
}

if ($officeDetected) {
    write-output "Retail Office products detected. Proceeding with removal..."

    ## The XML below will Remove Retail Copies of Office 365, including all languages. Note: Office Apps for Entreprise Editions will remain.

    ## Remove Retail Copies XML Start ##
$xml = @"
<Configuration>
  <Display Level="None" AcceptEULA="True" />
  <Property Name="FORCEAPPSHUTDOWN" Value="True" />
  <Remove>
    <!-- Microsoft 365 (consumer) -->
    <Product ID="O365HomePremRetail"/>

    <!-- Perpetual consumer (2021/2019 & legacy names) -->
    <Product ID="HomeStudent2021Retail"/>
    <Product ID="HomeBusiness2021Retail"/>
    <Product ID="Professional2021Retail"/>

    <Product ID="HomeStudent2019Retail"/>
    <Product ID="HomeBusiness2019Retail"/>
    <Product ID="Professional2019Retail"/>

    <!-- Legacy catch-alls some OEMs still use -->
    <Product ID="HomeStudentRetail"/>
    <Product ID="HomeBusinessRetail"/>
    <Product ID="ProfessionalRetail"/>

    <!-- Consumer Visio/Project retail -->
    <Product ID="VisioStdRetail"/>
    <Product ID="VisioProRetail"/>
    <Product ID="ProjectStdRetail"/>
    <Product ID="ProjectProRetail"/>
  </Remove>
</Configuration>
"@

    ## Remove Retail Copies XML End ##


    ## The XML below will Remove All Microsoft C2Rs ( Click-to-Runs), regardless of Product ID and Languages. To remove All Comment out or remove the XML block between Start and End above. Then Uncomment the XML below.

    ## Remove All Office Products XML Start ##

  ##  $xml = @"
##<Configuration>
  ##<Display Level="None" AcceptEULA="True" />
  ##<Property Name="FORCEAPPSHUTDOWN" Value="True" />
  ##<Remove All="TRUE">
  ##</Remove>
##</Configuration>
  ##"@

    ## Remove All Office Products XML End

    ##write XML to the debloat folder
    $xml | Out-File -FilePath "C:\ProgramData\Debloat\o365.xml"

    ##Download the Latest ODT URI obtained from Stealthpuppy's Evergreen PS Module
    $odturl = "https://officecdn.microsoft.com/pr/wsus/setup.exe"
    $odtdestination = "C:\ProgramData\Debloat\setup.exe"
    Invoke-WebRequest -Uri $odturl -OutFile $odtdestination -Method Get -UseBasicParsing

    ##Run it
    Start-Process -FilePath "C:\ProgramData\Debloat\setup.exe" -ArgumentList "/configure C:\ProgramData\Debloat\o365.xml" -WindowStyle Hidden -Wait

    write-output "Removed Office Retail Installations"
}

# Clean up Debloat folder
Remove-Item -Path "C:\ProgramData\Debloat" -Recurse -Force
# Stop Transcript
# Record the stop time

$stopUtc = [datetime]::UtcNow

# Calculate the total run time
$runTime = $stopUTC - $startUTC

# Format the runtime with hours, minutes, and seconds
if ($runTime.TotalHours -ge 1) {
    $runTimeFormatted = 'Duration: {0:hh} hr {0:mm} min {0:ss} sec' -f $runTime
}
else {
    $runTimeFormatted = 'Duration: {0:mm} min {0:ss} sec' -f $runTime
}

write-output "Completed"
write-output "Total Script $($runTimeFormatted)"

#Set ProgressPreerence back
$ProgressPreference = $OrginalProgressPreference
Stop-Transcript
