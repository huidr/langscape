-- Haskell basics

{-
  Install GHCup:
  curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

  To enter REPL:
  ghi

  To compile:
  ghc main.hs

  To run:
  ./main

  Check other compilation ways:
  ghc --help
-}

-- Single-line comment

{-
  Multi-line comment
-}

-- Defining a variable (immutable)
x :: Int          -- Type declaration (optional)
x = 10            -- Assignment

y = 20            -- Type inferred as Int
name = "Haskell"  -- String
isElegant = True  -- Boolean

-- Haskell has a strong static type system
-- Primitive types
num :: Int        -- Int (fixed-precision)
num = 24

bigNum :: Integer -- Integer (arbitrary-precision)
bigNum = 1234567890988765432123456789

pi :: Double
pi = 3.14159

letter :: Char    -- Single UNICODE character
letter = 'A'

name :: String
name = "Haskell"

-- Composite types
-- List (homogeneous)
numbers :: [Int]  
numbers = [1, 2, 3, 4, 5]

-- Tuple (fixed-sized, heterogeneous)
person :: (String, Int)
person = ("Alice", 24)

-- Custom data type (like enum, struct)
data Color = Red | Green | Blue       -- enum-like
data Person = Person {                -- struct-like
  name :: String,
  age :: Int
}

-- Functions
-- Haskell functions are pure (no side effects) and use pattern-matching
-- Function signature (optional but recommended)
add :: Int -> Int -> Int
add x y = x + y

-- Calling
sum = add 2 4

{-

-> is right associative:
Int -> Int -> Int = Int -> (Int -> Int) (currying)

-}

-- Pattern matching
factorial :: Int -> Int
factorial 0 = 1                       -- Base case
factorial n = n * factorial (n-1)     -- Recursive case

-- Lambda (Anonymous functions)
square = \x -> x*x
result = square 6

-- Control flow
-- Guards (like if-else chains)
max :: Int -> Int -> Int
max a b
| a > b = a
| otherwise = b

-- if then else
absolute :: Int -> Int
absolute x = if x >= 0 then x else -x

-- Recursion instead of loops
-- Haskell does not have loops, it uses recursion
-- recursive sum of list
sumList :: [Int] -> Int
sumList [] = 0                      -- base case
sumList (x:xs) = x + sumList xs     -- recursion

-- higher order functions
squaredList = map (\x -> x * x) [1, 2, 3]  -- [1, 4, 9]

-- Lazy evaluation & infinite lists
naturals = [1..]

-- take the first 5 elements
firstFive = take 5 naturals                -- -1, 2, 3, 4, 5]

-- Error handling
-- Haskell uses Maybe and Either for safe error handling
-- Maybe (success or nothing)
safeDivide :: Int -> Int -> Maybe Int
safeDivide _ 0 = Nothing  -- Division by zero
safeDivide x y = Just (x `div` y)

result = safeDivide 10 2  -- Just 5
failed = safeDivide 10 0  -- Nothing

-- Either (success or error message)
safeSqrt :: Double -> Either String Double
safeSqrt x 
  | x < 0     = Left "Negative input!"
  | otherwise = Right (sqrt x)
  
-- OOP? No, but typeclasses (like interfaces)
-- Define a typeclass (interface)
class Greet a where
  sayHello :: a -> String

-- Implement for a type
instance Greet String where
  sayHello name = "Hello, " ++ name

-- Usage
greeting = sayHello "Alice"  -- "Hello, Alice"

-- IO (Console & file handling)
-- Haskell separates pure and impure (IO) code
-- Console I/O
main :: IO ()
main = do
  putStrLn "Enter your name:"  -- Print
  name <- getLine              -- Read input
  putStrLn ("Hello, " ++ name) -- Print result

-- File handling
import System.IO  -- Required for file operations

main :: IO ()
main = do
  -- Write to a file
  writeFile "output.txt" "Hello, File!"

  -- Read from a file
  content <- readFile "output.txt"
  putStrLn content  -- Prints "Hello, File!"

-- Importing libraries
import Data.List (sort)  -- Import only `sort` from Data.List
import qualified Data.Map as Map  -- Import with prefix

sortedList = sort [3, 1, 2]  -- [1, 2, 3]

{-
  Haskell treates variables differently inside do block (including main function) and outside it

  Outside main (top level):
    use = directly;                  x = 5
    these are global immutables

  Inside main or any do block:
    use let or let + in (for local)
    this is required because do blocks handle imperative-style code (like I/O).
-}

