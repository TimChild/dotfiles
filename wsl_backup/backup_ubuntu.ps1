# Define params
$maxDaily = 7
$maxWeekly = 12
$maxMonthly = 12
$fileExt = "tar"


# Define paths
$backupBaseDir = "G:/11Backups/AthenaBackups/wsl-ubuntu"
$distribution = "Ubuntu-22.04" 
$dateString = Get-Date -Format "yyyyMMdd"
$dayOfWeek = (Get-Date).DayOfWeek

# Daily backup
$dailyBackup = "$backupBaseDir\daily\$dateString.$fileExt"
wsl --export $distribution $dailyBackup

# Remove daily backups older than 7 days
Get-ChildItem -Path "$backupBaseDir\daily\" -Filter "*.$fileExt" | Where-Object {$_.LastWriteTime -lt (Get-Date).AddDays(-$maxDaily)} | Remove-Item

# Weekly backup (on Sundays)
if ($dayOfWeek -eq "Sunday") {
    $weeklyBackup = "$backupBaseDir\weekly\$dateString.$fileExt"
    Copy-Item -Path $dailyBackup -Destination $weeklyBackup
    
    # Remove weekly backups older than 12 weeks
    Get-ChildItem -Path "$backupBaseDir\weekly\" -Filter "*.$fileExt" | Where-Object {$_.LastWriteTime -lt (Get-Date).AddDays(-($maxWeekly * 7))} | Remove-Item
}

# Monthly backup (1st of the month)
if ((Get-Date).Day -eq 1) {
    $monthlyBackup = "$backupBaseDir\monthly\$dateString.$fileExt"
    Copy-Item -Path $dailyBackup -Destination $monthlyBackup
    
    # Remove monthly backups older than 12 months
    Get-ChildItem -Path "$backupBaseDir\monthly\" -Filter "*.$fileExt" | Where-Object {$_.LastWriteTime -lt (Get-Date).AddMonths(-$maxMonthly)} | Remove-Item
}

