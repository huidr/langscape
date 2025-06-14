------------
-- Monads --
------------

-- preliminaries
def _first (xs : List α) (ok : xs.length > 0) : α :=
  xs[0]

#eval _first [2, 3, 4] (by decide) -- 2

-- can also be rewritten this way
def _first' (xs : List α) : Option α :=
  xs[0]?

#eval _first' [2, 3, 4] -- some 2       

-- to get first, third, fifth element...
def _firstThirdFifth (xs : List α) : Option (α × α × α) := -- to return a tuple
  match xs[0]? with
    | none => none
    | some first =>
      match xs[2]? with
        | none => none
        | some third =>
          match xs[4]? with
            | none => none
            | some fifth => (first, third, fifth)

-- observe: the above could go quite long and may clutter
-- solution: use a helper to take care of propagating none values
def _helper (opt : Option α) (next : α → Option β) : Option β :=
  match opt with
    | none => none
    | some x => next x

-- then rewrite our earlier long function..
def _firstThirdFifth' (xs : List α) : Option (α × α × α) :=
  _helper xs[0]? λ first =>                                     -- early exit, return none if xs[0] is none, otherwise chain...
  _helper xs[2]? λ third =>                                     -- chaining
  _helper xs[4]? λ fifth => 
  some (first, third, fifth)                                    -- final return

-- one can define infix operators using infix, infixl, infixr
-- infix : non-associative      1 + 2 + 3 fails
-- infixl : left-associative    1 + 2 + 3 = (1 + 2) + 3
-- infixr : right-associative   1 + 2 + 3 = 1 + (2 + 3)

infix:55 " ~~> " => _helper     -- 55 is the precedence (e.g., + has precedence 65 and * has 70)

-- larger functions will become more concise now
def _firstThirdFifthSeventhNinth (xs : List α) : Option (α × α × α × α × α) :=
  xs[0]? ~~> λ first =>
  xs[2]? ~~> λ third =>
  xs[4]? ~~> λ fifth =>
  xs[6]? ~~> λ seventh =>
  xs[8]? ~~> λ ninth =>
  some (first, third, fifth, seventh, ninth)

-- similarly error messages can be propagated too
-- errors in Lean are like Except α β with constructors error α, 
def get (xs : List α) (i : Nat) : Except String α :=
  match xs[i]? with
  | none => Except.error "Index not found"
  | some x => Except.ok x

-- the rest can be done similarly, that is, defining helper function and chaining...

/-
-- Many programs need to traverse a data structure once,
-- while both computing a main result and accumulating some kind of tertiary extra result.
-- An example: a function that computes the sum of all the nodes in a tree with an inorder traversal,
--             while simultaneously recording each nodes visited
--
-- The key idea of monads is that each monad encodes a particular kind of side effect
-- using the tools provided by the pure functional language Lean.
-- For example, Option represents programs that can fail by returning none,
--              Except represents programs that can throw exceptions. 
--
-- To make things easier, Lean standard library provides a type class Monad
-- Monads have two operations, which are equivalent of ok and _helper
-/

-- a simplified version looks like...
class simpleMonad (m : Type → Type) where
  pure : α → m α                             -- wrapping some value -- puts a value into some context
  bind : m α → (α → m β) → m β               -- like that helper function -- to chain computations, propagate context

-- Think of a monad as a "wrapped value" + "rules for composition"

-- our Option type
inductive _Option (α : Type) where
  | none
  | some : α → _Option α

-- Monad instance for Option can be created as...
instance : Monad _Option where
  pure x := _Option.some x
  bind opt next := 
    match opt with
    | _Option.none => _Option.none
    | _Option.some x => next x

-- Similary, for Except
inductive _Except (ε α : Type) where
  | error : ε → _Except ε α 
  | ok : α → _Except ε α

instance : Monad (_Except ε) where
  pure x := _Except.ok x
  bind attempt next :=
    match attempt with
    | _Except.error e => _Except.error e
    | _Except.ok x => next x

-- the previous function rewritten using Monad
def _firstThirdFifthSeventh [Monad m] (lookup : List α → Nat → m α) (xs : List α) : m (α × α × α × α) :=
  lookup xs 0 >>= λ first =>
  lookup xs 2 >>= λ third =>
  lookup xs 4 >>= λ fifth =>
  lookup xs 6 >>= λ seventh =>
  pure (first, third, fifth, seventh)
