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

$zipUrl = "https://github.com/Chidieberetech/custom-De-Bloat/releases/download/2.2/RemoveBloat.zip"
$zipPath = "$templateFilePath\RemoveBloat.zip"
$extractPath = "$templateFilePath"

Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath
Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force

# The main script now uses a SAFE BLACKLIST approach that automatically protects:
# - All Win32 applications that are NOT bloatware
# - All drivers (NVIDIA, AMD, Intel, Realtek, etc.)
# - All legitimate software (Git, Visual Studio Code, Chrome, Office, etc.)
# - All system components and utilities
#
# ONLY confirmed bloatware patterns get removed (McAfee, HP Wolf Security, Dell bloat, etc.)
# NO WHITELIST NEEDED - everything is safe by default!

# Define scheduled tasks to remove (if any). Leave empty for default behavior.
$tasksToRemove = @()

$pathwithfile = "$templateFilePath\removebloat.ps1"

# Execute the script - it will only target confirmed bloatware patterns
if ($tasksToRemove.Count -gt 0) {
    $tasksString = $tasksToRemove -join ','
    & $pathwithfile -TasksToRemove $tasksString
} else {
    & $pathwithfile
}
