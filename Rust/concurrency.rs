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

// 
