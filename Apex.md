# Apex
* [Salesforce Security Guide](https://developer.salesforce.com/docs/atlas.en-us.218.0.securityImplGuide.meta/securityImplGuide/review_and_certification.htm)
* [Salesforce Developers Blog](https://developer.salesforce.com/blogs/)
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


##
* Console density is not the same on Lightning
* Lightning migration must be done by October 1
* It will take 6 weeks to roll it out to agents
* Create another sandbox 
* Technical roadblocks for Lightning
* POC in a new sandbox
* Fitbit+ is a health coaching platform
* Dual skilled agents
* 

## Omni-channel
* federated to voice
* email 

