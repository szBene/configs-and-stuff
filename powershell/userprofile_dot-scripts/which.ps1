# find executable/script path

param([string]$name)

Get-Command $name | Select-Object -ExpandProperty Definition
