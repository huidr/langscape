-- IO actions

def helloWorld : IO Unit := IO.println "Hello World"

def greeter : String → IO Unit
  | "" => IO.println "Oops. Empty argument."
  | name => IO.print s!"Hello, {name}"

def main : IO Unit := greeter "Lean"
