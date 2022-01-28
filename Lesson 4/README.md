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

## IPAddress Class

Alright, so now that you know the basics of classes, go ahead and type this in in our `# classes` section:

```
# classes
class IPAddress {
    [Byte[]]$Octets = [Byte[]]::new(4)

    IPAddress([string]$str){
        $parts = $str.Split('.')
        for($i = 0; $i -lt 4; $i++){
            $this.Octets[$i] = [Byte]$parts[$i]
        }
    }
}
```

We're going to add a lot more features to our new class as we go along. Here, our *IPAddress* class has one single property, named *Octets* that is an array of Bytes. A byte is basically a numeric type that can store values between 0-255, which is perfect for modeling an octet. 

It hasn't been discussed yet, so we'll take a paragraph to explain how to instantiate an array. An array is specified by using the brackets after the name of the type, like `[int[]]` or `[string[]]`. On the right-hand side, we are calling **new** and passing in a parameter that says how many objects will be in our array. In this instance, we need 4 Byte objects to represent an IP address, so we enter 4 in the parameter list. In this instance, we know how many objects we need. But, sometimes you have no idea how many there will be and you'll be passing in a variable instead. 

We could have saved the initialization part (`... = [Byte[]]::new(4)`) for the constructor instead of initializing it outside of the constructor. Either way works, but always remember to initialize it. A good habit to develop is to implement initialization of your properties as soon as they are added to your class, unless you have a very good reason to leave them null. Notice that by the time our constructor is done, all 4 octets in the array are instantiated with their final values, leaving no room for error later on. 

Let's focus our attention on what this constructor is doing now. We are taking a string *str* as a parameter here so that we can easily convert from string to IPAddress after validation. The `[string]` type has a *Split* method that we utilize here. The split method takes a single character as a parameter, which it uses to split up the string into an array of strings. Each '.' in our IP address string will mark where the string gets split at, so we should end up with 4 string representations of numbers. We iterate through the array and cast each string into its final form, storing it in the *Octets* array. Note that this constructor doesn't do any validation. It trusts 100% that the data being passed into it has already been validated. That is important to keep in mind when using this class because it means we need to implement validation outside of the constructor. Notice that we are using the **this** keyword to reference the *Octets* array. In PowerShell, you must use the **this** keyword to reference the class members in the constructors as well as the methods.

## Static Methods

Now, let's add some validation logic to the class. This particular method is going to take a string as a parameter and then it's going to spit out a Boolean value telling us whether its a valid format for an IP address. Since it doesn't need to interact with any class members, but it is certainly related to the `[IPAddress]` type that we're creating, we're going to make it a **static method**. Static methods are like utility functions related to a particular type. Underneath the constructor, put this in:

```
static [Boolean]isValidIP([string]$str){
    throw "not implemented"    
}
```

## Regular Expressions

To validate our IP address string, we need to verify that it follows a particular string pattern. If you think about, an IP address is pretty recognizable when you see one. Every IPv4 address has 3 '.' characters that are seperating numbers that can be any value between 0 and 254 inclusive. Because an IP address has such a recognizable pattern, we can use something called a **regular expression** to test whether it matches that pattern. It doesn't take care of the validation 100%, but at least it will do the hardest part for us. We can use the *split* method to do the rest after we've verified that it actually has the '.' characters the *split* method will depend on. 

Regular expressions are a subject of their own and I won't be going into them in exhaustive detail. You can usually get by with a cheatsheet and some experimentation with a regex tester. I will explain how I came up with the pattern for this script. To start, open [this site](https://www.regextester.com/) up in a separate web browser tab. This can be used to test an expression on a test string. In the section below titled *Test String*, enter `1.12.123.12`. Now, in the top field, enter `\d`. You should see all of the digits highlighted. That's because `\d` matches all digits. Now, modify the top field to be `\d{3}`. You should now only see the 3rd octet highlighted. That's because the `{3}` is communicating that there are 3 consecutive digits. Now, let's make it `\d{1,3}`. All digits are highlighted now. Now we can add the dot by adding `.\` to the very end of the expression. Of course, it does not match the last octet because it is not suffixed by a dot. But, we at least have an expression that matches the first 3 sections and we are going to use this. Now, let's enclose our expression in parenthesis and specify that there are 3 instances of this expression, like so: `(\d{1,3}\.){3}`. You should see the first 3 octets highlighted along with the third dot. Now, we add `\d{1,3}` to the end of that and the whole thing should be highlighted now:

```
(\d{1,3}\.){3}\d{1,3}
```

Okay, that's great, but there is a problem with this that we're not seeing with the test string. Edit your test string so it looks like this: `cat1.12.123.12dog`. You'll notice that the string is still being highlighted because there's a pattern match. This will pass validation, which is not what we want. To fix this problem, we're going to prefix our pattern with '^' and suffix it with '$', which will symbolize the beginning and ending of the string respectively:

```
^(\d{1,3}\.){3}\d{1,3}$
```

Now, it doesn't match our invalid string. If you edit the test string back to what it was, it should now be highlighted. Congratulations, you now know how to construct a regular expression for validation. If you need to construct regular expressions in the future, you can use a cheat sheet like [this one](https://cheatography.com/davechild/cheat-sheets/regular-expressions/) for reference if you need to. You can also see if someone has already constructed the pattern you're looking for, but it's a good idea to test the pattern to make sure it functions like you need it to.

Now that we have a working pattern, we can update our static method to look like this:

```
static [Boolean]isValidIP([string]$str){
    if(!($str -match "^(\d{1,3}\.){3}\d{1,3}$")){
        return $false
    }
    
    return $true
}
```

Okay, now we have some pretty good input validation. But, our user could outsmart this by enter a string like '999.999.999.999' and this method would let it slide. So, we'll add a second validation that splits the string into 4 numbers that can be verified to be between 0 and 254:

```
static [Boolean]isValidIP([string]$str){
    if(!($str -match "^(\d{1,3}\.){3}\d{1,3}$")){
        return $false
    }
    
    $parts = $str.Split('.')
    
    foreach($part in $parts){
        $n = [int]$part
        if($n -gt 254){
            return $false
        }
    }
    
    return $true
}
```