-- The fact that m must have a Monad instance means that the >>= and pure operations are available.

#eval _firstThirdFifthSeventh (λ xs i => xs[i]?) [7, 8, 12, 4, 3, 10, 1]

-- Identity monad is a monad that has no effects: allows pure code to be used with monadic APIs

def Identity : Type → Type | t => t

instance : Monad Identity where
  pure x := x
  bind x f := f x

/-

There is a contract that each instance of Monad should obey.

* `pure` should be a left identity of `bind`, that is, `bind (pure v) f` should be the same as `f v`.
* `pure` should be a right identity of `bind`, so `bind v pure` is the same as `v`
* `bind` should be associative, that is, `bind (bind v f) g` is the same as `bind v (λ x => bind (f x) g)`

-/

-- do-notation for monads: allows more concise and tidier syntax which is reminiscent of imperative-style programming

-- rewriting our firstThirdFifthSeventh using do-notation
def _firstThirdFifthSeventh' [Monad m] (lookup : List α → Nat → m α) (xs : List α) : m (α × α × α × α) := do
  let first ← lookup xs 0
  let third ← lookup xs 2
  let fifth ← lookup xs 4
  let seventh ← lookup xs 6
  pure (first, third, fifth, seventh)

-- can make it even more succinct
def firstThirdFifthSeventh [Monad m] (lookup : List α → Nat → m α) (xs : List α) : m (α × α × α × α) := do
  pure (← lookup xs 0, ← lookup xs 2, ← lookup xs 4, ← lookup xs 6)

#eval firstThirdFifthSeventh (λ xs i => xs[i]?) [7, 8, 12, 4, 3, 10, 1]

-- The #print command reveals the internals of Lean datatypes and definitions
#print IO
#print IO.Error -- all constructors of IO.Error -- list of errors IO action can give 

-- multiple patterns sharing the same result expression can be made more concise
inductive Weekday where
  | monday
  | tuesday
  | wednesday
  | thursday
  | friday
  | saturday
  | sunday
deriving Repr

def Weekday.isWeekend : Weekday → Bool
  | .saturday | .sunday => true
  | _ => false

#print Weekday
#print Weekday.monday
#print Weekday.isWeekend

/-

## Functors vs Monads 

Functor describes containers in which the contained data can be transformed, and Monad describes an encoding of programs with side effects.

But, there is a deeper relationship between the two: _every monad is a functor_

* Applicative functors is an intermediate between the two; it has enough power to write many interesting programs and yet permits libraries that cannot use the Monad interface.
* Applicative type class provides the overloadable operations of applicative functors.
* Every monad is an applicative functor, and every applicative functor is a functor, but the converses do not hold.

-/

-- *Structure inheritance*

-- much like inheritance of object-oriented paradigm
structure MythicalCreature where
  large : Bool
deriving Repr

structure Monster extends MythicalCreature where       -- every monster is also mythical
  vulnerability : String
deriving Repr

def troll : Monster where
  large := true
  vulnerability := "sunlight"

def goblin : Monster := {large := false, vulnerability := "spears"}

def vampire : Monster := ⟨false, "sunlight"⟩ -- will fail
def vampire : Monster := ⟨⟨false⟩, "sunlight"⟩ -- works -- because inheritance is implemented using composition

/-

Note: _Inheritance is implemented using composition_.

In addition to defining functions to extract the value of each new field,
a function Monster.toMythicalCreature is defined with type Monster → MythicalCreature.
This can be used to extract the underlying creature.

Unlike upcasting in OOP languages (in which an upcast operator causes 
a value from a derived class to be treated as an instance of the parent class,
but the value retains its identity and structure),
in Lean, however, moving up the inheritance hierarchy actually erases the underlying information.

-/

#eval goblin.toMythicalCreature -- loses the information of vulnerability

-- _Multiple inheritance is possible_ (does automatic collapsing of diamonds: choose the first one that appears in the declaration)

/-

## _Type classes can be inherited_

* Behind the scenes, type classes are structures.
* Defining a new type class defines a new structure, and defining an instance creates a value of that structure type.
* A consequence of this is that type classes may inherit from other type classes.

* Because it uses precisely the same language features, type class inheritance supports all the features of structure inheritance.
* This includes multiple inheritance, default implementations of parent types' methods, and automatic collapsing of diamonds. 

-/
