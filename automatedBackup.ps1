$basePath = "C:\Users\sagar\Desktop"
$backupFolder = Join-Path -Path $basePath -ChildPath "Backups"
$publishFolder = Join-Path -Path $basePath -ChildPath "Client"

$currentBackupFolderName = (Get-Date).ToString("yyyy_MM_dd")
$currentBackupFolderName = Join-Path -Path $backupFolder -ChildPath $currentBackupFolderName

# create root backup folder (for very first time)
If(!(test-path $backupFolder))
{
    New-Item -ItemType Directory -Force -Path $backupFolder
}

# create folder where current backup will go
If(test-path $currentBackupFolderName)
{
    $currentBackupFolderName = (Get-Date).ToString("yyyy_MM_dd__hh_mm_ss")
    $currentBackupFolderName = Join-Path -Path $backupFolder -ChildPath $currentBackupFolderName
}

New-Item -ItemType Directory -Force -Path $currentBackupFolderName

# take backup to newly created folder
Get-ChildItem -Path $publishFolder -Recurse -Exclude web.config | Move-Item -Destination $currentBackupFolderName
