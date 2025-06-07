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

-- Zero and OfNat
-- Zero and OfNat are two type classes that are used to overload numeric literals.

-- Because many types have values that are naturally written with 0, the Zero class allow these specific values to be overridden
class Zero' (α : Type) where
  zero : α

-- This type class takes two arguments: α is the type for which a natural number is overloaded, and the unnamed Nat argument is the actual literal number that was encountered in the program
class OfNat' (α : Type) (_ : Nat) where -- 
  ofNat : α

I was experimenting with my own even number datatype

-- Let's implement even numbers
inductive Even where
  | zero
  | succ : Even → Even
deriving Repr

-- Addition on even numbers
def Even.add : Even → Even → Even
  | Even.zero, n => n
  | Even.succ k, n => Even.succ $ Even.add k n

-- Predecessor
def Even.pred : Even → Even
  | Even.zero => Even.zero
  | Even.succ k => k

-- Subtraction
def Even.sub : Even → Even → Even
  | k, Even.zero => k
  | Even.zero, _ => Even.zero
  | Even.succ n, Even.succ k => Even.sub n k

-- Multiplication
def Even.mul : Even → Even → Even
  | _, Even.zero => Even.zero
  | k, Even.succ Even.zero => Even.add k k
  | n, Even.succ k => Even.add (Even.mul n k) (Even.add n n)

-- Defining zero
instance : Zero Even where
  zero := Even.zero

-- To use + operator for evens
instance : Add Even where
  add := Even.add

-- To use - operator for evens
instance : Sub Even where
  sub := Even.sub

-- To use * operator for evens
instance : Mul Even where
  mul := Even.mul

-- Even to Nat
def Even.toNat : Even → Nat
  | Even.zero => 0
  | Even.succ k => toNat k + 2

-- Overloading some natural literals
instance : OfNat Even 2 where
  ofNat := Even.succ Even.zero

instance : OfNat Even 4 where
  ofNat := Even.succ (2: Even)

instance : OfNat Even 6 where
  ofNat := (4 : Even) + (2 : Even)

instance : OfNat Even 8 where
  ofNat := (4 : Even) * (2 : Even)

#eval (8 : Even).toNat
#eval ((8 : Even) * (6 : Even)).toNat



