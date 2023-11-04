fun print(): <console, div> ()
  var i := 10
  while { i >= 0 } {
    println(i)
    i := i - 1
  }

val print2 = fn() {
  2*2
}

val print3 = fn(): <console, div> ()
  print()

val print4: () -> <console, div> () = print

