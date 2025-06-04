-- basics.lean

-- Ways of defining functions:
def add (a: Nat) (b: Nat) : Nat :=  a + b
def sub (a: Nat) (b: Nat) := (a - b : Nat)
def mult : Nat → Nat → Nat := λ a b => a * b 
def div : Nat → Nat → Nat := fun a b => a / b -- fun instead of λ

-- Define variables (immutable)
def first : Nat := 4 -- type annotation
def second := 8

#check add -- add (a b : Nat) : Nat
#check add first -- add first : Nat -> Nat
#check add first second -- add first second : Nat

#eval add first second
-- #eval sub second first

#check mult -- mult : Nat → Nat → Nat
#check mult 6  -- mult 6 : Nat → Nat
#eval mult 6 9

#check div 8 3 -- div 8 3 : Nat
#eval div 8 3

-- Lean is expression-oriented
-- has only conditional expressions, no conditional statements
#eval if 3 ≥ 2 then true else false -- true
#eval if 3 ≠ 2 then "unequal" else "equal" -- "unequal"

#check String.append -- String.append : String → String → String
#eval String.append "it is" " great"

#eval String.append "it is" (String.append " a great" " machine")

def maximum : Nat → Nat → Nat := 
  λ a b => if a > b then a else b

#eval maximum 17 12

-- the following function creates a new string by placing its first argument between its second and third arguments
def joinStringsWith : String → String → String → String :=
  λ a b c => String.append b (String.append a c)

#check joinStringsWith ":" -- String → String → String 
#eval joinStringsWith " and " "Benny" "Joon" -- "Benny and Joon"

-- Defining types 
def Str : Type := String
def sail : Str := "Sail"

#check sail -- sail : Str
#eval sail

-- but the following will fail (because Lean supports overloaded integer literals)
-- def N : Type := Nat
-- def six : N := 6

-- the following will work though
def N : Type := Nat
def six : N := (6 : Nat)

#eval six

-- better to use abbrev for this purpose?
abbrev NN : Type := Nat
def nine : NN := 9

#check nine -- nine : NN
#eval nine

-- Structures ------------------------------------------------------------------------------

structure Point where
  x : Float
  y : Float
