# Lesson 2

## The Boolean Type

```
$var = $true # $var is type boolean with a value of true
$var = $false # $var is type boolean with a value of false
1 -eq 1 # evaluates to $true
1 -ne 1 # evaluates to $false
1 -gt 0 # evaluates to $true
1 -lt 0 # evaluates to $false
!(1 -eq 1) # evaluates to $false
```

## If Statement

```
if(<boolean statement is true>){
    <do this work>
}
```

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

## Switch Statement

```
switch(<statement>){
    <value 1> { <do this work if statement is equal to value 1>}
    <value 2> { <do this work if statement is equal to value 2>}
    default { <do this if nothing else matched> }
}
```

## While Loops

```
while(<statement>){
    <do this work>
}
```

or

```
do {
    <do this work at least once>
} while(<statement>)
```

## for/foreach loops

```
for($i = 0; $i -lt 10; $i++){
    Write-Output $i
}
```

```
$fruits = @("apple", "banana", "strawberry")

foreach($fruit in $fruits){
    Write-Output "My favorite fruit is $fruit.
}
```

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