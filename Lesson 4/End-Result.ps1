# script parameters
param (
    [string]$StartIP,
    [string]$EndIP,
    [string]$OutputPath = ".\results.txt"
)

# variables
$DebugPreference = "Continue"

$title  = "`t ################`r`n"
$title += "`t #              #`r`n"
$title += "`t #  IP Scanner  #`r`n"
$title += "`t #              #`r`n"
$title += "`t ################`r`n"
$title += "`r`n"
$title += "`t Powered by AXICOM"

# classes
class IPAddress {
    [Byte[]]$Octets = [Byte[]]::new(4)

    IPAddress([string]$str){
        $parts = $str.Split('.')
        for($i = 0; $i -lt $this.Octets.Count; $i++){
            $this.Octets[$i] = [Byte]$parts[$i]
        }
    }

    IPAddress([Byte[]]$ip){
        for($i = 0; $i -lt $this.Octets.Count; $i++){
            $this.Octets[$i] = $ip[$i]
        }
    }

    [string]ToString(){
        return ("{0}.{1}.{2}.{3}" -f $this.Octets[0], $this.Octets[1], $this.Octets[2], $this.Octets[3])
    }

    [Boolean]GreaterThan([IPAddress]$rhvalue){
        # check if any octets are less than the other
        for($i = 0; $i -lt $this.Octets.Count; $i++){
            if($this.Octets[$i] -lt $rhvalue.Octets[$i]){
                return $false
            }
        }

        # now check to verify if any octets are greater than the other
        for($i = 0; $i -lt $this.Octets.Count; $i++){
            if($this.Octets[$i] -gt $rhvalue.Octets[$i]){
                return $true
            }
        }

        # if the octets are equal, return false
        return $false
    }
}

class Test {
    [IPAddress]$ip
    [object]$result

    Test([IPAddress]$ip){
        $this.ip = $ip
    }

    [void]Run(){
        $this.result = Test-Connection -TargetName $this.ip.ToString() -IPv4 -Count 1
    }

    [Boolean]isSuccess(){
        if($null -eq $this.result -or $this.result.Status -ne "Success"){
            return $false
        }

        return $true
    }
}

# functions
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
        if($n -gt 254){
            return $false
        }
    }

    return $true
}

function promptIP([ref]$ip, [string]$name){
    while(!(isValidIP $ip.Value)){
        $ip.Value = Read-Host "Enter $name"
    }

    $ip.Value = [IPAddress]::new($ip.Value)
    
    printPadding "$($name):`r`n`t$($ip.Value)"
}

<#
    ENTRY POINT
#>
# print title
printPadding $title 2

# prompt user for start IP address
promptIP ([ref]$StartIP) "Start IP"

# prompt for end IP address
promptIP ([ref]$EndIP) "End IP"

# validate that end IP address comes after start IP address
if(!($EndIP.GreaterThan($StartIP))){
    Write-Error "End IP must come after Start IP, ending program..."
}

# perform the scan
# output the result