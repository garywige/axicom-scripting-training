# Lesson 2

## Introduction

In the previous lesson, the goal was to get you oriented with your scripting environment so you can begin experimenting. In this lesson, I'm going to focus more on the available scripting tools that PowerShell has to offer and prepare you for more advanced scripting projects. Instead of writing one large project script for this lesson, I would like you to open a PowerShell window that you can type or copy/paste the examples into. The PowerShell window is another valuable tool you can use when scripting. Sometimes you don't know if your syntax is right and testing something in a PowerShell window is a quick way to verify that you have it right before you commit it to your PS1 file.

## The Boolean Type

There are going to be instances where you need to evaluate a variable and change your program flow accordingly. This will usually involve **boolean** values, which can either be `$true` or `$false`. Sometimes, testing the boolean value of a variable is sufficient, like `if($var)` (you will learn about if statements soon). Other times, you may need a more complex statement to evaluate, like `if(($var -ne $null)-and ($var.value -eq 360))`. 

```
$var1 = $true
Write-Output "var1 is $var1"
```

## Logical Operators

Some boolean statements will require **logical operators**. If you are familiar with other programming languages, you should already be familiar with these, though they have a different syntax than what you are probably used to.

### Logical AND

The `-and` operator compares the statements on the left and right, then returns true only if both statements evaluate to true.

```
Write-Output ($false -and $false)
Write-Output ($true -and $false)
Write-Output ($false -and $true)
Write-Output ($true -and $true) # we have a winner
```

### Logical OR

The `-or` operator compares the boolean values on the left and right, then returns true if either of the statements evaluate to true.

```
Write-Output ($false -or $false) # only this is false
Write-Output ($false -or $true)
Write-Output ($true -or $false)
Write-Output ($true -or $true)
``` 

### Logical NOT

The `!` or `-not` operator will return the opposite boolean value of the statement to the right of the operator. If the statement evaluates to `$true`, `-not` will return `$false`. If the statement evaluates to `$false`, `-not` will return `$true`.

PowerShell also has an **Exclusive OR** operator `-xor`, but I will refrain from using it to keep things simple.

```
Write-Output (!$true)
Write-Output (!$false)
Write-Output (-not $true)
Write-Output (-not $false)
```

## Comparison Operators

Often, we are going to want to compare a variable or statement to another variable or statement and use the results to control program flow. 

### Equals

The `-eq` operator compares statements on the left/right and returns `$true` if the values match. Note that if they are of a different **type**, like the number value 32 and the string value '32', the values do not match and will return false if compared with this operator. 

Something important to note about using this with strings is that it is case-insensitive by default. This differs from most other programming languages, so watch out. If you need to compare the case in strings, use `-ceq` instead.

```
Write-Output (1 -eq 2) #false
Write-Output (1 -eq 1) #true
Write-Output ("banana" -eq "orange") #false
Write-Output ("Banana" -eq "banana") #true
Write-Output ("Banana" -ceq "banana") #false
```

### Not Equals

The `-ne` operator compares statements on the left/right and returns `$true` if the values do not match. This is basically a shorthand for `!($var1 -eq $var2)`.

```
Write-Output (1 -ne 2) #true
Write-Output (1 -ne 1) #false
Write-Output ("banana" -ne "orange") #true
Write-Output ("Banana" -ne "banana") #false
Write-Output ("Banana" -cne "banana") #true
```

### Greater Than

The `-gt` operator compares statements on the left/right and returns `$true` if the value on the left is greater than the value on the right. This can obviously be used with numbers, but you can also use it with strings. A good use case for using it with strings is for sorting. Any class that implements the **System.IComparable** interface can also work with comparison operators. Don't worry if you don't understand that last sentence.

```
Write-Output (1 -gt 2) #false
Write-Output (2 -gt 1) #true
Write-Output (1 -gt 1) #false
Write-Output ("apple" -gt "banana") #false because 'a' comes before 'b'
```

