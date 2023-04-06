---
geometry: margin=1in
header-includes:
  - \pagenumbering{gobble}
---

# Module Systems: Interfaces and Implementations

An interface defines the contract for an entire implementation. It describes only what a client needs to know to use an implemetation. No additional information!!

# Signatures: ML's Interfaces

A signature is the client-facing menu for an implemetation. It lists "all the things we can do"

Generally it'll have a bunch of **declarations** (not definitions)

We can put:

- Abstract types
- Constants or variables
- Functions
- Exceptions

in a signature.

There is no way for a client to see how these things are implemented. For example (no signature syntax yet)...

```sml
type 'a list (* totally abstract *)
val empty : 'a list
val length : 'a list -> int
exception EmptyList
```

## Priority Queue Example

```sml
signature PQUEUE = sig
    type elem (* abstract *)
    val compare_elem : elem * elem -> order
    type pqueue (* abstract *)
    val empty : pqueue
    val insert : elem * pqueue -> pqueue
    val isEmpty : pqueue -> bool
    exception Empty
    val deletemin : pqueue -> elem * pqueue
end
```

# Structures: ML's Implementations

A structure matches a signature if it implements _everything_ that signature declares.

## Queue Example

```sml
structure Queue :> QUEUE = struct 
    type 'a queue = 'a list
    exception Empty

    val empty = []
    fun put (x, q) = q @ [x]
    fun get []        = raise Empty
      | get (x :: xs) = (x, xs)
end

```

## Using Signatures/Structures

We have:
- `queue-sig.sml` (signature)
- `queue.sml` (structure)

```sml
use "queue-sig.sml"; (* gets us the QUEUE signature *)
use "queue.sml"; (* gets us the Queue structure *)
(* lots of output *)

Queue.empty; 
(* val 'a it = <queue> : 'a queue *)

Queue.put (true, Queue.empty);
(* val it = <queue> : bool queue *)

Queue.put (3, Queue.empty);
(* val it = <queue> : int queue *)

Queue.get (Queue.put (3, Queue.empty));
(* val it = (3, <queue>) : int * int queue *)
```

# Functors: functions over structures
