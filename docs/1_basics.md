# Koka Basics

## Compile a program

- The `main` function is the entry point to a koka program
- A file containing such a function can be compiled using `koka path/to/file.kk`

## Functions

- defined with keyword `fun` (anonymous with `fn`)
- Last expression is automatically returned

### Syntactic sugar

__automatic braces-insertion around function bodies:__

```koka
fun sqaure(x: int)
  x*x
// is equivalent to
fun square2(x: int) {
    x*x
}
```

__`{}` is a shorthand for anonymous functions without parameters:__

```koka
var i := 10
while { i >= 0 } {
  println(i)
  i := i - 1
}
// is equivalent to
var i := 10
while fn() { i >= 0 } fn() {
  println(i)
  i := i - 1
}
```

These syntactical sugar lead from:

Given:

```koka
fun twice(f)
  f()
  f()
```

```koka
fun test-twice() {
  twice (fn () {
    twice (fn () {
      println("hi")
    })
  })
}
```

over:

```koka
fun test-twice() {
  twice {
    twice {
      println("hi")
    }
  }
}
```

to

```koka
fun test-twice()
  twice
    twice
      println("hi")
```



- Dot-selection: receiver is handed in as first parameter to a function

```koka
fun printTimes(s: string, n: int)
  match n
    0 -> ()
    n -> 
      println(s)
      s.printTimes(n - 1)

"hello".printTimes(5)
// is equivalent to
printTimes("hello", 5)
```


__trailing lambdas:__ 

> If the last argument of a function is a function, it can be written
> outside the argument list.

```koka

for(1,10) fn(i)
  println(i)
// is equivalent to
for(1,10, fn(i)
  println(i)
)
```

### Suspenders

- arguments in parentheses are eagerly evaluated
- expression in curly-braces lazy

## With Statements

> `with` helps thinking as a closure over the rest of the lexical scope. It has
> some similarities to Haskell's `do`.

```koka
fun test-twice()
  with twice
  println("hi")

// is equivalent to
fun test-twice()
  twice
    println("hi")
```

> The with statement essentially puts all statements that follow it into an
> anonymous function block and passes that as the last parameter.

```koka
with myFun(e1, ..., eN)
<body>
// is translated to
myFun(e1, ..., eN) fn() {
  <body>
}
```

This works as well with binding variables

```koka
// the function `f` takes 1 param
fun twice(n:int, f)
  f(n)
  f(n)

// with binds the value `n` to a new variable `x`
fun test-twice()
  with x <- twice(2)
  println(x)

> test-twice()
2
2
2
2
```

### Further examples

basic example:

```koka
pub fun test-with() {
  with x <- list(1,10).foreach
  println(x)
}
// translates to
pub fun test-with() {
  list(1,10).foreach fn(x)
    println(x)
}
```

__with finally:__

> `finally` takes the functions `fin` and `action`. `fin` always runs after
> `action` has completed. `fin` also runs when an effect operation does
> not resume.

```koka
fun test-finally() 
  with finally{ println("exiting..") }
  println("entering..")
  throw("oops") + 42
```

### Using `with` with effect handlers

> An effect describes an abstract set of operations whose concrete
> implementation can be supplied by a handler.

```koka
effect fun emit(msg : string) : ()

// Emits a standard greeting.
fun hello()
  emit("hello world!")

fun emit-hello()
    with fun emit(s) println(s)
    hello()
// is equivalent to
fun emit-hello()
    (handler
      fun emit(s) println(s))
        hello()

```

### Optional and named parameter

- parameter can also be named using the pattern `name = value`
- this allows introducing optional parameters by just providing a default value
  in the function definition

```koka
fun sublist( xs : list<a>, start : int, len : int = xs.length ) : list<a>
  if start <= 0 return xs.take(len)
  match xs
    Nil        -> Nil
    Cons(_,xx) -> xx.sublist(start - 1, len)
```
