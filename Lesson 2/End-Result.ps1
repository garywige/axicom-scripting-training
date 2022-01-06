# Goals:
# - teach the value of reusable code by producing a library

# VARIABLES
$DebugPreference = 'SilentlyContinue' #'Continue'

$Operation = 0
$result = -1
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

function printWithPadding($content){
    Write-Output ""
    Write-Output $content
    Write-Output ""
}

# PROGRAM LOGIC
# print title
printWithPadding($title)

# prompt user for desired operation
Write-Output "Supported Operations: Addition, Subtraction, Multiplication, Division"
while($true){
    $in = Read-Host "Please enter which operation to perform"

    try {
        $Operation = [Operation]$in
        $break

    } catch{
        Write-Output "Please enter one of the 4 options: Addition, Subtraction, Multiplication, Division"
    }
}
Write-Debug "Operation = $Operation"

# get value for x
$x = getValueFor("x")
Write-Debug "x = $x"

# get value for y
$y = getValueFor("y")
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
    default {
        throw "only these operations are supported: addition, subtraction, multiplication, division."
    }
}
Write-Debug "result = $result, opString = $opString"

# output result
printWithPadding("Result: $x $opString $y = $result")