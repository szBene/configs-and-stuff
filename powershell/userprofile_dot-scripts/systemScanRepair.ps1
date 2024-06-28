# standard quick system scan and repair using SFC and DISM

Write-Output "Starting system scan and repair using SFC & DISM..."
Write-Output ">> SFC /scannow"
SFC /scannow

Write-Output ">> DISM /Online /Cleanup-Image /CheckHealth"
DISM /Online /Cleanup-Image /CheckHealth

Write-Output ">> DISM /Online /Cleanup-Image /ScanHealth"
DISM /Online /Cleanup-Image /ScanHealth

Write-Output ">> DISM /Online /Cleanup-Image /RestoreHealth"
DISM /Online /Cleanup-Image /RestoreHealth
