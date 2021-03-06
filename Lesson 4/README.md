# Lesson 4

## Introduction

In the previous lesson, you learned how to create a practical script example using the scripting knowledge that you've gained up to this point. In this lesson, you are going to learn about **Classes** and how you can use them to further organize your code. Throughout the lesson, we will be building a new practical script example that scans a specified IP address range with ICMP packets to tell us if there is a device at that IP address or not.

There are some features used in this lesson that are relatively new as of this writing. You should have at least PowerShell version 7.2 LTS installed for this lesson, which you can download [here](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.2)

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

    # another constructor (not default because it takes parameters)
    MyClass($one, $two){
        $this.var1 = $one
        $this.var2 = $two
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

Notice that we didn't provide any parameters to **new**. That's only because our constructor doesn't take any parameters. Below our default constructor is one that takes parameters, and we must specify the parameters in the parameter block of the **new** method if we wish to use this one instead.

Below our constructors, you see a **method**. A method is basically just a function that is a member of a class. You have been calling methods in previous lessons already, so you should be partially familiar with how to use them. For example, the **GetType** method was used in last lesson to verify that we were working with FileInfo. **GetType** is one method that all .NET classes inherit, along with **ToString**. The latter, you can customize to suit your needs. Customizing an inherited method is called **overriding** and we will be doing some of that in this lesson.

## Arrays

Okay, let's go over **arrays** in more detail before we create our first class. An array is a group of one or more objects of a specific type. You can create an array with prepopulated data with an **array literal**:

```
[string[]] $myArray = @("dog", "cat", "hello world", "Hola amigo")
```

You can also create an empty array with a specified number of elements:

```
[string[]] $myArray = [string[]]::new(10)
```

If you would like to read from, or write to, the elements of the array, you can do that like so:

```
$myArray[3] = "my name is Billy"
Write-Host $myArray[3] # "my name is Billy" is output to the console
```

Above you can see we are accessing element 3. This is the 4th element in the array since the array begins with element 0. Sometimes, you need to know how many elements exist in the array. You can get this info from the *Count* property:

```
for($i = 0; $i -lt $myArray.Count; $i++){
    Write-Host $myArray[$i]
}
```

## IPAddress Class

Alright, so now that you know the basics of classes and arrays, go ahead and type this in in our `# classes` section:

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

    IPAddress([Byte[]]$ip){
        for($i = 0; $i -lt 4; $i++){
            $this.Octets[$i] = $ip[$i]
        }
    }

    [string]ToString(){
        return ("{0}.{1}.{2}.{3}" -f $this.Octets[0], $this.Octets[1], $this.Octets[2], $this.Octets[3])
    }
}
```

We're going to add a lot more features to our new class as we go along. Here, our *IPAddress* class has one single property, named *Octets* that is an array of Bytes. A byte is basically a numeric type that can store values between 0-255, which is perfect for modeling an octet. 

We could have saved the initialization of the array (`... = [Byte[]]::new(4)`) for the constructor instead of initializing it outside of the constructor. Either way works, but always remember to initialize it. A good habit to develop is to implement initialization of your properties as soon as they are added to your class, unless you have a very good reason to leave them null. Notice that by the time either of our constructors is done, all 4 octets in the array are instantiated with their final values, leaving no room for error later on. 

Let's focus our attention on what the top constructor is doing now. We are taking a string *str* as a parameter here so that we can easily convert from string to IPAddress after validation. The `[string]` type has a *Split* method that we utilize here. The split method takes a single character as a parameter, which it uses to split up the string into an array of strings. Each '.' in our IP address string will mark where the string gets split at, so we should end up with 4 string representations of numbers. We iterate through the array and cast each string into its final form, storing it in the *Octets* array. Note that this constructor doesn't do any validation. It trusts 100% that the data being passed into it has already been validated. That is important to keep in mind when using this class because it means we need to implement validation outside of the constructor. Notice that we are using the **this** keyword to reference the *Octets* array. In PowerShell, you must use the **this** keyword to reference the class members in the constructors as well as the methods.

## Static Methods

Now, let's add some validation logic to the class. This particular method is going to take a string as a parameter and then it's going to spit out a Boolean value telling us whether it's a valid format for an IP address. Since it doesn't need to interact with any class members, but it is certainly related to the `[IPAddress]` type that we're creating, we're going to make it a **static method**. Static methods are like utility functions related to a particular type. Underneath the constructors, put this in:

```
static [Boolean]isValidIP([string]$str){
    throw "not implemented"    
}
```

## Regular Expressions

To validate our IP address string, we need to verify that it follows a particular string pattern. If you think about it, an IP address is pretty recognizable when you see one. Every IPv4 address has 3 '.' characters that are seperating numbers that can be any value between 0 and 254 inclusive. Because an IP address has such a recognizable pattern, we can use something called a **regular expression** to test whether it matches that pattern. It doesn't take care of the validation 100%, but at least it will do the hardest part for us. We can use the *split* method to do the rest after we've verified that it actually has the '.' characters the *split* method will depend on. 

Regular expressions are a subject of their own and I won't be going into them in exhaustive detail. You can usually get by with a cheatsheet and some experimentation with a regex tester. I will explain how I came up with the pattern for this script. To start, open [this site](https://www.regextester.com/) up in a separate web browser tab. This can be used to test an expression on a test string. In the section below titled *Test String*, enter `1.12.123.12`. Now, in the top field, enter `\d`. You should see all of the digits highlighted. That's because `\d` matches all digits. Now, modify the top field to be `\d{3}`. You should now only see the 3rd octet highlighted. That's because the `{3}` is communicating that there are 3 consecutive digits. Now, let's make it `\d{1,3}`. All digits are highlighted now. Now we can add the dot by adding `\.` to the very end of the expression. Of course, it does not match the last octet because it is not suffixed by a dot. But, we at least have an expression that matches the first 3 sections and we are going to use this. Now, let's enclose our expression in parenthesis and specify that there are 3 instances of this expression, like so: `(\d{1,3}\.){3}`. You should see the first 3 octets highlighted along with the third dot. Now, we add `\d{1,3}` to the end of that and the whole thing should be highlighted now:

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

## Passing Parameters by Reference

Okay, let's add a new static method to the class right below *isValidIP*:

```
static [void]Prompt($ip, [string]$name){
    while(!([IPAddress]::isValidIP($ip))){
        $ip = Read-Host "Enter $name"
    }
    
    $ip = [IPAddress]::new($ip)
    
    printPadding "$($name):`r`n`t$($ip)"
}
```

This should be relatively self-explanatory. We're using the static method *isValidIP* that we just created in the last section to validate that *ip* is in the format we need it to be in. After that's done, it's passed to the *IPAddress* constructor and then stored back in our *ip* variable. There's an issue with this logic though that doesn't become apparent until you try using the method. Let's add this to our implementation section so we can test:

```
# prompt user for start IP address
[IPAddress]::Prompt($StartIP, "Start IP")
Write-Debug "Start IP = $StartIP"

