fun withMutableVariables()
   val x = ref(0) 
   val y = ref(5) 
   x := add(x, y)
   !x

fun add(x, y)
  x := 2 * !x
  return !x + !y

