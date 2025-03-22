// ======================================================
// GENERICS =============================================
// ======================================================

#[derive(Debug)]
struct Point<X1, Y1> {
    a: X1,
    b: Y1,
}

impl<X1, Y1> Point<X1, Y1> {      
    fn createnew<X2, Y2> (self, other: Point<X2, Y2>) -> Point<X1, Y2> {  // cannot write &self
	Point {                             // cannot write Point<X1, Y2
	    a: self.a,
	    b: other.b,
	}
    }
}

fn main() {
    let object_one = Point {
	a: 37,
	b: String::from("Rust"),
    };
    let object_two = Point {
	a: String::from("Programming"),
	b: true,
    };	
    let object_three = object_one.createnew(object_two);       // object_one and object_two cannot be used again
    // let object_three = Point::createnew(object_one, object_two);  // this will work the same way

    println!("{:?}", object_three);
}

// =========================================================
// TRAITS ==================================================
// =========================================================

// Traits are like interfaces in Java

pub trait Summary {         // pub, because we want this to be visible from outside this module
    fn summarize(&self) -> String;    // no definition, waiting for an implementer, observe the semi-colon
}

pub struct Newspaper {
    title: String,
    editor: String,
    id: u32,
}

pub struct Team {
    name: String,
    captain: String,
    champion: bool,
}

// then, in the same or another module
impl Summary for Newspaper {
    fn summarize(&self) -> String {
	format!("title: {}, editor: {}, id: {}", self.title, self.editor, self.id) // Returns String, not &str
    }
}

impl Summary for Team {
    fn summarize(&self) -> String {
	format!("name: {}, captain {}, champion {}", self.name, self.captain, self.champion)
    }
}

fn main() {
    let newspaper = Newspaper {
	title: "Huiyen Lampao".to_string(), // Need String type
	editor: "Hemanta".to_string(),
	id: 34,
    };
    let team = Team {
	name: "Chennai Super Kings".to_string(),
	captain: "MS Dhoni".to_string(),
	champion: true,
    };
    println!("{}", newspaper.summarize());
    // The following also works the same
    println!("{}", Summary::summarize(&newspaper)); // Need &newspaper as argument
    println!("{}", team.summarize());
}

/* We can implement a trait on a type only if either the trait or the type, or both, are local to our crate.
 *        For instance, implement Display on Newspaper or Summary on Vec<T>
 * But we can't implement external traits on external types, like Display on Vec<T> because both
 *        are defined in standard library and not local to our crate.
 * This rule ensures that other people's code can't break our code and vice versa. Otherwise,
 *        two crates could implement the same trait for the same type and Rust will not know
 *        which implementation to use.
 */

// Default implementation: use it or override it

pub trait Summary {
    fn summarize(&self) -> String {                // use this if not overriden
	format("This is the default output")
    }
}

impl Summary for Newspaper {}                      // use default, need to put the braces {}

/*
 * Default implementations can call other methods in the same trait, even if
 *         those other methods don't have a default implementation.
 */

pub trait Summary {
    fn summarize_name(&self) -> String;
    
    fn summarize(&self) -> String {                                 // default implementation
	format!("The string is then {}", self.summarize_name())
    }
}

impl Summary for Newspaper {
    fn summarize_name(&self) -> String {                            // implemented summarize_name
	format!("{}", self.title)
    }
}

// Now, we can call summarize(&newspaper)

// ==========================================
// TRAITS as PARAMETERS =====================
// ==========================================

pub fn notify(item: &impl Summary) {   // the argument must be of any type for which
                                       // the Summary trait is implemented 
    // snippet
    // here, we can call any methods on item that come from the Summary trait,
    //                                                      such as summarize
}

// The above is a syntax sugar for a longer form known as trait bound

// TRAIT BOUND . . .

pub fn notify<T: Summary>(item: &T) {
    //
}

// Look at the following

