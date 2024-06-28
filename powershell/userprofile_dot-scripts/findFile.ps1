# find a file in current and subdirectories

param($filename=4, $mode="d")

Get-ChildItem -recurse -filter "*${filename}*" -ErrorAction SilentlyContinue | ForEach-Object {
	if ( $mode -ieq "d" -or $mode -ieq "detailed" ) {
		# detailed version with more info
		$_
	}
	else {
		# only filepaths
		"$_"
	}
}
