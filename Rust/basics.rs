// RUST BASICS ---------------------------------------------------

// COMPILATION, RUN, CARGO ---------------------------------------

/*
 * Shell commands:
 *
 * rustc --version
 * cargo --version
 *
 * rustc main.rs                 // compile
 * ./main                        // run the binary executable
 *
 * cargo new hello_cargo         // new project
 *
 * cd hello_cargo                // inside the project directory
 * cargo build                   // compile
 * ./target/debug/hello_world    // run (the executable lives here)       
 *
 * cargo build --release         // final compilation
 * ./target/release/hello_world  // run (the final executable lives here)
 *
 * cargo run                     // compile and run
 *
 * cargo check                   // check if compilable
 */

// VARIABLES -----------------------------------------------------

let x = 5;                               // immutable, de default
let mut y = 5;                           // mutable     

let x = x + 1;                           // shadowing (redefining)
{
    x = x * 2;                           // shadowing (block slope)
}

let spaces = "   ";                      // use of shadowing
let spaces = spaces.len();               // no need to define another variable

let x: char = 'x';                       // type annotation

const MAX_HEIGHT: u32 = 100_000;         // const must always be annotated

// DATA TYPES ----------------------------------------------------

// integer signed types:   i8, i16, i32, i64, i128, isize
// integer unsigned types: u8, u16, u32, u64, u128, usize

// decimal           1_000_000
// hex               0xff
// octal             0o77
// binary            0b1111_0000
// byte (u8 only)    b'A'

// float single precision:  f32
// float double precision:  f64  (default)

// five arithmetic operations:  +  -  *  /  %
// integer division / truncates near to 0

// booleans are one byte in size:  true  false

// char is 4 bytes, represents a Unicode Scalar Value
// hence can represent much more than just ASCII,
// including Chinese, Japanese and Korean characters; and emoji

// tuples are fixed length, can contain different data types

let tup: (u16, char, bool) = (12, 'A', true);      // annotation not necessary

let a = tup.0                                      // indexing
let (x, y, z) = tup;                               // destructuring

// arrays are fixed length and contain the same data type

let days = ["Sunday", "Monday", "Tuesday", "Wednesday",
	    "Thursay", "Friday", "Saturday"];

let a: [u32; 5] = [124, 166, 582, 2, 8];           // annotation [type; size]

let a = [3; 5];                                    // [3, 3, 3, 3, 3]

let first = a[0];                                  // access by indexing

// FUNCTIONS -----------------------------------------------------

fn add(x: u64, y: u64) -> u64 {           // parameter annotation necessary
    x + y                                 // no semicolon, implicit return
}

/*
 * statements vs expressions
 * statement performs some action but do not return any value
 * expression evaluates to a result and hence can be assigned to a variable
 * 
 * expressions dont end in semicolons
 */

// a block as an expression
let y = {
    let x = 5;
    x + 1
};

// CONTROL FLOW --------------------------------------------------

// if, if else, if else if:  condition must be a bool
// Rust do not automatically convert non-bool into bool

if y > 5 {
    println!("Greater");
} else if y < 5 {
    println!("Lesser");
} else {
    println!("Perfect");
}

/* using if in let statement (because if is an expression)
 * 
 * blocks evaluate to the last expression in them
 * numbers by themselves are also expressions
 *
 * data types in if, else if and else parts must match
 *     (variable data type must be known at compile time)
 */

let number = if y > 5 { 12 } else if y < 5 { 22 } else { 2 };

// loop: forever until you explicitly tell it to stop

loop {
    println!("Infinite... ");
}

// returning values from loops
// add the value you want returned after the break

let mut counter = 0
let result = loop {
    counter += 1;

    if counter == 10 {
	break counter * 2;              // semi-colon
    }
};                                      // semi-colon

/*
 * You can also return from inside a loop.
 * While break only exits the current loop,
 *       return always exits the current function.
 */

// loop labels to disambiguate between multiple loops

let mut count = 0;
'label: loop {                          // labelled
    // . . .
    loop {                              // inner loop
	// . . .
	if true {
	    break;                      // break the inner loop
	}
	else {
	    break 'label;
	}
    }
}

// while loop

while x > 5 {
    // body
}

// for loop: good for iterating over a collection

let a = [10, 20, 30, 40, 50];
for element in a {
    // body
}

// for loop and range start..end

for number in 0..5 {                  // 0, 1, 2, 3, 4
    println!("{number}");
}

for number in (0..5).rev() {          // 4, 3, 2, 1, 0 (reverse)
    println!("{number}");
}

