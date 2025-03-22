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

// Recoverable errors with Result --------------------------------------

// the Result enum is defined as having two variants as follows:

enum Result<T, E> {
    Ok(T),
    Err(E),
}

// opening a file . . .

use std::fs::File;

let greeting_file_result = File::open("hello.txt");

/* 
 * File::open() returns Result<T, E>
 *
 * T is the type of the success value std::fs::File,
 * which is a file handle
 *
 * E is the type std::io::Error
 * 
 * The File::open function needs to have a way to tell us
 * whether it succeeded or failed and at the same time
 * give us either the file handle or error information.
 *
 * In the case where File::open succeeds,
 * the value in the variable greeting_file_result
 * will be an instance of Ok that contains a file handle.
 *
 * In the case where it fails, the value in greeting_file_result
 * will be an instance of Err that contains more information
 * about the kind of error that occurred.
 */

use std::fs::File;

let file_handle = match File::open("esabi.txt") {
    Ok(file) => file,                       // Result::Ok(file) => file
    Err(error) => panic!("{error:?}"),
};

// a nested match . . .

use std::fs::File;
use std::io::ErrorKind;

let file_handle = match File::open("esabi.txt") {
    Ok(file)   => file,
    Err(error) => match error.kind() {
	ErrorKind::NotFound => match File::create("esabi.txt") {
	    Ok(file) => file,
	    Err(e)   => panic!("Problem creating file: {e:?}"),
	},
	other_error => panic!("Some error: {other_error:?}"),
    },
};

/*
 * The above basically does:
 * create the file if it does not exist, otherwise panic
 */

// the above uses lots of match.
// the same can be rewritten using closures and the unwrap_or_else()

use std::fs::File;
use std::io::ErrorKind;

let file_handle = File.open("esabi.txt").unwrap_or_else(|error| {
    if error.kind() == ErrorKind::NotFound {
	File::create("esabi.txt").unwrap_or_else(|error| {
	    panic!("Problem creating file: {error:?}")
	})
    } else {
	panic!("Some error: {error:?}")
    }
}); 

// using unwrap and expect . . .

/*
 * The Result<T, E> type has many helper methods
 * defined on it to do various, more specific tasks.
 * 
 * The unwrap method is a shortcut method implemented
 * just like the match expression.
 *
 * If the Result value is the Ok variant, unwrap will
 * return the value inside the Ok.
 *
 * If the Result is the Err variant, unwrap will call
 * the panic! macro for us.
 */

let file_handle = File::open("esabi.txt").unwrap();

/*
 * The expect method lets us also choose the panic! error message.
 * Using expect instead of unwrap and providing good error messages
 * can convey your intent and make tracking
 * down the source of a panic easier.
 */

let file_handle = File::open("esabi.txt")
    .expect("esabi.txt should be included in the directory");

/*
 * We use expect in the same way as unwrap: to return the file handle
 * or call the panic! macro. The error message used by expect
 * in its call to panic! will be the parameter that we pass to expect,
 * rather than the default panic! message that unwrap uses.
 *
 * In production-quality code, most Rustaceans choose expect
 * rather than unwrap and give more context about why
 * the operation is expected to always succeed.
 */

// Propagating errors . . .

/*
 * When a function’s implementation calls something that might fail,
 * instead of handling the error within the function itself you can
 * return the error to the calling code so that it can decide
 * what to do. This is known as propagating the error and gives more
 * control to the calling code, where there might be more information
 * or logic that dictates how the error should be handled than
 * what you have available in the context of your code.
 *
 * This pattern of propagating errors is so common in Rust that
 * Rust provides the question mark operator ? to make this easier.
 */

use std::fs::File;
use std::io::{self, Read};

fn read_username_from_file() -> Result<String, io::Error> {
    let mut username_file = File::open("esabi.txt")?;
    let mut username = String::new();
    username_file.read_to_string(&mut username)?;
    Ok(username)
}

