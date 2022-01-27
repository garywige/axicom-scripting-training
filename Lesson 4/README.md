# Lesson 4

## Introduction

In the previous lesson, you learned how to create a practical script example using the scripting knowledge that you've gained up to this point. In this lesson, you are going to learn about **Classes** and how you can use them to further organize your code. Throughout the lesson, we will be building a new practical script example that scans a specified IP address range with ICMP packets to tell us if there is a device at that IP address or not.

## Script Design

Before we do any coding, it's a good idea for you to familiarize yourself with the design that we've come up with for this one. I won't elaborate on the research that might have gone into this one as you should have a good idea about how to conduct that yourself now when you have to. 

### What do we want our script to do?

1. Print title
2. Prompt user for the beginning of the IP address range that we would like to scan
3. Prompt user for the end of the IP address range that we would like to scan
4. Iterate through each IP address and display whether it is alive or not
5. At the end, display a list of the successful pings
6. Save the results to a text file that can be used for reference later

### What features do we want to implement

- Robust input validation
- Accept input optionally as script parameters
- Optionally specify a different output path for our saved results
- Support for any private IP address range (which is typically a range where at least the first two octets are masked off)

## Let's Begin

Just like previous lessons, we have a *Start-Here.ps1* script that's been prepared with some initial comments for you to start with:

```
# script parameters
# variables
# functions
# classes

<#
    ENTRY POINT
#>
# print title
# prompt user for start IP address
# prompt for end IP address
# validate that end IP address comes after start IP address
# generate tests
# start the tests
# output the result
```

You can go ahead and fill out the first few sections with this:

```
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
function pad([int]$padding){
    $i = 0;
    while($i++ -lt $padding){
        Write-Host ""
    }
}

function printPadding([string]$str, [int]$padding = 1){
    pad $padding
    Write-Host $str
    pad $padding
}
```

And now you are able to print the title:

```
<#
    ENTRY POINT
#>
# print title
printPadding $title 2
```

And that just about summarizes the easy part of this lesson!

## Classes

Our next two sections are charging us to:

```
# prompt user for start IP address
# prompt for end IP address
```

Grabbing the input is simple enough, but we have to validate that the input is an actual IP address. Later on in the script, we will also need to generate IP addresses between the range. This is going to be difficult to do if we are working with strings! We can make this a whole lot easier if we have a way to model an IP address with a type that we can convert our strings to. Behold, the **class**:

```
class MyClass {

    # properties
    [int]$var1
    [int]$var2

    # default constructor
    MyClass(){
        $this.var1 = 0
        $this.var2 = 0
    }

    # method
    myMethod(){
        Write-Host "Hello, World!"
    }
}
```

Above, we have a **class** named *MyClass* that has 2 member variables named *var1* and *var2*. These are commonly referred to as **properties**. The area below the properties is called a **constructor**. A constructor always has the same name as the class. This particular constructor is called a **default constructor** because it doesn't accept any arguments. A constructor gets called when your class is used to create an object, and it's your opportunity to ensure that all properties are initialized. To store an instance of your class in a variable, you would need to call the constructor with the **new** static method like this:

```
$myInstance = [MyClass]::new()
```

Notice that we didn't provide any parameters to **new**. That's only because our constructor doesn't take any parameters. If our constructor takes parameters, we must specify the parameters in the parameter block of the **new** method.

Below our constructor, you see a **method**. A method is basically just a function that is a member of a class. You have been calling methods in previous lessons already, so you should be partially familiar with how to use them. For example, the **GetType** method was used in last lesson to verify that we were working with FileInfo. **GetType** is one method that all .NET classes inherit, along with **ToString**. The latter, you can customize to suit your needs. Customizing an inherited method is called **overriding** and we will be doing some of that in this lesson.