# prompt for end IP address
[IPAddress]::Prompt($EndIP, "End IP")
Write-Debug "End IP = $EndIP"
```

Test your program and see what it does. Did your debug message output what the prompt should have ended up with? The reason that it seems like the prompt didn't store the value we got from the user is because some types are copied when passed into a parameter list. Some types are called **reference types** and they can successfully be passed by reference into a function without doing anything special. Objects (instances of classes) are reference types. PowerShell strings are not reference types. The other issue here is that are are changing the type of the variable. We can force PowerShell to pass a variable by reference by specifying it as the `[ref]` type. You also need to work with the value of the variable by using the *Value* property. Behold, our new version of *Prompt*:

```
static [void]Prompt([ref]$ip, [string]$name){
    while(!([IPAddress]::isValidIP($ip.Value))){
        $ip.Value = Read-Host "Enter $name"
    }
    
    $ip.Value = [IPAddress]::new($ip.Value)
    
    printPadding "$($name):`r`n`t$($ip.Value)"
}
```

Also, when calling the method, you are required to cast the variable to `[ref]`:

```
# prompt user for start IP address
[IPAddress]::Prompt(([ref]$StartIP), "Start IP")

# prompt for end IP address
[IPAddress]::Prompt(([ref]$EndIP), "End IP")
```

You can test your script again and make sure the values are what you are expecting this time.

## Inheritance

Our next section charges us to `# validate that end IP address comes after start IP address`. An intuitive way to do this would be to have something like this:

```
# validate that end IP address comes after start IP address
if(!($EndIP -gt $StartIP)){
    Write-Error "End IP must come after Start IP, ending program..."
}
```

That seems intuitive enough, but will it work? Go ahead and add that in and test it. You should have received a runtime error that they can't be compared because it is not *IComparable*. Typically, if you see a type name begin with a capital 'I', it's because it's a class **interface**. Interfaces are very useful. Interfaces allow programmers to implement code features without knowing much about the classes that will be using those features. In this case, we can see that the `-gt` operator (code feature) supports the interface *IComparable*. If we want our class to support use of the comparison operators, we have to have our class **inherit** from the interface and **override** its methods. Take a look a the [System.IComparable](https://docs.microsoft.com/en-us/dotnet/api/system.icomparable?view=net-6.0) documentation for details on how this is implemented. This particular interface has a single method named *CompareTo* that returns 0 if the values are equal, 1 if **this** is greater than the parameter, or -1 if **this** is less than the parameter. To inherit from the interface, modify your class declaration like so:

