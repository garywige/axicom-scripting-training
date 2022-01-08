# INCLUDES
. ".\Calc-Lib.ps1"

# VARIABLES
$DebugPreference = 'Continue' #'SilentlyContinue' to turn off debugging
$title = "<<< PowerShell Calculator v1.0 >>>"

# PROGRAM LOGIC
# print title
printWithPadding($title)

# prompt user for desired operation
$Operation = infiniteLoop({
    [Operation](Read-Host "Addition, Subtraction, Multiplication, or Division")
})

Write-Debug "Operation = $Operation"

# get value for x
$x = getValueFor("x")

# get value for y
$y = getValueFor("y")

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