# pony-tiny-promise

A small promise library for pony, as it is currently missing them.
I was looking for promises as easy as the ones you can find in other languages, like JavaScript.
This library is an attempt to create a promise system similar to it.

Pony does not allow you to return anything from a behaviours, so my implementation works in a different way than the Javascript one: you define the `TinyPromise` object ahead, with the `resolve` and `reject` methods (or using a handy `TinyPromiseReceiver`), and then pass it as argument to the behaviour.

The `TinyPromise` is by itself an actor, so you do not have to worry about the capability of it.
You can only resolve or reject a `TinyPromise` once. It won't complain if you do it twice or thrice, it will instead do nothing. This may change in the future.

## Installation and usage

Clone this repository from github:

```sh
git clone https://github.com/adri326/pony-tiny-promise.git
```

Then import it in your pony code:

```pony
use "pony-tiny-promise"
```

A working example can be found in the `./test` directory.
