// --------------------- Value Handlers ---------------------
// the effect is only a value
effect val width : int

// pretty has the width effect
fun pretty( d: string) : width string
  d.truncate(width)

fun pretty-thin() : string
  with val width = 5 // handle the width effect
  pretty("hello world")






