$basePath = "C:\Users\sagar\Desktop"
$backupFolderName = "Backup"
$publishFolderName = "Client"
$backupFolder = Join-Path -Path $basePath -ChildPath $backupFolderName
$publishFolder = Join-Path -Path $basePath -ChildPath $publishFolderName

$currentBackupFolderName = (Get-Date).ToString("yyyy_MM_dd")
$currentBackupFolderPath = Join-Path -Path $backupFolder -ChildPath $currentBackupFolderName

$configFilePath = Join-Path -Path $backupFolder -ChildPath "web.config"

########## root backup folder (for very first time) ##########
If(!(test-path $backupFolder))
{
    Write-Output ""
    Write-Output "========> Creating Directory - '$backupFolderName'"
    New-Item -ItemType Directory -Force -Path $backupFolder | Out-Null
}

########## create publish folder to prevent error on backup stage ##########
If(!(test-path $publishFolder))
{
    Write-Output ""
    Write-Output "========> Creating Directory - '$publishFolderName'"
    New-Item -ItemType Directory -Force -Path $publishFolder | Out-Null
}

########## Current backup folder ##########
If(test-path $currentBackupFolderPath)
{
    $currentBackupFolderName = (Get-Date).ToString("yyyy_MM_dd__hh_mm_ss")
    $currentBackupFolderPath = Join-Path -Path $backupFolder -ChildPath $currentBackupFolderName
}
Write-Output ""
Write-Output "========> Creating Directory - '$currentBackupFolderName'"
New-Item -ItemType Directory -Force -Path $currentBackupFolderPath | Out-Null

########## Backup ##########
Write-Output ""
Write-Output "========> START - Backup"
Get-ChildItem -Path $publishFolder -Recurse | Move-Item -Destination $currentBackupFolderPath
Write-Output "========> END - Backup"

########## NPM install ##########
Write-Output ""
Write-Output "========> START - Node package installation"
npm install
Write-Output "========> END - Node package installation"

########## Build Angular Project ##########
Write-Output ""
Write-Output "========> START - Build Angular Project"
npm run ng -- build --prod --base-href=/client/ --output-path=$publishFolder
Write-Output "========> END - Build Angular Project"

########## Copy web.config ##########
Write-Output "========> Copying web.config file"
Copy-Item $configFilePath -Destination $publishFolder
