/// Concurrency in Rust

// use std::thread::spawn // to spawn threads
use std::thread;

// pass a closure to be run in that thread
thread::spawn(|| {
    // snippet
});

// The return type of thread::spawn is JoinHandle
// A JoinHandle is an owned value that,
// when we call the join method on it,
// will wait for its thread to finish. 
let handle = thread::spawn(|| {
    // snippet
});

// main thread awaits until the spawn thread is finished
handle.join().unwrap();

// move keyword in spawn
// force the closure to take ownership
let name = "Rust".to_string();

let handle = thread::spawn(move || {
    println!("Hello, I am {}.", name);
});

// Message passing to transfer data between threads -----------------------
// mpsc: multiple producers, single consumer
use std::sync::mpsc;

// tx: transmitter
// rx: receiver
let (tx, rx) = mpsc::channel();       // tuple destructuring

thread::spawn(move || {
    let val = "Rust from spawned thread".to_string();
    tx.send(val).unwrap();
});

let received = rx.recv().unwrap();
println!("Received: {}", received);

// receiver has two useful methods: recv and try_recv
// recv blocks the main thread's exectution and wait
// until a value is sent down the channel.
// recv will return it in a Result<T, E>.
// When the transmitter closes, recv will return an error
// to signal that no more values will be coming.

// try_recv doesn’t block, but will instead return
// a Result<T, E> immediately
let received = rx.try_recv().unwrap();
println!("Received: {}", received);

// sending multiple values ------------------------------------------------
let (tx, rx) = mpsc::channel();

thread::spawn(move || {
    let vals = vec![
	String::from("hi"),
	String::from("from"),
	String::from("the"),
	String::from("thread"),
    ];
    
    for val in vals {
        tx.send(val).unwrap();
	thread::sleep(Duration::from_secs(1));
    }
});

// treating rx as an iterator.
// For each value received, we’re printing it.
// When the channel is closed, iteration will end.
for received in rx {
    println!("Got: {received}");
}

// creating multiple producers by cloning the transimitter
let (tx, rx) = mpsc::channel();

// clone; to be moved to a thread
let tx1 = tx.clone();
thread::spawn(move || {
    let vals = vec![
	"some".to_string(),
	"messages".to_string(),
    ];

    for val in vals {
	tx1.send(val).unwrap();
	thread::sleep(Duration::from_secs(1));
    }
});

thread::spawn(move || {
    let vals = vec![
	"more".to_string(),
	"messages".to_string(),
    ];

    for val in vals {
	tx.send(val).unwrap();
	thread::sleep(Duration::from_secs(1));
    }
});

for received in rx {
    println!("Received: {received}");
}

// shared-state concurrency ---------------------------------------------

// multiple threads accessing the same shared data
// mutex: mutual exclusion

// mutexes have two rules
// 1. You must attempt to acquire the lock before using the data.
// 2. When you’re done with the data that the mutex guards,
//    you must unlock the data so other threads can acquire the lock.
use std::sync::Mutex;

// Mutex<T> is a smart pointer in Rust's standard library
// that ensures only one thread can access the data at a time.

// It provides interior mutability, meaning it lets you change
// its contents even if the outer structure is immutable.

// let m = Mutex::<i32>::new(4);
let m = Mutex::new(4);

{
    // After we’ve acquired the lock, we can treat the return value,
    // named num in this case, as a mutable reference to the data inside
    let mut num = m.lock().unwrap();
    *num = 8;              // Mutex<T> is a smart pointer

    // the smart pointer also has a Drop implementation that releases
    // the lock automatically when it goes out of scope.
}

println!("m = {m:?}");

/*
 * The type system ensures that we acquire a lock
 * before using the value in m.
 *
 * The type of m is Mutex<i32>, not i32,
 * so we must call lock to be able to use the i32 value.
 */

// sharing a Mutex<T> between multiple threads ------------------------

// we need multiple owners of the same shared data
// so, we need a smart pointer

// Arc<T> is a type that is safe to use in concurrent situations
// A: stands for atomic, meaning it's atomically reference counted pointer
use std:sync::{Mutex, Arc};

// create a thread-safe, shareable, and mutable integer (0)
// that multiple threads can safely access and modify.
let counter = Arc::new(Mutex::new(0));
let mut handles = vec![];

for _ in 1..10 {
    // clone a Arc<T> so that a new thread
    // (or some other part of the program)
    // can share ownership of the same underlying data.
    let counter = Arc::clone(&counter);

    // When you clone an Arc<T>, you don’t clone the actual data,
    // it just increases the reference count.
    // All clones still point to the same data in memory,
    // and the data is dropped only when the last Arc is dropped.

    let handle = thread::spawn(move || {
	let mut sptr = counter.lock().unwrap();
	*sptr += 1;
    });

    handles.push(handle);
}

for handle in handles {
    handle.join().unwrap();
}

// need to lock() to access the data
// println!("Result: {}", counter.lock().unwrap()); 
println!("Result: {}", *counter.lock().unwrap());
