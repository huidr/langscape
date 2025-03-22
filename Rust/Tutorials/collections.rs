// COLLECTIONS ------------------------------------------------------------

// https://doc.rust-lang.org/std/vec/struct.Vec.html

/*
 * Vectors: 
 *    1. elements of same type
 *    2. all values next to each other in memory
 */

let mut v: Vec<i32> = Vec::new(); // type annotation

let v = vec![1, 2, 3];            // type inference

// pushing elements
let mut v = Vec::new();
v.push(5);                        // type inference

let mut x = v.pop().unwrap();     // because v.pop() returns Some<T>
x = v.pop().unwrap_or(0);         // if v is empty, it returns None

// reading elements
let element: &i32 = &v[2];        // annotation not necessary
                                  // Using & and [] gives us a reference

let x = &mut v[1];                // want to modify the value
x = 4;

let element: Option<&i32> = v.get(2);  // we get Option<&T>

let x = v.get(0).unwrap_or(&0);   // &0; because it returns Option<&T>

// we can use Option<&T> with match
match element {
    Some(third) => println!("The element is {third}.");
    None => println!("There is no element at that index.");
}

/* 
 * The first [] method will cause the program to panic
 * when it references a nonexistent element. 
 * This method is best used when you want your program to crash
 * if there’s an attempt to access an element past
 * the end of the vector.
 * 
 * When the get method is passed an index that is outside the vector,
 * it returns None without panicking.
 * You would use this method if accessing an element beyond
 * the range of the vector may happen occasionally
 * under normal circumstances. Your code will then have logic
 * to handle having either Some(&element) or None
 */

// cannot have a mutable and an immutable reference in the same scope:
// the following code does not compile

let mut v = vec![1, 2, 3, 4, 5];

let first = &v[0];       // immutable reference to the first element

v.push(6);               // mutable borrow
println!("{:?}", v);     // compiles until here

println!("{}", first);   // immutable borrow again

/*
 * because vectors put the values next to each other in memory,
 * adding a new element onto the end of the vector might require
 * allocating new memory and copying the old elements to the new space,
 * if there isn’t enough room to put all the elements
 * next to each other where the vector is currently stored.
 * In that case, the reference to the first element
 * would be pointing to deallocated memory.
 */

// iterating over a vector . . .

let v = vec![1, 2, 3, 4, 5];

for i in &v {                       // immutable reference
    println!("{v}");
}

let mut v = vec![1, 2, 3, 4, 5];

for i in &mut v {                   // mutable reference
    *i += 50;                       // deference (using asterisk)
}

/*
 * Iterating over a vector, whether immutably or mutably,
 * is safe because of the borrow checker’s rules.
 * The reference to the vector that the for loop holds prevents
 * simultaneous modification of the whole vector.
 */

// Iterating over a vector directly (not using reference) takes ownership, and
//                  vector ceases to exist after the iteration
   
// using an enum to store multiple types . . .

enum SpreadsheetCell {
    Int(i32),
    Float(f64),
    Text(String),
}

let row = vec![
    SpreadsheetCell::Int(24),
    SpreadsheetCell::Text(String::from("Saileza")),
    SpreadsheetCell::Float(12.8),
]

/*
 * Rust needs to know what types will be in the vector at compile time
 * so it knows exactly how much memory on the heap will be needed to
 * store each element.
 *
 * We must also be explicit about what types are allowed in this
 * vector. If Rust allowed a vector to hold any type, there would be
 * a chance that one or more of the types would cause errors with
 * the operations performed on the elements of the vector.
 * Using an enum plus a match expression means that Rust will ensure
 * at compile time that every possible case is handled.
 */

// Like any other struct, a vector is freed when it goes out of scope.

{
    let v = vec![1, 2, 3, 4, 5];
    
    // do stuff
} // v goes out of scope and is freed here

/*
 * When the vector gets dropped, all of its contents are also dropped,
 * meaning the integers it holds will be cleaned up.
 * The borrow checker ensures that any references to contents of a
 * vector are only used while the vector itself is valid.
 */

// --------------------------------------------------------------------
    
// String
    
/* 
 * Rust has only one string type in the core language: string slice str,
 * that is usually seen in its borrowed form &str.
 * 
 * string slices are references to some UTF-8 encoded string data
 * stored elsewhere.
 * string literals are stored in the program’s binary
 * and are therefore string slices.
 *
 * The String type, which is provided by Rust’s standard library
 * rather than coded into the core language, is a growable, mutable,
 * owned, UTF-8 encoded string type.
 */
  
