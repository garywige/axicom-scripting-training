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

# functions
function script:pad([int]$padding){
    $i = 0;
    while($i++ -lt $padding){
        Write-Host ""
    }
}

function script:printPadding([string]$str, [int]$padding = 1){
    script:pad $padding
    Write-Host $str
    script:pad $padding
}

# classes
class IPAddress : System.IComparable {
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

    [int]CompareTo([object]$rhs){

        # iterate through each octet
        for($i = 0; $i -lt $this.Octets.Count; $i++){

            # if any octet isn't equal
            if($this.Octets[$i] -ne ([IPAddress]$rhs).Octets[$i]){

                # which one is greater
                return $this.Octets[$i] -gt ([IPAddress]$rhs).Octets[$i] ? 1 : -1
            }
        }

        # octets are equal
        return 0
    }

    static [Boolean]isValidIP([string]$str){
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

    static [void]Prompt([ref]$ip, [string]$name){
        while(!([IPAddress]::isValidIP($ip.Value))){
            $ip.Value = Read-Host "Enter $name"
        }
    
        $ip.Value = [IPAddress]::new($ip.Value)
    
        script:printPadding "$($name):`r`n`t$($ip.Value)"
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

            <#
                If this octet's value is equal with $start.Octets[0], then the next octet must have a minimum value of $start.Octets[1]. 
                Otherwise, the minimum is 0.

                Likewise, if this octet's value is equal with $end.Octets[0], then the next octet of this IP address must also have a 
                maximum value of $end.Octets[1]. Otherwise, the maximum value of that octet is 254.
            #>
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

    static [void]Output([Test[]]$tests, [string]$savePath){
        script:printPadding "These IP addresses are alive:"
        $output = ""
        $passed = $tests.Where({$_.isSuccess})
        foreach($test in $passed){
            $output += "$test`r`n"
        }

        Write-Host $output
        $output | Out-File -Path $savePath
    }
}

<#
    ENTRY POINT
#>
# print title
printPadding $title 2

# prompt user for start IP address
[IPAddress]::Prompt(([ref]$StartIP), "Start IP")

# prompt for end IP address
[IPAddress]::Prompt(([ref]$EndIP), "End IP")

# validate that end IP address comes after start IP address
if(!(([IPAddress]$EndIP) -gt $StartIP)){
    Write-Error "End IP must come after Start IP, ending program..."
}

# generate tests
$Tests = [Test]::GenerateTests($StartIP, $EndIP) 

# start the tests
$Tests.ForEach({
    $_.Run()
})

# output the result
[Test]::Output($Tests, $OutputPath)