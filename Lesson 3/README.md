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
# business logic
# final output
```