main :: IO ()
main = do
  let x = 5
  print x
  -- One let covers all bindings until the next non-indented line
  -- Indentation matters: Bindings must align vertically
  -- The let block ends when a less-indented line appears 
  let name = "Haskell"
      style = "functional programming"
      compiler = "ghc"
  print name              -- will print with quotes
  print style
  putStrLn compile        -- will print without quotes

-- Common functions
-- show :: Show a => a -> String
show 2.4                             -- to string
putStrLn (show 2.4)

arr :: String
arr = show [1, 2, 3, 4]              --- to string
putStrLn arr

show True

data Color = Red | Green | Blue

instance Show Color where
  show Red   = "Red"
  show Green = "Green"
  show Blue  = "Blue"

putStrLn (show Red)

print 24 -- sugar code, same as putStrLn (show 24)

-- List and tuples
1 : 2 : 3 : []       -- same as [1, 2, 3]
"abc"                -- list of three characters; strings are lists
'a' : 'b' : 'c' : [] -- same as above
(head, tail, 2, 'h') -- a tuple of two functions, an Int and a Char

-- Pattern matching examples
response :: String -> String
response "y"     = "Yes"
response "n"     = "No"
response ('y':_) = "Starts with 'y'"
response _       = "Invalid"           -- wildcard, matches anything

-- A simple counting function
-- Counts the number of evens in a list
countEven :: [Int] -> Int
countEven [] = 0
countEven (x:xs) =  (if even x then 1 else 0) + countEven xs

countEven [1, 2, 3, 4, 5, 6] -- 3

-- Operator section
square = (^2)
print (square 4)     -- 16

{-
Normal function               Lambda                 Operator section
square x = x^2                square = \x -> x^2     square = (^2)

Use normal function for
- Named, reusable, documented logic, 
- Preferred in public APIs/library code
- Example: factorial n = product [1..n]

Use lambda
- One-off, throw-away, inline transformations
- Higher-order functions (e.g., map, filter)
- When the logic is too small to name
- Example: filter (\x -> x > 0) [-1, 2, -4, 8]

Use operator section
- Ultra-short numeric operations
- Point-free style pipelines
- Example: map (^2) (take 5 [1..])

All the following work; best choice depends on the context
map (^2) [1..3]         -- Operator section
map (\x -> x^2) [1..3]  -- Equivalent lambda
let square x = x^2 in map square [1..3]  -- Named function
-}

-- otherwise is a predefined value equal to True in the Prelude (the standard library)
otherwise :: Bool
otherwise = True        -- defined in the Prelude

-- Guards are Haskell's clean way to handle multi-branch conditions without nested if-else
-- use otherwise in guards
grade :: Int -> String
grade score
  | score >= 90 = "A"
  | score >= 80 = "B"
  | score >= 70 = "C"
  | score >= 60 = "D"
  | otherwise   = "F"   -- equivalent to else

-- Why Not Use if-else-if?
-- Haskell’s if requires an else and gets messy with nested logic:
grade :: Int -> String
grade score =
  if score >= 90 then "A"
  else if score >= 80 then "B"
  else if score >= 70 then "C"
  else if score >= 60 then "D"
  else "F"

-- Combining guards and pattern matching
-- Pattern match + guards
factorial :: Int -> Int
factorial 0 = 1
factorial n | n > 0     = n * factorial (n - 1)
            | otherwise = error "Negative input"

-- Tips to learn Haskell faster?
-- Signature First: Always check the type signature to understand a function
map :: (a -> b) -> [a] -> [b]  -- Takes a function and a list, returns new list

-- In ghci, use :t to check type
-- :t filter
filter :: (a -> Bool) -> [a] -> [b]

-- Haskell code is a pipeline of transformations (no "steps" like in imperative code)
result = map (*2) (filter even [0..9])

-- Imperative: "Do this, then that, then loop…"
-- Haskell: "This is the result of transforming that input."

{- Comparison with Rust

Rust                   Haskell              Notes
Iterator::filter/map   filter/map           Almost identical usage
match                  Pattern matching     Haskell's more powerful (e.g. recursive destructuring)
Result<T, E>           Either E T           Same idea (Ok <-> Right, Err <-> Left)
Option<T>              Maybe T              Some <-> Just, None <-> Nothing
Immutable by default   Always immutable     Haskell never allows mutation
Closures (|x| x + 1)   Lambdas (x -> x + 1) Similar syntax

-}