pub fn notify(item1: &impl Summary, item2: &impl Summary) {  // item1 and item2 can be of any types
                                                             // for which Summary trait is implemented
    //
}

// What if we want to restrict item1 and item2 to be of the same type?
// Answer: we use trait bound

pub fn notify<T: Summary>(item1: &T, item2: &T) {            // item1 and item2 are now of the same type T
    //
}

// SPECIFY MULTIPLE TRAIT BOUNDS WITH + SYNTAX

pub fn notify(item: &(impl Summary + Display )) {
    //
}

pub fn notify<T: Summary + Display>(item: &T) {
    //
}

// Clearer TRAIT BOUNDS with WHERE clauses

// Instead of writing

fn somefunction<T: Summary + Display, U: Display + Debug>(t: &T, u: &U) -> u32 {
    //
}

// we can write, using where clause:

fn somefunnction<T, U>(t: &T, u: &U) -> u32
where
    T: Summary + Display,
    U: Display + Debug,
{
    //
}

// Returning Types that implement Traits

fn returns_summarizable() -> impl Summary {
    //                                        // but this can return only one Type that implements Summary
}

// ===================================================
// LIFETIME ANNOTATIONS ==============================
// ===================================================

// Every reference has a lifetime and we need to specify lifetime parameters
//                                for functions or structs that use references

fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {  // The returned reference will be valid as long as
                                                     // both the parameters are valid     
    /* The function signature tells Rust that
     * for some lifetime 'a, the function takes
     * two parameters, both live as least as long as
     * the lifetime 'a, and that the returned string slice
     * lives as at least as long as lifetime 'a.
     */
}

/* When returning a reference from a function,
 *                the lifetime parameter for the return type needs to match
 *                the lifetime parameter for one of the parameters
 *
 * If the reference returned does not refer to one of the parameters,
 *                it must refer to a value created within the function.
 *                However, this would be a dangling reference. => compilation error
 *
 * This way, Rust prevents dangling references and allow only memory-safe operations.
 */

// Lifetime annotations in struct definitions . . .

/*
 * structs can hold references, but in that case we need a lifetime annotation
 *                              on every reference in the stuct's definition
 */

struct Excerpt<'a> { // an instance of Excerpt cannot outlive the reference it holds in its part field
    part: &'a str,
}

// Lifetime elision . . .

/*
 * In certain cases, compiler allows not specifying lifetime annonations: it infers
 *
 * Input  := parameters in the function
 * Output := the returned
 *
 * Some rules about how compiler assigns lifetime annotations
 * (1) Compiler assigns a lifetime parameter to each parameter which is a reference
 * (2) If there is only one input lifetime parameter,
 *              that lifetime is assigned to all output lifetime parameters
 * (3) If there are multiple input parameters and one of them is &self or &mut self,
 *              the lifetime of self is assigned to all output lifetime parameters
 *
 * This is why the following will result in a compile error,
 *              because the compiler can't infer the lifetime parameter of the output
 */

fn function(x: &str, y: &str) -> &str {        // won't compile
    //
}

/*
 * In the above, by rule (1), compiler assigns x: &'a str, y: &'b str
 *               rule (2) doesn't apply because there are multiple inputs
 *               rule (3) doesn't apply either, because there is no &self or &mut self
 * So, the compiler can't infer the lifetime parameter of the output,
 *               hence the compilation error
 */

// Lifetime annotations in method definitions . . .

impl<'a> Excerpt<'a> {  // Put lifetime annotations after impl and then after struct name
    fn level(&self) -> i32 {
	3
    }
}

// the thid rule applies to the following case:

impl<'a> Excerpt<'a> {
    fn announce(&self, a: &str) -> &str {
	self.part
    }
}

// The static lifetime . . .

/*
 * All string literals have static lifetime: entire duration of the program
 * The text of the literal is stored directly in the binary.
 */

let s: &'static str = "I have a static lifetime.";

