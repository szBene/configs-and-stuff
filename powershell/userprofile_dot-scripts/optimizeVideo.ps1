# optimize video without changing framerate and resolution

param($video, $outputName, $quality="high")

$crf = switch ($quality){
	'ultrahigh'	{ 0 }
	'extrahigh'	{ 10 }
	'high' { 20 }
	'medium' { 28 }
	'low' { 32 }
	'extralow' { 36 }
}

Write-Output "Optimizing $video to $quality ($crf). The output will be saved as '$outputName'"

ffmpeg -i $video -vcodec libx265 -crf $crf "$outputName"
