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

Write-Output "Downloading RemoveBloat.zip from GitHub..."
try {
    Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath -ErrorAction Stop
    Write-Output "Download completed successfully."
} catch {
    Write-Error "Failed to download the script: $($_.Exception.Message)"
    exit 1
}

Write-Output "Extracting RemoveBloat.zip..."
try {
    Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force -ErrorAction Stop
    Write-Output "Extraction completed successfully."
} catch {
    Write-Error "Failed to extract the archive: $($_.Exception.Message)"
    exit 1
}

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

$pathwithfile = "$templateFilePath\RemoveBloat.ps1"

# Verify the script file exists after extraction
if (-not (Test-Path $pathwithfile)) {
    Write-Error "RemoveBloat.ps1 not found at expected location: $pathwithfile"
    Write-Output "Contents of ${templateFilePath}:"
    Get-ChildItem $templateFilePath -Recurse | ForEach-Object { Write-Output "  $($_.FullName)" }
    exit 1
}

Write-Output "Found RemoveBloat.ps1, executing debloat script..."

# Execute the script - it will only target confirmed bloatware patterns
try {
    if ($tasksToRemove.Count -gt 0) {
        $tasksString = $tasksToRemove -join ','
        & $pathwithfile -TasksToRemove $tasksString
    } else {
        & $pathwithfile
    }
    Write-Output "Debloat script completed successfully."
} catch {
    Write-Error "Failed to execute debloat script: $($_.Exception.Message)"
    exit 1
}
