# Lesson 2

For our second lesson, I would like to expand upon the first project and introduce you to some more advanced topics. To get started, go ahead and open the **Calculator.ps1** file in VS Code. You'll see that I put some comments to help you organize your code like the last project. 

## Dot Sourcing

This project is going to require some of the **same things** that the last project required. We're going to use the **printWithPadding** function as well as a beefed-up version of **getValueFor**. Do you recognize a problem? If we want to avoid code duplication, we'd have to borrow those functions from our previous project. Since that would require refactoring our previous project's code, we're going to go ahead and duplicate that code instead. It's only a few lines anyway. But, I will use the opportunity to show you how to save common code snippets in a way that can be shared across multiple scripts so you have the option of saving yourself some typing down the road.