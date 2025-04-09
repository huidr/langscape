-- Still basics but a bit more
-- Based on "Learn You a Haskell for Great Good!"

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
