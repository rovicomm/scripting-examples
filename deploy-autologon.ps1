# Enables Sysinternals Autologon
# 2024/04/2 HB

# Prevent Sysinternals EULA popup
$logOutput = "C:\logs\enable-autologon.log"
$registryPath = "HKCU:\Software\Sysinternals\Autologon"
Start-Transcript -Path $logOutput
# Check if reg key exists and create it if not
if (-not (Test-Path $registryPath)) {
    try {
        New-Item -Path $registryPath -Force -ErrorAction Stop
        New-ItemProperty -Path $registryPath -Name 'EulaAccepted' -Value '1' -PropertyType DWORD -Force -ErrorAction Stop
    }
    catch {
        Write-Host "Error creating $registryPath" >> $logOutput
    }
}

# Run Autologon64 with arguments
$user = ''
$domain = $env:COMPUTERNAME
$password = ''
try {
    Start-Process -FilePath "C:\Autologon64.exe"  -ArgumentList $user,$domain,$password -ErrorAction Stop 
}
catch {
    Write-Host "Error running AutoLogon process: $_" >> $logOutput
}
Stop-Transcript