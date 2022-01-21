$title = "=> Variable Addition 1.0 <="

#functions
function getValueFor($varname) {
    return [int](Read-host "Please enter value for $varname")
}

function printWithPadding($content){
    Write-Output ""
    Write-Output $content
    Write-Output ""
}

# print the title
printWithPadding $title

# get value for X from user
$x = getValueFor "x"

# get value for Y from user
$y = getValueFor "y"

# do business logic
$result = $x + $y

# output result
printWithPadding "Result: $x + $y = $result"
