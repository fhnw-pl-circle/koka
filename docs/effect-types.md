# Effect types

## Defining a handler for an effect

> An effect enables to specify different implementations for functions
> depending on the context they are used.

### Handler

A `handler` is a function that takes the implementations of the effects
function and then returns a function taking another function in which the
implementations of the effect is bound.

`val x = (handler { fun emit(msg) println(msg) })` defines `x` providing a
closure in which the function `emit(msg: string)` is bound.

So `x { emit('007') }` logs `007` to the console!

__Example:__

Since a handler returns a function taking another function as last argument it
can easily be used with `with`.
Thus, the following example is a more typical approach to use effects:

```koka
effect fun emit(msg : string) : ()

// Emits a standard greeting.
fun hello()
  emit("hello world!")

fun emit-hello()
    with handler
      fun emit(s) println(s)
    hello()
```

> Intuitively, we can view the handler with fun emit as a dynamic binding of
> the function emit over the rest of the scope.

## Combining effects

Functions that mix-up effects have _all_ the effect in the signature:

```koka
> fun combine-effects()
>   val i = srandom-int() // non-deterministic
>   throw("oops")         // exception raising
>   combine-effects()     // and non-terminating

> :t combine-effects
forall<a>. () -> <div, exn, ndet> a
```

### Polymorphic effects

Effects are polymorphic (e.g. when using higher order functions). For example
`map` takes a function which can cause _any_ effect, so the returned list takes
on the effect of the `mapper`:

```koka
map : (xs : list<a>, f : (a) -> e b) -> e list<b>
```

## Local mutable variables

`var` enables locally mutable variables. Internally it uses a state effect
handler:

Example:

```koka
fun exmaple()
  var i := 10 // assign a value to a mutable variable `i`
  while { i >= 0 } 
    doSomething(i)
    i := i - 1
```

The function `doSomething` can now not mutate the passed variable `i`, as it is
dereferenced when passing it. So mutable variables are not first class in Koka.

### Reference cells

Using reference cells Koka allows to allocate mutable variables on the heap.
Reference cells are first class and can therefore be passed to other functions.

Once a `ref` has been initialized it can be reassigned at any time:

```Koka
fun withMutableVariables()
   val x = ref(0) // allocate
   val y = ref(5) 
   x := add(x, y) // pass to another function
   !x // dereference and return

fun add(x, y)
  x := 2 * !x
  return !x + !y
```

The type of `ref(5)` is `ref<h, int>` which means it is a reference to a
mutable `int` on some heap `h`.

Heaps have their own effects describing 3 operations:

1. allocation `heap<h>`
2. read `read<h>`
3. write `write<h>`

These three effects are combined in an effect `st<h>`:

```koka
alias st<h> = <read<h>,write<h>,alloc<h>>
```

This means a function with effect `st<h>` can manipulate heap `h`.


> 💡 The function `withMutableVariables` has no effect and not `st<h>`! That is
> because the side effects are not observable outside this function. But the
> function `add` has the effect `<read<h>,write<h>>` because it takes refs as
> arguments!


