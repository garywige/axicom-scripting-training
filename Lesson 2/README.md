# Lesson 2

## The Boolean Type

There are going to be instances where you need to evaluate a variable and change your program flow accordingly. This will usually involve **boolean** values, which can either be `$true` or `$false`. Sometimes, testing the boolean value of a variable is sufficient, like `if($var)` (you will learn about if statements soon). Other times, you may need a more complex statement to evaluate, like `if(($var -ne $null)-and ($var.value -eq 360))`. 

## Logical Operators

Some boolean statements will require **logical operators**. If you are familiar with other programming languages, you should already be familiar with these, though they have a different syntax than what you are probably used to.

### Logical AND

```
$var1 = $true
$var2 = $true
$result = $var1 -and $var2 # result has the value $true
```

The `-and` operator compares the statements on the left and right, then returns true only if both statements evaluate to true.

### Logical OR

```
$var1 = $true
$var2 = $false
$result = $var1 -or $var2 # result has the value $true
```

The `-or` operator compares the boolean values on the left and right, then returns true if either of the statements evaluate to true. 

### Logical NOT

```
$var1 = $false
$result = !($var1) # result has the value true
# you can also use this syntax
$result = -not ($var1)
```

The `!` or `-not` operator will return the opposite boolean value of the statement to the right of the operator. If the statement evaluates to `$true`, `-not` will return `$false`. If the statement evaluates to `$false`, `-not` will return `$true`.

PowerShell also has an **Exclusive OR** operator `-xor`, but I will refrain from using it to keep things simple.

## Comparison Operators

Often, we are going to want to compare a variable or statement to another variable or statement and use the results to control program flow. 

### Equals

```
$var1 = 1
$var2 = 2
$result = $var1 -eq $var2 # result has the value $false
```

The `-eq` operator compares statements on the left/right and returns `$true` if the values match. Note that if they are of a different **type**, like the number value 32 and the string value '32', the values do not match and will return false if compared with this operator. 

### Not Equals

```
$var1 = 1
$var2 = 2
$result = $var1 -ne $var2 # result has the value $true
```

The `-ne` operator compares statements on the left/right and returns `$true` if the values do not match. This is basically a shorthand for `!($var1 -eq $var2)`.

### Greater Than

```
$var1 = 1
$var2 = 2
$result = $var1 -gt $var2 # result has the value $false
```

The `-gt` operator compares statements on the left/right and returns `$true` if the value on the left is greater than the value on the right. This can obviously be used with numbers, but you can also use it with strings. A good use case for using it with strings is for sorting. Any class that implements the **System.IComparable** interface can also work with comparison operators. Don't worry if you don't understand that last sentence.

### Great Than or Equal

```
$result = 100 -ge 100 # result is $true
```

The `-ge` operator will return true if the left/right statements are equal or if the left statement is greater than the right statement. This could also be accomplished with a combination of `-or`, `-eq`, and `-gt` operators, but this is a much simpler way of making the same comparison.

### Less Than

```
$result = 2 -lt 3 # result is true
$result = 100 -le 100 # result is true
```

As you may have guessed, the `-lt` operator compares the left/right statements and returns true if the statement on the left is less than the statement on the right. There is also a corresponding `-le` operator that also looks for equality.

## If Statement

```
if(<boolean statement is true>){
    <do this work>
}
```

Finally, we can put these operators to work! An **if statement** evaluates the expression in the parenthesis. If the statement is true, the block of code in between the curly braces is executed.

## Else Statement

```
if(<boolean statement is true>){
    <do this work>
} else {
    <do this work instead>
}

# chained if statements
if(<statement>) {

} else if(<another statement>) {

} else {

}
```

**Else statements** can only be used in conjunction with **if statements**. If the statement in the if statement evaluates to `$false`, the code block after the **else statement** is executed. Note that an **else statement** can execute another **if statement**, so you can chain if statements together like this if you have several comparisons to make. However, often times you will want to use a **switch statement** instead of chaining multiple **if statements** together.

## Switch Statement

```
switch(<statement>){
    <value 1> { <do this work if statement is equal to value 1>}
    <value 2> { <do this work if statement is equal to value 2>}
    default { <do this if nothing else matched> }
}
```

A **switch statement** can be used to compare a variable with multiple values. Let's say you have the user select what program mode they want to use:

```
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
```

You can use the `default {}` block to catch any values that weren't matched. 

## While Loops

```
while(<statement>){
    <do this work>
}
```

Sometimes, it's necessary to repeat a block of code. A **while loop** will evaluate the statement in the parenthesis and execute the code if it's true, just like an **if statement**. Once the block is done, it evaluates the statement again and executes it if the statement is still true. Here is a useful variation you may want to use sometimes:

```
do {
    <do this work at least once>
} while(<statement>)
```

The **do/while loop** will always execute the block of code at least once because the conditional statement isn't examined until the end of the code block is reached.

## for/foreach loops

A **while loop** is great for when you want to use a boolean statement to control the flow, but you may want to use a different loop depending on the scenario.

### For Loop

```
for($i = 0; $i -lt 10; $i++){
    Write-Output $i
}
```

A **for loop** is a bit different than other structures you've seen so far. The code in between the parenthesis is broken down into 3 sections separated by semi-colons. The first section is used to initialize a varialbe that will be used for the other 2 sections. This typically looks like `$i = 0`. The second section is a boolean statement used to determine whether to continue execution, similar to a **while loop**. In most cicumstances, it will look something like `$i -lt <number of iterations>`. The third section controls how the variable you created in the first section is incremented. Typically it will be incremented with the **increment operator** ++, for instance `$i++`, which will add 1 to the variable $i. **For loops** are great for when you need to use $i in the code block on each iteration. For instance, you can create a numbered list like this:

```
for($i = 0; $i -lt $items.count; $i++){
    Write-Output "$($i): $($items[$i])"
}
```

$items is an **array** and you will learn about those later. 

### Foreach Loop

```
$fruits = @("apple", "banana", "strawberry")

foreach($fruit in $fruits){
    Write-Output "My favorite fruit is $fruit.
}
```

**Foreach loops** are great for iterating over arrays when you don't need to keep track of which iteration you are on. In the code example above, an array is instantiated named $fruits containing 3 members. The **foreach loop** creates a temporary variable for each iteration named $fruit that can be used for the code block. We will go over arrays in detail in another lesson. 

## break/continue

```
while($true){
    # oh no, infitite loop!

    if(<statement>){
        break
    } else {
        continue
    }

    # this code will never execute, so no one will ever hear your cries for help
    Write-output "Help!"
}
```

## try/catch

```
try {
    <potentially buggy/dangerous code>
} catch {
    <do something to handle the error if it happens>
}
```

## Conclusion