/*
 * Many of the same operations available with Vec<T> are available with
 * String as well because String is actually implemented as a wrapper
 * around a vector of bytes with some extra guarantees,
 * restrictions, and capabilities.
 */

let mut s = String::new();

// to_string() can also be used on any type that implements
// the Display trait (e.g. string literals)

let data = "initialization";

let mut s = data.to_string();          // s is mutable String type

let mut s = "initialization".to_string();

let mut s = String::from("initialization");   // equivalent to above

// Since strings are UTF-8 encoded, so we can include
// any properly encoded data in them

let hello = String::from("Здравствуйте");

// Updating a string . . .

let mut s = String::from("existentialism");

s.push_str(" is ");       // to append a string slice

// The push_str() method takes a string slice because we don’t
// necessarily want to take ownership of the parameter.

let ss = " is humanism.";
s.push_str(ss);
println!("ss is {ss}");   // legal, because push_str does not take
                          // ownership of ss

let mut s = "hell";

s.push('o');              // push() takes a single character

let s1 = String::from("Hello, ");
let s2 = String::from("world!");
let s3 = s1 + &s2;                  // s1 has been moved here
                                    // and can no longer be used

// The + operator uses the add method,
// whose signature looks something like this:

fn add(self, s: &str) -> String {
    //;
}

// that is, we can only add &str to String

/*
 * The reason we’re able to use &s2 in the call to add is that
 * the compiler can coerce the &String argument into a &str.
 * When we call the add method, Rust uses a deref coercion,
 * which here turns &s2 into &s2[..].
 * Because add does not take ownership of the s parameter,
 * s2 will still be a valid String after this operation.
 *
 * We can see in the signature that add takes ownership of self
 * because self does not have an &. This means s1 will be moved into
 * the add call and will no longer be valid after that.
 * So, although let s3 = s1 + &s2; looks like it will copy both strings
 * and create a new one, this statement actually takes ownership of s1,
 * appends a copy of the contents of s2, and then
 * returns ownership of the result.
 * In other words, it looks like it’s making a lot of copies,
 * but it isn’t; the implementation is more efficient than copying.
 */

// For combining strings in more complicated ways,
// we can instead use the format! macro:

let s1 = String::from("tic");
let s2 = String::from("tac");
let s3 = String::from("toe");

let s  = format!("{s1}-{s2}-{s3}");        // works like println!

/*
 * format! works like println! but instead of printing to the screen,
 * it returns a String with the contents.
 *
 * The code generated by the format! macro uses references so that
 * this call doesn’t take ownership of any of its parameters.
 */

// Rust strings don’t support indexing

// Slicing strings . . .

/* Indexing into a string is often a bad idea because it’s not clear
 * what the return type of the string-indexing operation should be:
 * a byte value, a character, a grapheme cluster, or a string slice.
 *
 * If you really need to use indices to create string slices,
 * therefore, Rust asks you to be more specific.
 */

// Use [] with a range to create a string slice
// containing particular bytes:

let hello = "hello";             // each character here is of one byte
let s     = &hello[0..4];        // s will be "hell"

let hello = "Здравствуйте";      // each character here is of two bytes
let s     = &hello[0..4];        // s will be a &str that contains
                                 // the first four bytes of the string
                                 // so, s will contain "Зд"

let s     = &hello[0..1];        // Rust will panic at runtime

// Use caution when creating string slices with ranges,
// because doing so can crash your program.

// Methods for iterating over strings

/*
 * The best way to operate on pieces of strings is to be
 * explicit about whether you want characters or bytes.
 *
 * For individual Unicode scalar values, use the chars method.
 */

for c in "Здравствуйте".chars() {
    // snip;
}

let s = "ꯁꯥꯏꯂꯦꯖꯥ ꯍꯤꯗꯥꯡꯃꯌꯨꯝ";

for c in s.chars() {
    // snip;
}

// The bytes method returns each raw byte,
// which might be appropriate for your domain:

for s = String::from("ꯁꯥꯏꯂꯦꯖꯥ ꯍꯤꯗꯥꯡꯃꯌꯨꯝ");

for c in s.bytes() {
    // snip
}

