---
geometry: margin=1in
header-includes:
  - \pagenumbering{gobble}
---

# Generating Type-Equality Constraints

## Goals
- The inputs are a typing environment $\Gamma$ and the expression $e$
- The outputs are a mono type $\tau$ and the constraint $C$ that must be solved

## Type Inference vs. Type Checking

Same:
- Recurse on subexpressions
- Use $\Gamma$ to help with names

Different:
- Create fresh type variables for unknown types
- Accumulate type-equality constraints
- Solve constraints

# How Do We Solve Constraints?

## Formally

A solution to a constraint is a substitution from type variables to types
- Represented as a function mapping type variables to types

Formally we solve a constraint $C$ by finding a substitution $\theta$ such that applying $\theta$ to $C$ satisfies $C$.
- Find $\theta$ such that $\theta C$ is satisfied
- A substitution can be applied to anything involving types (constraints, types, type evironments,...)

# Substitution: A Solution to a Constraint

# Solving Constraints by Finding Substitutions
