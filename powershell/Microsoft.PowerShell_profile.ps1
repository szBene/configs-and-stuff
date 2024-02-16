# -------------------
# SET COMMAND ALIASES AND STUFF

# reload powershell profile (by reloading powershell)
function psreload { pwsh }
#function reload { . $PROFILE } # this doesnt work for some reason

# edit this profile with micro
function psedit { micro $PROFILE }

# alias for clearing the terminal
Set-Alias -Name clear -Value Clear-Host

# set history command to show full history
function Show-History { Get-Content (Get-PSReadLineOption).HistorySavePath }
Set-Alias -Name history -Value Show-History

# find executable/script path
function which($name) {
	Get-Command $name | Select-Object -ExpandProperty Definition
}

# change network settings
Set-Alias -Name chnet -Value "$env:USERPROFILE\chnet.bat"
# function chnet { Start-Process "$env:USERPROFILE\chnet.bat" -Verb runAs -ArgumentList $arg }

# alias for micro editor
Set-Alias -Name m -Value micro
Set-Alias -Name mic -Value micro

# system scan and repair
function SystemScanAndRepair {
	"Starting system scan and repair using SFC & DISM..."
	"> SFC /scannow"
	SFC /scannow
	
	"> DISM /Online /Cleanup-Image /CheckHealth"
	DISM /Online /Cleanup-Image /CheckHealth

	"> DISM /Online /Cleanup-Image /ScanHealth"
	DISM /Online /Cleanup-Image /ScanHealth

	"> DISM /Online /Cleanup-Image /RestoreHealth"
	DISM /Online /Cleanup-Image /RestoreHealth
}
Set-Alias -Name sysscan -Value SystemScanAndRepair
Set-Alias -Name sysscanrepair -Value SystemScanAndRepair
Set-Alias -Name syssr -Value SystemScanAndRepair

# get public ipv4 address
function getpubip {
	echo "Public IPv4 address:"
	(Invoke-WebRequest https://ifconfig.me/ip).Content
}

# find a file in current directory and subdirectories
function find($file, $mode) {
	Get-ChildItem -recurse -filter "*${file}*" -ErrorAction SilentlyContinue | ForEach-Object {
	if ($mode -ieq "d"){
		# detailed version with more info
		$_
	} else {
		# normal version, only filepaths
		# if printed as string, only outputs full path, not all info
		"$_"
		}
	}
}

function proc($action, $name){
	if ($action -ieq "get"){
		# get process by name
		Get-Process $name
	} elseif ($action -ieq "kill"){
		# kill process by process name
		Get-Process $name -ErrorAction SilentlyContinue | Stop-Process
	} else {
		Write-Host "invalid parameter for action: $action"
		Write-Host "{get, kill}"
	}
}

# create empty file
function mkfile($fn){
	"" >> $fn  # if the file exists, appends an empty string to its content
}
Set-Alias -Name touch -Value mkfile

function showwifi($name){
	netsh wlan show profile name=$name key=clear
}

# optimize video without changing framerate and resolution
function optvid ( $video, $outname, $quality = 'high' ){

	$crf = switch ($quality) {
		'ultrahigh'	{ 0 }
		'extrahigh'	{ 10 }
		'high'		{ 20 }
		'mid'  		{ 28 }
		'low'  		{ 32 }
		'extralow'  { 36 }
	}
	
	echo "Optimizing $video to $quality ($crf)"
	echo "The video will be saved as $outname"
	
	ffmpeg -i $video -vcodec libx265 -crf $crf "$outname"
}
#--------------------
# INIT STUFF

# Print "Administrator" if the instance is elevated
if ( ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator") ){
	"Administrator"
}

# to be fancy
neofetch

# load oh my posh 
oh-my-posh init pwsh --config "$env:USERPROFILE\clean-detailed.omp.json" | Invoke-Expression

#34de4b3d-13a8-4540-b76d-b9e8d3851756 PowerToys CommandNotFound module
Import-Module "$env:LOCALAPPDATA\PowerToys\WinUI3Apps\..\WinGetCommandNotFound.psd1"
#34de4b3d-13a8-4540-b76d-b9e8d3851756

# Import the PSReadLine module
Import-Module PSReadLine

# Enable predictive intellisense
Set-PSReadLineOption -PredictionSource History
# Set the UpArrow and DownArrow keys to search the command history
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
