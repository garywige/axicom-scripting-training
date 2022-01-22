# script arguments
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

$DebugPreference = "Continue"

enum Mode {
    OverwriteAll
    OverwriteNone
    OverwriteOld
}

function printPadding([string]$str, [int]$padding = 1){
    for($i = 0; $i -lt $padding; $i++){
        Write-Output ""
    }

    Write-Output $str

    for($i = 0; $i -lt $padding; $i++){
        Write-Output ""
    }
}

function promptFolder([string]$description = "Select a folder"){
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

function pathExists([string]$path){
    return Test-Path -Path $path
}

function isModeString([string]$str){
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


$script:filesCopied = 0
function copyItem([string]$Source, [string]$Destination){
    Write-Output "Copy item: $Source`r`n`tDestination: $Destination"
    Copy-Item -Path $Source -Destination $Destination -Force
    $script:filesCopied++
}

function copyItems([System.IO.DirectoryInfo]$Source, [System.IO.DirectoryInfo]$Destination){

    # foreach item in source
    foreach($item in (Get-ChildItem -Path $Source)) {

        $itemDest = "$($Destination.FullName)\$($item.Name)"

        # if item is file
        if($item.GetType().Name -eq "FileInfo"){

            # copy depending on mode
            switch($Mode){
                OverwriteAll {
                    copyItem -Source $item.FullName -Destination $Destination
                }

                OverwriteNone {
                    if(pathExists $itemDest ) {
                        Write-Output "Skipping item: $($item.FullName)"
                    } else {
                        # copy the item
                        copyItem -Source $item.FullName -Destination $Destination
                    }
                }

                OverwriteOld {
                    $itemNew = New-Object -TypeName "System.IO.FileInfo" -ArgumentList @($itemDest)

                    if(!(pathExists $itemDest) -or ($item.LastWriteTime -gt $itemNew.LastWriteTime)){
                        copyItem -Source $item.FullName -Destination $Destination
                    }
                    else{
                        Write-Output "Skipping item: $($item.FullName)"
                    }
                }

                default {
                    throw "Not supported"
                }
            }
        }
        # else (dir)
        else {
            # create directory in destination
            if(!(pathExists $itemDest )){
                # create directory
                Write-Output "New directory: $itemDest"
                New-Item -Path $Destination.FullName -Name $item.Name -ItemType "directory" | Out-Null
            }

            # recurse
            copyItems -Source $item.FullName -Destination $itemDest
        }
    }
}

<#
    ENTRY POINT
#>

# print title
printPadding $title

# prompt for source (if not specified by argument)
while($Source -eq "" -or !(pathExists $Source)) {
    # prompt
    $Source = promptFolder "Select Source Directory"
}

printPadding "Selected Source:`r`n`t$Source"

# prompt for destination (if not specified by argument)
while($Destination -eq "" -or !(pathExists $Destination)) {
    # prompt
    $Destination = promptFolder "Select Destination Directory"
} 

printPadding "Selected Destination:`r`n`t$Destination"

# prompt for copy mode (if not specified by argument)
Write-Output "Supported Modes: OverwriteAll, OverwriteNone, OverwriteOld"

while($Mode -eq "" -or !(isModeString $Mode)) {
    try{
        $Mode = [Mode](Read-Host "Please enter mode")
    } catch {
        # do nothing
    }
} 

# cast to Mode incase this was passed in as a script argument
$Mode = [Mode]$Mode
printPadding "Selected Mode:`r`n`t$Mode"

# business logic
copyItems -Source $Source -Destination $Destination

# final output
printPadding -str "$script:filesCopied file(s) copied successfully!" -padding 2