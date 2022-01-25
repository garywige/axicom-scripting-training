# script parameters
param (
    [string]$StartIP,
    [string]$EndIP
)

# functions, classes, etc
$DebugPreference = "Continue"

$title  = "`t ################`r`n"
$title += "`t #              #`r`n"
$title += "`t #  IP Scanner  #`r`n"
$title += "`t #              #`r`n"
$title += "`t ################`r`n"
$title += "`r`n"
$title += "`t Powered by AXICOM"

function pad([int]$padding){
    $i = 0;
    while($i++ -lt $padding){
        Write-Output ""
    }
}

function printPadding([string]$str, [int]$padding = 1){
    pad $padding
    Write-Output $str
    pad $padding
}

function isValidIP([string]$str){
    if(!($str -match "^(\d{1,3}\.){3}\d{1,3}$")){
        return $false
    }

    $parts = $str.Split('.')

    foreach($part in $parts){
        $n = [int]$part
        if($n -gt 254 -or $n -eq 0){
            return $false
        }
    }

    return $true
}

<#
    ENTRY POINT
#>
# print title
printPadding $title 2

# prompt user for start IP address
while(!(isValidIP $StartIP)){
    $StartIP = Read-Host "Enter start IP address"
}

printPadding "Start IP Address:`r`n`t$StartIP"

# prompt for end IP address
# prompt user for path to save results
# perform the scan
# output the result