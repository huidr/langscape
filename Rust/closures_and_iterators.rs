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

