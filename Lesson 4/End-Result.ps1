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

    static [Test[]] GenerateTests([IPAddress]$start, [IPAddress]$end) {
        # Calculate the number of tests we need
        $testCount = ($end.Octets[0] - $start.Octets[0]) * [Math]::Pow(255, 3)
        $testCount += ($end.Octets[1] - $start.Octets[1]) * [Math]::Pow(255, 2)
        $testCount += ($end.Octets[2] - $start.Octets[2]) * 255
        $testCount += $end.Octets[3] - $start.Octets[3] + 1

        # generate a test for each IP
        $tests = [Test[]]::new($testCount)
        [int]$selector = 0
        for([Byte]$i = $start.Octets[0]; $i -le $end.Octets[0]; $i++){

            $jStart = $i -eq $start.Octets[0] ? $start.Octets[1] : 0
            $jEnd = $i -eq $end.Octets[0] ? $end.Octets[1] : 254

            for([Byte]$j = $jStart; $j -le $jEnd; $j++){

                $kStart = $j -eq $start.Octets[1] ? $start.Octets[2] : 0
                $kEnd = $j -eq $end.Octets[1] ? $end.Octets[2] : 254

                for([Byte]$k = $kStart; $k -le $kEnd; $k++){
            
                    $lStart = $k -eq $start.Octets[2] ? $start.Octets[3] : 0
                    $lEnd = $k -eq $end.Octets[2] ? $end.Octets[3] : 254

                    for([Byte]$l = $lStart; $l -le $lEnd; $l++){
                
                        $ipNew = [IPAddress]::new([Byte[]]@($i, $j, $k, $l))
                        $tests[$selector++] = [Test]::new($ipNew)
                    }
                }
            }
        }

        return $tests
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
if(!(([IPAddress]$EndIP).GreaterThan($StartIP))){
    Write-Error "End IP must come after Start IP, ending program..."
}

# generate tests
$Tests = [Test]::GenerateTests($StartIP, $EndIP) 

# start the tests
$Tests.ForEach({
    $_.Run()
})

# output the result
printPadding "These IP addresses are alive:"
$output = ""
$passed = $Tests.Where({$_.isSuccess})
foreach($test in $passed){
    $output += "$test`r`n"
}

Write-Host $output
$output | Out-File -Path $OutputPath