### JavaScript Resources
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
* [Arrow functions in the mdn web docs](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Arrow_functions) 
* [ES6 Arrow Functions: Fat and Concise Syntax in JavaScript](https://www.sitepoint.com/es6-arrow-functions-new-fat-concise-syntax-javascript/)
* [Default Parameters](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Default_parameters)
* [ES6 In Depth: Rest parameters and defaults](https://hacks.mozilla.org/2015/05/es6-in-depth-rest-parameters-and-defaults/)
* [Rest parameters](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/rest_parameters)
* [Spread syntax](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Spread_syntax)


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

### Block Scope
Block scoping ensures that any variables defined within those braces don’t become global variables. They instead have local scope. Having this type of control over how variables are scoped helps you prevent unexpected behaviour in your code. 
* Variables assigned with `let` are always block scoped. 
* Variables assigned with `let` cannot be hoisted. 
* Hoisting occurs when the JavaScript interpreter makes two passes at your code.
* In the first pass, variable and function declarations are “hoisted” to the top of the code.
* In the second pass they are evaluated and assignments are made. 
* Variables declared with the `const` keyword are also block-scoped and cannot be hoisted
* Constants are not immutable.  This means that it is possible to modify the properties of objects or arrays assigned with const. 
* when dealing with objects or arrays, only the object itself cannot be reassigned. Properties within that object or array can be changed.
```javascript
let firstName = 'John', lastName = 'Doe';
//properties of an object are initialized using variables
let user = {
  firstName : firstName,
  lastName : lastName
}
console.log(user);
// ======
let firstName = 'John', lastName = 'Doe';
let user = { firstName, lastName };
console.log(user); 

// getting data out of arrays or objects:
let numbers = [1,2,3,4]

let one = numbers[0],
    two = numbers[1],
    three = numbers[2],
    four = numbers[3]
console.log(one)

// array destructuring
let [one, two, three, four] = numbers
console.log(one)

```
### JavaScript Functions
* if you include the curly braces, the `return` keyword is required.
* Functions have a special variable called `this`, often referred to as the “dynamic this,” which refers to the object used to invoke the function.
* Referencing the `this` keyword inside the nested function just refers to the scope in which the object was invoked
```javascript 
function showMessage(who, {p1 = "Hello", p2 = "World"} = {}) {
  console.log(who + ' says ' + p1 + p2);
}
showMessage("Vuk")  // Displays "Vuk says Hello World"
```
In the above function, the second parameter is an object that is specified with the destructuring syntax.  Equal sign followed by empty curly braces enables you to call the function without parameters.  

* Rest parameters are indicated with three dots (...) and they can appear only at the end of the argument list:
```javascript 
function showContact (firstName, lastName, ...titles)  {
  console.log(firstName + ' ' + lastName + ', ' + titles[0] + ' and ' + titles[1]);
}
showContact('Sue', 'Johnson', 'Developer', 'Architect');  
```
The three dots ( … ) operator has two uses. As the rest operator, it is used to gather up all the remaining arguments into an array. But as the spread operator, it is used to expand a single variable into an array. 
* ... allows you to use zero or more arguments

### JavaScript Classes
Prior to ES6, if you wanted to create a class in JavaScript, you used prototypes
* function declarations can be hoisted - you can call a function that has yet to be declared.
* Classes come in two flavors: base classes and derived classes. The difference is the extends keyword. Derived classes (also known as subclasses) have them
```javascript
class Parent {
  constructor(name) {
    this.name = name
  }

  getName() {
    return this.name
  }
}

//
class Child extends Parent {
  constructor(name) {
    super(name)
  }

  getMessage() {
    return 'Hello ' + super.getName()
  }
}

let someone = new Child('person')
console.log(someone.getMessage()) // Displays "Hello person"
console.log(typeof Parent)
```
* `super` keyword, which allows you to reference the parent constructor and the method definitions from the Base class. Whenever you see the `super` keyword, you know you are in a derived class and referring to the base class.

