# koka-intro

## Links

- [Koka Website](https://koka-lang.github.io/koka/doc/index.html)
- [Official Examples](https://github.com/koka-lang/koka/tree/master/samples)
- [Koka GitHub](https://github.com/koka-lang/koka)
- [Koka Documentation](https://koka-lang.github.io/koka/doc/book.html)

## Repl

Start the REPL using `koka`

Get the type of expressions:

```
> val str = "hello world"
> :t str
string

>:t println(str)
console ()
```

`ctrl+r` searches the history
`ctrl+l` clears the console

Load a file into the REPL:

```
:l samples/basic/fibonacci // loads file samples/basic/fibonacci.kk
```

set options of the REPL using `set`:

```
:set --showtime // prints the elapsed runtime
```

