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
* 