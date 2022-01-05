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

## Variables

Before moving onto the next section of the script, I would like to introduce you to the **variable**. Insert the following at the top of the script before all other lines of text:

```
$title = "=> Variable Addition 1.0 <="
```

We are assigning the value of **"=> Variable Addition 1.0 <="** to the variable named **$title**. Variables always begin with a '$' character and they should always be assigned a value before using to avoid errors. Replace the line of code under `# print the title` with the following:

```
Write-Output $title
```
Assigning your string literals at the top of the script like this makes them easier to edit later and saves you from having to sift through possibly hundreds of lines of code. You don't need to put all of your variables at the top, but you should at least put variables at the top that you think you are likely to want to edit later on. Debug your app again to confirm that you get the same output in the terminal as before.

## Read-Host

Our next section is asking us to `# get value for x from user`. In order to get a value from the user, we need to use the `Read-Host` cmdlet to output a prompt and get the user's response after they hit the **Enter** key. We will then assign the input that the user provided to a new variable named "$x". Insert an empty line under `# get value for x from user` and insert the following text in the empty line:

```
$x = Read-Host "Please enter value for x"
```

With a single line of code, you have output "Please enter a value for x: " to the screen, grabbed what the user typed in prior to hitting **Enter**, and assigned that string to $x. For testing, insert the following line of code underneith:

```
Write-Output "x = $x"
```
And hit the Start Debugging button from the Run menu. You should see the value for $x printed in the terminal. Okay, now delete the last line of code that you added because that was just for testing. Later on, I will teach you a better method of outputting development information to the screen that the user doesn't need to see. For now, we'll keep things simple. 

Let's now do the **same thing** for our next section. Go ahead and copy the code we used to assign to $x and paste that directly below `# get value for y from user`. Now, delete 'x' from that line and replace with 'y' so it reads like:

```
$y = Read-Host "Please enter value for y"
```

Now, I will use this opportunity to teach you about something that all programmers should strive for in their code: **minimizing code duplication**. I emphasized to you that we had to do the **same thing** for y that we are doing for x and even had you copy/paste your code into another section of your script because this is a recognizable pattern that you are going to want to watch out for. Okay, that's nice, but how do we resolve the duplicated code?

## Functions

Let's add a new section below our $title variable assignment at the top:

```
# functions
```

Underneith that line, enter the following:

```
function getValueFor($varname){
    return Read-Host "Please enter value for $varname"
}
```

Now, replace the line that assigs $x with the following:

```
$x = getValueFor("x")
```

And let's do the same for $y:

```
$y = getValueFor("y")
```

You may debug your script to confirm that it functions like you expect it to. We have replaced the code with a function named **getValueFor**. While we didn't really save ourselves any typing here, if we need to make any edits to how $x and $y are assigned, we can make that edit for both variables in one place. We will make such an edit later. While we're at it, let's create another function below the one we just created:

```
function printWithPadding($content){
    Write-Output ""
    Write-Output $content
    Write-Output ""
}
```

And replace the line of `Write-Output $title` with `printWithPadding($title)`. Debug to confirm everything is working correctly so far. Now, you probably get the gist of how this works, but let me explain it a little. The code units under the `# functions` section are called **function declarations** and they are where you can give functions a name, like **getValueFor**, give their variables a name between the parenthesis, like **$varname**, and define what the function does between the curly braces. As you can see, we use the **return** keyword to send the output of the **Read-Host** cmdlet back to the user (which is the programmer in this context). Not every function needs to return a value, and we demonstrate that with our **printWithPadding** function. Functions can also have multiple variables seperated by commas, like `functionName($var1, $var2, $var3){return "$var1 $var2 $var3"}`. Also, the previous sentence demonstrates that you could put the whole function on one line **if you really wanted to**. You should avoid doing that in practice because it makes your code hard to read by other programmers. Programmers like conventions. If you ever have the pleasure of sifting through a script you wrote years ago, or having to help another coder with their project, it makes it a lot easier when what you're reading follows a format that you're used to. Don't worry about getting it perfect right off the bat though. It's important at first for you to familiarize yourself with the available tools, and for you to know the appropriate setting in which those tools should be used. Making your code pretty takes time & practice, just like anything.

# Casting

Okay, so the rest of the script should be a breeze at this point, right? It should, but you will learn not to get your hopes up too high as a coder! Let's insert this code underneith `# do business logic`:

```
$result = $x + $y
```

We are adding $x and $y together and assigning the result to $result. Operators like '+' can work on variables depending on their underlying **type** . We are expecting our variables $x and $y to be a number type, but is that really the case? Let's output the result to find out. Enter the following underneith `# output result`:

```
printWithPadding("Result: $x + $y = $result")
```

Click Start Debugging to see the results. Provide input for x and y and verify that the output is what you're expecting. Here's an example of what you should see:

```
Result: 2 + 3 = 23"
```

That's not exactly what we were taught in our math class, was it? The issue is that the data assigned to $x and $y is of the **string** type. We need to make sure the type of the data is of type **int**, which is for whole number integers. 