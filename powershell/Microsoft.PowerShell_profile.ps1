# to be fancy
neofetch

# load oh my posh 
oh-my-posh init pwsh --config "$env:USERPROFILE\clean-detailed.omp.json" | Invoke-Expression

#34de4b3d-13a8-4540-b76d-b9e8d3851756 PowerToys CommandNotFound module
Import-Module "$env:LOCALAPPDATA\PowerToys\WinUI3Apps\..\WinGetCommandNotFound.psd1"
#34de4b3d-13a8-4540-b76d-b9e8d3851756

# -------------------
# SET COMMAND ALIASES AND STUFF

# reload powershell profile (by reloading powershell)
function reload { pwsh }
#function reload { . $PROFILE } # this doesnt work for some reason

# alias for clearing the terminal
Set-Alias -Name clear -Value cls

# set history command to show full history
function Show-History { Get-Content (Get-PSReadLineOption).HistorySavePath }
Set-Alias -Name history -Value Show-History

# change network settings
Set-Alias -Name chnet -Value .\chnet.bat

# alias for micro editor
Set-Alias -Name m -Value micro
Set-Alias -Name mic -Value micro

# system scan and repair
function SystemScanAndRepair {
	echo "Starting system scan and repair using SFC & DISM..."
	echo "> SFC /scannow"
	SFC /scannow
	echo "> DISM /Online /Cleanup-Image /CheckHealth"
	DISM /Online /Cleanup-Image /CheckHealth
	echo "> DISM /Online /Cleanup-Image /ScanHealth"
	DISM /Online /Cleanup-Image /ScanHealth
	echo "> DISM /Online /Cleanup-Image /RestoreHealth"
	DISM /Online /Cleanup-Image /RestoreHealth
}
Set-Alias -Name sysscan -Value SystemScanAndRepair
Set-Alias -Name sysscanrepair -Value SystemScanAndRepair
Set-Alias -Name syssr -Value SystemScanAndRepair

# Simple function to start a new elevated process. If arguments are supplied then 
# a single command is started with admin rights; if not then a new admin instance
# of PowerShell is started.
function admin {
	if ($args.Count -gt 0) {   
		#$argList = "& '" + $args + "'"
		#Start-Process "$psHome\pwsh.exe" -Verb runAs -ArgumentList $argList
		echo "Enter your command manually in the newly window"
		#Start-Process wt -Verb runAs
		wt -p "PowerShell (Admin)" # this is using terminal profile name
	} else {
		#Start-Process "$psHome\pwsh.exe" -Verb runAs
		#Start-Process wt -Verb runAs 
		wt -p "PowerShell (Admin)" # this is using terminal profile name
	}
}

# get public ipv4 address
function getpubip {
	echo "Public IPv4 address:"
	(Invoke-WebRequest http://ifconfig.me/ip).Content
}

# find a file in current directory and subdirectories
function find($name) {
	Get-ChildItem -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | ForEach-Object {
		$place_path = $_.directory
		Write-Output "${place_path}\${name}"
	}
}
# detailed version
function dfind($name){
	Get-ChildItem -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | ForEach-Object {
		echo $_
	}
}

# kill process by process name
function killproc($name) {
	Get-Process $name -ErrorAction SilentlyContinue | Stop-Process
}

# get process by name
function getproc($name){
	Get-Process $name
}

# create file
function mkfile($fn){
	"" >> $fn #if file exists, appends an empty string to its content
}
#--------------------
