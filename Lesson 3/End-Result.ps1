# accept arguments
param (
    [string]$Source = "", 
    [string]$Destination = "",
    [string]$Mode = ""
)

# functions etc
$title  = "`t %%%%%%%%%%%%%%%%`r`n"
$title += "`t %              %`r`n"
$title += "`t %  Power Copy  %`r`n"
$title += "`t %              %`r`n" 
$title += "`t %%%%%%%%%%%%%%%%`r`n"
$title += "`r`n"
$title += "`t Powered by AXICOM"


function printPadding($str, $padding = 1){
    for($i = 0; $i -lt $padding; $i++){
        Write-Output ""
    }

    Write-Output $str

    for($i = 0; $i -lt $padding; $i++){
        Write-Output ""
    }
}

# print title
printPadding($title)

# prompt for source (if not specified by argument)
if($Source -eq "") {
    # prompt
} else {
    Write-Output "Source: $Source"
}

# prompt for destination (if not specified by argument)
if($Destination -eq "") {
    # prompt
} else {
    Write-Output "Destination: $Destination"
}

# prompt for copy mode (if not specified by argument)
if($Mode -eq "") {
    # prompt
} else {
    Write-Output "Mode: $Mode"
}

# Validate parameters
# business logic
# final output