deriving Repr -- asks Lean to generate code to display values of type Point (used by #eval to render the result of evaluation)
 
def origin : Point := { x := 0, y := 0}

#check origin
#eval origin

#eval origin.x -- dot notation to extract the individual fields of a structure
#eval origin.y

def addPoints : Point → Point → Point :=
  λ a b => { x := a.x + b.x, y := a.y + b.y }

#check addPoints
#eval addPoints { x := 2.0, y := 7.1 } { x := 0.2, y := 4.3 }

-- Updating structures
def zeroX : Point → Point :=
  λ p => { p with x := 0 }

#check zeroX
#eval zeroX { x := 7.2, y := -4 } -- the first field (i.e., x) will be 0

-- Every structure has a constructor, which simply gather the data to be stored in the newly allocated data structure
-- This concept of constructor is different from that in C++ or Java or Python
-- By default, the constructor of a structure S is named S.mk (here S is an namespace qualifier and mk is the name of the constructor itself
-- Constructors have function types, hence they can be used anywhere that a function is expected
#check Point.mk -- Point.mk (x y : Float) : Point

-- the following syntax may be used although not considered good practice 
#check Point.mk 1.4 2.7 -- applying constructor directly instead of using curly-brace initialization syntax

-- An accessor function is defined for each field of a structure
#check Point.x 
#check Point.y -- Point.y (self : Point) : Float

#eval Point.x origin -- 0.000000
#eval origin.x -- same thing as above

-- The dot accessor notation can be generalized as follows
-- TARGET.f ARG1 ARG2 .....
-- If TARGET has type T, the function named T.f is called
-- TARGET becomes its leftmost argument of type T and ARG 1 ARG 2 ... are provided in order as the remaining arguments

#eval "Me".append " and You" -- equivalent to String.append "Me" " and You"

def Point.modifyBoth : (Float → Float) → Point → Point := -- modifyBoth is defined in the Point namespace
  λ f p => { x := f p.x, y := f p.y }

#check Point.modifyBoth

def randomPoint : Point := { x := 7.1, y := -2.4 }
#eval Point.modifyBoth Float.floor randomPoint -- Float.floor is the standard floor function
#eval randomPoint.modifyBoth Float.floor -- equivalent to the above

-- Datatypes and Patterns ---------------------------------------------------------------

-- Product types (e.g. structure): group together a collection of values
-- Sum types: allow choices (Rust's enum?)
-- Recursive types: can include instances of themselves
-- Inductive types: sum + recursive

inductive NewBool where -- sum type
  | newFalse : NewBool -- a constructor (the annotation may be omitted)
  | newTrue -- another constructor

#check NewBool.newTrue -- NewBool

-- Let's do some Peano stuff
inductive NaturalNumber where
  | zero
  | succ : NaturalNumber → NaturalNumber -- alternatively, succ (k : NaturalNumber) : NaturalNumber

def one : NaturalNumber := NaturalNumber.succ NaturalNumber.zero
#check one -- one : NaturalNumber
#eval one -- NaturalNumber.succ NaturalNumber.zero

def two : NaturalNumber := NaturalNumber.succ one
#eval two -- NaturalNumber.succ (NaturalNumber.succ (NaturalNumber.zero))

def three := NaturalNumber.succ two -- no annotation, type inference

-- Some pattern matching demo ahead
def isZero : NaturalNumber → Bool :=
  λ n => match n with
  | NaturalNumber.zero => true
  | NaturalNumber.succ _ => false -- using _ as placeholder

def pred : NaturalNumber → NaturalNumber :=
  λ n => match n with
  | NaturalNumber.zero => NaturalNumber.zero
  | NaturalNumber.succ k => k

def isEven : NaturalNumber → Bool := λ n => 
  match n with
  | NaturalNumber.zero => true
  | NaturalNumber.succ k => not (isEven k)

def isOdd (n : NaturalNumber) : Bool := ¬ (isEven n) -- not and ¬ are the same

def plus (m n : NaturalNumber) : NaturalNumber :=
  match n with
  | NaturalNumber.zero => m
  | NaturalNumber.succ k => NaturalNumber.succ (plus m k)

def four := plus two two -- type inference
def five := plus one four

def minus (m n : NaturalNumber) : NaturalNumber :=
  match n with
  | NaturalNumber.zero => m
  | NaturalNumber.succ k => pred (minus m k) -- because m-n = m-(k+1) = m-k-1 = pred(m-k)

def multiply (m n : NaturalNumber) : NaturalNumber :=
  match n with
  | NaturalNumber.zero => NaturalNumber.zero
  | NaturalNumber.succ k => plus m (multiply m k)

-- Polymorphism ------------------------------------------------------------------------------

-- In functional programming, the term polymorphism typically refers to datatypes and definitions that take types as arguments

structure PolyPoint (α : Type) where
  xcoor : α
  ycoor : α
deriving Repr

def polyOrigin : PolyPoint String := { xcoor := "Lean", ycoor := "Prover" }

def xyConcat (p : PolyPoint String) : String := String.append p.xcoor p.ycoor
def leanProver := xyConcat polyOrigin

-- Types are ordinary expressions in Lean, so passing arguments to polymorphic types requires no special syntax

def replaceY (α : Type) (point : PolyPoint α) (newYcoor : α) : PolyPoint α :=
  { point with ycoor := newYcoor }

#check (replaceY) -- replaceY : (α : Type) → PolyPoint α → α → PolyPoint α

-- Providing the first argument, Nat, causes all occurrences of α in the remainder of the type to be replaced with Nat (currying)
#check (replaceY Nat) -- replaceY Nat : PolyPoint Nat → Nat → PolyPoint Nat

def leanLang := xyConcat (replaceY String polyOrigin "Lang")

inductive Sign where
  | pos
  | neg

-- Types are first class and can be computed using the ordinary rules of the Lean language
-- If the argument (Sign) is positive, the function returns a Nat, while if it's negative, it returns an Int:
def posOrNegOne (s : Sign) : 
    match s with
    | Sign.pos => Nat
    | Sign.neg => Int :=
  match s with
  | Sign.pos => 1
  | Sign.neg => -1

-- Another example (a feature of dependently typed languages, not directly possible in Haskell)
def someFunction : (b : Bool) → (if b then Nat else String)
  | true => (4 : Nat)
  | false => "Four"

-- In the above, (if b then Nat else String) is a dependent return type (since b depends on the input)

-- Linked lists
def someNats : List Nat := [1, 4, 7, 9]

inductive PolyList (α : Type) where
  | nil
  | cons : α → PolyList α → PolyList α

def someExplicitNats : PolyList Nat := PolyList.cons 1 (PolyList.cons 4 (PolyList.cons 7 (PolyList.cons 9 PolyList.nil)))

-- Lean ensures termination of all recursive definitions by construction (structural recursion)
def length (α : Type) (xs : PolyList α) : Nat := -- structural recursion on xs
  match xs with
  | PolyList.nil => 0
  | PolyList.cons _ ys => 1 + length α ys -- recursive calls must be on subcomponents (subterms) of the original input

#eval length Nat someExplicitNats -- 4

def map (α : Type) (f : α → α ) (xs : PolyList α ) : PolyList α :=
  match xs with
  | PolyList.nil => PolyList.nil
  | PolyList.cons y ys => PolyList.cons (f y) (map α f ys)

#eval map Nat (λ x => x*x) someExplicitNats -- PolyList.cons 1 (PolyList.cons 16 (PolyList.cons 49 (PolyList.cons 81 (PolyList.nil))))

def append (α : Type) (x : α) (xs : PolyList α) : PolyList α :=
  match xs with
  | PolyList.nil => PolyList.cons x PolyList.nil
  | PolyList.cons y ys => PolyList.cons y (append α x ys)

def appendList (α : Type) (xs ys : PolyList α) : PolyList α :=
  match xs with
  | PolyList.nil => ys
  | PolyList.cons x xs' => PolyList.cons x (appendList α xs' ys)

def reverseSlow (α : Type) (xs : PolyList α) : PolyList α := -- O(n^2) time, since append traverses the list each time it is called
  match xs with
  | PolyList.nil => PolyList.nil
  | PolyList.cons y ys => append α y (reverseSlow α ys) 

-- The above reverseSlow can be improved to get O(n) time by using an accumulator
def reverseHelper (α : Type) (xs acc : PolyList α) : PolyList α :=
  match xs with
  | PolyList.nil => acc
  | PolyList.cons y ys => reverseHelper α ys (PolyList.cons y acc)

def reverse (α : Type) (xs : PolyList α) : PolyList α := -- this is O(n) time
  reverseHelper α xs PolyList.nil

-- Write filter and fold 
