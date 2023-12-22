# Koka

## Introduction

- [Koka](https://koka-lang.github.io/koka/doc/index.html)

## Basics

- Types can be inferred
- A lot of syntactic sugar

Examples: [1_basics.kk](1_basics.kk)

## Functional but in place

- [Perceus](https://koka-lang.github.io/koka/doc/book.html#why-perceus)
- [FBIP Paper](https://www.microsoft.com/en-us/research/uploads/prod/2023/05/fbip.pdf)
- [Performance](https://github.com/koka-lang/koka?tab=readme-ov-file#benchmarks)

## Effect Types

> An effect enables to specify different implementations for functions depending
on the context they are used.

- Effects of a function are part of its type
- Effects consist of one or multiple functions
- Define effects using `effect`

Let's dive in: [2_effect-types.kk](2_effect-types.kk)

## Effect handlers

> A way to define control-flow abstractions and dynamic binding as user defined handlers.

- Effect handlers "discharge" an effects
- Effect handlers can change the control flow
- Resuming enables to the caller of the effect

Let's see how effect handlers work: [3_effect-handlers.kk](3_effect_handlers.kk)

## Further topics

- [Value handlers](examples/1_value-handler.kk)
- [Overriding handlers](examples/2_overriding-handler.kk)

## Examples

- [Ref](examples/3_ref.kk)
- [State](examples/4_state.kk)
- [Combining handlers](examples/5_combining-handlers.kk)

### Refs

```koka
fun withMutableVariables()
   val x = ref(0) // allocate
   val y = ref(5) 
   x := add(x, y) // pass to another function
   // !x // dereference and return
   x

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
