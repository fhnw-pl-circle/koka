// --------------------- Sample effects ---------------------
fun square1( x : int ) : total int   { x*x }                  // can't have effects (total is omitted usually)
fun square2( x : int ) : div int     { x * square2( x ) }     // divergence (might not terminate)
fun square3( x : int ) : exn int     { throw( "oops" ); x*x } // Exception
// --- ^ Haskells pure functions

fun square4( x : int ) : console int { println( "" ); x*x }   // Can write to the console
fun square5( x : int ) : io int      { throw( "oops" ); x*x } // everything is allowed

val l = Cons(5, Cons(4, Cons(3, Cons(2,Cons(1, Nil)))))

fun traverse (l: list<a>, f: (a) -> /*console*/ ()): /*console*/ ()
  match l
    Nil -> ()
    Cons(x, xs) -> 
      f(x)
      traverse(xs, f)

//traverse(l, println)

// --------------------- lets define our first effect ---------------------

// simple effect with 1 function
// defines a new type, and operations belongig to this type
// ctl is the only effect keyword at the moment
effect emit
  ctl emit( msg: string ) : ()

// equivalent to
effect fun emit2(msg : string) : ()

// use effect-functions like normal functions
fun hello()
  emit("hello world!")

// handle-emit is a function that takes a function
val handle-emit = handler {
  fun emit(s) println(s)
} 

fun emit-hello()
  handle-emit
    emit("hello world")

// --------------------- combining effects ---------------------

// :t combine-effects
fun combine-effects()
  // emit("hello world") // emit
  throw("oops")         // exception raising
  combine-effects()     // and non-terminating


// --------------------- Polymorphic effects ---------------------

// the effect of f goes to map2
fun map2(l: list<a>, f: a -> e b): e list<b>
  match l
    Nil -> Nil
    Cons(x, xs) ->  Cons(f(x), map2(xs, f))
