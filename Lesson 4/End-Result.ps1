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
        for($i = 0; $i -lt 4; $i++){
            $this.Octets[$i] = [Byte]$parts[$i]
        }
    }

    IPAddress([Byte[]]$ip){
        for($i = 0; $i -lt 4; $i++){
            $this.Octets[$i] = $ip[$i]
        }
    }

    [string]ToString(){
        return ("{0}.{1}.{2}.{3}" -f $this.Octets[0], $this.Octets[1], $this.Octets[2], $this.Octets[3])
    }

    [Boolean]GreaterThan([IPAddress]$rhvalue){

        [Boolean]$isGt = $false
        [Boolean]$isLt = $false
    
        for($i = 0; $i -lt $this.Octets.Count; $i++){

            # check if any octets are less than the other
            $isLt = $this.Octets[$i] -lt $rhvalue.Octets[$i]

            # now check to verify if any octets are greater than the other
            $isGt = $this.Octets[$i] -gt $rhvalue.Octets[$i]

            if($isLt -or $isGt){
                break
            }
        }

        # if the octets are equal, return false
        return $isGt
    }
}

class Test {
    [IPAddress]$ip
    [Boolean]$isSuccess

    Test([IPAddress]$ip){
        $this.ip = $ip
    }

    [void]Run(){
        $result = Test-Connection -TargetName $this.ip.ToString() -IPv4 -Count 1 -TimeoutSeconds 1
        $this.isSuccess = $result.Status -eq "Success"
        Write-Host "$($this): $($this.isSuccess ? "PASS" : "FAIL")"
    }

    [string]ToString(){
        return $this.ip
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

# Calculate the number of tests we need
$testCount = ($EndIP.Octets[0] - $StartIP.Octets[0]) * [Math]::Pow(255, 3)
$testCount += ($EndIP.Octets[1] - $StartIP.Octets[1]) * [Math]::Pow(255, 2)
$testCount += ($EndIP.Octets[2] - $StartIP.Octets[2]) * 255
$testCount += $EndIP.Octets[3] - $StartIP.Octets[3] + 1

# Create array of tests for each IP in the range
[Test[]]$Tests = [Test[]]::new($testCount)
[int]$selector = 0
for([Byte]$i = $StartIP.Octets[0]; $i -le $EndIP.Octets[0]; $i++){

    $jStart = $i -eq $StartIP.Octets[0] ? $StartIP.Octets[1] : 0
    $jEnd = $i -eq $EndIP.Octets[0] ? $EndIP.Octets[1] : 254

    for([Byte]$j = $jStart; $j -le $jEnd; $j++){

        $kStart = $j -eq $StartIP.Octets[1] ? $StartIP.Octets[2] : 0
        $kEnd = $j -eq $EndIP.Octets[1] ? $EndIP.Octets[2] : 254

        for([Byte]$k = $kStart; $k -le $kEnd; $k++){
            
            $lStart = $k -eq $StartIP.Octets[2] ? $StartIP.Octets[3] : 0
            $lEnd = $k -eq $EndIP.Octets[2] ? $EndIP.Octets[3] : 254

            for([Byte]$l = $lStart; $l -le $lEnd; $l++){
                
                $ipNew = [IPAddress]::new([Byte[]]@($i, $j, $k, $l))
                $Tests[$selector++] = [Test]::new($ipNew)
            }
        }
    }
}

# start the tests
foreach($test in $Tests){
    $test.Run()
}

# output the result
printPadding "These IP addresses are alive:"
$output = ""
$passed = $Tests.Where({$_.isSuccess})
foreach($test in $passed){
    $output += "$test`r`n"
}

Write-Host $output
$output | Out-File -Path $OutputPath