### Great Than or Equal

The `-ge` operator will return true if the left/right statements are equal or if the left statement is greater than the right statement. This could also be accomplished with a combination of `-or`, `-eq`, and `-gt` operators, but this is a much simpler way of making the same comparison. For extra credit, I challenge you to figure how how you could do the same thing using the 3 operators mentioned.

```
Write-Output (1 -ge 2) #false
Write-Output (2 -ge 1) #true
Write-Output (1 -ge 1) #true because they are equal
Write-Output ("apple" -ge "banana") #false because 'a' comes before 'b'
```

### Less Than

As you may have guessed, the `-lt` operator compares the left/right statements and returns true if the statement on the left is less than the statement on the right. There is also a corresponding `-le` operator that also looks for equality.

```
Write-Output (1 -lt 2) #true
Write-Output (2 -lt 1) #false
Write-Output (1 -lt 1) #false
Write-Output ("apple" -lt "banana") #true because 'a' comes before 'b'

Write-Output (1 -le 2) #true
Write-Output (2 -le 1) #false
Write-Output (1 -le 1) #true because they are equal
Write-Output ("apple" -le "banana") #true because 'a' comes before 'b'
```

## If Statement

Finally, we can put these operators to work! An **if statement** evaluates the expression in the parenthesis. If the statement is true, the block of code in between the curly braces is executed.

```
if($true){
    Write-Output "This gets printed to the screen"
}

if($false){
    Write-Output "This does not get printed :P"
}
```

## Else Statement

**Else statements** can only be used in conjunction with **if statements**. If the statement in the if statement evaluates to `$false`, the code block after the **else statement** is executed. Note that you can use the keyword **elseif** to chain if statements together like this if you have several comparisons to make. However, often times you will want to use a **switch statement** instead of chaining multiple **if statements** together.

```
$motivationLevel = 1

if($motivationLevel -gt 5){
    Write-Output "I'm really motivated right now"
} else {
    Write-Output "I'm going back to bed..."
}

# chained if statements
if($motivationLevel -lt 2) {
    Write-Output "back to bed"
} elseif($motivationLevel -lt 5) {
    Write-Output "but I'm still in my pajamas..."
} else {
    Write-Output "I'm ready to rock!"
}
```


## Switch Statement

A **switch statement** can be used to compare a variable with multiple values. Let's say you have the user select what program mode they want to use:

```
$var1 = 3
$var2 = 7
$mode = Read-Host "1) Addition, 2) Subtraction, 3) Multiplication, 4) Division"
```

You can then use a switch statement to take the appropriate action

```
switch($mode){
    "1" {
        $result = $var1 + $var2
    }

    "2" {
        $result = $var1 - $var2
    }

    "3" {
        $result = $var1 * $var2
    }

    "4" {
        $result = $var1 / $var2 # usually want to verify that $var2 isn't 0 first
    }

    default {
        $result = "not supported"
    }
}

Write-Output "Result: $result"
```

You can use the `default {}` block to catch any values that weren't matched. 

## While Loops

Sometimes, it's necessary to repeat a block of code. A **while loop** will evaluate the statement in the parenthesis and execute the code if it's true, just like an **if statement**. Once the block is done, it evaluates the statement again and executes it if the statement is still true.

```
$i = 0
while($i -lt 100){
    Write-Output "$i little monkeys jumping on the bed!"
    $i++
}
```

Here is a useful variation you may want to use sometimes:

```
$superSecretPassword = "password"

Write-Output "\tSUPER-SECURE LOGIN"
Write-Output "the password is '$superSecretPassword'"

do {
    $pw = Read-Host "Please enter the password"
} while($pw -ne $superSecretPassword)
```

The **do/while loop** will always execute the block of code at least once because the conditional statement isn't examined until the end of the code block is reached.

## for/foreach loops

A **while loop** is great for when you want to use a boolean statement to control the flow, but you may want to use a different loop depending on the scenario.

