# -------------------
# SET COMMAND ALIASES AND STUFF

# reload powershell profile (by reloading powershell)
function psreload { pwsh } # this relaunches powershell
#function psreload { & $PROFILE }

# edit this profile with micro
function psedit { micro $PROFILE }

# alias for clearing the terminal
Set-Alias -Name clear -Value Clear-Host

# set history command to show full history
function Show-History { Get-Content (Get-PSReadLineOption).HistorySavePath }
Set-Alias -Name history -Value Show-History

# cheatsheet
Set-Alias -Name cheat -Value C:\Users\szBene\cheat.exe

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
function ip {
	Write-Output "Public IPv4 address:"
	(Invoke-WebRequest https://ifconfig.me/ip).Content
}

# find a file in current directory and subdirectories
function find($file, $mode) {
	Get-ChildItem -recurse -filter "*${file}*" -ErrorAction SilentlyContinue | ForEach-Object {
		if ($mode -ieq "d") {
			# detailed version with more info
			$_
		}
		else {
			# normal version, only filepaths
			# if printed as string, only outputs full path, not all info
			"$_"
		}
	}
}

function proc($action, $name) {
	if ($action -ieq "get") {
		# get process by name
		Get-Process $name
	}
 elseif ($action -ieq "kill") {
		# kill process by process name
		Get-Process $name -ErrorAction SilentlyContinue | Stop-Process
	}
 else {
		Write-Output "invalid parameter for action: $action"
		Write-Output "{get, kill}"
	}
}

# create empty file
function mkfile($fn) {
	"" >> $fn  # if the file exists, appends an empty string to its content
}
Set-Alias -Name touch -Value mkfile

function showwifi($name) {
	netsh wlan show profile name=$name key=clear
}

# optimize video without changing framerate and resolution
function optvid ( $video, $outname, $quality = 'high' ) {

	$crf = switch ($quality) {
		'ultrahigh'	{ 0 }
		'extrahigh'	{ 10 }
		'high' { 20 }
		'mid' { 28 }
		'low' { 32 }
		'extralow' { 36 }
	}
	
	Write-Output "Optimizing $video to $quality ($crf)"
	Write-Output "The video will be saved as $outname"
	
	ffmpeg -i $video -vcodec libx265 -crf $crf "$outname"
}

function unziptd($file, $outputDirectory = ".") {
	# Extract filename without extension
	$fileName = [System.IO.Path]::GetFileNameWithoutExtension($file)
  
	# Check if output directory is a valid path
	if (Test-Path $outputDirectory) {
		$destinationPath = Join-Path $outputDirectory -ChildPath $fileName
	}
 else {
		# Handle invalid output directory (e.g., throw error or use default)
		Write-Error "Invalid output directory path: $outputDirectory"
		return
	}
  
	# Create output directory if it doesn't exist
	if (!(Test-Path $destinationPath)) {
		New-Item -ItemType Directory -Path $destinationPath
	}
  
	# Write output message
	Write-Output "Extracting $file to $destinationPath"
  
	# Expand archive to the created directory
	Expand-Archive -Path $file -DestinationPath $destinationPath
}

function grep($regex, $dir) {
	if ( $dir ) {
		Get-ChildItem $dir | select-string $regex
		return
	}
	$input | select-string $regex
}
  
#--------------------
# INIT STUFF

# Print "Administrator" if the instance is elevated
if ( ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator") ) {
	Write-Output "Administrator"
}

# fastfetch, just to be fancy
C:\Users\szBene\.fastfetch\fastfetch.exe -c C:\Users\szBene\.fastfetch\config.jsonc

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
