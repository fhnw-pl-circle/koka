# Effect handlers

> A way to define control-flow abstractions and dynamic binding as user defined
> handlers.


```koka
effect raise
  ctl raise( msg: string ) : a

> :t raise
(msg: string) -> raise a
```

- The effect declaration defines
    - a new type
    - operations belonging to this type, in this case the only operation is a
      "control" operation (`ctl`)

It can be used like:

```koka
fun safe-divide( x : int, y : int ) : raise int
  if y==0 then raise("div-by-zero") else x / 
```

This newly created function can only be used in contexts, where the `raise`
effect is handled, meaning `raise` is dynamically bound.

The following snippet handles the effect, by just returning `42`:

```koka
fun raise-const() : int
  with handler
    ctl raise(msg) 42 
  8 + safe-divide(1,0)
```

By default, when an effect is yielded the most inner effect handler is
evaluated, the stack up to the handler is "unwinded" and the evaluated result
from the effect handler is returned.

> When handling an effect (e.g. raise) one speaks of "defining the dynamic
> binding of raise" or the "raise capability".

## Resuming

> "Resuming" enables to come back to the call site with a result

```koka
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
  // Will return 0, because the second call does not resume anymore
  add-twice()
```

### Tail-resumptive operations

In practice most often `ctl`-operations resume with their value and do not
interrupt the control flow. This also allows better performance as
tail-resumptive functions can be called just like regular functions.

Because this is used often there exists snytactical sugar:

```koka
fun ask-const2() : int 
  with fun ask() 21
  add-twice() // returns 42
```

### Value handlers

Value handlers just return a static value. Define value effects as:

```koka
effect val width : int

// pretty has the width effect
fun pretty( d: string) : width string
  d.truncate(width)

fun pretty-thin() : string
  with val width = 5 // handle the width effect
  pretty("hello world")
```

### Abstracting Handlers into separate functions

Since with works with any function that receives a function as argument, it is
also possible to abstract handlers into separate functions:

```koka
effect fun emit( msg : string ) : ()

fun ehello() : emit ()
  emit("hello")
  emit("world")

fun emit-console( action )
  with fun emit(msg) println(msg) 
  action()

fun ehello-console() : console ()
  with emit-console
  ehello()
```

The following example defines a generic catch method to handle the `raise` effect:

```koka
// runs the action, and handles raise using the given hnd-function
fun catch( hnd: (string) -> e a, action : () -> <raise|e> a) : e a
  with ctl raise(msg) hnd(msg)
  action()

fun catch-example()
  with catch( fn(msg) { println("error: " ++ msg); 42 }) // handles raise
  safe-divide(1,0)
```

### Return Operations

> The return operation of a handler transforms the return value of a function accessing
a handler.


Consider the following example using a state:

```koka
effect state<a>
  fun set( x: a ): ()
  fun get(): a

// set the state and return the current state
fun modify( x: int ) : state<int> ()
  set(x)

fun use-state( value: int )
  var st := 0
  with handler
    // return modifies the result of every function using this handler
    return(_) st
    fun get() st
    fun set( x: int) 
      // only allow positive numbers
      if x >= 0 then 
        return st := x 
      else 
        return st := 0
  // altough modify returns (), return changes it to the current value of the
  state
  modify(value)
```
