---
geometry: margin=1in
header-includes:
  - \pagenumbering{gobble}
  - \usepackage{syntax}
---

# Motivating Operational Semantics

## How do we know what a program does?

- We need to understand the **semantics** (meaning) of a program.
- These can be formal (mathy) or informal (prose or code). Usually we chose the formal one because its "impossible" to refute.
- There are a few choices for formalizing programming language semantics
  - Axiomatic
  - Denotational
  - Operational

We're going to chose operational semantics because its the easiest to reason about.

## What are Operational Semantics?

A mathematical model that describes how a programming language **gets executed**

How do we specify operational semantics for a program?

1. Give meaning to its individual components.
2. Inductively give meaning to the whole thing.

but how? what symbols can we use?

# Abstract Syntax

Our goal is a compositional program representaiton that:

1. Specifies a program precisely
2. Makes it easy to compare languages

## Converting from concrete syntax to abstract syntax

```cpp
// In C++
if (true) 3; else 4;
```

```
;; An equivalent Impcore expression
(if 1 3 4)
```

In abstract syntax:

```
IF(LIT(true), LIT(3), LIT(4))
```

That's the C++ version, the Impcore one would replace `LIT(true)` with `LIT(1)` because Impcore doesn't have boolean literals.

\pagebreak

## Abstract Syntax of Impcore Expressions

### Abriviated concrete syntax of Impcore

```{=latex}
\setlength{\grammarindent}{40pt}
\renewcommand{\syntleft}{\normalfont\itshape}
\renewcommand{\syntright}{}
\begin{grammar}

<exp> ::= <literal>
\alt <variable-name>
\alt "(if" <exp> <exp> <exp>")"
\alt "("<function-name> \{<exp>\}")"

\end{grammar}
```

We have some metavariables we can use to represent different things

|     |                            |
| --- | -------------------------- |
| _e_ | expression                 |
| _x_ | variable or parameter name |
| _v_ | value                      |

Let's convert the concrete syntax above to an abstract syntax.

### Abriviated abstract syntax of Impcore

```{=latex}
\setlength{\grammarindent}{30pt}
\renewcommand{\syntleft}{\normalfont\itshape}
\renewcommand{\syntright}{}
\begin{grammar}

<e> ::= LITERAL(<v>)
\alt VAR(<x>)
\alt IF($e_1$, $e_2$, $e_3$)
\alt APPLY(<f>, $e_1$, ..., $e_n$)

\end{grammar}
```

### Example

Convert the following concrete syntax into abstract syntax:

```
(+ (if x 1 0)
   (< 3 (f))
```

becomes...

```
APPLY(+, IF(VAR(x), LITERAL(1), LITERAL(0)),
         APPLY(<, LITERAL(3), APPLY(f)))
```

I don't love that, it's hard to read. Can we do any better?

### Abstract Syntax Trees

It's a tree, but its abstract syntax...yay.

The abstract syntax example above becomes:

![](./assets/ast.png)

Maybe that is better?

\pagebreak

# Assigning Meaning to Abstract Syntax

## Semantics of Base Cases

We have two of these, literals and variable names

1. `LITERAL(`_v_`)` &rarr; gives us the **value** _v_
2. `VAR(`_x_`)` &rarr; gives us the **value bound to** _x_

### Environments

How do we do this second thing?

- We need to look up that name in the **environment**
- The environment tells us what values are bound to what names

Okay yay let's formalize the environment

For example, take this environment: $\rho = \{ x1 \mapsto v1, ..., xn \mapsto vn \}$

What can we do with $\rho$?

1. **Inspect it**: "Is `tufts` in the environment $\rho$?" &rarr; "`tufts` $\in$ `dom` $\rho$ ?"
2. **Get a value**: "What is bound to `tufts`?" &rarr; "$\rho ($`tufts`$)$ ?"
3. **Extend it**: "Set `y` to `2` in this environment." &rarr; "$\rho \{$`y` $\mapsto$ `2`$\}$"

### Impcore's Environments

| Name   | Meaning           | Mapping            |
| ------ | ----------------- | ------------------ |
| $\xi$  | Global Variables  | names to values    |
| $\rho$ | Formal Parameters | names to values    |
| $\Phi$ | Fucntions         | names to functions |
