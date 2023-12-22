// --------------------- Resume more than once and further handler ---------------------
effect ctl choice() : bool

effect state<a>
  fun set( x: a ): ()
  fun get(): a

fun choice-all(action : () -> <choice|e> a) : e list<a>
  with handler
    return(x)    [x] 
    ctl choice() resume(False) ++ resume(True) 
  action()

fun pstate( init : a, action : () -> <state<a>,div|e> b ) : <div|e> (b,a)
  var st := init
  with handler     
    return(x)  (x,st)       // pair the result with the final state
    fun get()  st
    fun set(i) st := i 
  action()

/* 
When combining pstate with multi-resumption handler choice-all, we have to options

1. First handling the state, and then handling the choice
2. Vice versa

*/

// share the state over all resumptions
fun state-choice(action) : div (list<bool>,int) 
  pstate(0) // result is a tuple
    choice-all // result is a list
      action() 

fun choice-state(action) : div list<(bool,int)>
  choice-all // result is a list
    pstate(0) // result is a tuple
      action() 

fun example() : <choice,state<int>> bool 
  val p = choice()
  val i = get()
  set(i+1)
  i>0 && p

fun eval-choice-state()
  val res = choice-state(example)
  res.foreach fn(x)
    match x
      (r, state) -> println(r.show ++ " " ++ state.show)

fun eval-state-choice()
  val res = state-choice(example)
  match res
    (l, state) -> 
      println(l.foldr("", fn(cur, acc) acc ++ cur.show) ++ " " ++ state.show)