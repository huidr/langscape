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
def three := plus two oneS
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

-- Equality check
instance : BEq Even where
  beq n m := n.toNat == m.toNat

-- to implement string printing (Repr) for Even type
instance : Repr Even where
  reprPrec e _ := repr (e.toNat)

#eval (8 : Even) -- instead of (8 : Even).toNat
#eval ((8 : Even) * (6 : Even))
#eval (8 : Even) == (6 : Even)

-- Instance implicits

-- A function that sums all entries in a list needs two instances:
-- (1) Add allows the entries to be added, i.e. instance : Add α 
-- (2) an OfNat instance for 0 provides a sensible value to return for the empty list, i.e. instance : OfNat α 0 (or Zero α)
def List.sumOfContents [Add α] [OfNat α 0] : List α → α
  | [] => 0                                               -- 0 : α (type inference)
  | x :: xs => x + List.sumOfContents xs

def List.mulOfContents [Mul α] [Zero α] : List α → α
  | [] => 0
  | x :: [] => x
  | x :: xs => x * List.mulOfContents xs

def someListOfEvens : List Even := [4, 8, 2, 6]
#eval someListOfEvens.sumOfContents
#eval someListOfEvens.mulOfContents

/-
-- Instance implicits are specifications of required instances in square brackets.
-- Behind the scenes, every type class defines a structure that has a field for each overloaded operation.
-- Instances are values of that structure type, with each field containing an implementation.
-- At a call site, Lean is responsible for finding an instance value to pass for each instance implicit argument.
-- The most important difference between ordinary implicit arguments and 
-- instance implicits is the strategy that Lean uses to find an argument value.
-- In the case of ordinary implicit arguments, Lean uses a technique called unification
-- to find a single unique argument value that would allow the program to pass the type checker.
-- This process relies only on the specific types involved in the function's definition and the call site.
-- For instance implicits, Lean instead consults a built-in table of instance values.
-/

-- Heterogeneous addition

def addNatEven : Nat → Even → Nat
  | n, k => n + k.toNat

def addEvenNat : Even → Nat → Nat
  | k, n => k.toNat + n 

instance : HAdd Nat Even Nat where
  hAdd := addNatEven

instance : HAdd Even Nat Nat where
  hAdd := addEvenNat

#eval (1 : Nat) + (2 : Even)
#eval (4 : Even) + (6 : Nat)

-- HAdd and HMul be like...
class HAdd' (α β γ : Type) where
  hAdd' : α → β → γ 

class HMul' (α β γ : Type) where
  hMul' : α → β → γ

-- Look up: output parameters and default instances

-- Arrays

/- 
-- Lean arrays are much more efficient than linked lists for most purposes.
-- Array α is much like C++ std::vector or Rust Vec.
-- Arrays occupy a contiguous region of memory, which is much better for processor caches.
-- Looking up a value in an array takes O(1), while lookup in a linked list takes O(n).
-/

def heroes : Array String := #["Bruce Wayne", "Peter Parker", "Tony Stark"]
def langs := #["Lean", "Rust", "Haskell"]

#eval heroes.size -- 3
#eval heroes[0] -- "Bruce Wayne"

-- using abbrev
abbrev nonEmpty? (xs : Array α) := xs.size > 0
abbrev sameSize? (xs : Array α) (ys : Array β) := xs.size == ys.size

theorem thm1 : nonEmpty? heroes := by decide
theorem thm2 : sameSize? heroes langs := by decide

-- Look up: Overloading indexing using GetElem type class

-- Standard classes

/-
-- Unlike C++, infix operators in Lean are defined as abbreviations for named functions;
-- this means that overloading them for new types is not done using the operator itself,
-- but rather using the underlying name (such as HAdd.hAdd).
-/

/-
-- Arithmetic: HAdd.hAdd, HSub.hSub, HMul.hMul, HDiv.hDiv, HMod.hMod, HPow.hPow., Neg.neg
-- Bitwise operators
-/

-- overloading <, ≤, >, ≥
-- since the concerned typeclasses except Prop instead of Bool, we implement using Prop
def lessThan : Even → Even → Prop
  | 0, 0 => False                                 -- False : Prop
  | 0, _ => True                                  -- instead of true : Bool
  | _, 0 => False
  | Even.succ n, Even.succ k => lessThan n k

def lessOrEquals : Even → Even → Prop
  | 0, _ => True
  | _, 0 => False
  | Even.succ n, Even.succ k => lessOrEquals n k

