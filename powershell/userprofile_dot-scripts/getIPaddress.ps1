# get IP address

param($IPmode=4, $ReturnMode="p")

# unchange parameters, allows to change only one
if ($IPmode -eq "-") { $IPmode = 4 }
if ($ReturnMode -eq "-") { $ReturnMode = "p"}

# check if parameters are valid (todo: better value check)
if (( $IPmode -eq 4 -or $IPmode -eq "a" ) -and
	( $ReturnMode -eq "p" -or $ReturnMode -eq "r" ))
{

# this needs to be false when offline, if the return value is used
switch ($IPmode) {
	4 {	
		$IPaddress
		try { $IPaddress = (Invoke-WebRequest https://ifconfig.me/ip).Content }
		catch { $IPaddress = $false }
		# finally
		if ($ReturnMode -eq "r") { return $IPaddress } else {
			Write-Host "IPv4 address: $(if ($IPaddress) {$IPaddress} else {'N/A'})"
		}
	}
	"a" { ipconfig /all }
}

} # parameter validity 
# if any of them are invalid
else {
	Write-Host "One or more parameters are incorrect. Use:"
	Write-Host "getIPaddress <ip version> <scope> <return mode>"
	Write-Host "IP version: {4, 6}              (default: 4)"
	Write-Host "Scope: {public, local}          (default: public)"
	Write-Host "Return mode: {print, return}    (default: print)"
}