// Be sure to remember that valid Unicode scalar values
// may be made up of more than one byte.

/*
 * Getting grapheme clusters from strings, as with the Devanagari,
 * is complex, so this functionality is not provided by the standard
 * library. Crates are available on crates.io if this is the
 * functionality you need.
 */

// ---------------------------------------------------------------------

// Hash maps

/*
 * The type HashMap<K, V> stores a mapping of
 * keys of type K to values of type V using a hashing function,
 * which determines how it places these keys and values into memory.
 */

use std::collections::HashMap;

let mut scores = HashMap::new();

scores.insert(String::from("Blue"), 10);
scores.insert(String::from("Green"), 40);

/*
 * Hash maps have less support from the standard library;
 * there’s no built-in macro to construct them.
 *
 * Just like vectors, hash maps store their data on the heap.
 * Like vectors, hash maps are homogeneous: all of the keys must have
 * the same type, and all of the values must have the same type. 
 */

// Accessing values in a hash map . . .

let team_name = String::from("Blue");
let score = scores.get(&team_name).copied().unwrap_or(0);

/*
 * The get method returns an Option<&V>;
 * if there’s no value for that key in the hash map,
 * get will return None.
 *
 * The above program handles the Option by calling copied()
 * to get an Option<i32> rather than an Option<&i32>,
 * then unwrap_or() to set score to zero if scores
 * doesn’t have an entry for the key.
 */

for (key, value) in &scores {        // iterating over a hash map
    println!("{key}: {value}");      // in arbitrary order
}

// note:

let v: Option<i32> = Some(28);       // v is Some(28)
let w: i32 = v.unwrap_or(0);         // w is 28

let v: Option<i32> = None;           // v is None
let w: i32 = v.unwrap_or(0);         // w is 0

/*
 * For types that implement the Copy trait, like i32,
 * the values are copied into the hash map.
 * 
 * For owned values like String, the values will be moved and
 * the hash map will be the owner of those values:
 */

use std::collections::HashMap;

let field_name  = String::from("Favorite color");
let field_value = String::from("Blue");

let mut map = HashMap::new();
map.insert(field_name, field_value);         // ownership

// field_name and field_value are invalid at this point;
// they’ve been moved into the hash map with the call to insert.

// the above situation does not happen for i32 or types
// that implement the Copy trait.

/*
 * If we insert references to values into the hash map,
 * the values won’t be moved into the hash map.
 * The values that the references point to must be valid
 * for at least as long as the hash map is valid.
 */

// We could have done:

map.insert(field_name.clone(), field_value.clone());

// or pass references:

map.insert(&field_name, &field_value);

// Updating a hash map . . .

/* Each unique key can only have one value associated with it at a time
 * but not vice versa.
 *
 * When you want to change the data in a hash map, you have to decide
 * how to handle the case when a key already has a value assigned.
 * (1) You could replace the old value with the new value,
 *     completely disregarding the old value.
 * (2) You could keep the old value and ignore the new value, only
 *     adding the new value if the key doesn’t already have a value.
 * (3) Or you could combine the old value and the new value. 
 */

use std::collections::HashMap;

let mut scores = HashMap::new();

scores.insert(String::from("Blue"), 10);
scores.insert(String::from("Blue"), 20);    // replaces the old value

println!("{scores:?}");

// in the following, checks if the key exists;
// otherwise, insert

scores.entry(String::from("Blue")).or_insert(30);
scores.entry(String::from("Yellow")).or_insert(50);

/* 
 * The or_insert() method on entry() is defined to return
 * a mutable reference to the value for the corresponding entry key
 * if that key exists, and if not, it inserts the parameter
 * as the new value for this key and returns
 * a mutable reference to the new value. 
 */


// to look up a key’s value and then
// update it based on the old value . . .

use std::collections::HashMap;

let text = "hello wonderful hello world";

let mut map = HashMap::new();

// counting word counts of each unique word in text
for word in text.split_whitespace() {      // process each word
    let count = map.entry(word).or_insert(0);
    *count += 1;     // because a mutable reference is returned
                     // by or_insert() method on entry() method
}

/*
 * The split_whitespace method returns an iterator over subslices,
 * separated by whitespace, of the value in text.
 * The or_insert method returns a mutable reference (&mut V)
 * to thevalue for the specified key.
 */
