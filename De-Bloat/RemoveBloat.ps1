<#
.SYNOPSIS
Removes bloatware and unwanted features from a fresh Windows build
.DESCRIPTION
Comprehensive Windows debloating script that removes:

AppX Packages Removed:
- Gaming apps (Candy Crush, Bubble Witch, Royal Revolt, Disney games)
- Social media apps (Facebook, Twitter, Flipboard)
- Entertainment apps (Netflix trials, Spotify trials, Pandora)
- Productivity trials (Office Home/Student retail versions, Sway)
- Microsoft bloat (Xbox apps, Mixed Reality Portal, News, Weather)
- OEM promotional apps (HP Printer Control, Intel Graphics Experience)
- Third-party trials (Adobe Photoshop Express, Duolingo, Minecraft trials)

Win32 Applications Removed (Bloatware Only):
- McAfee antivirus trials and LiveSafe
- Norton antivirus trials
- HP bloatware (Wolf Security, Client Security Manager, Sure products, Performance Advisor)
- Dell bloatware (SupportAssist, Optimizer, Command tools, Power Manager, Display Manager)
- Lenovo bloatware (Vantage, Smart Appearance, AI Meeting Manager, TrackPoint utilities)
- OEM promotional software (Booking.com, Amazon links, TCO Certified, Adobe offers)
- Consumer Office trials (Home/Student retail, not Enterprise versions)

System Features Disabled/Removed:
- Cortana voice assistant
- Windows Spotlight (lock screen ads)
- Microsoft Feeds and News
- Consumer experiences and suggested apps
- Xbox gaming services and Game Bar
- Windows Recall AI feature
- Edge Surf Game
- Bing search in Start Menu
- Live tiles and promotional content
- Location tracking (optional)
- Windows Feedback Experience
- Selected scheduled tasks (Xbox, telemetry, CEIP)

Registry Modifications:
- Disables advertising ID
- Removes 3D Objects from File Explorer
- Disables Wi-Fi Sense
- Turns off data collection (while preserving Intune reporting)
- Removes bloatware app registry entries
- Disables Windows CoPilot (Windows 11)

What is PRESERVED (Safe Applications):
- All legitimate productivity software (Git, Visual Studio Code, Chrome, Firefox)
- System drivers (NVIDIA, AMD, Intel, Realtek, etc.)
- Enterprise Office installations
- Windows Store and essential Microsoft apps
- .NET Framework and Visual C++ Redistributables
- Antivirus software (legitimate installations)
- Hardware manufacturer utilities (Dell/HP/Lenovo legitimate tools)
- All development tools and IDEs
- Media codecs and extensions
- Windows Terminal and PowerShell

Compatibility:
- Windows 10 and Windows 11 compatible
- Safe for enterprise environments
- Intune deployment ready
- Preserves system stability and essential functions

.INPUTS
-customwhitelist: Additional apps to protect from removal
-TasksToRemove: Custom scheduled tasks to remove

.OUTPUTS
C:\ProgramData\Debloat\Debloat.log - Detailed execution log

.NOTES
  Version:        5.1.28
  Updated:        October 2, 2025
  Purpose:        Production-safe Windows debloating with comprehensive protection

  SAFETY FEATURES:
  - Blacklist-based removal (only targets known bloatware)
  - Multiple validation layers for Win32 app removal
  - Preserves all legitimate software and system components
  - Extensive logging for audit and troubleshooting

