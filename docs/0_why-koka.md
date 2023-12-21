# Basic concepts of Koka

## Language features

> "Core features include first-class functions, a higher-rank impredicative
> polymorphic type- and effect system, algebraic data types, and effect
> handlers."


## Effect typing

A function type has 3 parts:

- argument types
- effect type
- result type

```koka
fun square1( x : int ) : total int   { x*x }                  // can't have effects
fun square2( x : int ) : console int { println( "" ); x*x }   // Can write to the console
fun square3( x : int ) : div int     { x * square3( x ) }     // divergence (might not terminate)
fun square4( x : int ) : exn int     { throw( "oops" ); x*x } // Exception
fun square5( x : int ) : io int      { throw( "oops" ); x*x } // everything is allowed
```

> 💡 The combination of `exn` and `div` corresponds to pure functions in Haskell.

- keyword `total` is usually left out
- If a function does not care about the effect type, it can be wild carded
  using a name prefixed with `_` (or just `_`). In this case the effect type is inferred
- `io` effect allows everything
