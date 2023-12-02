fun encode( s : string, shift )
  fun encode-char(c) 
    if c < 'a' || c > 'z' then return c
    val base = (c - 'a').int
    val rot  = (base + shift) % 26
    (rot.char + 'a')  
  s.map(encode-char)

fun encode2( s : string, shift : int )
  s.map fn(c)
    if c < 'a' || c > 'z' then return c
    val base = (c - 'a').int
    val rot  = (base + shift) % 26
    (rot.char + 'a')

effect fun emit(msg : string) : ()

// Emits a standard greeting.
fun hello()
  emit("hello world!")

fun emit-hello()
    with fun emit(s) println(s)
    hello()

fun hello-console1()
    (handler { fun emit(msg) println(msg) }){
      hello()
    }

fun combine-effects()
  throw("oops")         // exception raising
  combine-effects()     // and non-terminating

fun doSomething(x: int)
  println(x)

fun withMutableVariables()
   val x = ref(0) 
   val y = ref(5) 
   x := 5
   !x


// Data types
struct person
  age : int
  name : string
  realname : string = name

type person2
  Person2 { name: string; age: int; realname: string = name }

val tobi = Person( 27, "Tobi" )
val fullnamed = Person( 27, "Tobi", "Tobias" )

fun birthday( p : person ): person
    p( age = p.age + 1)

type list2<a>
  Nil2
  Cons2{ head2 : a; tail2 : list2<a> }

fun map2(l: list2<a>, f: a -> e b): e list2<b>
  match l
    Nil2 -> Nil2
    Cons2(x, xs) ->  Cons2(f(x), map2(xs, f))

val l: list2<int> = Cons2(1, (Cons2( 2, Nil2)))

val f = fn(x: int): console int
  println(x)
  2*x


// Effect handlers

effect raise
  ctl raise( msg: string ) : a

fun safe-divide( x : int, y : int ) : raise int 
  if y==0 then raise("div-by-zero") else x / y

fun raise-const() : console int
  with handler
    ctl raise(msg) 
      println(msg)
      42 
  8 + safe-divide(1,0)

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
  add-twice()

fun sugus(): int
  with ctl ask()
    val f = fn() 21
    resume(f())
  add-twice()



fun ehello() : emit ()
  emit("hello")
  emit("world")

fun emit-console( action )
  with fun emit(msg) println(msg) 
  action()

fun ehello-console() : console ()
  with emit-console
  ehello()

fun emit-collect( action : () -> <emit|e> () ) : e string
  var lines := []
  with handler
    return(x)     lines.reverse.join("\n") 
    fun emit(msg) lines := Cons(msg,lines)   
  action()

fun ehello-commit() : string
  with emit-collect
  ehello()

// runs the following action, and handles raise using the given hnd-function
fun catch( hnd: (string) -> e a, action : () -> <raise> a) : e a
  with ctl raise(msg) hnd(msg)
  action()

fun catch-example()
  with catch( fn(msg) { println("error: " ++ msg); 42 }) // handles raise
  safe-divide(1,0)

fun raise-maybe( action : () -> <raise, console|e> a ) : <console|e> maybe<a>
  with handler
    return(x)      Just(x)   // normal return: wrap in Just
    ctl raise(msg) 
      println(msg)
      Nothing   // exception: return Nothing directly  
  action()

fun div42( x : int, y : int )
  with raise-maybe
  safe-divide(x, y)

effect state<a>
  fun set( x: a ): ()
  fun get(): a

fun modify( x: int ) : state<int> ()
  set(x)

fun use-state( value: int )
  var st := 0
  with handler
    return(_) st
    fun get() st
    fun set( x: int) 
      if x >= 0 then 
        return st := x 
      else 
        return st := 0
  modify(value)
  
fun use-state2()
  with return(x) Just(x)
  25

fun raise-maybe2( action: () -> <raise2<a>> int, value : a) : maybe<int>
  with return(x) Just(x)
  with handler
    ctl raise2(msg) resume(value) // exception: return Nothing directly  
  action()

effect raise2<a>
  ctl raise2( msg: string ) : a

fun ask-const2() : int 
  with fun ask() 21
  add-twice() // returns 42

fun positive-state(init: a, compare: (a: a, b: a) -> bool, action: () -> <state<a>, div|e> a): <div|e> a
  var st := init
  with handler
    fun get() st
    fun set( x ) 
      if compare(x, init) then 
        st := x 
      else 
        st := init
  action()

fun raise-either( action : () -> <raise|e> a ) : e either<string, a>
  with handler
    return(x)      Right(x)   // normal return: wrap in Just
    ctl raise(msg) Left(msg) 
  action()

fun state-raise(init : int) : _e either<string, int>
  with raise-either
  with positive-state(init, fn(a: int,b: int) a >= b)
  val i = get()
  if i.is-odd then raise("no odds") else
    set( i / 2 )
    i

// fun state-raise2(init)
//   with positive-state(init, fn(_a,_b) True)
//   with raise-either
//   val i = get()
//   i

fun mask-print( action)
  with ctl raise(msg) 42 
  val x = action() // gets not handled by the internally defined raise handler
  if x.is-odd then raise("wrong")   // internal exception
  x


fun emit-quoted1( action )
  var str := ""
  with fun emit(msg) str := msg
  action()

fun emit-quoted2( action : () -> <emit|e> a ) : <emit|e> a
  with override fun emit(msg) emit("\"" ++ msg ++ "\"") 
  action()



effect ctl choice() : bool

fun xor() : choice bool
  val p = choice()
  val q = choice()
  if p then !q else q

val init = fn() {println("init")}
val multi = fn() {println("multi")}


// fun choice-all(action : () -> <choice|e> a) : e list<a>
//   with initially(init)
//   with handler
//     return(x)    [x] 
//     ctl choice() resume(False) ++ resume(True) 
//   action()