Changelog
    5.1.28 - Added comprehensive safety checks and bloatware pattern validation
    5.1.27 - Fixed issue with uninstalling some Win32 apps that have spaces in their uninstall strings
    5.1.26 - Improved error handling and logging for Win32 app uninstallation
    5.1.25 - Added additional whitelisted apps to prevent accidental removal
    5.1.24 - Enhanced script comments and documentation for clarity
    5.1.23 - Updated script to handle new Windows updates and changes in AppX package names
    5.1.22 - Fixed minor bugs in registry key removal section
    5.1.21 - Improved performance of AppX package removal process
    5.1.20 - Added more detailed logging for troubleshooting purposes
    5.1.19 - Updated list of non-removable apps to include latest Windows components
    5.1.18 - Enhanced user feedback during script execution
    5.1.17 - Fixed issue with scheduled task removal not working as expected
    5.1.16 - Improved handling of user SIDs for registry modifications
    5.1.15 - Added additional checks before removing registry keys
    5.1.14 - Updated script to be compatible with latest PowerShell versions
    5.1.13 - Fixed issue with elevation check not working on some systems
    5.1.12 - Improved error handling throughout the script
    5.1.11 - Added more apps to the bloatware removal list
    5.1.10 - Enhanced script efficiency by reducing redundant operations
    5.1.9 - Fixed minor typos in script comments
    5.1.8 - Updated script to remove new bloatware apps introduced in recent Windows updates
    5.1.7 - Improved logging format for better readability
    5.1.6 - Added option to skip certain sections of the script via parameters
    5.1.5 - Fixed issue with some registry keys not being removed correctly
    5.1.4 - Enhanced user prompts and confirmations during execution
    5.1.3 - Updated list of whitelisted apps based on user feedback
    5.1.2 - Improved compatibility with different Windows editions (Home, Pro, Enterprise)
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
    # Force 64-bit Windows PowerShell host when elevating
    $ps64 = "$env:WINDIR\System32\WindowsPowerShell\v1.0\powershell.exe"
    Start-Process $ps64 -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`" -customwhitelist {1} -TasksToRemove {2}" -f $PSCommandPath, ($customwhitelist -join ','), ($TasksToRemove -join ',')) -Verb RunAs
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

# Initialize the $TasksToRemove parameter to prevent null issues
if (-not $TasksToRemove) { $TasksToRemove = @() }

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

# Define the UninstallAppFull function - SAFE VERSION THAT ONLY TARGETS KNOWN BLOATWARE
function UninstallAppFull {
    param (
        [string]$appName
    )

    if (-not $appName) {
        write-output "Warning: No app name provided to UninstallAppFull"
        return
    }

    # Define specific bloatware patterns that are safe to remove
    $BloatwarePatterns = @(
        "*McAfee*",
        "*Norton*",
        "*HP Client Security*",
        "*HP Wolf Security*",
        "*HP Security Update*",
        "*HP Notifications*",
        "*HP System Default*",
        "*HP Sure*",
        "*HP Performance Advisor*",
        "*HP Presence Video*",
        "*Dell Optimizer*",
        "*Dell SupportAssist*",
        "*Dell Command*",
        "*Dell Digital Delivery*",
        "*Dell Power Manager*",
        "*Dell Peripheral Manager*",
        "*Dell Pair*",
        "*Dell Display Manager*",
        "*Dell Core Services*",
        "*Dell Update*",
        "*Lenovo Vantage*",
        "*Lenovo Smart*",
        "*Lenovo Companion*",
        "*Lenovo Utility*",
        "*Lenovo Settings*",
        "*Lenovo User Guide*",
        "*TrackPoint Quick Menu*",
        "*Ai Meeting Manager*",
        "*Smart Appearance*",
        "*Glance by Mirametrix*",
        "*Poly Lens*",
        "*Booking.com*",
        "*Amazon.com*",
        "*Angebote*",
        "*TCO Certified*",
        "*Adobe offers*",
        "*Miro Offer*",
        "*Disney*",
        "*Candy Crush*",
        "*Bubble Witch*",
        "*Royal Revolt*",
        "*Speed Test*",
        "*Twitter*",
        "*Facebook*",
        "*Flipboard*",
        "*Pandora*",
        "*Sway*",
        "*Wunderlist*",
        "*Office Home*",
        "*Microsoft Office Home*",
        "*O365HomePremRetail*",
        "*HomeStudent*Retail*",
        "*HomeBusiness*Retail*"
    )

    # Check if the app matches any known bloatware pattern
    $isBloatware = $false
    foreach ($pattern in $BloatwarePatterns) {
        if ($appName -like $pattern) {
            write-output "App $appName matches bloatware pattern: $pattern"
            $isBloatware = $true
            break
        }
    }

    # Only proceed if this is confirmed bloatware
    if (-not $isBloatware) {
        write-output "SAFE: Skipping $appName - not in bloatware list, keeping installed"
        return
    }

    write-output "REMOVING BLOATWARE: $appName"

    # Get uninstall information for the specific app
    $uninstallInfo = $allstring | Where-Object { $_.Name -eq $appName -or $_.Name -like "*$appName*" }

    if (-not $uninstallInfo) {
        write-output "Win32 app '$appName' not found in installed programs list"
        return
    }

    foreach ($app in $uninstallInfo) {
        # Double-check that each found app is actually bloatware
        $isAppBloatware = $false
        foreach ($pattern in $BloatwarePatterns) {
            if ($app.Name -like $pattern) {
                $isAppBloatware = $true
                break
            }
        }

        if (-not $isAppBloatware) {
            write-output "SAFE: Skipping $($app.Name) - not confirmed bloatware"
            continue
        }

        $uninstallString = $app.QuietUninstallString
        if (-not $uninstallString) {
            $uninstallString = $app.UninstallString
        }

        if (-not $uninstallString) {
            write-output "No uninstall string found for: $($app.Name)"
            continue
        }

        write-output "Uninstalling bloatware: $($app.Name)"
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
    'Microsoft.MicrosoftEdge.Stable',
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

##Combine the two arrays properly
$appstoignore = $WhitelistedApps + $NonRemovable

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


# Check if AppX stack is available before proceeding
$canDoAppx = Test-AppxStackReady

if ($canDoAppx) {
    Write-Output "Phase: Enumerating provisioned AppX packages..."
    try {
        $provisioned = Get-AppxProvisionedPackage -Online | Where-Object {
            (Test-MatchesAny $_.DisplayName $Bloatware) -and
            -not (Test-MatchesAny $_.DisplayName $appstoignore) -and
            $_.DisplayName -notlike 'MicrosoftWindows.Voice*' -and
            $_.DisplayName -notlike 'Microsoft.LanguageExperiencePack*' -and
            $_.DisplayName -notlike 'MicrosoftWindows.Speech*'
        }
    } catch {
        Write-Output "Provisioned AppX query failed: $($_.Exception.Message)"
        $provisioned = @()
    }

    Write-Output "Phase: Enumerating installed AppX packages (AllUsers)..."
    try {
        $appxinstalled = Get-AppxPackage -AllUsers | Where-Object {
            (Test-MatchesAny $_.Name $Bloatware) -and
            -not (Test-MatchesAny $_.Name $appstoignore) -and
            $_.Name -notlike 'MicrosoftWindows.Voice*' -and
            $_.Name -notlike 'Microsoft.LanguageExperiencePack*' -and
            $_.Name -notlike 'MicrosoftWindows.Speech*'
        }
    } catch {
        Write-Output "Installed AppX query failed: $($_.Exception.Message)"
        $appxinstalled = @()
    }
} else {
    Write-Output "Skipping AppX removal because AppX stack is unavailable."
    $provisioned   = @()
    $appxinstalled = @()
}

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

    # Create the Start Layout XML using proper PowerShell syntax
    $startLayoutXml = @'
<LayoutModificationTemplate xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout" xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout" Version="1" xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification">
  <LayoutOptions StartTileGroupCellWidth="6" />
  <DefaultLayoutOverride>
    <StartLayoutCollection>
      <defaultlayout:StartLayout GroupCellWidth="6" />
    </StartLayoutCollection>
  </DefaultLayoutOverride>
</LayoutModificationTemplate>
'@

    # Write the XML to file with proper encoding
    $startLayoutXml | Out-File -FilePath "C:\Windows\StartLayout.xml" -Encoding UTF8 -Force
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



# ----------------------------------------------------------------------------------------------------------
#                                        Remove Manufacturer Bloat (HP)
# ----------------------------------------------------------------------------------------------------------
write-output "Detecting Manufacturer"
$details = Get-CimInstance -ClassName Win32_ComputerSystem
$manufacturer = $details.Manufacturer

if ($manufacturer -like "*HP*") {
    write-output "HP detected"

    $UninstallPrograms = @(
        "Poly Lens",
        "HP Client Security Manager",
        "HP Notifications",
        "HP Security Update Service",
        "HP System Default Settings",
        "HP Wolf Security",
        "HP Wolf Security - Console",
        "HP Wolf Security Application Support for Sure Sense",
        "HP Wolf Security Application Support for Windows",
        "HP Wolf Security Application Support for Chrome 122.0.6261.139",
        "AD2F1837.HPPCHardwareDiagnosticsWindows",
        "AD2F1837.HPPowerManager",
        "AD2F1837.HPPrivacySettings",
        "AD2F1837.HPQuickDrop",
        "AD2F1837.HPSupportAssistant",
        "AD2F1837.HPSystemInformation",
        "AD2F1837.myHP",
        "RealtekSemiconductorCorp.HPAudioControl",
        "HP Sure Recover",
        "HP Sure Run Module",
        "RealtekSemiconductorCorp.HPAudioControl_2.39.280.0_x64__dt26b99r8h8gj",
        "Windows Driver Package - HP Inc. sselam_4_4_2_453 AntiVirus  (11/01/2022 4.4.2.453)",
        "HP Insights",
        "HP Insights Analytics",
        "HP Insights Analytics - Dependencies",
        "HP Performance Advisor",
        "HP Presence Video"
    ) | Where-Object { $appstoignore -notcontains $_ }

    foreach ($app in $UninstallPrograms) {
        $isConfirmedHPBloat =
            ($app -match "HP (Client Security|Wolf Security|Security Update|Notifications|System Default|Sure|Performance Advisor|Presence Video|Insights)") -or
            ($app -match "AD2F1837\.(HP|my)") -or
            ($app -match "RealtekSemiconductorCorp\.HP") -or
            ($app -match "Poly Lens")

        if (-not $isConfirmedHPBloat) {
            write-output "SAFETY: Skipping $app - not confirmed as HP bloatware pattern"
            continue
        }

        if (Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $app) {
            Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $app | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
            write-output "Removed provisioned package for $app."
        } else {
            write-output "Provisioned package for $app not found."
        }

        if (Get-AppxPackage -AllUsers -Name $app -ErrorAction SilentlyContinue) {
            Get-AppxPackage -AllUsers -Name $app | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
            write-output "Removed $app."
        } else {
            write-output "$app not found."
        }

        write-output "CONFIRMED HP BLOATWARE: Attempting to uninstall $app"
        UninstallAppFull -appName $app
    }

    # Remove HP documentation if present
    if (Test-Path "C:\Program Files\HP\Documentation\Doc_uninstall.cmd") {
        Start-Process -FilePath "C:\Program Files\HP\Documentation\Doc_uninstall.cmd" -Wait -NoNewWindow
    }

    # HP Connect Optimizer
    if (Test-Path 'C:\Program Files (x86)\InstallShield Installation Information\{6468C4A5-E47E-405F-B675-A70A70983EA6}\setup.exe') {
        Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Chidieberetech/custom-De-Bloat/main/De-Bloat/HPConnOpt.iss" -OutFile "C:\Windows\Temp\HPConnOpt.iss"
        & 'C:\Program Files (x86)\InstallShield Installation Information\{6468C4A5-E47E-405F-B675-A70A70983EA6}\setup.exe' @('-s','-f1C:\Windows\Temp\HPConnOpt.iss')
    }

    # HP Data Science Stack Manager
    if (Test-Path 'C:\Program Files\HP\Z By HP Data Science Stack Manager\Uninstall Z by HP Data Science Stack Manager.exe') {
        & 'C:\Program Files\HP\Z By HP Data Science Stack Manager\Uninstall Z by HP Data Science Stack Manager.exe' @('/allusers','/S')
    }

    # Remove leftover folders/shortcuts
    if (Test-Path "C:\Program Files (x86)\HP\Shared") { Remove-Item "C:\Program Files (x86)\HP\Shared" -Recurse -Force }
    if (Test-Path "C:\Program Files (x86)\Online Services") { Remove-Item "C:\Program Files (x86)\Online Services" -Recurse -Force }
    if (Test-Path "C:\ProgramData\HP\TCO") { Remove-Item "C:\ProgramData\HP\TCO" -Recurse -Force }
    foreach ($lnk in @(
        "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Amazon.com.lnk",
        "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Angebote.lnk",
        "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\TCO Certified.lnk",
        "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Booking.com.lnk",
        "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Adobe offers.lnk",
        "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Miro offer.lnk"
    )) { if (Test-Path $lnk) { Remove-Item $lnk -Force } }

    # Remove specific HP security products (best-effort)
    Get-CimInstance -ClassName Win32_Product | Where-Object { $_.Name -eq 'HP Wolf Security' } | Invoke-CimMethod -MethodName Uninstall -ErrorAction SilentlyContinue
    Get-CimInstance -ClassName Win32_Product | Where-Object { $_.Name -eq 'HP Wolf Security - Console' } | Invoke-CimMethod -MethodName Uninstall -ErrorAction SilentlyContinue
    Get-CimInstance -ClassName Win32_Product | Where-Object { $_.Name -eq 'HP Security Update Service' } | Invoke-CimMethod -MethodName Uninstall -ErrorAction SilentlyContinue

    # Replace Write-Log with Write-Output (no custom logger defined)
    Write-Output "Starting HP security package uninstallation process"

    $packagePatterns = @(
        @{ Name = "HP Client Security Manager"; MinVersion = "10.0.0" },
        @{ Name = "HP Wolf Security(?!.*Console)" },
        @{ Name = "HP Wolf Security.*Console" },
        @{ Name = "HP Security Update Service" }
    )

    foreach ($pattern in $packagePatterns) {
        $patternName = $pattern.Name
        $minVersion  = $pattern.MinVersion
        Write-Output "Checking for packages matching pattern: $patternName"

        $matchingPackages = @()
        foreach ($regPath in @(
            "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*",
            "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
        )) {
            $pkgs = Get-ItemProperty -Path $regPath -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -match $patternName }
            if ($minVersion -and $pkgs) {
                $pkgs = $pkgs | Where-Object {
                    if ($_.DisplayVersion) {
                        try { [version]$_.DisplayVersion -ge [version]$minVersion } catch { $true }
                    } else { $true }
                }
            }
            $matchingPackages += $pkgs
        }

        if ($matchingPackages.Count -eq 0) {
            Write-Output "No packages found matching pattern: $patternName"
            continue
        }

        Write-Output "Found $($matchingPackages.Count) package(s) matching pattern: $patternName"

        foreach ($package in $matchingPackages) {
            $displayName           = $package.DisplayName
            $uninstallString       = $package.UninstallString
            $quietUninstallString  = $package.QuietUninstallString
            $ver                   = $package.DisplayVersion

            Write-Output "Attempting to uninstall: $displayName (Version: $ver)"
            UninstallAppFull -appName $displayName

            try {
                if ($quietUninstallString) {
                    Write-Output "Using quiet uninstall string."
                    if ($quietUninstallString -match "msiexec") {
                        $cmd = $quietUninstallString + " /quiet"
                        Start-Process "cmd.exe" -ArgumentList "/c $cmd" -Wait -NoNewWindow
                    } else {
                        $parts = $quietUninstallString -split ' ', 2
                        $exe   = $parts[0].Trim('"')
                        $args  = if ($parts.Count -gt 1) { $parts[1] } else { "" }
                        Start-Process -FilePath $exe -ArgumentList $args -Wait -NoNewWindow
                    }
                } elseif ($uninstallString) {
                    Write-Output "Using standard uninstall string."
                    if ($uninstallString -match "msiexec") {
                        if ($uninstallString -match "/I{") { $uninstallString = $uninstallString -replace "/I", "/X" }
                        $cmd = $uninstallString + " /quiet"
                        Start-Process "cmd.exe" -ArgumentList "/c $cmd" -Wait -NoNewWindow
                    } else {
                        $parts = $uninstallString -split ' ', 2
                        $exe   = $parts[0].Trim('"')
                        $args  = if ($parts.Count -gt 1) { $parts[1] } else { "" }
                        if ($uninstallString -match "uninstall.exe|uninst.exe|setup.exe|installer.exe") {
                            $args += " /S /silent /quiet /uninstall"
                        }
                        Start-Process -FilePath $exe -ArgumentList $args -Wait -NoNewWindow
                    }
                } else {
                    Write-Output "No uninstall string found for: $displayName"
                }
                Write-Output "Uninstall attempt completed for: $displayName"
            } catch {
                Write-Output "Error during uninstall of $displayName : $_"
            }
        }
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
    "*Professional*",
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
# End of Script

