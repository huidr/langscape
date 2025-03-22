// STRUCTURES -------------------------------------------------------------

struct User {
    active: bool,
    username: String
}                               // no semicolon

let user1 = User {
    active: true,
    username: String::from("Saileza")
};                                         // semicolon

// If the instance is mutable, we can change a value
//        by using the dot notation and assigning into a particular field

let mut user2 = User {
    active: true,
    username: String::from("Salza")
};

user2.username = String::from("Sagain, the compiler givileza Sharma");

// The entire instance must be mutable; Rust doesn’t allow us
//            to mark only certain fields as mutable.
//
// As with any expression, we can construct a new instance of the struct
//         as the last expression in the function body
//         to implicitly return that new instance.

// The following is a nice shorthand

fn build_user(username: String) -> User {
    User {
	active: true,
	username
    }
}

// create instances from other instances with struct update syntax

let user2 = User {
    active: false,
    ..user1                  // the other data are same as date of user1
};

// but now both user1.username and user2.username
//         point to the same heap memory (move instead of copy)

// Tuple structs don’t have names associated with their fields;
//         rather, they just have the types of the fields.

// Tuple structs are useful when you want to give the whole tuple a name
//         and make the tuple a different type from other tuples.

struct Color(i32, i32, i32);
struct Point(i32, i32, i32);

let black  = Color(0, 0, 0);
let origin = Point(0, 0, 0);

// Each struct you define is its own type, even though
//      the fields within the struct might have the same types.
//      For example, a function that takes a parameter of type Color
//      cannot take a Point as an argument, even though
//      both types are made up of three i32 values.

// Unit-like structs without any fields
//      can be useful when you need to implement a trait on some type
//      but don’t have any data that you want to store in the type itself. 

struct AlwaysEqual;             // behave similarly to ()

let subject = AlwaysEqual;

// Imagine that later we’ll implement behavior for this type
//      such that every instance of AlwaysEqual is always equal to
//      every instance of any other type, perhaps to have a known
//      result for testing purposes. We wouldn’t need any data to
//      implement that behavior!

// Accessing fields of a borrowed struct instance
//           does not move the field values, which is why
//           you often see borrows of structs

// Tuples and arrays can be printed directly with println! macro
//           using {:?} formatter

let tuple1 = (729, 2.18, true, "Roza");
println!("The tuple is: {0:?}", tuple1);            // print the tuple
println!("The name is: {0:?}", tuple1.3);           // print indexed element

// To extend this to structures we use

#[derive(Debug)]                                    // useful for debugging
struct Rectangle {
    length: usize,
    width : usize
}

let rect1 = Rectangle {
    length: 42,
    width : 36
};

println!("The struct instance is: {:?}", rect1);    // {:#?} for pretty print

// dbg! ()                 takes ownership of an expression 
// println! ()             takes reference

dbg!(&rect1);           // to allow using rect1 after this line
                        //          beccause dbg! takes ownership

/*
 * The above output uses the pretty Debug formatting of the Rectangle type.
 * The dbg! macro can be really helpful when you’re
 *          trying to figure out what your code is doing!
 */

// METHOD SYNTAX -----------------------------------------------------------

#[derive(Debug)]
struct User {
    active: bool,
    username: String
}

impl User {
    fn change_activity_status(&mut self) {         // mutable reference
	self.active = !self.active;
    }
}

/*
 * Things to note:
 * (1)    &self is actually short for self: &Self.
 * (2)    Methods must have a parameter named self of type Self
 *                for their first parameter, so Rust lets you
 *                abbreviate this with only the name self.
 * (3)    We still need to use the & in front of the self shorthand
 *                to indicate that this method borrows the Self instance.
 * (4)    Methods can take ownership of self, borrow self immutably,
 *                as we’ve done here, or borrow self mutably,
 *                just as they can any other parameter.
 * (5)    We can choose to give a method the same name
 *                as one of the struct’s fields.
 * (6)    Often, but not always, when we give a method the same name as
 *                a field we want it to only return the value in the field
 *                and do nothing else. Methods like this are called getters,
 * (7)    Automatic referencing and deferencing:
 *                When you call a method with object.something(),
 *                Rust automatically adds in &, &mut, or *
 *                so object matches the signature of the method.
 * (8)    All functions defined within an impl block are called associated
 *                functions. We can define associated functions that don’t
 *                have self as their first parameter (and thus are not
 *                methods) because they don’t need an instance (e.g. the
 *                String::from function that’s defined on the String type.
 * (9)    Associated functions that aren’t methods are often used for
 *                constructors that will return a new instance of the struct.
 *                These are often called new, but new isn’t a special name
 *                and isn’t built into the language.
 */

impl Rectangle {
    fn square(size: usize) -> Self {   
	Self {
	    length: size,
	    width : size
	}
    }
}

let sq = Rectangle::square(10);

// Each struct is allowed to have multiple impl blocks.

