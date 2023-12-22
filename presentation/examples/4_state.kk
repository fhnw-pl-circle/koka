// --------------------- State ---------------------

effect ctl raise( msg: string ) : a

effect state<a>
  fun set( x: a ): ()
  fun get(): a

fun state-handler(action: () -> <state<int>> int): int
  var st := 0
  with handler
    fun get() st
    fun set( x: int) 
      // only allow positive numbers
      if x >= 0 then 
        return st := x 
      else 
        return st := 0
  action()


fun raise-either( action : () -> <raise|e> a ) : e either<string, a>
  with handler
    return(x)      Right(x)   // normal return: wrap in Just
    ctl raise(msg) Left(msg)  // if raise was called, wrap the message in Left
  action()

// the lowest allowed number in the state is 0
fun positive-state(init: int, action: () -> <state<int>|e> int): e int
  var st := init
  with handler
    fun get() st
    fun set( x: int) 
      if x >= 0 then 
        st := x 
      else 
        st := 0
  action()

// try to halve the number in the state
fun state-raise(init) : either<string, int>
  with raise-either
  with positive-state(init)
  val i = get()
  if i.is-odd then raise("Can't halve odd number") else
    set( i / 2 )
    get()

fun result(init : int): console ()
  match state-raise(init)
    Right(x) -> println("result: " ++ x.show)
    Left(e) -> println(e)