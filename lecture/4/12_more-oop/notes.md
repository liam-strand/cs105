---
geometry: margin=1in
header-includes:
  - \pagenumbering{gobble}
---

# Intro to "Pure" Object-Oriented Programming

The rules:
- Everything is an object
- Everything is communicated using messages

# Baby's First OOP Demo: Shapes!

## Pseudocode Example

![](assets/shapes.png)

## Mindset

1. Ask object what to do
2. Object decides how to respond
3. Object name is first `(c position: N')`

For example if we want to print every element of a list...

- Functional
  - Are you the empty list?
  - Yes? done No? print and recurse
- OOP
  - Send a message to every object asking it to print itself.

# $\mu$Smalltalk: Intro and Basic Expressions

## Top-Level

- global variables
- top-level expressions
- unit-tests
- named "blocks" (like a lambda)
- classes

## Basic Expressions

Expressions are evaulated to values...nothing new here

- Literals (integers and symbols (no booleans, they're different))
- Array literals (instantiated the same way, look slightly different)
- Varaible names (can be created with a `val` definition or similar)
- `SET` and `BEGIN` (same as $\mu$Scheme)

# $\mu$Smalltalk: Message Sending and Blocks

## Message Sending

### General Syntax

```
(e message-name { e })
```
- The first `e` is an expression that evaluates to an object. ("The receiver")
- The `message-name` is the name of the message being sent
- The `{ e }`s are the arguments sent to the message

### Example: Boolean Objects

`true` and `false` are predefined objects, not literals. Non-literals evaluate to objects, and the interpreter reports the **class** of that object.

```
-> true
<True>
-> (true not)
<False>
-> (true & true)
<True>
-> (true & false)
<False>
```

### Example: Lists

Most objects are created by sending the message `new` to the object's class.

```
-> (val xs (List new))
List( )
-> (xs add: 3)
List( 3 )
-> (xs add: 4)
List( 3 4 )
```

Message name conventions:
1. If the name begins with a _nonletter_, the message takes one argument
2. If the name begins with a _letter_, the message takes as many arguments as there are **colons** in the name

## `block`s

$\mu$Smalltalk's version of a lambda

```
[block (args) { e }]
```

- `block` is a keyword
- `(args)` contain 0 or more names
- `{ 0 }` is a sequence of 0 or more expressions (executed like `BEGIN`)

```
-> [block (n) (n + 2)]
<Block>
-> [block (n) (n + 2)
              (n print)]
<Block>
```

We need to send a message to the `block` that is like "run yourself!" That message has the special name `value`

```
-> ([block (n) (n + 2)] value: 3)
5
-> ([block () 'hello] value)
'hello
-> ([block () 'hello] value:)
syntax error: in message send, message value: expects 1
argument, but gets 0 arguments
```

Notice that a `block` knows how many arguments it needs, and you need to use the correct flavor of `value` to invoke a `block`.

If we need more than 1 argument...

```
([block (n m) (n + m)] value:value: 2 3)
```

_ugly_ `:(`

### Syntactic Sugar for 0-arg `block`s

```
{{ e }}
```
- 0 or more expressions in curly braces

It's a super common mistake to forget the parentheces within the curly braces. The interpreter tries to give a warning if you do that.

```
-> ({(3 + 2)} value)
5
-> ({3 + 2} value)
warning: inside {...} it looks like (...) was forgotten
Name + not found
Method-stack traceback:
Sent 'value' in standard input, line 10
```

## Putting It Together

Some messages expect blocks as arguments. The standard basis has a "filter" message on `List`s. It is called `filter:`. It expects a `block` that forms a predicate. In this example, the predicate returns `true` if the element is even and `false` otherwise.

```
-> (val ns (List withAll: '(1 2 3 4 5)))
List( 1 2 3 4 5 )
-> (ns select: [block (n) ((n mod: 2) = 0)])
List( 2 4 )
```


