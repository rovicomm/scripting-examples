# Sets the screen orientation to portrait based on hardware identifier in registry.
# HB 2024-03-14

$switchlog = "C:\logs\set-portrait.log"
Start-Transcript -Path $switchlog

$monitorIds = @("HMX*", "DEL*", "SGT*", "PDO*")
$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Configuration\"
$monitorList = Get-ChildItem -Path $registryPath

foreach ($monitorId in $monitorIds) {
    $monitors = $monitorList | Where-Object { $_.PSChildName -like $monitorId }
    # Rotates the display to portrait for ***. 
    # *** has an HD 1080p display.
    if ($monitorId -like "PDO*") {
        try {
            $key = $monitor | ForEach-Object { Get-ItemProperty -Path $_.PSPath } 
            $monitorName = $key.PSChildName
                try {
                    Set-ItemProperty -Path "$registryPath\$monitorName\00\00" -Name Rotation -Value 2 # Portrait
                    Set-ItemProperty -Path "$registryPath\$monitorName\00\00" -Name "ActiveSize.cx" -Value 1080 # Width
                    Set-ItemProperty -Path "$registryPath\$monitorName\00\00" -Name "ActiveSize.cy" -Value 1920 # Height
                    Set-ItemProperty -Path "$registryPath\$monitorName\00\00" -Name "PrimSurfSize.cx" -Value 1080 # Width
                    Set-ItemProperty -Path "$registryPath\$monitorName\00\00" -Name "PrimSurfSize.cy" -Value 1920 # Height
                    Set-ItemProperty -Path "$registryPath\$monitorName\00\00" -Name Scaling -Value 4 # 100%
                    Write-Host "Set portrait for ***."
                }
                catch {
                    Write-Host "Registry write error $_"
                }
        }
        catch {
            Write-Host "Error reported $_"
        }
    } else {
        # UHD 4K Portrait Display
        foreach ($monitor in $monitors) {
            try {
                $key = $monitor | ForEach-Object { Get-ItemProperty -Path $_.PSPath } 
                $monitorName = $key.PSChildName
                    try {
                        Set-ItemProperty -Path "$registryPath\$monitorName\00\00" -Name Rotation -Value 2 # Portrait
                        Set-ItemProperty -Path "$registryPath\$monitorName\00\00" -Name "ActiveSize.cx" -Value 2160 # Width
                        Set-ItemProperty -Path "$registryPath\$monitorName\00\00" -Name "ActiveSize.cy" -Value 3840 # Height
                        Set-ItemProperty -Path "$registryPath\$monitorName\00\00" -Name "PrimSurfSize.cx" -Value 2160 # Width
                        Set-ItemProperty -Path "$registryPath\$monitorName\00\00" -Name "PrimSurfSize.cy" -Value 3840 # Height
                        Set-ItemProperty -Path "$registryPath\$monitorName\00\00" -Name Scaling -Value 4 # 100%
                    }
                    catch {
                        Write-Host "Registry write error $_"
                    }
            }
            catch {
                Write-Host "Error reported $_"
            }
        }
    }
}  

Stop-Transcript
