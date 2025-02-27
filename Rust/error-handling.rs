// ERROR HANDLING ------------------------------------------------------

/* 
 * Rust doesn’t have exceptions.
 * Instead, it has the type Result<T, E> for recoverable errors and
 * the panic! macro that stops execution
 * when the program encounters an unrecoverable error.
 */

// Unrecoverable errors with panic! ------------------------------------

/* 
 * There are two ways to cause a panic in practice:
 * (1) by taking an action that causes our code to panic
 *     (such as accessing an array past the end) or
 * (2) by explicitly calling the panic! macro.
 *
 * By default, these panics will print a failure message,
 * unwind, clean up the stack, and quit.
 *
 * Via an environment variable, you can also have Rust display
 * the call stack when a panic occurs to make it easier
 * to track down the source of the panic.
 */

