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

function copyItems([System.IO.DirectoryInfo]$Source, [System.IO.DirectoryInfo]$Dest){

    # foreach item in source
    foreach($item in (Get-ChildItem -Path $Source)) {

        # if item is file
        if($item.GetType().Name -eq "FileInfo"){

            # copy depending on mode
            switch($Mode){
                OverwriteAll {
                    Write-Output "$item : Overwriting all!"
                }

                OverwriteNone {
                    Write-Output "$item : Overwriting nothing!"
                }

                OverwriteOld {
                    Write-Output "$item : Overwriting old stuff!"
                }

                default {
                    throw "Not supported"
                }
            }
        }
        # else (dir)
        else {
            # create directory in destination
            $dirNew = "$($Dest.FullName)\$($item.Name)"
            if(!(dirExists $dirNew )){
                # create directory
                New-Item -Path $Dest.FullName -Name $item.Name -ItemType "directory"
            }

            # recurse
            copyItems -Source $item.FullName -Dest $dirNew
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
copyItems -Source $Source -Dest $Destination

# final output
# TODO: implement file counter
printPadding -str "Files copied successfully!" -padding 2