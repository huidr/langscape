-- Based on Learn you a Haskell for great good

-- In ghci, you use :l lib to load a Haskell file lib.hs in the same directory

-- Boolean algebra: True, False, &&, ||, not
-- Check equalities and inequalities: ==, /=

-- if else is an expression; so, else is always necessary
doubleSmallNumber x = if x < 10 then 2*x else x

-- apostrophe ' is a valid character for naming functions
-- mostly used to either denote a strict version of a function (one that isn't lazy)
--      or a slightly modified version of a function or a variable
doubleSmallNumber' x = do
  print (doubleSmallNumber x)

-- Lists and tuples -------------------------------------------------------

-- lists are homogenous
numbers = [1,2,3,4,5]

-- strings are lists: "Haskell" is simpy ['H','a','s','k','e','l','l']
-- ++ means to concatenate
-- x:list means the new list [x] ++ list, so 1:2:3:[] is simply [1:2:3]
myList = 0 : numbers

-- indexing is done using !!
-- indexing starts from 0
firstNum = myList !! 4

-- lists can contain lists which can be different lengths but should be of the same type
-- lists can be compared using <, >, ==, /= (uses lexicographical order)

head [1, 2, 3, 4, 5, 6] -- returns 1
tail [1, 2, 3, 4, 5, 6] -- returns [2, 3, 4, 5, 6]
init [1, 2, 3, 4, 5, 6] -- returns [1, 2, 3, 4, 5]
last [1, 2, 3, 4, 5, 6] -- returns 6

length [1, 2, 3, 4, 5, 6] -- returns 6 (the length)
null [1, 2, 3, 4, 5, 6] -- returns False (check if the list is empty)

reverse [1, 2, 3, 4, 5, 6] -- returns the reverse
take 2 [1, 2, 3, 4, 5, 6] -- returns [1, 2]
drop 3 [1, 2, 3, 4, 5, 6] -- returns [4, 5, 6]

-- maximum takes a list of stuff that can be put in some kind of order and returns the biggest element.
maximum [1, 2, 3, 4, 5, 6] -- returns 6
maximum "Hello" -- returns 'o' (think of ASCII code)
maximum "Rr" -- returns 'r'
minimum "Zet" -- returns 'Z'

sum [1, 2, 3, 4, 5, 6] -- returns 21 (sum)
product [1, 2, 3, 4, 5, 6] -- returns 720 (product)

elem 1 [1, 2, 3, 4, 5, 6] -- returns True (is 1 an element of the list)
1 `elem` [1, 2, 3, 4, 5, 6] -- same thing, infix, this is more common

[1..6] -- [1, 2, 3, 4, 5, 6]
[1..(-4)] -- [] -- removing the parenthesis gives an error
[-2..2] -- [-2,-1,0,1,2]

['A'..'Z'] -- "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

[0,2..100] -- all evens upto 100 (arithmetic progression)
[0,-2..(-100)] -- works similarly

[10..0] -- returns []
[10,9..0] -- returns [10,9,8,7,6,5,4,3,2,1,0]

take 5 [-1,-3..] -- returns [-1,-3,-5,-7,-9]

-- cycle takes a list and cycles it into an infinite list
-- it takes forever, so slice it off somewhere
take 6 (cycle [1,2]) -- [1,2,1,2,1,2]

-- repeat is like cycling with one element
take 6 (repeat 2) -- [2,2,2,2,2,2]
replicate 6 2 -- same thing as above [2,2,2,2,2,2]

-- list comprehensions
[ x*2 | x <- take 5 [1,3..] ] -- [2,6,10,14,18]

-- filtering a list using a predicate
[ x*2 | x <- [0..10], x*2 `mod` 3 == 1] -- [4,10,15]

-- there can be many predicates
[ x | x <- [1..100], x `mod` 3 == 1, x /= 4, x `mod` 7 == 2]

-- drawing elements from multiple lists
[ [x,y] | x <- [1,2], y <- [7,8,9], [x,y] /= [2,9] ] -- [[1,7],[1,8],[1,9],[2,7],[2,8]]

length' xs = sum [1 | _ <- xs] -- underscore _ means we don't care what we draw from the list

-- recall: strings are lists
-- so, string comprehensions possible!

-- tuples can be heterogenous
-- the number of elements in a tuple is a part of its type
-- tuples of the same type can be compared
-- can't compare tuples of different sizes but they are of different type
-- a pair is a tuple of size 2
fst (1,2) -- returns 1 (first)
snd (1,2) -- returns 2 (second)

-- zip takes two lists and produce a list of pairs
zip [1..3] ["One", "Two", "Three"] -- [(1,"One"),(2,"Two"),(3,"Three")]
zip [1..8] ["One", "Two", "Three"] -- [(1,"One"),(2,"Two"),(3,"Three")] -- ignores the rest of the longer list
zip [1..] ["Rust", "Haskell", "C", "Lisp"]

-- typeclasses
-- where keyword
density :: (RealFloat a) => a -> a -> String
density mass volume
    | density < air = "Ride in the sky"
    | density <= water = "Float"
    | otherwise = "Sink"
    where density = mass / volume
          air = 1.2
          water = 1000.0

calcDensities :: (RealFloat a) => [(a, a)] -> [a]  
calcDensities xs = [density m v | (m, v) <- xs]
    where density mass volume = mass / volume  

-- let   in
var = let (x, y) = (2, 3) in x + y        -- var = 5

let x = 1; y = 2; z = 3 in x + y + z      -- 6

cylinder :: (RealFloat a) => a -> a -> a  
cylinder radius height =
    let sideArea = 2 * pi * r * h
        topArea = pi * r^2
    in  sideArea + 2 * topArea

-- case
case expression of pattern -> result  
                   pattern -> result  
                   pattern -> result  

-- example
head' :: [a] -> a
head' xs = case xs of [] -> error "Empty"
                      (x:_) -> x

length' :: [a] -> Int
length' xs = case xs of [] -> 0
                        (x:y) -> 1 + length' y

-- recursion
replicate' :: (Integral i) => i -> a -> [a]
replicate' n x
    | n <= 0 = []
    | n == 1 = [x]
    | otherwise = x: replicate' (n-1) x

replicate' 4 2 -- [2, 2, 2, 2]

reverse' :: [a] -> [a]
reverse' [] = []
reverse' (x:xs) = xs ++ [x]

reverse' [2, 4, 3, 1] -- [1, 3, 4, 2]

quicksort' :: (Ord a) => [a] -> [a]
quicksort' [] = []
quicksort' (x:xs) =
    let firstHalf = quicksort' [ a | a <- xs, a <= x ]
        secondHalf = quicksort' [ a | a <- xs, a > x ]
    in  firstHalf ++ [x] ++ secondHalf

quicksort' [3, 4, 8, 2, 1, 5] -- [1, 2, 3, 4, 5, 8]

-- Higher order functions: those that take functions as arguments or return them
-- curried functions
-- lambda functions
-- partial evaluation
divideBy10 :: Fractional a => a -> a
divideBy10 = (/10)
divideBy10 23      -- 2.3

add :: Num a => a -> a -> a
add' x y = x + y

-- on ghci
:t (add 3)         -- (add 3) :: Num a => a -> a
                   -- (add 3) = \x -> x + 3

isUpperAlpha :: Char -> Bool
isUpperAlpha = (`elem` ['A'..'Z'])

isUpperAlpha 'c'    -- False
isUpperAlpha 'F'    -- True

-- maps and filters
map (^2) [1..5]    -- [1, 4, 9, 16, 25]
filter (>7) [1..9] -- [8, 9]

-- lambdas
func = \x -> x^2 + 1
:t func                 -- func :: Num a => a -> a

func 5                  -- 26
map func [1..5]         -- [2, 5, 10, 17, 26]
map (\x -> x^2 + 1) [1..5]     -- same as above
map (+1) (map (^2) [1..5])     -- same as above
map (+1) $ map (^2) [1..5]     -- same as above

map (\(x,y) -> x + y) [(1,2),(3,4),(5,6)]    -- [3,7,11]

add' = \x -> \y -> \z -> x + y + z -- add' x y z = x + y + z
:t add' -- add' :: Num a => a -> a -> a -> a

-- folds
-- foldl (from left)
-- foldr (from right)
sum' :: (Num a) => [a] -> a
sum' xs = foldl (\acc x -> acc + x) 0 xs

-- the following are equivalent forms of writing the above function
sum' = foldl (\acc x -> acc + x) 0 -- removing xs from both sides
sum' = foldl (+) 0                 -- where (+) is the binary function: \acc x -> acc + x

sum' [1..100] -- 5050

-- scanl, scanr works like foldl, foldr except they report all the intermediate accumulator states in the form of a list.

-- using $
-- f $ x = f x      (definition of $)
-- why use $? because it is right associative and can reduce usage of parenthesis
-- f ( g (h x)) can be written as f $ g $ h x

-- function composition can be written using dot
fn = tan . cos . max 3      -- fn x = tan (cos (max 3 x))

-- modules
import System.Environment (getArgs)           -- only getArgs defined in System.Environment
import Data.List                              -- everything in Data.List
import Data.List hiding (num, sort)           -- all except num and sort
import qualified Data.Map as M                -- to resolve name conflicts, use M as an alias for Data.Map

-- declare a module (a file in the same directory as the main.hs)
module Geometry            -- at the top of Geometry.hs
  ( sphereVolume           -- list of functions defined in Geometry.hs which you want to be exported
  , sphereArea
  , cuboidVolume
  , cuboidArea
  ) where

-- suppose you have Geometry/Cube.hs, and the directory Geometry is in the same directory as main.hs
module Geometry.Cube
  ( cubeVolume
  , cubeArea
  ) where

-- to import
import Geometry.Cube

-- types -----------------------------------------------------------------
data Shape = Circle Float Float Float | Rectangle Float Float Float Float | Square Float Float Float -- like enum

:t Circle -- Circle :: Float Float Float -> Shape
:t Rectangle -- Rectangle :: Float -> Float -> Float -> Float -> Shape
:t Square -- Square :: Float -> Float -> Float -> Shape

-- accessor functions
radius :: Shape -> Float
radius (Circle _ _ r) = r
radius (Rectangle _ _ _ _) = error "It's a rectangle!"
radius (Square _ _ _) = error "It's a square!"

sideLength :: Shape -> Float
sideLength (Square _ _ s) = s
sideLength (Circle _ _ _) = error "It's a circle!"
sideLength (Rectangle _ _ _ _) = error "It's a rectangle!"

area (Circle _ _ radius) = pi * radius ^2
area (Rectangle _ _ len wdth) = len * wdth
area (Square _ _ side) = side ^2

:t area -- area :: Shape -> Float

area (Circle 1 2 3) -- 28.274334 (area of circle with center (1,2) and radius 3
area (Rectangle 1 2 3 4) -- 12
area (Square 1 2 3) -- 9

-- types deriving (like Rust's derive trait)
-- Shape is a type
-- Circle, Rectangle, Square are constructors
data Shape = Circle Float Float Float | Rectangle Float Float Float Float | Square Float Float Float deriving (Show, Eq)
-- Show is to convert to string
-- Eq to check equality == or /=

let cir1 = Circle 0 0 1
let cir2 = Circle 0 0 2
let cir' = Circle 0 0 1

show cir1 -- "Circle 0.0 0.0 1.0"
show cir2 -- "Circle 0.0 0.0 2.0"
show cir' -- "Circle 0.0 0.0 1.0"

cir1 == cir2 -- False
cir1 == cir' -- True
cir1 /= cir2 -- True

radius cir1 -- 1.0 (using accessor function we defined above)

-- make something like struct
data Person = Person { name :: String, age :: Int } deriving (Show, Eq)

let p = Person { name = "Haskell", age = 24 }
let q = Person { name = "Rust", age = 17 }
let r = Person { name = "Haskell", age = 24 }

show p -- "Person {name = \"Haskell\", age = 24 }"

p == q -- False
p == r -- True

-- accessor functions (automatically available for record-based data (like struct)
name p -- "Haskell"
age p -- 24

-- Maybe ----------------------------------------------------------------
data Maybe a = Nothing | Just a
-- It's like Rust's Option<T>
divide' :: Float -> Float -> Maybe Float
divide' x y
    | y == 0 = Nothing
    | otherwise = Just $ x / y

print $ divide' 3 2 -- 1.5

-- Typeclasses are like traits of Rust or interfaces of Java
-- we implement them using "deriving" keyword
data Day = Sun | Mon | Tue | Wed | Thu | Fri | Sat
     deriving (Eq, Ord, Bounded, Enum, Show, Read)

putStrLn $ show Fri -- because implemented Show for Day
read "Wed" :: Day -- returns a value of Day type (having value Wed)
Mon == Fri -- False
Wed > Thu -- False (we implemented Ord)
minBound :: Day -- Sun (we implemented Bounded)
maxBound :: Day -- Sat
succ Sun -- Mon (successor, because we implemented Enum)
pred Sat -- Fri (predecessor)

-- type synonyms
-- [Char] and String are equivalent (that was implemented with type synonyms)
-- like C++'s typedef
type String = [Char] -- so, String can be used instead of [Char] in declarations like...
rev' :: String -> String -- instead of rev' :: [Char] -> [Char]

-- Either ----------------------------------------------------------------
data Either a b = Left a | Right b deriving (Eq, Ord, Read, Show)
-- It's like Rust's Result<T, E>

safeDivide :: Float -> Float -> Either String Float
safeDivide _ 0 = Left "Denominator zero"
safeDivide x y = Right (x / y)

-- can be used like this
val = case safeDivide 4 3 of
    Left msg -> "Error: " ++ msg
    Right value -> "Value: " ++ show value

putStrLn val

-- or do pattern matching
describeResult :: Either String Float -> String
describeResult (Left msg) = "Error: " ++ msg
describeResult (Right value) = "Value: " ++ show value

putStrLn $ describeResult $ safeDivide 4 0

-- interoperability
-- convert Either to Maybe
eitherToMaybe :: Either a b -> Maybe b
eitherToMaybe (Left _) = Nothing
eitherToMaybe (Right x) = Just x

print $ eitherToMaybe $ safeDivide 7.2 0.0

-- recursive data structures ---------------------------------------------
-- binary search tree (BST)
data BST a = Empty      -- base case
           | Node a (BST a) (BST a)  -- a node contains a value of type 'a' and two sub trees

-- in the above, a is a type, could be Int, String, etc.

-- insert a value into the BST
insert :: (Ord a) => a -> BST a -> BST a -- Ord means comparable <, >, ==, etc.
insert x Empty = Node x Empty Empty -- Insert into an empty tree
insert x (Node y left right)
    | x == y = Node y left right -- value already exists, do nothing
    | x < y = Node y (insert x left) right -- recurse into the left subtree
    | x > y = Node y left (insert x right)

-- search for an element
search :: (Ord a) => a -> BST a -> Bool
search _ Empty = False
search x (Node y left right)
    | x == y = True
    | x < y  = search x left
    | x > y  = search x right
