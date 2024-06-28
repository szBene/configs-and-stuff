# get and kill processes

param($action, $processName)

if ( $action -ieq "get" ){
	Get-Process $processName
}
elseif ( $action -ieq "kill" ){
	Get-Process $processName -ErrorAction SilentlyContinue | Stop-Process
}
else {
	Write-Output "invalid action parameter: $action"
	Write-Output "{get, kill}"
}
