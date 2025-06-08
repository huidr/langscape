-- basics.lean

-- Ways of defining functions:
def add (a: Nat) (b: Nat) : Nat :=  a + b
def sub (a: Nat) (b: Nat) := (a - b : Nat)
def mult : Nat → Nat → Nat := λ a b => a * b 
def div : Nat → Nat → Nat := fun a b => a / b -- fun instead of λ

-- Define variables (immutable)
def first : Nat := 4 -- type annotation
def second := 8

--#check add -- add (a b : Nat) : Nat
--#check add first -- add first : Nat -> Nat
--#check add first second -- add first second : Nat

--#eval add first second
--#eval sub second first

--#check mult -- mult : Nat → Nat → Nat
--#check mult 6  -- mult 6 : Nat → Nat
--#eval mult 6 9

--#check div 8 3 -- div 8 3 : Nat
--#eval div 8 3

-- Lean is expression-oriented
-- has only conditional expressions, no conditional statements
#eval if 3 ≥ 2 then true else false -- true
#eval if 3 ≠ 2 then "unequal" else "equal" -- "unequal"

#check String.append -- String.append : String → String → String
#eval String.append "it is" " great"

#eval String.append "it is" (String.append " a great" " machine")

def maximum : Nat → Nat → Nat := 
  λ a b => if a > b then a else b

--#eval maximum 17 12

-- the following function creates a new string by placing its first argument between its second and third arguments
def joinStringsWith : String → String → String → String :=
  λ a b c => String.append b (String.append a c)

#check joinStringsWith ":" -- String → String → String 
#eval joinStringsWith " and " "Benny" "Joon" -- "Benny and Joon"

-- Defining types 
def Str : Type := String
def sail : Str := "Sail"

--#check sail -- sail : Str
--#eval sail

-- but the following will fail (because Lean supports overloaded integer literals)
-- def N : Type := Nat
-- def six : N := 6

-- the following will work though
def N : Type := Nat
def six : N := (6 : Nat)

--#eval six

-- better to use abbrev for this purpose?
abbrev NN : Type := Nat
def nine : NN := 9

#check nine -- nine : NN
--#eval nine

-- Structures ------------------------------------------------------------------------------

structure Point where
  x : Float
  y : Float
