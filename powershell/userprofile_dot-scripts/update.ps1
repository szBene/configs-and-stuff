# updates software using winget

# update winget source data
winget source update

# start updating non-pinned packages
winget upgrade --all

# print pinned packages
Write-Output "`nPinned packages:"
winget upgrade --include-pinned
Write-Output "Update manually through other methods"
