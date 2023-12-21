# Data types

- All data types are by default immutable

## Structs

```koka
struct person
  age : int
  name : string
  realname : string = name

val tobi = Person( 27, "Tobi" )
val fullnamed = Person( 27, "Tobi", "Tobias" )

fun birthday( p : person ): person
    // Syntactic sugar to edit records, calls the copy ctor
    p( age = p.age + 1)
```

- Every struct comes with ctor functions
    - They can be also used named
- Koka generates accessor functions as well, e.g. `tobi.age`

## Alternatives

```koka
type number
  Infinity
  // Can also be parametrized
  Integer( i : int )

// Definition of list, alternatives can also be recursive
type list<a>
  Nil
  Cons
    head : a; 
    tail : list<a>

val l = Cons(1,Nil)
val h = l.head
```

- `void`, unit `()` and `bool` are alternatives

> 💡 Structs are just syntactic sugar for alternatives

Thus, the type person could also be written as:

```koka
type person
  Person
    age : int
    name : string
    realname : string = name
```

### Matching on alternatives

```koka
type list2<a>
  Nil2
  Cons2{ head2 : a; tail2 : list2<a> }

fun map2(l: list2<a>, f: a -> e b): e list2<b>
  match l
    Nil2 -> Nil2
    Cons2(x, xs) ->  Cons2(f(x), map2(xs, f))

val l: list2<int> = Cons2(1, (Cons2( 2, Nil2)))

val f = fn(x: int): console int
  println(x)
  2*x

val l2 = l.map(f)
```
