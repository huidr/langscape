-- IO actions

def helloWorld : IO Unit := IO.println "Hello, World"

def greeter : String → IO Unit
  | "" => IO.println "Oops. Empty argument."
  | name => IO.println s!"Hello, {name}"

-- do keyword is used to perform a sequence of IO actions
def timesGreeter : Nat -> String → IO Unit
  | 0, _ => pure () -- do nothing, pure () has type IO Unit
  | _, "" => pure ()
  | k + 1, name => do
    IO.println s!"Hello, {name}"
    timesGreeter k name

-- use of IO input
def receiveInputGreeter : IO Unit := do
  let stdin ← IO.getStdin
  let stdout ← IO.getStdout
  stdout.putStrLn "How should I greet you?"
  let input ← stdin.getLine
  let name := input.dropRightWhile Char.isWhitespace 
  --let name := String.dropRightWhile input Char.isWhitespace
  greeter name

-- take an IO action of type IO Unit as input and perform it n times
def nTimes (action : IO Unit) : Nat → IO Unit
  | 0 => pure ()
  | k + 1 => do
    action
    nTimes action k

def nTimesInputGreeter (k : Nat) : IO Unit := nTimes receiveInputGreeter k

-- A list of IO actions
def listActions : IO Unit → Nat → List (IO Unit)
  | _, 0 => []
  | action, k + 1 => action :: listActions action k

-- Run all IO actions from a list of IO actions
def runActionsList : List (IO Unit) → IO Unit
  | [] => pure ()
  | x :: xs => do
    x
    runActionsList xs

def someListofActions := listActions receiveInputGreeter 3
def anotherListofActions := receiveInputGreeter :: timesGreeter 2 "Lean" :: helloWorld :: timesGreeter 3 "Theorem Prover" :: []

-- Use of partial keyword for non-terminating recursion
-- Use of (← ) 
partial def inputLoop : IO Unit := do
  IO.println "What's your name?"
  let name ← IO.getLine
  IO.println s!"Hello, {name}"
  inputLoop

def main : IO Unit := inputLoop
