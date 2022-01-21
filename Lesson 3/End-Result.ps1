# accept arguments
param (
    [string]$Source = "", 
    [string]$Destination = "",
    [string]$Mode = ""
)

# functions etc
$title  = "`t %%%%%%%%%%%%%%%%`r`n"
$title += "`t %              %`r`n"
$title += "`t %  Power Copy  %`r`n"
$title += "`t %              %`r`n" 
$title += "`t %%%%%%%%%%%%%%%%`r`n"
$title += "`r`n"
$title += "`t Powered by AXICOM"


function printPadding($str, $padding = 1){
    for($i = 0; $i -lt $padding; $i++){
        Write-Output ""
    }

    Write-Output $str

    for($i = 0; $i -lt $padding; $i++){
        Write-Output ""
    }
}

function promptFolder($description = "Select a folder"){
    [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null

    $dirName = New-object System.Windows.Forms.FolderBrowserDialog
    $dirName.Description = $description
    $dirName.RootFolder = "MyComputer"
    $dirName.SelectedPath = ""

    if($dirName.ShowDialog() -eq "OK"){
        return $dirName.SelectedPath
    }
    else {
        return $null
    }
}

function dirExists($dir){
    return Test-Path -Path $dir
}

function isModeString($str){
    switch($str){
        "OverwriteAll" {
            return $true
        }

        "OverwriteNone" {
            return $true
        }

        "OverwriteOld" {
            return $true
        }

        default {
            return $false
        }
    }
}

enum Mode {
    OverwriteAll
    OverwriteNone
    OverwriteOld
}

# print title
printPadding($title)

# prompt for source (if not specified by argument)
if($Source -eq "" -or !(dirExists($Source))) {
    # prompt
    $Source = promptFolder("Select Source Directory")
}

Write-Output "Source: $Source"

# prompt for destination (if not specified by argument)
if($Destination -eq "" -or !(dirExists($Destination))) {
    # prompt
    $Destination = promptFolder("Select Destination Directory")
} 

Write-Output "Destination: $Destination"

# prompt for copy mode (if not specified by argument)

if($Mode -eq "" -or !(isModeString($Mode))) {
    # prompt
    Write-Output "Modes: OverwriteAll, OverwriteNone, OverwriteOld"
    $Mode = ""

    while($Mode -eq ""){
        try{
            $Mode = [Mode](Read-Host "Please enter mode")
        } catch {
            # do nothing
        }
    }
} 

Write-output "Mode: $Mode"

# business logic

# final output