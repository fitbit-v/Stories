### JavaScript Resources
* [ECMA Script Compatibility Table](http://kangax.github.io/compat-table/es6/)
* https://caniuse.com/
* http://jsbin.com/tavinaz/1/edit?js,console,output
* https://jsbin.com/nuveda/11/edit?js,console,output
* https://www.w3counter.com/globalstats.php
* https://jsbin.com/kejonuq/28/edit?html,js,output
* https://jsbin.com/mamager/1/edit?js,console
* [Example Code for JavaScript for Salesforce Developers Trailhead module](https://github.com/pchittum/js-skills-for-sf-developers)
* [JavaScript Object](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object)
* [Working with objects](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Working_with_Objects)
* [Details of the object model](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Details_of_the_Object_Model)
* [Lightning Aura Components Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/intro_framework.htm)
* 


### Declaring Variables
All variables are pointers. Assignment is the act of pointing that variable to something in memory. Mutability is whether or not a variable can be reassigned once it has initially been assigned something. Using var or let creates mutable pointers, whereas const is immutable.

### Functions Are Values
In JavaScript, everything is an object. This goes for functions too. And like other objects, functions can be assigned to variables, passed into parameters of other functions, and used the same way you can any other object. 

### Object Literal Notation
```javascript
const bike = {
  gears: 10,
  currentGear: 3,
  changeGear: function(direction, changeBy) {
    if (direction === 'up') {
      this.currentGear += changeBy;
    } else {
      this.currentGear -= changeBy;
    }
  }
}
console.log(bike.gears); // 10
console.log(bike.currentGear); //3
bike.changeGear('up', 1);
console.log(bike.currentGear); //4
```

### New Objects with Constructors
A constructor is a function that contains instructions for establishing the properties of an object when it's created and assigned. This has an advantage over object literal as you can create many instances of objects that have the same properties. 

* follow JavaScript convention and capitalize the first word to signal that this function is a constructor. 
```javascript
function Bike(gears, startGear) {
  this.gears = gears;
  this.currentGear = startGear;
}
Bike.prototype.changeGear = function(direction,changeBy){
  if(direction === 'up') {
    this.currentGear += changeBy;
  } else {
    this.currentGear -= changeBy;
  }
}
const bike = new Bike(10, 3);
console.log(bike.gears); // 10
console.log(bike.currentGear); //3
bike.changeGear('up', 1);
console.log(bike.currentGear); //4
```

### Assigning Properties and Functions to Objects
Properties come in three basic shapes.
* Primitives
* Objects
* Arrays
There are six primitive types in JavaScript: string, number, Boolean, null, undefined, and symbol. When a variable is a primitive type, it’s passed by value when assigned. That is to say, each time a primitive is assigned, a copy of the value is made and assigned to the new variable. 

### Classes and JavaScript
The class keyword in JavaScript is a nice bit of syntactic sugar to address the complexities of prototype inheritance using constructor functions. Under the covers, the engine is still using Object.create and there is still no class (in the object-oriented sense), just that in-memory prototype object that is the actual source of inheritance. 


## Events and Functions
* Parts of the DOM emit events that correspond to what that DOM object does.
* Buttons have click events
* input and select controls have change events
* To make something happen in a web page, functions get assigned to these events as event handlers. 
*  DOM events and other events related to the browser environment are not actually part of the core JavaScript language, rather they are APIs that are implemented for JavaScript in the browser. 
* When an event is emitted, a message is created in the engine. It is these messages that are placed in the event queue.
* Once the stack is free, the event handler is invoked.
* This creates what’s referred to as a frame on the call stack.
* Each time one function invokes another, a new frame is added to the stack, and when complete, it is popped off the stack, until finally the frame for the actual event handler is popped, the stack is empty, and we start all over again. 

### Defining and Assigning Functions
* In JavaScript functions are essentially special objects. 
* As objects, they are first-class members of JavaScript. 
* They can be assigned as the values of variables, passed into other functions as parameters, and returned from functions. 
* When function is declared, its definition is loaded into memory. 
* A pointer is then assigned to it in the form of a variable name, parameter name, or an object property.
* there are several different syntaxes to do this.

#### Function Declaration
```javascript
// declare function
function calculateGearRatio(driverGear, drivenGear){
  return (driverGear / drivenGear);
}
// call function
let gearRatio = calculateGearRatio(42, 30);
console.log(gearRatio); // 1.4
```
```javascript
// call function
let gearRatio = calculateGearRatio(42, 30);
// function is declared after the line it is called
// this is allowed in function declaration
function calculateGearRatio(driverGear, drivenGear){
  return (driverGear / drivenGear);
}
console.log(gearRatio); // 1.4
```
#### Function Expressions
```javascript
const calculateGearRatio = function(driverGear, drivenGear){
  return (driverGear / drivenGear);
}
// the rest works the same
let gearRatio = calculateGearRatio(42, 30);
console.log(gearRatio); // 1.4
```
In this instance we have an explicitly assigned variable. Since we’ve named the pointer, we can drop the function name after the `function` keyword. The only catch here is that the function must be declared prior to it being invoked. 

#### Returning a Function
Since functions are first-class objects, another way to declare a function is when a function returns another function. This pattern is often referred to as a factory function. 
```javascript
// when invoked, this function will assign a function
function gearFactory(){
  return function(driverGear, drivenGear){
    return (driverGear / drivenGear);
  }
}
// calculateGearRatio can now be invoked as a function
const calculateGearRatio = gearFactory();
// and all the rest
```
