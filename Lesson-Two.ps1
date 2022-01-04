# VARIABLES
$DebugPreference = 'SilentlyContinue' #'Continue'

$isValid = $false
$Operation = 0
$result = -1
$opString = ""
$title = "<<< PowerShell Calculator v1.0 >>>"

# TOOLBOX
enum Operation {
    Addition
    Subtraction
    Multiplication
    Division
}

function getValueFor($varname) {
    while($true){
        try{
            return [int]::Parse((Read-host "Please enter value for $varname"))
        } catch {
            # don't need to do anything other than repeat
        }
    }
}

# PROGRAM LOGIC
# print title
Write-Output ""
Write-Output $title
Write-Output ""

# prompt user for desired operation
Write-Output "Supported Operations: Addition, Subtraction, Multiplication, Division"
while($isValid -eq $false){
    $input = Read-Host "Please enter which operation to perform"

    try {
        $Operation = [Operation]$input
        $isValid = $true

    } catch{
        Write-Output "Please enter one of the 4 options: Addition, Subtraction, Multiplication, Division"
    }
}
Write-Debug "Operation = $Operation"

# get value for x
[int]$x = getValueFor("x")
Write-Debug "x = $x"

# get value for y
[int]$y = getValueFor("y")
Write-Debug "y = $y"

# do business logic
switch($Operation){
    Addition {
        $result = $x + $y
        $opString = "+"
    }
    Subtraction {
        $result = $x - $y
        $opString = "-"
    }
    Multiplication{
        $result = $x * $y
        $opString = "x"
    }
    Division {
        $result = $x / $y
        $opString = "/"
    }
}
Write-Debug "result = $result, opString = $opString"

# output result
Write-Output ""
Write-Output "Result: $x $opString $y = $result"