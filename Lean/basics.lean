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

-- Structures
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

