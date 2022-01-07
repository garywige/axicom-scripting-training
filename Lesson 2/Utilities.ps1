# TOOLBOX
enum Operation {
    Addition
    Subtraction
    Multiplication
    Division
}

function infiniteLoop($callback){
    while($true){
        try {
            $out = &$callback
        } catch {           

            continue
        }

        break
    }

    return $out
}

function getValueFor($varname) {

    $out = infiniteLoop({
        return [int]::Parse((Read-Host "Please enter value for $varname"))
    })

    Write-Debug "$varname = $out, type = $($out.GetType().Name)"

    return $out
}

function printWithPadding($content){
    Write-Output ""
    Write-Output $content
    Write-Output ""
}
