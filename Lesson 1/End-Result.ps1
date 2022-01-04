#functions
function getValueFor($varname) {
    $output = "Please enter value for " + $varname
    return [int](Read-host $output)
}

# get value for X from user
$x = getValueFor("x")

# get value for Y from user
$y = getValueFor("y")

# do business logic
$result = $x + $y

# output result
Write-Output "$x + $y = $result"
