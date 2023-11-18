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

fun static-nr() : int
  with ctl ask() resume(42)
  add-twice()