def greaterThan : Even → Even → Prop
  | 0, 0 => False
  | 0, _ => False
  | _, 0 => True
  | Even.succ n, Even.succ k => greaterThan n k

def greaterOrEquals : Even → Even → Prop
  | _, 0 => True
  | 0, _ => False
  | Even.succ n, Even.succ k => greaterOrEquals n k

instance : LT Even where
  lt := lessThan

instance : LE Even where
  le := lessOrEquals

-- also use LT for greater than by switching the arguments
instance : LT Even where 
  lt y x := greaterThan x y

instance : LE Even where
  le y x := greaterOrEquals x y

def zero' : Even := 0
def two' : Even := 2
def four' : Even := 4
def six' : Even := 6
def eight' : Even := 8

-- will need more work than the above to get it to work....oops

-- Deriving standard classes

deriving Repr for Even
deriving BEq for Even -- Boolean equality

-- Appending (++) 

#eval [2, 3, 4] ++ [6]
#eval ["Linux"] ++ ["Symbian", "macOS"]

-- our custom List
inductive lameList (α : Type) where
  | nil
  | cons : α → lameList α → lameList α
deriving Repr, BEq, Hashable

open lameList

def list1 : lameList String := cons "Kierkegaard" nil
def list2 : lameList String := cons "Wittgenstein" $ cons "Nietzsche" $ cons "Sartre" nil

def lameListConstruct : List α → lameList α
  | [] => nil
  | x :: xs => cons x (lameListConstruct xs)

#eval lameListConstruct ["Dmitri", "Ivan", "Alyosha"]
#eval list2 == (lameListConstruct ["Wittgenstein", "Nietzsche", "Sartre"]) -- because we derived BEq for our lameList

-- length function of our lameList
def lameList.length {α : Type} : lameList α → Nat
  | nil => 0
  | cons _ xs => 1 + xs.length

-- to append a single element
def lameList.appendElm {α : Type} : lameList α → α → lameList α
  | nil, k => cons k nil
  | cons x xs, k => cons x (xs.appendElm k) 

-- to append two lameLists
def lameList.append {α : Type} : lameList α → lameList α → lameList α
  | xs, nil => xs
  | xs, cons y ys => lameList.append (xs.appendElm y) ys -- very inefficient: try to improve

#eval list1.appendElm "Schopenhauer"
#eval list1.append list2
#eval lameList.append list2 list1

-- Overloading appending (++)
-- to overload ++, use HAppend (heterogeneous) or Append

instance : Append (lameList α) where
  append := lameList.append

#eval list1 ++ list2 -- works
#eval (list1 ++ list2) == (list1.append list2) -- true

theorem thm3 : (list1 ++ list2) = (list1.append list2) := by decide -- failed to synthesize Decidable (list1 ++ list2 = list1.append list2)

-- Functors

/-
-- A polymorphic type is a functor if it has an overload for a function named map that
-- transforms every element contained in it by a function.
-- For instance, mapping a function f over an Option leaves none untouched, and replaces some x with some (f x)
--
-- Lean provides an infix operator for mapping a function, namely <$>
-/

#eval List.map (λ x => x ^ 2) [1, 2, 3, 4, 5] -- [1, 4, 9, 16, 25]
#eval (· ^ 2) <$> [1, 2, 3, 4, 5] -- [1, 4, 9, 16, 25]
#eval List.reverse <$> [["Time", "Space"], ["Einstein", "Newton"]]

-- our lameList again
def lameList.map {α β : Type} (f : α → β) : lameList α → lameList β
  | nil => nil
  | cons x xs => cons (f x) (lameList.map f xs)

#eval lameList.map String.length list2 -- it works

-- to use <$> operator
-- the instance is defined for lameList rather than for lameList α because the argument type α plays no role in resolving the type class
instance : Functor lameList where
  map := lameList.map -- map f xs := lameList.map f xs

#eval String.length <$> list2 -- it works

/-
-- Even when the type contained in a functor is itself a functor,
-- mapping a function only goes down down layer.
-- (See example below)
-/

def layeredList : lameList (Array Nat) := cons #[2, 3, 5, 7] $ cons #[2, 4, 6, 8] nil
#eval Array.size <$> layeredList                  -- works, since it goes down just one level
#eval (· ^ 2) <$> layeredList                     -- failed to synthesize HPow (Array Nat) Nat ?m.14757

