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

-- Pattern matching
factorial :: Int -> Int
factorial 0 = 1                       -- Base case
factorial n = n * factorial (n-1)     -- Recursive case

-- Lambda (Anonymous functions)
square = \x -> x * x
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




    
