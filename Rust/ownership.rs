/*
 * ON STACK AND HEAP
 *
 * All data stored on the stack must have a known, fixed size.
 * Data with an unknown size at compile time or a size that might change
 *              must be stored on the heap instead.
 * 
 * On a stack, the data are stored close;
 * on a heap,  they are far away (takes more time to access or work with)
 * 
 * During function call, the arguments and function's local variables
 *             get pused onto the stack. When the function is over,
 *             those values get popped off the stack.
 *
 * The main prupose of ownership is to manage heap data.
 *
 * OWNERSHIP RULES
 * Each value in Rust has an owner.
 * There can only be one owner at a time.
 * When the owner goes out of scope, the value will be dropped.
 *
 * String type manages data allocated on the heap and as such
 *             is able to store an amount of text that
 *             is unknown to us at compile time.
 *
 * Rust calls drop function to free memory when variables go out of scope
 */



let mut s = String::from("hello");      // requests memory at runtime
s.push_str(", world!");                     

let mut s1 = String::from("string");
let s2 = s1;                            // move: Rust now considers s1 invalid

let s1 = String::from("new string");
/* 
 * the heap memory previously pointed to by s has been freed
 *          that is, the original string immediately goes out of scope
 */

let s2 = s1.clone();                    // like deep copy

// Passing a variable to a function will move or copy (like assignment).

// see the following........

fn main() {
    let s = String::from("hello");  // s comes into scope

    takes_ownership(s);             // s's value moves into the function...
                                    // ... and so is no longer valid here

    let x = 5;                      // x comes into scope

    makes_copy(x);                  // x would move into the function,
                                    // but i32 is Copy, so it's okay to still
                                    // use x afterward

} // Here, x goes out of scope, then s.
  // But because s's value was moved, nothing special happens.

fn takes_ownership(some_string: String) { // some_string comes into scope
    println!("{some_string}");
} // Here, some_string goes out of scope and `drop` is called.
  // The backing memory is freed.

fn makes_copy(some_integer: i32) { // some_integer comes into scope
    println!("{some_integer}");
} // Here, some_integer goes out of scope. Nothing special happens.

/*
 * Consider cloning a String before sending it to a function as argument
 *          if you still want to use it after the call
 *
 * The ownership of a variable follows the same pattern every time:
 *          assigning a value to another variable moves it.
 * 
 * When a variable that includes data on the heap goes out of scope,
 *          the value will be cleaned up by drop unless
 *          ownership of the data has been moved to another variable.
 */

// Rust does let us return multiple values using a tuple.

// REFERENCE -------------------------------------------------------------

// We may use references to pass the arguments, so that
//          the parameter does not take ownership of the value


fn calculate (s: &String) -> usize {  // reference
    // body                           // allows referring to some value
}                                     // without taking ownership

calculate_len(&s1);                   // function call using reference

// borrowing: the action of creating a reference
//            (because you don't own it, you only borrow)

// can't modify something we're borrowing

// mutable references allows modifying borrowed values

fn main() {
    let mut s = String::from("hello");       // necessary to be mutable

    change(&mut s);
}

fn change(some_string: &mut String) {
    some_string.push_str(", world");
}

/* At any given time, you can have either one mutable reference
 *        or any number of immutable references.
 *       
 * This prevents data race: two or more pointers simultaneously
 *        trying to modify the same value without any sync.
 *  
 * A reference’s scope starts from where it is introduced and 
 *        continues through the last time that reference is used.
 */

let mut s = String::from("hello");

let r1 = &s; // no problem
let r2 = &s; // no problem
println!("{r1} and {r2}");
// variables r1 and r2 will not be used after this point

let r3 = &mut s; // no problem
println!("{r3}");

// SLICE ---------------------------------------------------------------

// A string slice is a reference to part of a String

let s = String::from("Saileza is my girlfriend");

let saileza    = &s[..7];            // [0..7]
let girlfriend = &s[14..];           // [14..24]

// Defining a function to take a string slice
//          instead of a reference to a String makes our API
//          more general and useful without losing any functionality

fn funct(s: &str) -> &str {
    // body
}

// The concepts of ownership, borrowing, and slices
//     ensure memory safety in Rust programs at compile time.






