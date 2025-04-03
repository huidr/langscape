# JULIA BASICS

x = 5                  # Int64
y = 6.42               # Float64
z = 3 + 4im            # Complex
b = true               # Bool
const PI = 3.14159

name = "Julia"         # String, dynamic typing
ch   = 'J'             # Char

name = "Julia " * "Lang"       # concatenation

n = nothing            # nothing type
m = missing            # missing type

# Operations
x = 5/0                        # Inf
x = 4/3                        # 1.333333333333333333
x = 4%3                        # 1
z = (1 + 2im) * (3 - 2im)      # complex multiplication
s = sqrt(4 + 3im)              

# Containers
arr = [ 1, 2, 3 ]              # Vector{Int64}
arr = [ 1, "Julia" ]           # Vector{Any}

arr = Int64[1, 2, 3]           # Typed vector
arr = Array{Int64}(undef, 5)   # 5-element Vector{Int64}, garbage values

mat = [1 2; 3 4]               # 2x2 Matrix{Int64}
mat = rand(3, 4)               # random 3x4 Matrix{Float64}

tup = (1, 2, "Julia")          # tuple, immutable

dct = Dict(1 => 1, 2 => 4, 3 => 9)                 # Dict{Int64, Int64} with 3 entries
dct = Dict(1 => 1, 2 => 4, 3 => 9.2)               # Dict{Int64, Real} with 3 entries
dct = Dict("a" => 4, "b" => 6, 'c' => "Julia")     # Dict{Any, Any} with 3 entries
dct['d'] = 8                                       # add new key => value pair

s = Set([ 1, 2, 3, 4, 5)]                          # Set{Int64} with 4 elements
s = Set([ "Julia", "Rust", "Lisp", "Assembly" ])   # Set{String} with 4 elements
s = Set([ 1, "Julia" ])                            # Set{Any} with 2 elements

# Control flow
if x > 4
    y = 7.12
elseif x < 2
    y = 6.24
else
    y = 7.77
end

result = x > y ? x : y                             # ternary operator

# Console
print("Hello, Julia")                              # No newline
println("Hello, Julia")                            # With newline

num = readline()                                  # Read input
num = parse(Int64, num)                           # String to Int64

using Printf
@printf("%.2f", 3.14159265)                       # Formatted printing

# Loops
for i in 1:5
    print(i)
end

for (key, value) in Dict( 1 => "one", 2 => "two", 3 => "three")
    println("$key, $value")                       # because key and value are variables
end

i = 0
while i < 10
    print(i)
    i += 1
end

# File handling
open("file.txt") do file
    content = read(file, String)                  # scope rules apply: content not accessible outside
end                                               

content = readlines("file.txt")                   # content will be a Vector{String}

open("file.txt", "w") do file                     # write mode (overwrite), create if not exists
    write(file, "Hello, Julia")
end

open("file.txt", "a") do file                     # append
    write(file, "\nHello, Julia")                 # a new line
end

# Iterations, ranges, list comprehensions, etc
1:10    # 1 to 10 (inclusive)
1:2:10  # 1, 3, 5, .. 9

squares = [ x^2 for x in 1:10 ]                   # Vector{Int64}
odd_squares = [ x^2 for x in 1:10 if isodd(x^2) ]
even_squares = [ x^2 for x in 1:10 if iseven(x) ]

s = sum(x for x in 1:10)                          # generator expression
s = sum(x^2 for x in 1:20 for iseven(x))

# Functions
function add(a, b)       # generic function with 1 method
    return a + b
end

add(a, b) = a + b        # short form

maximum(a, b) = a > b ? a : b                         # generic function with 1 method

function paint(msg; name = "Julia", count = 1)        # optional and keyword arguments
    for i in 1:count
        println("$msg $name")
    end
end

paint("Hello")                                        # Hello Julia
paint("Hello", name = "Rust")                         # Hello Rust
paint("Hello", name = "Rust", count = 5)              # Hello Rust (5 times)

paint("Hello", "Rust")                                # fails, keyword must be provided
paint("Hello", name = "Rust", 2)                      # fails, same reason

function swap(a, b)                                   # multiple return values
    return b, a                                       # return (b, a)
end

x = 1
y = 2
x, y = swap(x, y)                                     # (x, y) = swap(x, y)

# Multiple dispatch
function foo(x::Int)     # generic function with 1 method; "Int64" also works
    println("Integer")
end

function foo(x::String)  # generic function with 2 methods
    println("String")
end

foo(64)          # calls the first method
foo("Julia")     # calls the second method
foo(6.4)         # MethodError: no method matching foo(::Float64)

# Broadcasting
arr = [ x for x in 1:5 ]
arr = arr .^ 2                    # arr is now [ 1, 4, 9, 16, 25 ]
arr = arr .- 50                   # subtract 50 from each element

# Pipe operator
sq = arr |> sum |> sqrt                       # sq = sqrt(sum(arr))
sq = [ x for x in 1:100] |> sum |> isodd      # isodd(sum(x for x in 1:100))

# Exception handling
try
    x = sqrt(-1)
catch e
    if isa(e, DomainError)
        println("$e")
    else
        println("Something else: $e")
    end
finally
    println("\nPrint this regardless")
end

error("This is an error")                             # Throw exceptions

# OOP-like features
struct Point                                          # immutable struct
    x::Float64
    y::Float64
end

p = Point(1.0, 2.0)
println(p.x)

p.x = 3.0                                             # fails, p is immutable

mutable struct MPoint                                 # mutable; writing Point will fail, can't redefine a constant
    x::Float64
    y::Float64
end

p = MPoint(1.0, 2.0)
p.x = 3.0                                            # works, since p is

# Importing libraries
import Dates                # import only the module name
Dates.today()

import Dates:today          # import specific function
today()

using Dates                 # import all exported names
today()              
