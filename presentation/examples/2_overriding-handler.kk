// --------------------- Overriding handlers ---------------------
effect emit
  ctl emit( msg: string ) : ()

fun emit-quoted1( action : () -> <emit,emit|e> a ) : <emit|e> a
  // emit gets handled here, but needs another handling! That's why action has this special inferred type
  with fun emit(msg) emit("\"" ++ msg ++ "\"") 
  action()

// override fixes this issue
fun emit-quoted2( action : () -> <emit|e> a ) : <emit|e> a
  with override fun emit(msg) emit("\"" ++ msg ++ "\"") 
  action()
