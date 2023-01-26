---
geometry: margin=1in
header-includes:
  - \pagenumbering{gobble}
  - \usepackage{syntax}
---

# Formal Operational Semantics: States and Judgements

## Big Picture

- The goal is to formalize an Impcore program's execution
  - Where an Impcore program is simply a sequence of definitions.
- Executing a definition does at most two things:
  1. Execute an expression to produce a value
  2. Update an Impcore environment
- We want to execute each definition in sequence, maintaining updated environments between each execution.

### Conceptual States

1. About to execute a definition
2. About to execute an expression
3. Just executed an expression
4. Just executed a definition

## Moving from state to state

For example, in state 1 we have $\langle e, \xi, \Phi, \rho \rangle$, and in state 2 we're going to have $\langle v, \xi', \Phi, \rho' \rangle$

- Expression $e$ evaluates to $v$
- Same metavariable $\implies$ equivalent
- Primes $\implies$ that state _might_ change

We are going to formalize getting from one state to another using judgements. So we have:

$$\langle e, \xi, \Phi, \rho \rangle \Downarrow \langle v, \xi', \Phi, \rho' \rangle$$

is equivalent to saying "Expression $e$ evaluates to $v$ without modifying $\Phi$, while possibly modifying $\xi$ or $\rho$".

A judgement can be general (with metavariables) or specific (with concrete/abstract syntax). It's a bit easier to see what's going on with specific judgements.

\pagebreak

# Formal Semantics of Impcore Expressions

## Inference Rules

Prerequisites

- Evaluation judgements formalize state transitions
- We have at least one judgement for each piece of abstract syntax

How do we know if a judgement actually works? We will use inference rules. They look like:

$$\frac{\text{\textit{premise(s)}}}{\text{\textit{conclusion}}} \text{Name of Rule}$$

## Literals and Variables

Evaluating a literal just gives its value, there are no premises.

$$\frac{}{\langle \text{LITERAL} (v), \xi, \Phi, \rho \rangle \Downarrow \langle v, \xi, \Phi, \rho \rangle} \text{(Literal)}$$

A variable could be **formal** or **global**. If the variable $x$ is formal, look it up in $\rho$. If the variable $x$ is a global and not a formal, look it up in $\xi$. Remember, formals shadow (hide) globals, so we need to check for that in this case.

$$\frac{x \in \text{dom} \ \rho}{\langle \text{VAR} (x), \xi, \Phi, \rho \rangle \Downarrow \langle \rho (x), \xi, \Phi, \rho \rangle} \text{(FormalVar)}$$

$$\frac{x \notin \text{dom} \ \rho \ \ \ x \in \text{dom} \ \xi}{\langle \text{VAR} (x), \xi, \Phi, \rho \rangle \Downarrow \langle \xi (x), \xi, \Phi, \rho \rangle} \text{(GlobalVar)}$$

It's a little trickier to assign to a formal variable. The variable must be in $\rho$, and the expression must evaluate to a value that can be assigned to the variable.

$$\frac{x \in \text{dom} \ \rho \ \ \  \langle e, \xi, \Phi, \rho \rangle \Downarrow \langle v, \xi', \Phi, \rho' \rangle}{\langle \text{SET} (x, e), \xi, \Phi, \rho \rangle \Downarrow \langle v, \xi', \Phi, \rho'\{x \mapsto v\} \rangle} \text{(FormalAssign)}$$

For the global version, we need to first check that the variable isn't being shadowed by a formal, then make sure it's in $\xi$, then make sure the expression is evaluatable.

$$\frac{x \notin \text{dom} \ \rho \ \ \ x \in \text{dom} \ \xi \ \ \ \langle e, \xi, \Phi, \rho \rangle \Downarrow \langle v, \xi', \Phi, \rho' \rangle}{\langle \text{SET} (x, e), \xi, \Phi, \rho \rangle \Downarrow \langle v, \xi'\{x \mapsto v\}, \Phi, \rho' \rangle} \text{(GlobalAssign)}$$

\pagebreak

## Function Calls

We're just going to focus on user-defined, 2-argument functions (the textbook has rules for n-argument and primitives)

An example of a function like this would be:

```
(define add (x y)
    (+ x 1))
```

And we can call `add` by:

```
(define blah (x)
    (add (set x 1) 3)
    ...)
```

We have to:

1. Check that the function is defined
   $$\Phi (f) = \text{USER}(\langle x_1, x_2 \rangle, e)$$
   $$x_1 \neq x_2$$

2. Evaluate all the arguments
   $$\langle e_1, \xi_0, \Phi, \rho_0 \rangle \Downarrow \langle v_1, \xi_1, \Phi, \rho_1 \rangle$$
   $$\langle e_2, \xi_1, \Phi, \rho_1 \rangle \Downarrow \langle v_2, \xi_2, \Phi, \rho_2 \rangle$$

3. Bind the arguments to their internal names and evaluate the function body with those arguments
   $$\langle e, \xi_2, \Phi, \{x_1 \mapsto v_1, x_2 \mapsto v_2\} \rangle \Downarrow \langle v, \xi', \Phi, \rho' \rangle$$
4. Return a value and go back to the calling scope
   $$\langle v, \xi', \Phi, \rho_2 \rangle$$
   [(slide 29 for details)](https://canvas.tufts.edu/courses/44710/files/5490895?module_item_id=927510)

$$
\frac{\Phi (f) = \text{USER}(\langle x_1, x_2 \rangle, e) \ x_1 \neq x_2 \ \langle e_1, \xi_0, \Phi, \rho_0 \rangle \Downarrow \langle v_1, \xi_1, \Phi, \rho_1 \rangle \ \langle e, \xi_2, \Phi, \{x_1 \mapsto v_1, x_2 \mapsto v_2\} \rangle \Downarrow \langle v, \xi', \Phi, \rho' \rangle}{\langle \text{APPLY}(f, e_1, e_2), \xi_0, \Phi, \rho_0 \rangle \Downarrow \langle v, \xi', \Phi, \rho_2 \rangle} \text{(ApplyUser)}
$$

I think...?

# Derivations: Proofs about Specific Evaluation

See textbook
