# Lightning Service Cloud

## Events
In Event-driven programming, write handlers that respond to interface events as they occur.  Events are fired from JavaScript controller actions that are typically triggered by a user interacting with the user interface.  You write the handlers in JavaScript controller actions.

There are two types of events in the framework:
* Component events are handled by the component itself or a component that instantiates or contains the component.
* Application events are handled by all components that are listening to the event. These events are essentially a traditional publish-subscribe model.


## Create Support Processes

### Create a New User Using Lightning Setup Flow  
### Configure Case Status Picklist Values 
### Create a product support process to support product-related cases.
### Create an inquiry support process for customer inquiries.
### Create Case Page Layouts
* Highlights Panel
* Quick Actions in the Salesforce Classic Publisher
* Case Detail
### Create Record Types 
### Create a Case to Test Your Support Processes 


### Build an Aura Component or a Lightning Web Component?
Lightning web components can’t contain Aura components, none of the smaller nested components can be an Aura component.  If building a new Lightning web component that expects other subcomponents in its body, those subcomponents must also be Lightning web components.  Aura components can contain Lightning web components.
### Lightning Web Components and Aura Components Working Together
An interoperability layer enables Lightning web components and Aura components to work together in an app.
* To communicate down the hierarchy, parents set properties on children.
* In an Aura component, to refer to either Aura components or Lightning web components, use camel case with a colon separating the namespace and the component name.

* This Aura component is composed of `lightning:card`, which is a base Lightning component, and  `c:lwcHelloWorld`, which is a Lightning web component.
* components that come with the Lightning Design System styling are available in the lightning namespace. 

