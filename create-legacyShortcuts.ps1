# Creates shortcuts in the start menu for machines that have not been reimaged.
# 16/04/2024 HB

$log_file = "C:\logs\Set-LegacyShortcut.log"
$''_start = "C:\programdata\Microsoft\Windows\Start Menu\Programs\''"

# Create the '' folder in the Start Menu
try {
    if (-not (Test-Path -Path $''_start)) {
        New-Item -ItemType Directory -Path $''_start -ErrorAction Stop
        Write-Output "Start directory '' created." >> $log_file
    }
} catch {
    Write-Output $_ >> $log_file
}

# Create shortcuts for the batch files in psscripts directory
$batch_files = @("start-program1.bat","start-program2.bat","start-qprogram3.bat")
$batch_directory = "C:\''\psscripts"

foreach ($batch in $batch_files) {
    try {
        $shortcutName = ($batch -split '_') -join ' ' -replace '\.bat$',''
        $TargetFile = "$batch_directory\$batch"
        $ShortcutFile = "$''_start\$shortcutName.lnk"
        $WScriptShell = New-Object -ComObject WScript.Shell
        $shortcutObject = $WScriptShell.CreateShortcut($ShortcutFile)
        $shortcutObject.TargetPath = $TargetFile
        $shortcutObject.IconLocation = "$batch_directory\''.ico"
        $shortcutObject.Save()  
    } catch {
        Write-Output "Failed to create shortcut for $Batch"
    }    
}
