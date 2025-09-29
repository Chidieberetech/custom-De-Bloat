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

$templateFilePath = "C:\ProgramData\Debloat"

$zipUrl = "https://github.com/Chidieberetech/custom-De-Bloat/raw/main/De-Bloat/RemoveBloat.zip"
$zipPath = "$templateFilePath\RemoveBloat.zip"
$extractPath = "$templateFilePath"

Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath
Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force

# Define apps to whitelist (comma-separated)
$whitelistApps = ""

# Define scheduled tasks to remove (empty by default).  Comma separated
$tasksToRemove = @() -join ','

# Correct path to the script (it's in a RemoveBloat subfolder)
$scriptPath = "$templateFilePath\RemoveBloat\RemoveBloat.ps1"

# Check if the script exists
if (Test-Path $scriptPath) {
    Write-Output "Found script at: $scriptPath"

    # Build parameters array
    $scriptParams = @()

    if ($whitelistApps) {
        $scriptParams += "-customwhitelist"
        $scriptParams += $whitelistApps
    }

    if ($tasksToRemove) {
        $scriptParams += "-TasksToRemove"
        $scriptParams += $tasksToRemove
    }

    # Execute the script with proper syntax
    if ($scriptParams.Count -gt 0) {
        & $scriptPath @scriptParams
    } else {
        & $scriptPath
    }
} else {
    Write-Error "Script not found at: $scriptPath"
    Get-ChildItem -Path $templateFilePath -Name "*.ps1" | ForEach-Object {
        Write-Output "Available PS1 files: $_"
    }
}
