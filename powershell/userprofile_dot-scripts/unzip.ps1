# unzip archive to directory

param($file, $outputDirecotry=".")

# filename, without extension
$fileName = [System.IO.Path]::GetFileNameWithoutExtension($file)
$destinationPath = "."

#check if the output path is VALID
if (Test-Path $outputDirecotry){
	# concat output dir and filename to create a new directory for the extracted conten
	$destinationPath = Join-Path $outputDirecotry -ChildPath $fileName
} else {
	Write-Error "destination path invalid."
	return # todo fix this later
}

# check if destination path EXISTS
if (!(Test-Path $destinationPath)) {
	New-Item -ItemType Directory -Path $destinationPath
}

Write-Output "Extracting $file to $destinationPath"

Expand-Archive -Path $file -DestinationPath $destinationPath
