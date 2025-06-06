-- Overloading and Type Classes

/-
-- Lean implements overloading using a mechanism called type classes, pioneered in Haskell,
-- that allows overloading of operators, functions, and literals in a manner that works well with polymorphism.
-- A type class describes a collection of overloadable operations.
-- To overload these operations for a new type, an instance is created that contains
-- an implementation of each operation for the new type.

-- A Lean type class is very analogous to Rust trait
--
-- Differences between Rust traits, Haskell type classes and Lean type classes:
-- (1) Rust traits can have default method implementations and associated types.
-- (2) Lean and Haskell have more powerful instance resolution thanks to their logic foundations and unification.
-- (3) Lean’s type classes are foundational to its theorem proving — they also guide things like arithmetic, decidability, etc.
-/

-- Positive Integers

-- Rather than relying on natural numbers, and littering the code with assertions that the number is not zero,
-- it can be useful to design a datatype that represents only positive numbers.

-- defining a type class
class Plus (α : Type) where
  plus : α → α → α

-- type classes are first-class
-- a type class is a kind of type
#check (Plus) -- Plus : Type → Type

-- To overload plus for a particular type
instance : Plus Nat where -- the colon after instance indicates that Plus Nat is indeed a type
  plus := Nat.add

#eval Plus.plus 3 7 -- 10

inductive Pos where
  | one
  | succ : Pos → Pos

def Pos.add : Pos → Pos → Pos
  | Pos.one, k => Pos.succ k
  | Pos.succ n, k => Pos.add n (Pos.succ k)

instance : Plus Pos where
  plus := Pos.add

open Plus (plus)

def one := Pos.one
def two := Pos.succ Pos.one
def three := plus two one
def four := plus three one
def five := plus four one

#eval plus four four

def getPos : Pos → Nat
  | Pos.one => 1
  | Pos.succ k => getPos k + 1

#eval getPos $ plus five four -- 9