deriving Repr -- asks Lean to generate code to display values of type Point (used by #eval to render the result of evaluation)
 
def origin : Point := { x := 0, y := 0}

--#check origin
--#eval origin

--#eval origin.x -- dot notation to extract the individual fields of a structure
--#eval origin.y

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

-- Can also use ⟨ ⟩ syntax (positional arguments) to build a structure
#eval (⟨1.4, 2.7⟩ : Point) -- equivalent to Point.mk 1.4 2.7

-- An accessor function is defined for each field of a structure
#check Point.x 
#check Point.y -- Point.y (self : Point) : Float

#eval Point.x origin -- 0.000000
--#eval origin.x -- same thing as above

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
--#check one -- one : NaturalNumber
--#eval one -- NaturalNumber.succ NaturalNumber.zero

def two : NaturalNumber := NaturalNumber.succ one
--#eval two -- NaturalNumber.succ (NaturalNumber.succ (NaturalNumber.zero))

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

--#check (replaceY) -- replaceY : (α : Type) → PolyPoint α → α → PolyPoint α

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

-- y :: ys is Lean equivalent of Haskell's y : ys 
def myLength {α : Type} (xs : List α) : Nat :=
  match xs with
  | [] => 0
  | _ :: ys => 1 + myLength ys

inductive PolyList (α : Type) where
  | nil
  | cons : α → PolyList α → PolyList α

def someExplicitNats : PolyList Nat := PolyList.cons 1 (PolyList.cons 4 (PolyList.cons 7 (PolyList.cons 9 PolyList.nil)))

-- Lean ensures termination of all recursive definitions by construction (structural recursion)
def length {α : Type} (xs : PolyList α) : Nat := -- structural recursion on xs
  match xs with
  | PolyList.nil => 0
  | PolyList.cons _ ys => 1 + length ys -- recursive calls must be on subcomponents (subterms) of the original input

def map {α : Type} (f : α → α ) (xs : PolyList α ) : PolyList α :=
  match xs with
  | PolyList.nil => PolyList.nil
  | PolyList.cons y ys => PolyList.cons (f y) (map f ys)

-- The implicit argument fails 
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
def reverseHelper {α : Type} (xs acc : PolyList α) : PolyList α :=
  match xs with
  | PolyList.nil => acc
  | PolyList.cons y ys => reverseHelper ys (PolyList.cons y acc)

def reverseFast {α : Type} (xs : PolyList α) : PolyList α := -- this is O(n) time
  reverseHelper xs PolyList.nil

--#eval reverseFast someExplicitNats

def filter {α : Type} (f : α → Bool) (xs : PolyList α) : PolyList α :=
  match xs with
  | PolyList.nil => PolyList.nil
  | PolyList.cons y ys => if f y then PolyList.cons y (filter f ys) else filter f ys

-- Left Fold
def fold (α β: Type) (f : β → α → β) (acc : β) (xs : PolyList α) : β := -- tail-recursive
  match xs with
  | PolyList.nil => acc
  | PolyList.cons y ys => fold α β f (f acc y) ys

-- Right Fold
def rfold (α β : Type) (f : α → β → β) (acc : β) (xs : PolyList α) : β := -- not tail-recursive
  match xs with
  | PolyList.nil => acc
  | PolyList.cons y ys => f y (rfold α β f acc ys)

#eval filter (α := Nat) (λ x => x ≠ 1) someExplicitNats -- the implicit argument has been provided, so don't infer
#eval fold Nat Nat (λ a x => a + x) 0 someExplicitNats

-- To try next...
-- map₂ — zip two lists with a function
-- flatten — flatten a PolyList (PolyList α)
-- concatMap — map then flatten (a precursor to monads)
-- Define a Monad or Functor instance manually

-- Option
-- List.head? and List.tail? are implemented as Option
#eval List.head? [1, 2, 3] -- equivalently, [1, 2, 3].head?
#eval List.tail? [1, 2, 3] -- equivalently, [1, 2, 3].tail?

-- It is a convention to define operations that might fail in groups using the suffixes ? for a version that returns an Option

def List.newHead? {α : Type} (xs : List α) : Option α :=
  match xs with
  | [] => none
  | y :: _ => some y

def List.newTail? {α : Type} (xs : List α) : Option (List α) :=
  match xs with
  | [] => none
  | _ :: ys => some ys

#eval [2, 4, 7, 8].newHead?
#eval List.newTail? [2, 4, 7, 8]

-- implementing last (like Haskell's)
def List.last? {α : Type} (xs : List α) : Option α :=
  match xs with
  | [] => none
  | [k] => some k
  | _ :: ys => List.last? ys

#eval [7, 10, 2, 4].last? -- some 4
#eval List.last? [] (α := String) -- none

-- finds the first entry in a list that satisfies a given predicate
def List.findFirst? {α : Type} (xs : List α) (predicate : α → Bool) : Option α :=
  match xs with
  | [] => none
  | y :: ys => if predicate y then some y else List.findFirst? ys predicate

#eval List.findFirst? [2, 4, 7] (λ x => x ≠ 2)

-- You can also leave the implicit argument out in the signature itself leaving all to type inference (see the following)
-- Haskell-like take function
def newTake (n : Nat) (xs : List α) : List α := -- List.take is defined in the standard library
  match xs with
  | [] => []
  | y :: ys => if n > 0 then y :: newTake (n - 1) ys else []

-- Pattern-matching definitions
-- The same function without using match keyword (note the change in syntax)
def take : Nat → List α → List α 
  | 0, _ => []
  | _, [] => []
  | n, y :: ys => y :: take (n-1) ys

def drop : Nat -> List α → List α
  | 0, xs => xs
  | _, [] => []
  | n, _ :: ys => drop (n-1) ys

inductive MyOption (α : Type) where
  | myNone
  | mySome (k : α)

open MyOption -- brings the namespace myOption into scope, so you don't have to write full qualified names like myOption.myNone
-- open can be used globally or locally (inside def, for instance)
-- open MyOption (mySome) -- expose only this identifier instead of the whole namespace

#eval mySome (2.4 : Float)
#eval mySome "Tom Holland" -- type inference
#eval (myNone : MyOption Nat)

#eval [].head? (α := Nat) -- type annotation necessary 
#eval ([] : List Nat).head? -- equivalent to above

-- Product types: defined in the standard library as structure
def ones : Prod String Nat := { fst := "one", snd := 1 }
def twos : String × Nat := { fst := "two", snd := 2 } -- α × β as a notation for Prod α β 
def threes : String × Nat := ("three", 3) -- works too, think of pairs

-- Both the above notations are right-associative
def fours : String × (String × Int) := ("IV", ("four", 4))
def fives : String × String × Int := ("V", "fives", 5)

structure MyProd (α β : Type) where
  fst : α
  snd : β
deriving Repr

notation s " Π " t => MyProd s t 

def newOnes : String Π Int := { fst := "one", snd := 1 }

-- switches the two fields in a pair for each other
def Prod.switch {α β : Type} (pair : α × β) : β × α :=
  { fst := pair.snd, snd := pair.fst }

-- Sum types
def PetName : Type := String ⊕ String -- α ⊕ β as notation for Sum α β
def animals : List PetName := [ Sum.inl "Tom", Sum.inr "Jerry" ]

inductive MySum (α β : Type) where
  | inl : α → MySum α β -- inl stands for left injection
  | inr : β → MySum α β -- inr stands for right injection
deriving Repr

notation s " Σ " t => MySum s t

def myNum : String Σ Nat := MySum.inl "Five"
def myNat : String Σ Nat := MySum.inr 5

-- Exercise: build monadic-style functions like mapLeft, mapRight

/- 
-- Prod and Sum should be used either when writing very generic code,
-- for a very small section of code where there is no sensible domain-specific type,
-- or when the standard library contains useful functions.
-- In most situations, it is more readable and maintainable to use a custom inductive type.
-/

-- Local definitions: use 'let' to store intermediate values

-- Local definitions with let may also use pattern matching when one pattern is enough to match all cases of a datatype (see below)
def unzip : List (α × β) → List α × List β
  | [] => ([], [])
  | (x, y) :: xys => 
    let (xs, ys) : List α × List β := unzip xys -- to avoid multiple computation of the same value
    (x :: xs, y :: ys)

#eval unzip [(2, "time"), (4, "mimick"), (3, "spare")] -- ([2, 4, 3], ["time", "mimick", "spare"])

-- The biggest difference between let and def is that recursive let definitions must be explicitly indicated by writing let rec
def reverse (xs : List α) : List α :=
  let rec helper : List α → List α → List α -- can't use def here
    | [], soFar => soFar
    | y :: ys, soFar => helper ys (y :: soFar)
  helper xs []

-- def, inductive, structure, theorem, etc. are always global
-- Only let and let rec are allowed inside expressions

-- Simultaneous matching

-- similar to the pattern-matching definition
def sameLength? (xs : List α) (ys : List β) : Bool :=
  match xs, ys with
  | [], [] => true
  | _ :: xs', _ :: ys' => sameLength? xs' ys'
  | _, _ => false

#eval sameLength? [1, 2] ["one", "two", "three"]

-- Natural number patterns

def even : Nat → Bool
  | 0 => true
  | k + 1 => ¬ even k

def halve : Nat → Nat
  | 0 => 0
  | 1 => 0
  | k + 2 => halve k + 1 -- | 2 + k => halve k + 1 would have been an error

-- Namespaces

-- Each name in Lean occurs in a namespace, which is a collection of names
-- Names are placed in namespaces using .

-- Names can be directly defined within a namespace
def List.double : List Nat → List Nat
  | [] => []
  | x :: xs => x * 2 :: List.double xs

#eval List.double [3, 4]

-- Alternatively, namespace keyword may be used
namespace LittleSpace
def double : Nat → Nat | x => 2*x
def triple : Int → Int | x => 3*x
end LittleSpace

#eval LittleSpace.double 12
#eval LittleSpace.triple (-2)

-- Namespace can be opened, to bring the names defined inside that namespace in scope
def quadruple (x : Nat) : Nat :=
  open LittleSpace in
  double $ double x

-- if let
-- When consuming values that have a sum type, it is often the case that only a single constructor is of interest

inductive Inline where
  | lineBreak
  | string : String → Inline
  | emph : Inline → Inline
  | strong (k : Inline)

def Inline.string? (inline : Inline) : Option String :=
  if let Inline.string s := inline then some s else none

#eval Inline.string "Devil" |> Inline.string?

-- String interpolation

-- expressions contained in curly braces inside the string are replaced with their values (like f-strings of Python)
#eval s!"This is {LittleSpace.double 1}"

-- Be warned: not all expressions cannot be converted to strings (use deriving Repr syntax for that)

-- Anonymous functions

-- Every simple functions can be written using ⬝ (cdot) as a placeholder
#eval (· - 2) 7 -- subtraction
#eval filter (α := Nat) (· ≠ 1) someExplicitNats -- the implicit argument has been provided, so don't infer

-- Notations
#eval some $ String.append "Bruce" " Wayne" -- like in Haskell, $ is right-associative and low-precedence
#eval "Time" |> String.length -- like in OCaml, Elixir -- equivalent to #eval String.length "Time"
-- But $, |> are not built-in keywords, they are regular notations

-- You can define notations:
notation f " | " x => f x 

#eval mySome | String.append "Lean" " Language"

-- Lean also supports function composition through ∘ 
#eval (String.length ∘ String.trim) "  function composer  "
