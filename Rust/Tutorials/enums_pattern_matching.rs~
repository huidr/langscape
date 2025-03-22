// ENUMS ------------------------------------------------------------------

// Enums give you a way of saying a value is one of a possible set of values.

enum IpAddressVariant {                 // a custom data type
    V4,                                 // with two possible values
    V6,
}

let four = IpAddressVariant::V4;        // declare value

fn route(ip_variant: IpAddressVariant) {}   // functing accepting enum object

route(IpAddressVariant::V6);            // function call

// Can put data directly into each enum variant.
// Each enum variant can have different data associated with them.

enum IpAddress {
    V4(u8, u8, u8, u8),
    V6(String),
}

// then IpAddress::V4() acts like a constructor
let home     = IpAddress::V4(127, 0, 0, 1);         
let loopback = IpAddress::V6(String::from("::1"));

// Can put any kind of data inside an enum variant
//         (can even include another enum)

struct Ipv4Addr {
    // --snip--
}

struct Ipv6Addr {
    // --snip--
}

enum IpAddr {
    V4(Ipv4Addr),
    V6(Ipv6Addr)
}

// An enum whose variants each store different amounts and types of values:

enum Message {
    Quit,
    Move{x: i32, y: i32},           // has named fields, like a struct does
    Write(String),                  // includes a single String
    ChangeColor(i32, i32, i32)      // includes three i32 values
}

// The above enum is similar to having four structs:

struct QuitMessage;                 // unit struct
struct MoveMessage {
    x: i32,
    y: i32
}
struct WriteMessage(String);                 // tuple struct
struct ChangeColorMessage(i32, i32, i32);    // tuple struct

// Another similarity between enums and structs: can define methods

impl Message {
    fn call(&self) {
	// body
    }
}

let m = Message::Write(String::from("Devil May Cry"));
m.call();

// Rust doesn’t have the null feature that many other languages have.
// Null is a value that means there is no value there.
// In languages with null, variables can always be in
//              one of two states: null or not-null.

// Option Enum is defined by the standard library and
//             can encode the concept of a value being present or absent.

enum Option<T> {              // defined in standard library
    None,
    Some(T),
}

// The Option<T> enum is so useful that it’s even included in the prelude;
//               you don’t need to bring it into scope explicitly.
// Its variants are also included in the prelude: you can use Some and None //               directly without the Option:: prefix.
// The Option<T> enum is still just a regular enum, and Some(T) and None
//               are still variants of type Option<T>.

let some_number = Some(5);           // type of some_number is Option<i32>
let some_char   = Some('e');         // type of some_char   is Option<char>

// In the above, Rust can infer these types because
//        we’ve specified a value inside the Some variant.
// For absent_number, Rust requires us to annotate the overall Option type:
//        the compiler can’t infer the type by looking only at a None value.

let absent_number: Option<i32> = None;

// Option<T> has advantages over null values

// Becoming familiar with the methods on Option<T> will be
//          extremely useful in your journey with Rust.

// MATCH CONTROL FLOW ------------------------------------------------------

enum Coin {
    Penny,
    Nickel,
    Dime,
    Quarter,
}

fn value_in_cents(coin: Coin) -> u8 {
    match coin {
	Coin::Penny   =>  1,
	Coin::Nickel  =>  5,
	Coin::Dime    => 10,
	Coin::Quarter => 25,
    }
}

// The match construct performs pattern matching and returns
//           the expression on the right when a correct matching is found

fn value_in_cents(coin: Coin) -> u8 {
    match coin {
        Coin::Penny => {
            println!("Lucky penny!");       // will print this
            1                               //      but return 1
        }
        Coin::Nickel => 5,
        Coin::Dime => 10,
        Coin::Quarter => 25,
    }
}

// Another useful feature of match arms is that they can bind
//         to the parts of the values that match the pattern.
//         This is how we can extract values out of enum variants.

#[derive(Debug)]
enum UsState {
    Alabama,
    Alaska,
    // --snip--
}

enum Coin {
    Penny,
    Nickel,
    Dime,
    Quarter(UsState),
}

// In the match expression for this code, we add a variable called state
//        to the pattern that matches values of the variant Coin::Quarter.
// When a Coin::Quarter matches, the state variable will bind to the value
//        of that quarter’s state.

fn value_in_cents(coin: Coin) -> u8 {
    match coin {
	Coin::Penny => 1,
	Coin::Nickel => 5,
	Coin::Dime => 10,
	Coin::Quarter(state) => {
	    println!("State quarter from {state:?}");
	    25
	}
    }
}

// Matching with Option<T>
//          We want to write a function that takes an Option<i32> and,
//          if there’s a value inside, adds 1 to that value.
//          If there isn’t a value inside, the function should
//          return the None value and not attempt to perform any operations.

fn plus_one(x: Option<i32>) -> Option<i32> {
    match x {
	None => None,
	Some(i) => Some(i + 1),
    }
}

let five = Some(5);
let six  = plus_one(five);
let none = plus_one(None);

// Combining match and enums is useful in many situations.
// You’ll see this pattern a lot in Rust code: match against an enum,
//        bind a variable to the data inside, and then
//        execute code based on it.

// Matches are exhaustive:
//        The arms’ patterns must cover all possibilities.
//        Otherwise, we get a compilation error.

// Catch-all Patterns and the _Placeholder:
//        To match the other possibilities not specified

let dice_roll = 4;
match dice_roll {
    2 => add_fancy_hat(),
    3 => remove_fancy_hat(),
    other => move_player(other),      // must be put last (top-down order
}                                     //                   evaluation

// Catch-all: use _ so that the compiler doesn't warn about being unused

match dice_roll {
    2 => // --snip--
    3 => // --snip--
    _ => ()                           // () means do nothing
}

// The if let syntax lets you combine if and let into a less verbose way
//     to handle values that match one pattern while ignoring the rest.

let config_max = Some(3u8);
match config_max {
    Some(max) => println!("The maximum is configured to be {max}"),
    _ => (),
}

// The above can be concisely written as

let config_max = Some(3u8);
if let Some(max) = config_max {
    println!("The maximum is configured to be {max}");
}

// The syntax if let takes a pattern and an expression separated by
//     an equal sign. It works the same way as a match.
// In this case, the pattern is Some(max), and the max binds to the value
//     inside the Some. We can then use max in the body of the if let block
//     in the same way we used max in the corresponding match arm.
// The code in the if let block isn’t run if
//     the value doesn’t match the pattern.

// Think of if let as syntax sugar for a match that runs code when
//     the value matches one pattern and then ignores all other values.

// if let and else construct

let mut count = 0;
match coin {
    Coin::Quarter(state) => println!("State quarter from {state:?}!"),
    _ => count += 1,
}

// The above may be rewritten as

let mut count = 0;
if let Coin::Quarter(state) = coin {
    println!("State quarter from {state:?}!");
} else {
    count += 1;
}

// SUMMARY -----------------------------------------------------------------

// When enum values have data inside them, you can use match or if let
//      to extract and use those values, depending on how many cases
//                                                you need to handle.

