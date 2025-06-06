-- IO actions
-- Basics of propositions and proofs

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

def nTimesInputGreeter (k : Nat) : IO Unit :=
  nTimes receiveInputGreeter k

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
def anotherListofActions := 
  receiveInputGreeter ::
  timesGreeter 2 "Lean" ::
  helloWorld ::
  timesGreeter 3 "Theorem Prover" ::
  []

-- Use of partial keyword for non-terminating recursion
-- Use of (← ) 
partial def inputLoop : IO Unit := do
  IO.println "What's your name?"
  let name ← (← IO.getStdin).getLine 
  IO.println s!"Hello, {name}"
  inputLoop

-- This function has problems
partial def inputLoopUntilEmpty : IO Unit := do
  (← IO.getStdout).putStrLn "What's your name?"
  let name ← (← IO.getStdin).getLine
  if name.trim == "Jerk" then
    pure ()
  else
    inputLoopUntilEmpty

/-
-- Partial functions are not evaluated during type checking, because an infinite loop
-- in a function could cause the type checker to enter an infinite loop.
-- Furthermore, mathematical proofs are unable to inspect the definitions of partial functions,
-- which means that programs that use them are much less amenable to formal proof. 
-/

-- def main : IO Unit := inputLoopUntilEmpty

-- Propositions and proofs

-- Prop is a type for propositions
-- Further propositions are types
def OnePlusOneIsTwo : Prop := 1 + 1 = 2
theorem onePlusOneIsTwo : OnePlusOneIsTwo := rfl -- rfl refers to reflexity

-- the above is logically equivalent to
theorem opoit : 1 + 1 = 2 := rfl -- because propositions are types

-- use the former to name propositions and refer to the names later multiple times
-- use the latter for short/one-off proofs 

-- Tactics

/-
-- Tactics are small programs that construct evidence for a proposition.
-- These programs run in a proof state that tracks the statement that is to be proved (called the goal)
-- along with the assumptions that are available to prove it.
-- Running a tactic on a goal results in a new proof state that contains new goals.
-- The proof is complete when all goals have been proven.
-/

-- To write a proof with tactics, begin the definition with by
theorem newtheo : 1 + 1 = 2 := by -- by 
  decide 

-- The decide tactic in Lean tries to automatically decide propositions that are decidable — that is,
-- where Lean can compute a boolean result and prove the truth or falsehood mechanically

-- Connectives: ∧ ∨

theorem r1 : 1 + 2 = 3 ∧ "Lean".append "Prover" = "LeanProver" := by
  decide


