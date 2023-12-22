// --------------------- General ---------------------

type list2<a>
  Nil2
  Cons2
    head : a
    tail : list2<a>

fun head (l: list2<a>): exn a
  match l
    Nil2 -> throw("empty list")
    Cons2(x, _) -> x

fun traverse (l: list2<a>, f: (a) -> e ()): e ()
  match l
    Nil2 -> ()
    Cons2(x, xs) -> 
      f(x)
      traverse(xs, f)

val l: list2<int> = Cons2(3, Cons2(2, Cons2(1, Nil2)))

struct person
  age : int
  name : string
  realname : string = name

// optional arguments
val tobi = Person( 27, "Tobi" )
// access using tobi.age


// --------------------- Syntactic sugar ---------------------

// automatic braces insertion
fun sqaure-automatic(x: int)
  x*x

// anonymous functions
fun syntactic-sugar ()
  // calls f twice
  fun twice(f)
    f()
    f()
  
  fun test-twice-desugared() {
    twice (fn () {
      twice (fn () {
        println("hi")
      })
    })
  }

  fun test-twice()
    twice
      twice
        println("hi")
  test-twice()

// Dot-selection: receiver is handed in as first parameter to a function
fun dot-selection() {

  fun printTimes(s: string, n: int)
    match n
      0 -> ()
      n -> 
        println(s)
        s.printTimes(n - 1)

  "hello".printTimes(5)

  // is equivalent to
  printTimes("hello", 5)
}

fun trailing-lambdas() {
 for(1,10) fn(i)
   println(i)
 // is equivalent to
 for(1,10, fn(i)
   println(i)
 )
}

// works with functions taking an argument as last param
fun with-statement()
  fun twice(f)
    f()
    f()
  
  fun test-twice()
    with twice
    println("hi")

  // is equivalent to
  fun test-twice-desugared()
    twice
      println("hi")

  // works with functions taking a variable as well 
  fun test-with() {
    with x <- list(1,10).foreach
    println(x)
  }
  // translates to
  fun test-with-desugared() {
    list(1,10).foreach fn(x)
      println(x)
  }

  test-with()



