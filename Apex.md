# Apex
## Best Practices
1. Every Salesforce org with a strong development team always has just one trigger per object.  “One Trigger per Object” design pattern - combine all possible triggers on a specific object into just one trigger. 
How do you combine many triggers into one?
Instead of coding your logic directly inside a trigger, you code it separately in a class. Then in your trigger, you create an object of the class, then run your records through its logic. Repeat for all triggers.
What are the benefits of this design pattern?
* Reusability – with your logic in a class, you can now re-use it outside of triggers, for example in a Visualforce page, test class, batch Apex, etc. No need to copy code!
* Simplicity – every “trigger” gets reduced to just two lines of code in the master trigger. An object oriented code base is more organized, predictable, and modular too!
* Control your order of execution – in Apex, “the order of execution isn’t guaranteed for multiple triggers on the same object.” This pattern gives you total order control.

2. Bulkification
3. 