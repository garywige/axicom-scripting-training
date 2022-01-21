# accept arguments
param (
    [string]$Source = "", 
    [string]$Destination = "",
    [string]$Mode = ""
)

$DebugPreference = "Continue"

# functions etc
$title  = "`t %%%%%%%%%%%%%%%%`r`n"
$title += "`t %              %`r`n"
$title += "`t %  Power Copy  %`r`n"
$title += "`t %              %`r`n" 
$title += "`t %%%%%%%%%%%%%%%%`r`n"
$title += "`r`n"
$title += "`t Powered by AXICOM"

$script:filesCopied = 0

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

function dirExists([string]$dir){
    return Test-Path -Path $dir
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

function copyItem([string]$Source, [string]$Destination){
    Write-Output "Copy item: $Source`r`n`tDestination: $Destination"
    Copy-Item -Path $Source -Destination $Destination -Force
    $script:filesCopied++
}

function copyItems([System.IO.DirectoryInfo]$Source, [System.IO.DirectoryInfo]$Destination){

    # foreach item in source
    foreach($item in (Get-ChildItem -Path $Source)) {

        # if item is file
        if($item.GetType().Name -eq "FileInfo"){

            $itemPath = "$($Destination.FullName)\$($item.Name)"

            # copy depending on mode
            switch($Mode){
                OverwriteAll {
                    copyItem -Source $item.FullName -Destination $Destination
                }

                OverwriteNone {
                    if(Test-Path $itemPath ) {
                        Write-Output "Skipping item: $($item.FullName)"
                    } else {
                        # copy the item
                        copyItem -Source $item.FullName -Destination $Destination
                    }
                }

                OverwriteOld {
                    $itemNew = New-Object -TypeName "System.IO.FileInfo" -ArgumentList @($itemPath)
                    
                    if()
                }

                default {
                    throw "Not supported"
                }
            }
        }
        # else (dir)
        else {
            # create directory in destination
            $dirNew = "$($Destination.FullName)\$($item.Name)"
            if(!(dirExists $dirNew )){
                # create directory
                Write-Output "New directory: $dirNew"
                New-Item -Path $Destination.FullName -Name $item.Name -ItemType "directory" | Out-Null
            }

            # recurse
            copyItems -Source $item.FullName -Destination $dirNew
        }
    }
}

# print title
printPadding $title

# prompt for source (if not specified by argument)
if($Source -eq "" -or !(dirExists $Source)) {
    # prompt
    $Source = promptFolder "Select Source Directory"
}

printPadding "Source:`r`n`t$Source"

# prompt for destination (if not specified by argument)
if($Destination -eq "" -or !(dirExists $Destination)) {
    # prompt
    $Destination = promptFolder "Select Destination Directory"
} 

printPadding "Destination:`r`n`t$Destination"

# prompt for copy mode (if not specified by argument)

if($Mode -eq "" -or !(isModeString $Mode)) {
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

$Mode = [Mode]$Mode
printPadding "Mode:`r`n`t$Mode"

# business logic
copyItems -Source $Source -Destination $Destination

# final output
# TODO: implement file counter
printPadding -str "$script:filesCopied file(s) copied successfully!" -padding 2