/-
-- Functor instances should follow two rules
-- (1) Mapping the identity function should result in the original argument,
       i.e.,    id <$> x equals x
-- (2) Mapping two composed functions should have the same effect as composing their mapping,
       i.e.,    map (fun y => f (g y)) x equals map f (map g x)
-/

-- a binary tree prototype
inductive BTree' (α : Type) where
  | nill
  | node (value : α) (left : BTree' α) (right : BTree' α)
deriving Repr

def BTree'.toList {α : Type} : BTree' α → List α
  | BTree'.nill => []
  | BTree'.node value left right => [value] ++ left.toList ++ right.toList

def BTree'.length {α : Type} : BTree' α → Nat
  | BTree'.nill => 0
  | BTree'.node _ left right => 1 + left.length + right.length

def emptyTree' : BTree' String := BTree'.nill
def oneNodeTree' : BTree' String := BTree'.node "Dostoevsky" BTree'.nill BTree'.nill

#eval emptyTree'
#eval oneNodeTree'
#eval emptyTree'.length
#eval oneNodeTree'.length

/-
-- Appending an element to a BTree' (the code is unfinished)
def BTree'.append {α : Type} : BTree' α → α → BTree' α
  | BTree'.nil, k => BTree'.node k BTree'.nil BTree'.nil
  | BTree'.node _ BTree'.nill _, k => BTree'.node _ (BTree'.node k BTree'.nil BTree'.nil) _
  | BTree'.node _ _ BTree'.nill, k => BTree'.node _ _ (BTree'.node k BTree'.nil BTree'.nil)
  | BTree'.node _ left right, k => 
-/

-- Challenge: given the size of a BTree', find the exact position where the next (new) element must go to

--- Coercions

/-
-- When Lean encounters an expression of one type in a context that expects a different type,
-- it will attempt to coerce the expression before reporting a type error.
-- Unlike Java, C, and Kotlin, the coercions are extensible by defining instances of type classes.
-/

-- The type class Coe describes overloaded ways of coercing from one type to another

instance : Coe Even Nat where
  coe x := x.toNat

#eval [1, 4, 2, 9].drop (2 : Even) -- drop expects a Nat, no Even, but coercion occurs
#check [1, 4, 2, 9].drop (2 : Even) -- List.drop (Even.toNat 2) [1, 4, 2, 9] : List Nat

-- Coercions can be chained: such as using two coercions: from A to B, then from B to C

-- The Lean standard library defines a coercion from any type α to Option α that wraps the value in some.

def List.myLast? : List α → Option α
  | [] => none
  | [x] => x           -- instead of some x
  | _ :: xs => myLast? xs

#eval [7, 8, 9, 12].myLast? -- some 12

-- Look up: Dependent coercions can be used when the ability to coerce from one type to another
-- depends on which particular value is being coerced. 

-- Coercing to types

-- Think of mathematical monoid
structure Monoid (Carrier : Type) where
--  Carrier : Type                      -- underlying set
  neutral : Carrier                   -- identity element
  op : Carrier → Carrier → Carrier    -- monoid operation

-- Natural numbers addition as monoid
def natAddMonoid : Monoid Nat := 
  { neutral := 0, op := (· + ·) }

-- Natural numbers multiplication as monoid
def natMulMonoid : Monoid Nat :=
  { neutral := 1, op := (· * ·) }

def stringMonoid : Monoid String :=
  { neutral := "", op := String.append }

def listMonoid (α : Type) : Monoid (List α) :=
  { neutral := [], op := List.append }

/-
-- Given a monoid, it is possible to write the foldMap function that, in a single pass,
-- transforms the entries in a list into a monoid's carrier set and then combines them using the monoid's operator.
-- Because monoids have a neutral element, there is a natural result to return when the list is empty,
-- and because the operator is associative, clients of the function don't have to care
-- whether the recursive function combines elements from left to right or from right to left.
-/

-- receives a list, converts into a monoid, and do fold operation using the monoid's operation
-- if list empty, returns the neutral element
def foldMap (M : Monoid β) (f : α → β) (xs : List α) : β :=
  let rec go (soFar : β) : List α → β
    | [] => soFar
    | y :: ys => go (M.op soFar (f y)) ys
  go M.neutral xs

def someExperimentalEvens : List Even := [2, 4, 6, 8]

#eval foldMap natMulMonoid (·) [1, 2, 3, 4, 5]
#eval foldMap natAddMonoid Even.toNat someExperimentalEvens
