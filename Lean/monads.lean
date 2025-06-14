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



