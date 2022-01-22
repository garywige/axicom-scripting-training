# Lesson 3

## Introduction

In the last lesson, you learned a lot of new PowerShell tools you can use to control the flow of your scripts. In this lesson, we are going to apply what we've learned to create a practical example. By the end of this lesson, you will have constructed a script that copies a source directory chosen by the user to a destination directory also chosen by the user. It will also offer 3 different modes that can be used for different scenarios: OverwriteAll, OverwriteNone, and OverwriteOld. You will find that this script will be much more resilient than the original one you created.

## Planning

Before writing any lines of code, it's important to spend a bit of time in the design phase. First, we identify the problem that we want to solve. *We'd like to copy the entire file contents from one folder to another on the same PC.* What are the features that are most important to us? Sometimes, overwriting the entire destination is desired, but I think having the *safe* options of only overwriting older files, and not overwriting anything are a huge improvement over only having one mode. They are fairly easy to implement as well. In general, when writing a new application, you want to keep the initial feature list as small as possible to simplify implementation. Additional features can be added in increments later on. 

With the initial feature list in hand, you may need to do some quick initial research to make sure what you want to do is actually possible. For this project, our main challenges are being able to copy those files and implementing the 3 modes we want to support. A little bit of googling and you will find that there is a PowerShell cmdlet that can be used for the copying named `Copy-Item`. If you run `Get-Help Copy-Item` in a PowerShell window, you will be presented with a syntax guide and a description of the tool. This can absolutely accomplish our main item of copying a file. And how can we get the list of files to copy in the first place? `Get-ChildItem` is the tool we'll be using for that (which is what `dir` is an alias for). 

But, what about our other features? If you examine the `Get-Help Copy-Item` output, you will see that it has a `-Force` parameter that we can use for our OverwriteAll mode. Boom, that's 2 features down, and 2 to go. How about OverwriteNone? We would need a way to test if a file exists or not. Googling "powershell test if file exists" will quickly bring up pages referencing `Test-Path`, which does exactly what we want. 

One more to go. How do we implement OverwriteOld? We would need a way to compare the modified dates on files. That sounds complicated! If you do some research on how to find file modified dates in PowerShell, you will probably find a lot of people recommending the `Get-Item` cmdlet. This is similary to the `Get-ChildItem` cmdlet and it appears to output the same *type* of data. And what *type* is that exactly? Let's find out! Open up a PowerShell Window and type this in:

```
$item = Get-Item .\
```

We now have a variable *$item* that contains the object returned. Now, here's another useful one that you're going to want to write down:

```
$item | Get-Member
```

At the top of the output, you can see the type is "System.IO.DirectoryInfo". Oh, that's because we did that on a *directory*. Now try running that `$item = Get-Item ...` again but with a file as the last parameter. After running the `Get-Member` cmdlet on that one, you will find the type is "System.IO.FileInfo". Below that is a lot of useful info. If you Google that type name, you will find the Microsoft documentation that contains the same info about methods and properties, and additional info that we will need later on. In particular, there is a very useful property we can use named "LastWriteTime". Bingo, there's our answer to our last feature. The type returned by LastWriteTime is *DateTime*, which supports comparison using the -lt & -gt operators.

Once you have an idea of what your script needs to do, you can then begin building a scaffolding to your script in the form of comments. I've done this for you in the *Start-Here.ps1* script.

```
# script arguments
# functions etc

<#
    ENTRY POINT
#>

# print title
# prompt for source (if not specified by argument)
# prompt for destination (if not specified by argument)
# prompt for copy mode (if not specified by argument)
# copy the data
# final output
```

## Escape Characters

Generally, I like to write apps similar to the way I put a 1000 piece puzzle together. I start with the easy stuff and work my way in to the challenging parts. Let's go ahead and set our title. Go ahead and type this out right below `# functions etc`:

```
$title  = "`t Power Copy`r`n`t Powered by AXICOM"
```

You can use the backtick character '\`' to indicate mark an **escape character**. Escape characters are special characters used in strings used to represent things that aren't alphanumeric, like tabs, return characters, beep noises (hey, never know when you'll need it) and other things you may need in a string. Escaping 't' will result in a tab character, giving us a little margin on the left, or making certain text stand out from other text. I usually need to escape 'r' and 'n' in combination to represent a return carriage and newline. Now that you understand how escape characters work, let's improve on this.

