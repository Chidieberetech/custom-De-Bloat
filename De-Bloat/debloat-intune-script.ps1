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

$zipUrl = "https://github.com/#####/RemoveBloat.zip"
$zipPath = "$templateFilePath\RemoveBloat.zip"
$extractPath = "$templateFilePath"

Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath
Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force


# Define apps to whitelist (comma-separated)
$whitelistApps = ""

# Define scheduled tasks to remove (empty by default).  Comma separated
$tasksToRemove = @() -join ','

# Build the arguments string with both parameters
$arguments = " -customwhitelist `"$whitelistApps`""

# Only add the TasksToRemove parameter if there are tasks to remove
if ($tasksToRemove) {
    $arguments += " -TasksToRemove `"$tasksToRemove`""
}

$pathwithfile = "$templateFilePath\removebloat.ps1"

# Execute the script with parameters
invoke-expression -Command "$pathwithfile $arguments"
