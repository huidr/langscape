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



























  
  
