# Hides active user accounts from Login UI. 11/04/2024 HB
$logOutput = "c:\logs\Hide-UserLoginUI.log"
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList"

# Check if reg key exists and create it if not
if (-not (Test-Path $registryPath)) {
    try {
        New-Item -Path $registryPath -Force 
    }
    catch {
        Write-Host "Error creating $registryPath" >> $logOutput
    }
    
} else {
    Write-Host "Registry key '$registryPath' already exists." >> $logOutput
}

# Hide the following user accounts from the Login UI.
$userName = @("Administrator","RMSAdmin")
try {
    foreach ($user in $userName) {
        New-ItemProperty -Path $registryPath -Name $user -Value 0 -PropertyType DWORD -Force
    }
}
catch {
    Write-Host "Error creating values: $_" >> $logOutput
}
