// Traits and trait objects in Rust

// Traits: Defining shared behavior ---------------------------------------
// like interfaces in Java
// basic trait definition
trait Greet {
    // method signature (no implementation)
    fn say_hello(&self) -> String;
}

struct Person {
    name: String,
}

// implement a trait for a type
impl Greet for Person {
    // concrete implementatoin of say_hello
    fn say_hello(&self) -> String {
	format!("My name is {}", self.name)
    }
}

struct Robot;
impl Greet for Robot {
    fn say_hello(&self) -> String {
	format!("I am a robot")
    }
}

enum Color { Red, Blue, Green, }
impl Greet for Color {
    fn say_hello(&self) -> String {
	match self {
	    Color::Red => format!("Red"),
	    Color::Blue => format!("Blue"),
	    Color::Green => format!("Green"),
	}
    }
}

// using traits
// function accepting a reference to any type implementing Greet
fn greet_someone(greeter: &impl Greet) {
    println!("{}", greeter.say_hello());
}

// now use say_hello as member functions
let person = Person { name: "Rust".to_string(), };
let robot = Robot;
let color = Color::Blue;

greet_someone(&person);
greet_someone(&robot);
greet_someone(&color);

// also possible
println!("{}", person.say_hello());
println!("{}", robot.say_hello());
println!("{}", color.say_hello());

// Static dispatch (monomorphization):
//        The compiler generates optimized code for each
//                    concrete type at compile time.

// Trait objects: Dynamic polymorphism -----------------------------------

// Trait objects (dyn Trait) allow runtime polymorphism
// (deciding which method to call at runtime).
// They are stored behind pointers (&dyn Trait, Box<dyn Trait>).

// a functin taking any type implementing Greet via a trait object
fn dynamic_greet(greeter: &dyn Greet) {
    println!("{}", greeter.say_hello());
}

// using trait objects
let alice = Person { name: "Alice".to_string(), };
let bot = Robot;
let col = Color::Green;
    
// store trait objects in a vector
let greeters: Vec<&dyn Greet> = vec![&alice, &bot, &col];

// dynamic dispatch: no monomorphization
for greeter in greeters {
    dynamic_greet(greeter);
}

// Key points for trait objects
// 1. Dynamic dispatch (The method call is resolved at runtime
//                      (slightly slower than static dispatch))
// 2. Must be behind a pointer (&dyn Trait, Box<dyn Trait>, etc.)
// 3. Object-safe traits only: Traits must not return Self
//                              or use generic methods

// When to use traits vs. trait objects
// Use Case	Static Dispatch (impl Trait)	Dynamic Dispatch (dyn Trait)
// Performance	Faster (compile-time resolution)	Slightly slower (runtime lookup)
// Flexibility	Less flexible (types known at compile time)	More flexible (heterogeneous collections)
// Binary Size	Larger (due to monomorphization)	Smaller (one implementation)
// Use Case	When types are known at compile time	When types vary at runtime (e.g., plugins)

// default implementation ------------------------------------------------
trait Greet {
    fn say_hello(&self) -> String {
	format!("Default hello")
    }
}

// use default implementation
impl Greet for Robot {}

// impl trait in return position -----------------------------------------
// return a concrete type implementing Greet
fn get_greeter(name: &str) -> impl Greet {
    Person { name: name.to_string() }
}

let bob = get_greeter("Bob");
dynamic_greet(&bob);

// Box<dyn Trait> --------------------------------------------------------

// Box is a smart pointer that allocates its contents on the heap
// dyn Trait is a trait object that enables runtime polymorphism (dynamic dispatch).
// Together, Box<dyn Trait> means a heap-allocated object that implements Trait, where the exact type is determined at runtime.

// Why Box is needed?
// Trait objects (dyn Trait) are unsized (their size isn’t known at compile time).
// Rust requires all values to have a known size, so we must store them behind a pointer.

// &dyn Trait         (borrowed reference)
// Box<dyn Trait>     (owned heap allocation)
// Rc<dyn Trait>      (shared ownership)       // Rc: Reference counted

trait Animal {
    fn speak(&self);
}

struct Dog;
struct Cat;

impl Animal for Dog { fn speak(&self) { println!("Woof!"); } }
impl Animal for Cat { fn speak(&self) { println!("Meow!"); } }

// a vector containing Box<dyn Animal>
let animals: Vec<Box<dyn Animal>> = vec![
    Box::new(Dog),  // Stored as a trait object
    Box::new(Cat),  // Different types, same interface
];

// How it works:
// Box<dyn Animal> stores:
//         A pointer to the actual data (Dog or Cat),
//         A pointer to a vtable (contains method addresses for Animal).
// When calling animal.speak(), Rust checks the vtable to find the correct implementation.

// Static Dispatch (impl Trait)
//         Resolved at compile time (monomorphization),
//         Faster, but generates duplicate code for each type.
// Dynamic Dispatch (dyn Trait)
//         Uses a vtable (virtual method table) at runtime to look up the correct method,
//         Slightly slower (indirection cost), but flexible.

// 