## String Concatenation

Go ahead and replace the line with the title initialization with the following:

```
$title  = "`t %%%%%%%%%%%%%%%%`r`n"
$title += "`t %              %`r`n"
$title += "`t %  Power Copy  %`r`n"
$title += "`t %              %`r`n" 
$title += "`t %%%%%%%%%%%%%%%%`r`n"
$title += "`r`n"
$title += "`t Powered by AXICOM"
```

As you can see, we've made liberal use of escape characters here, but also broken up the title initialization into several lines using the **addition assignment operator** '+='. The operator works by adding the right hand value to the value stored in the variable, and then storing the result back in the variable on the left side of the operator. This allows us to make multi-line strings and to be able to do so without having turn our heads sideways to look at it. 

Right underneath our *$title* variable, you can type in the following code:

```
function printPadding([string]$str, [int]$padding = 1){
    for($i = 0; $i -lt $padding; $i++){
        Write-Output ""
    }

    Write-Output $str

    for($i = 0; $i -lt $padding; $i++){
        Write-Output ""
    }
}
```

We're making a more flexible version of the **printWithPadding** function from Lesson 1. This time, we have a second parameter that specifies how much padding the user wants above and below the text. We're choosing to be explicit with type here by specifying the type before the variable name with `[string]` and `[int]`. Doing so makes our intention clear and helps avoid bugs in the app. You can see that our second variable is assigned 1 in the parameter list. This is called a **default value**. If the caller of the function doesn't provide this parameter during the call, the default value of 1 is used. If you use default values in your function declarations, they always must be at the end of the parameter list. You should notice that we used **for loops** for the padding. We could have used **while loops** if we wanted to. Since a temporary variable is involved in tracking the iterations, a **for loop** seemed like the most appropriate choice for this.

With our new function in hand, you may implement the first section below the entry point:

```
# print title
printPadding $title
```

Go ahead and test your script before continuing.

## Write-Debug

Right underneath our *$title* variable, enter this in:

```
$DebugPreference = "Continue"
```

*$DebugPreference* is called a **Preference Variable**, which can be used to change settings in the PowerShell environment. Here, we are replacing the default value of "SilentlyContinue" with "Continue" so that we may write useful debug info to the screen in bright yellow. This is a useful tool for testing your script as you write it. Throughout your scripting, you can use `Write-Debug` to write development messages to the screen that you feel are helpful. Once you're done writing the script, you can just set the value of *$DebugPreference* to "SilentlyContinue" to hide the text from the users of your script.

## Script Parameters

At the top of the script, type this in:

```
# script arguments
param (
    [string]$Source = "", 
    [string]$Destination = "",
    [string]$Mode = ""
)
```

These will allow the user of the script to specify parameters when running the script, like `.\End-Result.ps1 -Source "C:\Source" -Destination "C:\Destination" -Mode "OverwriteOld"` . If you need to repeatedly run the script for testing, this can save quite a bit of time. Let's now add some code to the next section underneath where the title is printed:

```
# prompt for source (if not specified by argument)
while($Source -eq "") {
    # prompt
    $Source = Read-Host "Select Source Directory"
}