```
class IPAddress : System.IComparable {
    ...
}
```

Now, to implement the interface, we can add the *CompareTo* method below *ToString*:

```
[int]CompareTo([object]$rhs){

    # iterate through each octet
    for($i = 0; $i -lt $this.Octets.Count; $i++){

        # if any octet isn't equal
        if($this.Octets[$i] -ne ([IPAddress]$rhs).Octets[$i]){

            # which one is greater
            return $this.Octets[$i] -gt ([IPAddress]$rhs).Octets[$i] ? 1 : -1
        }
    }

    # octets are equal
    return 0
}
```

To decide `# which one is greater`, we are using something called the *ternary operator* that works as an alternative to some if/else block combinations. It's relatively new to PowerShell, so make sure you have at least PowerShell 7.2 LTS installed. The syntax of the ternary operator is like this:

```
x = <boolean expression> ? <return if true> : <return if false>
```

If the boolean expression evaluates to true, the value after the '?' is stored in *x*, otherwise, the value after ':' gets stored in *x*. This is quite a useful tool to add to your arsenal, so I definitely recommend getting used to its syntax.

## Overloading

Alright, now let's see if it makes the scripting engine happy. At the time of this writing, I encountered an occasional bug where the scripting engine doesn't appear to recognize that *EndIP* is an *IPAddress* and not a *string*. to get around this, I cast *EndIP* to an *IPAddress* and that seems to have silenced the bug:

```
# validate that end IP address comes after start IP address
if(!(([IPAddress]$EndIP) -gt $StartIP)){
    Write-Error "End IP must come after Start IP, ending program..."
}
```

## Test Class

Let's start a new class declaration under our *IPAddress* class:

```
class Test {
    [IPAddress]$ip
    [Boolean]$isSuccess

    Test([IPAddress]$ip){
        $this.ip = $ip
    }

    [string]ToString(){
        return $this.ip
    }
}
```

We have two properties, *ip* and *isSuccess*, as well as a single constructor, and an override of the *ToString* method. This class is going to grow by quite a few lines by the end of this lesson.

## GenerateTests Method

Right below the *ToString* method, let's add a new static method declaration:

```
static [Test[]] GenerateTests([IPAddress]$start, [IPAddress]$end) {
    throw "not implemented"
}
```

This method needs to create an array of *Test* objects for each IP address in the range. Before we can generate the tests, we need to initialize the array, which means we have to know how many tests there are going to be. Sorry, there is going to be some *math* involved! Sometimes, logic like this can take some trial and error to get right. I originally came up with a faulty algorithm for this that limited the range for each octet to be within the *StartIP* and *EndIP* values. That didn't work well. If we wanted to simplify the test generation logic, we could make it really easy by choosing to only support the typical class C range where only the last octet is different. But, I wanted to be able to support larger ranges than that. The final algorithm that I came up with for generating a test count is this

```
# Calculate the number of tests we need
$testCount = ($end.Octets[0] - $start.Octets[0]) * [Math]::Pow(255, 3)
$testCount += ($end.Octets[1] - $start.Octets[1]) * [Math]::Pow(255, 2)
$testCount += ($end.Octets[2] - $start.Octets[2]) * 255
$testCount += $end.Octets[3] - $start.Octets[3] + 1
```

Okay, so now we need to populate our array with every possible IP address in this range. We do this by using nested for loops. Each loop is responsible for generating the value of one of the octets. For the last 3 octets, the start and end values will depend on whether the previous octet is at it's first or last value. Why? Because if the previous octet is not on either its first or last value, then this octet needs to iterate through all of the values between 0 and 254 inclusive. Perhaps it would be easier to explain by showing you an example:

Start IP: **192.168.1.5**
End IP: **192.168.3.7**

Starting Octets:
1. 192
2. 168
3. 1
4. 5

- We start the 4th octet loop at 5 and iterate all the way to 254. Notice that we do not stop at 7.
- We increment the 3rd octet to 2.
- We start the 4th octet loop again, but this time we start at 0 and iterate all the way to 254. (192.168.2.0 is a valid IP address on networks that have less than a 24-bit subnet mask. The more you know :rainbow: )
- We increment the 3rd octet to 3. This is our final value for this octet.
- We start the 4th octet loop one final time, starting at 0 and ending at 7.

Originally, I implemented this using a couple of if/else blocks in each loop:

```
if($i -eq $start.Octets[0]){
    $jStart = $start.Octets[1]
} else {
    $jStart = 0
}

if($i -eq $end.Octets[0]){
    $jEnd = $end.Octets[1]
} else {
    $jEnd = 254
}
```

That gets really messy having to do this in 3 nested loops. Thankfully, if you installed PowerShell 7.2 like I advised at the beginning of the lesson, we can use the *ternary operator* to simplify the logic a bit. So, we can easily translate the previous if/else statements into this:

