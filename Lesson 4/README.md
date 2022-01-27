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

