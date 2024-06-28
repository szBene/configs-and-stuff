# -------------------
# SET COMMAND ALIASES AND STUFF

$IsAdmin = $false
if ( ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator") ) {
	# check if opened as admin
	$IsAdmin = $true
}

# Import the PSReadLine module
Import-Module PSReadLine

# Enable predictive intellisense
Set-PSReadLineOption -PredictionSource History
# Set the UpArrow and DownArrow keys to search the command history
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

# Enhanced PowerShell Experience
Set-PSReadLineOption -Colors @{
	Command   = 'Cyan'
	Parameter = 'White'
	String    = 'Yellow'
	Number    = 'Magenta'
	Variable  = 'Green'
	Operator  = 'Gray'
	Comment   = 'DarkGreen'
	Keyword   = 'DarkCyan'
	Type      = 'DarkYellow'
}

Set-Alias -Name update -Value "$env:USERPROFILE\\.scripts\\update.ps1"

# alias for clearing the terminal
Set-Alias -Name clear -Value Clear-Host

# reload powershell profile
function psreload {
	& $PROFILE
}

# edit this profile with micro
function psedit {
	micro $PROFILE
}

# set history command to show full history
Set-Alias -Name history -Value "$env:USERPROFILE\\.scripts\\history.ps1"

# cheatsheet
Set-Alias -Name cheat -Value "$env:USERPROFILE\\cheat.exe"
Set-Alias -Name man -Value "$env:USERPROFILE\\cheat.exe"

# list all usb devices
Set-Alias -Name lsusb -Value "$env:USERPROFILE\\.scripts\\listUSB.ps1"

# find executable/script path
Set-Alias -Name which -Value "$env:USERPROFILE\\.scripts\\which.ps1"

# change network settings
Set-Alias -Name chnet -Value "$env:USERPROFILE\\chnet.bat"
# function chnet { Start-Process "$env:USERPROFILE\chnet.bat" -Verb runAs -ArgumentList $arg }

# alias for micro editor
Set-Alias -Name m -Value micro
Set-Alias -Name mic -Value micro

# basic system scan and repair
Set-Alias -Name sysscan -Value "$env:USERPROFILE\\.scripts\\systemScanRepair.ps1"
Set-Alias -Name sysscanrepair -Value "$env:USERPROFILE\\.scripts\\systemScanRepair.ps1"
Set-Alias -Name syssr -Value "$env:USERPROFILE\\.scripts\\systemScanRepair.ps1"

# ip script
Set-Alias -Name ip "$env:USERPROFILE\\.scripts\\getIPaddress.ps1"
# find file
Set-Alias -Name find "$env:USERPROFILE\\.scripts\\findFile.ps1"
# get/kill processes
Set-Alias -Name proc "$env:USERPROFILE\\.scripts\\processUtil.ps1"

# create empty file
Set-Alias -Name touch "$env:USERPROFILE\\.scripts\\createFile.ps1"

# show wifi
Set-Alias -Name wifi "$env:USERPROFILE\\.scripts\\wifi.ps1"

# optimize video without changing framerate and resolution
Set-Alias -Name optvid -Value "$env:USERPROFILE\\.scripts\\optimizeVideo.ps1"

# unarchive an archive
Set-Alias -Name unzip -Value "$env:USERPROFILE\\.scripts\\unzip.ps1"

# installed GnuWin32.Grep instead of this
#function grep($regex, $dir) {
#	if ( $dir ) {
#		Get-ChildItem $dir | Select-String $regex
#		return
#	}
#	$input | Select-String $regex
#}
 
#--------------------
# INIT STUFF

if ($IsAdmin) { Write-Output "Administrator" }

# fastfetch only loads when opening terminal in user home directory
if ( [Environment]::CurrentDirectory -eq $env:USERPROFILE ) {
	& "$env:USERPROFILE\\.fastfetch\\fastfetch.exe" -c "$env:USERPROFILE\\.fastfetch\\config.jsonc"
}

# load oh my posh
#todo load different config when in admin mode
oh-my-posh init pwsh --config "$env:USERPROFILE\\clean-detailed.omp.json" | Invoke-Expression

# this module breaks powershell on load when there is no internet
#f45873b3-b655-43a6-b217-97c00aa0db58 PowerToys CommandNotFound module
#              yes, this check is necessary.
if ($(ip 4 r) -ne $False) { Import-Module -Name Microsoft.WinGet.CommandNotFound }
#f45873b3-b655-43a6-b217-97c00aa0db58
