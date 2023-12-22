// --------------------- Effect handlers ---------------------
effect ctl raise( msg: string ) : a

val handle-raise = handler {
  ctl raise(s) println(s)
} 

fun raise-exn()
  handle-raise
    raise("hello world")

// equivalent using syntactic sugar and with keyword
fun raise-exn2()
  with handler
    ctl raise(s) println(s)
  raise("hello world")

// handler can be omitted
fun raise-exn3()
  with 
    ctl raise(s) println(s)
  raise("hello world")

fun safe-divide( x : int, y : int ) : raise int
  if y==0 then raise("div-by-zero") else x / y

// raise-const has the "raise capability"
fun raise-const() : int
  with handler
    ctl raise(msg) 42 
  8 + safe-divide(1,0) // the result of raise-const is 42


// --------------------- Resuming---------------------
effect ask<a>
  ctl ask() : a

fun add-twice() : ask<int> int 
  ask() + ask()

fun ask-once() : int
  var count := 0
  with ctl ask()
    count := count + 1
    // resume with 42 on the first call, later just use 0
    if count <= 1 then resume(42) else 0   
  // Will return 0, because the second call does not resume anymore
  add-twice()

// tail resumptive handler
fun ask-const2() : int 
  with fun ask() 21
  add-twice() // returns 42

// fun resumes, ctl changes the control flow

// --------------------- Abstracting handlers into separate functions ---------------------

// runs the action, and handles raise using the given hnd-function
fun catch( hnd: (string) -> e a, action : () -> <raise|e> a) : e a
  with ctl raise(msg) hnd(msg)
  action()

fun catch-example()
  with catch fn(msg) // handles raise
    println("error: " ++ msg)
    42 
  safe-divide(1,0)

// --------------------- Returning from a handler ---------------------

// if an error occurs just return Nothing
fun raise-either( action : () -> <raise|e> a ) : e either<string, a>
  with handler
    return(x)      Right(x)   // normal return: wrap in Just
    ctl raise(msg) Left(msg)  // if raise was called, wrap the message in Left
  action()


fun natural(value: int)
  with raise-either
  if value >= 0 then value else raise("only natural values are allowed")

// --------------------- Masking effects ---------------------

fun mask-raise( action : () -> e int ) : e int
  with ctl raise(msg) 42
  val x = mask<raise>(action) // gets not handled by the internally defined raise handler
  if x.is-odd then raise("wrong")   // internal exception
  x

// when not masking action, raise gets in its type
fun mask-raise2( action : () -> <raise|e> int ) : e int
  with ctl raise(msg) 42
  val x = action() // gets not handled by the internally defined raise handler
  if x.is-odd then raise("wrong")   // internal exception
  x

// nevertheless, mask-raise2 can be used also when not raising
fun test-mask-raise2()
  with mask-raise2
  println("hello world")
  5

// --------------------- Resuming more than once ---------------------
effect ctl choice() : bool

fun choice-all(action : () -> <choice|e> a) : e list<a>
  with handler
    return(x)    [x] 
    ctl choice() resume(False) ++ resume(True) 
  action()

fun xor() : choice bool
  val p = choice()
  val q = choice()
  if p then !q else q