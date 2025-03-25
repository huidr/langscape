// ====================================================
// CLOSURES ===========================================
// ====================================================

let add_one_v1 = |x| { x + 1 }; // compiler will infer types for its first usage
let add_one_v2 = |x| x + 1;     // an equivalent definintion; works because there is
                                //          only one expression in the closure body

let add_one_v3 = |mut x, mut y| { x += 1; y += 1; x * y}; 

let mut v = vec![1, 2, 3];
let immutable_borrow = || println!("{v:?}");          // immutable borrow
immutable_borrow();                                                 

let mut mutable_borrow = || v.push(4);             // mutable borrow
mutable_borrow();

// immutable_borrow(); // can't compile (cannot have an immutable and mutable borrowing at the same time)

// but the following compiles because it's a new immutable borrow
let echo = || println!("{v:?}");
echo();

// move keyword: useful in spawning threads
let take_ownership = move || println!("{v:?}");   // move keyword forces to take ownershipp
take_ownership();

// println!("{v:?}"); // won't work now

/*
 * Closures capture values from their environment in three ways,
 * which directly  map to the three ways a function can take a parameter
 * (1) immutable borrow (2) mutable borrow (3) taking ownership
 *
 * Closure decides which to use based on what the body does with the captured values
 *
 * A closure body can do any of the following:
 * (1) move a captured value out of the closure,
 * (2) mutate the captured value,
 * (3) neither move nor mutate the value,
 * (4) capture nothing from the environment to begin with. 
 */

// Some uses of closures

// Pass closures as arguments to higher-order functions like map, filter and fold
let v = vec![1, 2, 3];
let w: Vec<_> = v.iter().map(|x| x * 2).collect();

// Store closures in variables for future use: lazy evaluation?
let greet = || printlln!("Hello, world");
greet();

// Return closures from functions
fn create_multiplier(factor: i32) -> impl Fn(i32) -> i32 {
    move |x| x * factor
}

let doubler = create_multiplier(2);
let tripler = create_multiplier(3);
let mut a = 4;
println!("{}", doubler(a));

// Capture variables from their surrounding scope, either by reference or by value

let add_x = |x| x + a; // captures a, by reference
a = add_x(6);

let add_x = move |x| x + a; // capture a, by value
a = add_x(6);

// =============================================================
// Iterator ====================================================
// =============================================================

/*
 * iter(): burrows elements immutably (&T),
 *         use when you only need to scan/read data,
 *         original collection remains usable after iteration.
 *
 * iter_mut(): burrows elements mutably (&mut T)
 *             use when you need to modify elements in place,
 *             original collection remains usable but cannot be accessed during iteration.
 *
 * into_iter(): takes ownership of elements (T),
 *              use when you want to consume/transform the collection,
 *              original collection is no longer usable after iteration.
 */

let v = vec![1, 2, 3, 4, 5];
let vect: Vec<_> = v.iter().         // immutable borrow (&T)
    map(|x| x * x).                  // applies to each element in the iterator, returns an iterator
    filter(|&x| x > 5).              // pick only those elements returning true
    collect();                       // materialize into a vector, needs annotation such as Vec<_> or
                                     //                            .collect::<Vec<_>>()

let vect: Vec<_> = v.into_ter().     // v can be used again because it was not consumed
    map(|x| x * x).
    filter(|x| x > 5).
    collect();

// println!("{:?}", v); // v was already consumed

let v = vec![String::from("Vito"), String::from("Michael")];

let vect: Vec<_> = v.into_iter().    // consume v
    map(|x| x + " Huidrom").                  
    filter(|x| x.len() > 12).
    collect();

let v = vec![true, true, false, true, false, false, false, true];

let vect: Vec<_> = v.iter().         // immutable burrow (&T)
    map(|x| !x).                     // true -> false and false -> true
    filter(|&x| x).
    collect();

// .iter()             useful for read-only pipelines with map(), filter() and fold()
// .iter_mut()         rarely used with map(), filter() and fold()
// .into_iter()        powerful for transformations that consume data

// fold() reduces a collection to a single value by repeatedly applying an operation.

fn fold<B, F>(self, init: B, f: F)
where
    F: FnMut(B, Self::Item) -> B,

// init       initial accumulator value, like 0 for sums, Vec::new() for collecting
// f          closure that takes the accumulator (acc) and the current item,
//                                                     and returns a new accumulator

// Examples of fold()