### For Loop

A **for loop** is a bit different than other structures you've seen so far. The code in between the parenthesis is broken down into 3 sections separated by semi-colons. 

```
for($i = 0; $i -lt 10; $i++){
    Write-Output $i
}
```

The first section is used to initialize a varialbe that will be used for the other 2 sections. This typically looks like `$i = 0`. The second section is a boolean statement used to determine whether to continue execution, similar to a **while loop**. In most cicumstances, it will look something like `$i -lt <number of iterations>`. The third section controls how the variable you created in the first section is incremented. Typically it will be incremented with the **increment operator** ++, for instance `$i++`, which will add 1 to the variable $i. **For loops** are great for when you need to use $i in the code block on each iteration. For instance, you can create a numbered list like this:

```
$fruits = @("apple", "banana", "coconut", "avocado", "cherry", "mango", "tomato", "jalapeno", "bell pepper")

for($i = 0; $i -lt $fruits.count; $i++){
    Write-Output "$($i): $($fruits[$i])"
}
```

$fruits is an **array** and you will learn about those in detail in another lesson. For now, you now know enough to instanteate your own for practice. 

### Foreach Loop

**Foreach loops** are great for iterating over arrays when you don't need to keep track of which iteration you are on. In the code example below, an array is instantiated named $fruits containing 3 members. The **foreach loop** creates a temporary variable for each iteration named $fruit that can be used for the code block. We will go over arrays in detail in another lesson. 

```
$fruits = @("apple", "banana", "strawberry")

foreach($fruit in $fruits){
    Write-Output "My favorite fruit is $fruit."
}
```

## break/continue

Sometimes, you want a way to change the program flow *within* a loop.

```
$i = 0
while($true){
    # oh no, infitite loop!

    if(++$i -gt 100){
        Write-Output "stopping..."
        break
    } else {
        Write-Output "Error: stopping when 'i' is less than 100 is not supported! (i == $i)"
        continue
    }

    # this code will never execute, so no one will ever hear your cries for help
    Write-output "Help!"
}
```

The **break** keyword causes the loop to immediately end execution and anything after the loop's code block is then executed. In the loop above, we have created something called an **infinite loop**, so called because the loop can never end if only for its boolean statement `while($true){}`. In that scenario, a **break** or **return** statement is the only way you can end the loop.

The **continue** keyword is also useful for loops. When **continue** is encountered, the rest of the code block is skipped and the boolean statement is evaluated before starting the next round. Because of the **continue** keyword in the example above, the word "Help!" is never written to the screen.

## try/catch

If you enter bad input into the Lesson 1 example script, the script doesn't **handle** it very well. For a small script with limited budget, this is fine. But, sometimes it makes sense to put the extra work in to make the script overcome the errors it may encounter.

```
while($true){
    try {
        $num = [int](Read-Host "Enter a number")
    } catch {
        Write-Output $_
        continue
    }

    break
}
```

You may surround your potentially buggy code in a **try** block like above. The **catch** block right below it defines what action will be taken when an error is encountered. You may need to print a custom message to the script, instantiate variables with default values to avoid future errors, etc. If this is in a loop, maybe just **continue** will suffice so the user can try reentering their input. The `$_` in the example above is called the **$PSItem** variable and it will contain the last error message encountered.

What if you want to throw your own errors? All you have to do is use the **throw** keyword suffixed by your error text like so:

```
throw "I have no idea what I'm doing..."
```

This will cause code execution to halt and the error will bubble up to the first catch block that it encounters. If no catch block is encountered, the program ends with an unhandled exception and the error is written to the screen in red.

## Conclusion

In this lesson, you learned many useful concepts that can help you write much more advanced scripts than the previous lesson. I encourage you to you experiement with what you've learned so far to solidify the knowledge. A great excercise would be to expand on the Lesson 1 example and create a calculator with 4 basic modes: addition, subtraction, multiplication, and division. I leave the implementation details up to you!