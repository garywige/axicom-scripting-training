# Lesson 2

For our second lesson, I would like to expand upon the first project and introduce you to some more advanced topics. To get started, go ahead and open the **Calculator.ps1** file in VS Code. You'll see that I put some comments to help you organize your code like the last project. 

## Dot Sourcing

This project is going to require some of the **same things** that the last project required. We're going to use the **printWithPadding** function as well as a beefed-up version of **getValueFor**. Do you recognize a problem? If we want to avoid code duplication, we'd have to borrow those functions from our previous project. Since that would require refactoring our previous project's code, we're going to go ahead and duplicate that code instead. It's only a few lines anyway. But, I will use the opportunity to show you how to save common code snippets in a way that can be shared across multiple scripts so you have the option of saving yourself some typing down the road. It's also generally a good idea to break up large scripts into smaller code units that can be easier to manage. 

To start, go ahead and create a new file in the same folder as the **Calculator.ps1** file you have open and name it **Calc-Lib.ps1**. Actually, you can name it whatever you want as long as it ends with ".ps1". Just please remember what you named it because you're going to have to link that up next. Now in your **Calculator.ps1** file, under `#INCLUDES`, type `. ".\Calc-Lib.ps1"`, but replace **Calc-Lib.ps1** with whatever you named your file. The ".\" part specifies that the file exists in the **current working directory** of whatever is running the script. What does that mean? Well, maybe now is a good time to make sure you understand how to execute these scripts that you're creating.

## Executing PowerShell Scripts

We've spent a good amount of time **writing** a script and even **debugging** the script from within VS Code, but if you are planning on using PowerShell scripts for a profession, then you'd better know how to properly execute them. Open up PowerShell on your PC and wait for the blinking cursor to be after what probably looks like "PS C:\Users\Sally>". That is your "current working directory" for this PowerShell session. If you want to change your current working directory to the location where your script is located, you can use this command, replacing the path with the file path where your script is located:

```
Set-Location C:\MyScripts
```

`cd` is also an alias for `Set-Location`, so you can use that in its place if you prefer classic CMD syntax. Relative paths work too. For instance, if your current working directory is the root of this GitHub project, then running `Set-Location "Lesson 2"` should set the "Lesson 2" subdirectory as your current working directory, without the need to specify the whole path. Why did I surround "Lesson 2" in quotes in the last command? If you are providing a string parameter to a cmdlet, you need to enclose it in quotation marks if it contains a space. If your current working directory is the "Lesson 2" subdirectory, then running `Set-Location "..\Lesson 1"` will take you into the "Lesson 1" subdirectory. The ".." syntax is shorthand for the parent directory. You can use a single dot "." as shorthand for the current directory as said previously and you will need to use that when executing a PowerShell script from the shell:

```
.\Calculator.ps1
```

If you run that from the "Lesson 2" directory in a PowerShell window, it should attempt to execute the script. Note that if you try to run that from the GitHub project root directory with `".\Lesson 2\Calculator.ps1"` after you've dot sourced your library script, it's not going to work correctly. For this reason, you may not be able to break some scripts up into seperate files like the way we're doing here. That's okay, but I'd at least like you to know how to keep your code as organized as possible in case you decide to learn other programming languages that don't have such limitations.

With that out of the way, go ahead and copy/paste these two methods from **Lesson 1** into your library script that you created:

```
function getValueFor($varname) {
    return [int](Read-host "Please enter value for $varname")
}

function printWithPadding($content){
    Write-Output ""
    Write-Output $content
    Write-Output ""
}
```

Go ahead and create a title variable and print it to the screen like we did in **Lesson 1** using the **printWithPadding** function. I'll let you choose what to display for a title.