printPadding "Selected Source:`r`n`t$Source"
```

The code checks for an empty string in case a value was specified as a script parameter. This is great, but it's not very resilient. If the user accidently mistypes the path, the script will happily continue and likely fail. Any time user input is involved, it's a good idea to **validate** the input and make sure that what was entered is not going to cause a bug in your app. This is just plain old good UX (user experience) design. Let's encapsulate our `Test-Path` cmdlet that we discussed earlier and use that here to make this more resilient. Underneath your **printPadding** function, declare this new one:

```
function pathExists([string]$path){
    return Test-Path -Path $path
}
```

Our new function is just a wrapper for `Test-Path`. In my opinion, this helps make the code more readable. If you wanted to, you could use `Test-Path $item` instead of `pathExists $item`, it doesn't affect the end result. This is a DX (developer experience) enhancement, and it's sole function is to make developing the script a little bit easier to think about. Now you may edit the while loop like so:

```
while($Source -eq "" -or !(pathExists $Source)) { 
    <code omitted>
}
```

Now, we are validating whether the path exists before continuing, which offers the user a chance to correct mistakes and avoids bugs.

## New-Object

It's great that our script is more resilient, but what if our users aren't very fast typers? They will probably loathe using our script. What if we could add a traditional folder selection dialog to our script without too much hassle? Does that sound like science fiction? I know I said we didn't want to add too many features at the beginning, but this is actually an easy one to add and it's a nice enhancement to the UX in my opinion. If you did some googling on "powershell folder dialog", you will likely come across the **FolderBrowserDialog** that exists in the *System.Windows.Forms* namespace. We don't have to have a perfect understanding of how this works to put it to use. I have copied a code snippet into my own function and modified it slightly to fit our needs:

```
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
```

Much of this code is specific to the FolderBrowserDialog class. We initialize **$dirName** with the `New-Object` cmdlet. This cmdlet can be used to instantiate .NET or COM objects in your PowerShell scripts. So, if you have a feature that you'd like to implement and you find examples of it being implemented in .NET code (C#, Visual Basic, etc.), it's likely that you can do the same thing in a PowerShell script. We set the properties *Description* and *RootFolder* before using the **ShowDialog()** *method* to display the dialog to the user. A *method* is basically a function that is a member of an object and we will learn more about those in another lesson. This method returns "OK" after the user selects a directory and we can use the *SelectedPath* property to grab the path that they have selected. Now that we've implemented this function, let's rewrite our prompt:

```
while($Source -eq "" -or !(pathExists $Source)) {
    # prompt
    $Source = promptFolder "Select Source Directory"
}

printPadding "Selected Source:`r`n`t$Source"
```

And now, we can implement this for the destination as well:

```
# prompt for destination (if not specified by argument)
while($Destination -eq "" -or !(pathExists $Destination)) {
    # prompt
    $Destination = promptFolder "Select Destination Directory"
} 

printPadding "Selected Destination:`r`n`t$Destination"
```

Before continuing, run your script and verify that it functions correctly. If you're using VS Code, you may need to open a separate PowerShell window to test instead of using the built in terminal in order for the dialog to display. 

## Enum

In the next section below our prompt for a destination, we can implement the following:

```
# prompt for copy mode (if not specified by argument)
Write-Output "Supported Modes: OverwriteAll, OverwriteNone, OverwriteOld"

while($Mode -eq "") {
    $Mode = Read-Host "Please enter mode"
} 

printPadding "Selected Mode:`r`n`t$Mode"
```

As long as the string is empty, the user will be asked to enter one of 3 modes. This is a great start, but there is no input validation and this code faces the same problem as the previous two sections. Just below our *$DebugPreference*, enter the following:

```
enum Mode {
    OverwriteAll
    OverwriteNone
    OverwriteOld
}
```

With this, we have created a new *type* named **Mode** that has 3 possible values. Now, let's modify our Mode prompt slightly:

```
while($Mode -eq "") {
    try {
        $Mode = [Mode](Read-Host "Please enter mode")
    }
    catch {
        # do nothing
    }
} 
```

We cast the string input to a **Mode**. If the cast fails due to incorrect input, the loop repeats until the user gets it right. This is great, but what if the user enters a mode as a script parameter? Add this function to our function section somewhere below where the enum is declared:

```
function isModeString([string]$str){
    try {
        [Mode]$str
    } catch {
        return $false
    }

    return $true
}
```

This function verifies whether a string can be converted to a Mode in the same way we implemented the last section, using a try/catch block. Now, let's modify our while loop:

```
while($Mode -eq "" -or !(isModeString $Mode)) {
    <code omitted>
}
```

Just in case we have the mode from the script parameter, we would like to reinitialize this variable so that it is our new **Mode** type rather than a string:

```
# cast to Mode incase this was passed in as a script argument
$Mode = [Mode]$Mode
printPadding "Selected Mode:`r`n`t$Mode"
```

## Variable Scope

## Recursive Functions

## Code Refactoring

## Conclusion

