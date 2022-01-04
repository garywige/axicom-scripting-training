# Lesson 1

For our first project, we will start by creating a simple app that adds two user-provided values together and presents the result back to the user. **End-Result.ps1** contains a working sample of what this lesson will guide you through. To start, please open the **Start-Here.ps1** file.

## Comments

The first scripting tool I will teach you is the **comment**. Comments are typically used to insert text into a script that is not to be executed. Comments are created by prefixing a line in the file with **#** . In the **Start-Here.ps1** file, you can see that we are using comments as pseudocode to give us an overview of what the code should be achieving:

```
# print the title
# get value for X from user
# get value for Y from user
# do business logic
# output result
```

You can also use comments to explain sections of your code that may be difficult for others, or yourself, to understand:

 ```
# assign 'banana' to $var if $x is 360, otherwise assign 'orange'
$var = ($x == 360) ? "banana" : "orange"

 ```

It's generally a good idea to use comments to organize your code to help make your scripts easier to read. I typically start a script kind of how **Start-Here.ps1** is formatted because it helps me to split up the fairly large task of writing a complex document of hundreds of lines of code into smaller tasks that are easier for my tiny little brain to think about.

## Write-Output

As we can see in our **Start-Here.ps1** file, our first challenge is to `# print the title`. In PowerShell, you can output text to the user with `Write-Output <text string>` where `<text string>` represents a string of characters enclosed in either double quotes (") or single quotes ('). Hit return after `# print the title` to insert a new empty line and enter the following:

```
Write-Output "=> Variable Addition 1.0 <="
```

Once you have typed this in, go to the top of the VS Code window, click Run->Start Debugging. You should see "=> Variable Addition 1.0 <=" printed on the terminal output at the bottom of the window. Congratulations, your first line of working code! I could have ended the lesson here, but I think we can cram some more in.

