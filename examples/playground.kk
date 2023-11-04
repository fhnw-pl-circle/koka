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
