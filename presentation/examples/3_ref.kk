// --------------------- Ref ---------------------

// keep effect inside a function
fun withMutableVariables()
   val x = ref(0) // allocate
   val y = ref(5) 
   x := add(x, y) // pass to another function
   // x // no dereferencing
   !x // dereference and return

fun add(x, y)
  x := 2 * !x
  return !x + !y