/*
 * The ? placed after a Result value is defined to work in almost
 * same way as the match expressions we defined above
 * 
 * If the value of the Result is an Ok, the value inside the Ok
 * will get returned from this expression,
 * and the program will continue.
 *
 * If the value is an Err, the Err will be returned from
 * the whole function as if we had used the return keyword
 * so the error value gets propagated to the calling code.
 *
 * When the ? operator calls the from function,
 * the error type received is converted into the error type
 * defined in the return type of the current function.
 *
 * This is useful when a function returns one error type
 * to represent all the ways a function might fail,
 * even if parts might fail for many different reasons.
 */

// We can even shorten the code by chaining method calls . . .

fn read_username_from_file() -> Result<String, io::Error> {
    let mut username = String::new();

    File::open("esabi.txt")?.read_to_string(&mut username)?;

    Ok(username)
}

// We can make this even shorter using fs::read_to_string

use std::fs;
use std::io;

fn read_username_from_file() -> Result<String, io::Error> {
    fs::read_to_string("esabi.txt")
}

/*
 * Reading a file into a string is a fairly common operation,
 * so the standard library provides the convenient fs::read_to_string
 * function that opens the file, creates a new String,
 * reads the contents of the file, puts the contents
 * into that String, and returns it.
 */

// where the ? operator can be used . . .

/*
 * The ? operator can only be used in functions
 * whose return type is compatible with the value the ? is used on.
 *
 * This is because the ? operator is defined to perform
 * an early return of a value out of the function,
 * in the same manner as the match expression.
 *
 * For example, we can't use ? in main()
 * because main() has return type of (), not Result
 *
 * To fix this, you have two choices.
 * (1) To change the return type of your function to be compatible
 *     with the value you’re using the ? operator on as long as
 *     you have no restrictions preventing that.
 * (2) To use a match or one of the Result<T, E> methods
 *     to handle the Result<T, E> in whatever way is appropriate.
 *
 * The operator ? can be used with Option<T> values as well.
 * As with using ? on Result, you can only use ? on Option
 * in a function that returns an Option.
 * 
 * Using ? on Option<T> . . .
 * If the value is None, the None will be returned early
 * from the function at that point.
 * If the value is Some, the value inside the Some is the resultant
 * value of the expression, and the function continues.
 */

fn last_char_of_first_line(text: &str) -> Option<char> {
    text.lines().next()?.chars().last()
}

/*
 * The above function returns Option<char> because it’s possible
 * that there is a character there, but it’s also possible
 * that there isn’t.
 *
 * The code takes the text string slice argument and calls lines()
 * on it, which returns an iterator over the lines in the string.
 * Because this function wants to examine the first line, it calls
 * next() on the iterator to get the first value from the iterator.
 * If text is the empty string, this call to next will return None,
 * in which case we use ? to stop and return None from the function.
 * If text is not the empty string, next will return a Some value
 * containing a string slice of the first line in text.
 *
 * The ? extracts the string slice, and calling chars() on that
 * gets an iterator of its characters.
 * Then we call last to return the last item in the iterator.
 * This is an Option<char>. If there is a last character
 * on the first line, it will be returned in the Some variant.
 */
 
// main can also return a Result<(), E> . . .

use std::error::Error;
use std::fs::File;

fn main() -> Result<(), Box<dyn Error>> {
    let file_handle = File::open("esabi.txt")?;        // ? operator

    Ok(());
}

/*
 * For now, you can read Box<dyn Error> to mean “any kind of error.”
 * Using ? on a Result value in a main function with the error type
 * Box<dyn Error> is allowed because it allows any Err value to be
 * returned early. Even though the body of this main function will only
 * ever return errors of type std::io::Error, by specifying
 * Box<dyn Error>, this signature will continue to be correct even if
 * more code that returns other errors is added to the body of main.
 */

/*
 * When a main function returns a Result<(), E>, the executable
 * will exit with a value of 0 if main returns Ok(()) and will
 * exit with a nonzero value if main returns an Err value. 
 */

/*
 * Using panic! and Result in the appropriate situations will
 * make your code more reliable in the face of inevitable problems.
 * 
 * panic! when there is no way out (unrecoverable)
 * Result<T, E> when it might be recoverable
 */