```
$jStart = $i -eq $start.Octets[0] ? $start.Octets[1] : 0
$jEnd = $i -eq $end.Octets[0] ? $end.Octets[1] : 254
```

Okay, and now for the entire set of nested loops. Please don't stress if this gives you a headache. This took a lot of trial and error on my part and it's okay if it doesn't make sense right away. But, you should take a look at how these start and end values are used to manipulate the loop because it reveals the usefulness of the for loop.

```
# generate a test for each IP
$tests = [Test[]]::new($testCount)
[int]$selector = 0
for([Byte]$i = $start.Octets[0]; $i -le $end.Octets[0]; $i++){

    $jStart = $i -eq $start.Octets[0] ? $start.Octets[1] : 0
    $jEnd = $i -eq $end.Octets[0] ? $end.Octets[1] : 254

    for([Byte]$j = $jStart; $j -le $jEnd; $j++){

        $kStart = $j -eq $start.Octets[1] ? $start.Octets[2] : 0
        $kEnd = $j -eq $end.Octets[1] ? $end.Octets[2] : 254

        for([Byte]$k = $kStart; $k -le $kEnd; $k++){
            
            $lStart = $k -eq $start.Octets[2] ? $start.Octets[3] : 0
            $lEnd = $k -eq $end.Octets[2] ? $end.Octets[3] : 254

            for([Byte]$l = $lStart; $l -le $lEnd; $l++){
                
                $ipNew = [IPAddress]::new([Byte[]]@($i, $j, $k, $l))
                $tests[$selector++] = [Test]::new($ipNew)
            }
        }
    }
}

return $tests
```

Don't forget to `return $tests` at the very end. With that class feature fully implemented, we can now use it to populate a test array:

```
# generate tests
$Tests = [Test]::GenerateTests($StartIP, $EndIP) 
```

## Test Run Method

For the test implementation, we are going to use the *Test-Connection* cmdlet to send an ICMP packet to the specified IP address. Add the *Run* method to your *Test* class:

```
[void]Run(){
    $result = Test-Connection -TargetName $this.ip.ToString() -IPv4 -Count 1 -TimeoutSeconds 1
    $this.isSuccess = $result.Status -eq "Success"
    Write-Host "$($this): $($this.isSuccess ? "PASS" : "FAIL")"
}
```

As soon as this method is done executing, it will print a "PASS" or "FAIL" message to the screen so the user can get some instant feedback from the program. We can use one of the loop types you've already learned to start the tests, or I can introduce you to another cool tool. Okay, let's try out another cool tool! Here's another way you can run a **foreach** loop on an array. Juse use the *ForEach* method:

```
# start the tests
$Tests.ForEach({
    $_.Run()
})
```

Remember that the *$_* variable is the *PSItem* special variable and it represents the object in the current iteration of the loop. Okay, go ahead and test your script on a small range in your LAN and you should be able to see whether devices in that range are alive.

## Final Output

Our script finally does something useful at this point, but we still have some final steps to do to fine tune the final output of the script. Add this static method to the *Test* class:

```
static [void]Output([Test[]]$tests, [string]$savePath){
    printPadding "These IP addresses are alive:"
    $output = ""
    $passed = $tests.Where({$_.isSuccess})
    foreach($test in $passed){
        $output += "$test`r`n"
    }

    Write-Host $output
    $output | Out-File -Path $savePath
}
```

I have a couple of things I need to explain here. You can see that we are using a *Where* method to filter an array. The method uses a boolean expression to decide whether to include an element or not. We are using the *isSuccess* property of the test class for this method. Also, the '{}' inside of the parameter block indicate that we are working with a **function literal**. Function literals are useful when you need to use a function once and have no need to give it a name. In this literal, the **return** keyword is implied and this is perfectly valid syntax if there's only one line. 

On the final line of the method, we use *Out-File* to save the *output* variable to *savePath*. We are using the pipe symbol '|' to send the data data of the *output* variable to the *InputObject* parameter of the *Out-File* cmdlet. Now, let's add this to the end of our script:

```
# output the result
[Test]::Output($Tests, $OutputPath)
```

Your script is complete and you are free to run tests to confirm this is working correctly. 

## Conclusion

I hope you enjoyed following along with this lesson at least as much as I enjoyed writing it. Programming with classes is commonly referred to as **Object-Oriented Programming** and some programming languages like C# take it to the next level by making everything a class. In my experience, it's not always desirable to use classes, especially for small scripts, and you'd just be forcing yourself to type more lines of code that aren't really necessary. However, classes are very useful for modeling things that may have many properties and behavior that would otherwise be difficult to work with outside of a class. I encourage you to try writing your own scripts with classes so you can get the hang of this style of programming.