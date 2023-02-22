(* This file shows a full interactive session with the mosml interpreter, which
 * was started up with command
 *
 *    ledit mosml -P full -I /comp/105/lib
 *
 * on the Halligan servers *)

- (* ML Comments *);
- (* In the interpreter, need to end definitions (and top-level expressions)
     with a semicolon. Don't do this in your files!!! *);

- (* Arithmetic *);
- 3 + 2 * 4;
> val it = 11 : int
- 3.4 + 2.2 * 1.2;
> val it = 6.04 : real
- ~3 * 2;
> val it = ~6 : int

- (* Our first type error! *);
- 2 + 3.0;
! Toplevel input:
! 2 + 3.0;
!     ^^^
! Type clash: expression of type
!   real
! cannot have type
!   int

- (* Strings *);
- "we have strings";
> val it = "we have strings" : string
- "Richard " ^ "Townsend";
> val it = "Richard Townsend" : string

- (* Booleans *);
- true;
> val it = true : bool
- false;
> val it = false : bool
- not true;
> val it = false : bool
- true orelse false;
> val it = true : bool
- true andalso false;
> val it = false : bool

- (* Conditionals require then and else clauses *);
- if 1 < 2 then 1 else 0;
> val it = 1 : int
- if 1 >= 2 then 1 else 0;
> val it = 0 : int

- (* Equality and inequality use potentially unexpected operators *);
- if 1 = 2 then 1 else 0;
> val it = 0 : int
- if 1 <> 2 then 1 else 0;
> val it = 1 : int

- (* Branches must have same types, determined by type of first branch *);
- if 1 <> 2 then 1 else "hello";
! Toplevel input:
! if 1 <> 2 then 1 else "hello";
!                       ^^^^^^^
! Type clash: expression of type
!   string
! cannot have type
!   int

- (**** Defining (immutable) variables globally and locally *****)

- (* A 'val declaration' binds a name to a value *)
- val x = 3;
> val x = 3 : int
- x;
> val it = 3 : int

- (* Without 'val', an = is comparison, not assignment *)
- x = 8;
> val it = false : bool
- x;
> val it = 3 : int

- (* If you re-bind a name to a new value with 'val', it creates a completely
  new binding as opposed to updating the old one. We say variables in ML are
  "immutable": once bound to a value, it can never be bound to a new one.
  Reusing the same name creates a completely new variable of the same name. *)
- val y = x + 2;
> val y = 5 : int
- val x = 9;
> val x = 9 : int
- y; (* y just sees the old x used when y was defined. *)
> val it = 5 : int 

- (* Let bindings for local variables! Need let, val, in, and end keywords *)
- let val x = 4 in x + 5 end;
> val it = 9 : int
- (* Better formatting *)
- let val x = 4
  in  x + 5     
  end;
> val it = 9 : int
- (* Let works like let* in scheme *)
- let val x = 4
      val y = x + 5
  in  y
  end;
> val it = 9 : int
- (* Also like in Scheme, a let can appear wherever an expression is expected *)
- if (let val x = 3 > 2 in x end)
  then x + 3
  else x * 2;
> val it = 12 : int

(* What value does this produce? *)
- 4 + (if not (let val x = "a" = "a" in x end)         
       then 12
       else let val y = 1
                val x = y * 3
                val z = if false orelse (not (x = y))
                        then 2
                        else 4
            in z
            end);
> val it = 6 : int

- (**** Lists -- collection of elements with same type ****)

- (* We have a new kind of type! *)
- [1, 2, 3];
> val it = [1, 2, 3] : int list
- ["hi", "there"];
> val it = ["hi", "there"] : string list

- (* First element of list dictates the list's type *)
- [1, "hi", 3];
! Toplevel input:
! [1, "hi", 3];
!     ^^^^
! Type clash: expression of type
!   string
! cannot have type
!   int
- ["hi", 1, 3];
! Toplevel input:
! ["hi", 1, 3];
!        ^
! Type clash: expression of type
!   int
! cannot have type
!   string

- (* The empty list is a "list of any type". This is captured with a polymorphic
  type, which will be covered in a later ML session *) 
- [];
> val 'a it = [] : 'a list
- (* Once you add an of known type to a list, its not polymorphic anymore. Here,
  we're using the cons operator :: *)
- 1 :: [];
> val it = [1] : int list
- (* Cons is right-associative, so parentheses are unnecessary to build up a
  list *)
- 1 :: 2 :: 3 :: [];
> val it = [1, 2, 3] : int list
- 1 :: (2 :: (3 :: []));
> val it = [1, 2, 3] : int list
- (* Concatentate lists with @ operator *)
- [1, 2, 3] @ [4, 5];
> val it = [1, 2, 3, 4, 5] : int list
- (* Lists of lists are fine! *)
- [[1, 2], [3, 4]];
> val it = [[1, 2], [3, 4]] : int list list

- (**** Tuples -- collection of 2 or more elements with different types ****)

- (* Another new type! *)
- (1, "hello"); 
> val it = (1, "hello") : int * string
- ("hello", 1);
> val it = ("hello", 1) : string * int
- ("hi", 1, 2, true);
> val it = ("hi", 1, 2, true) : string * int * int * bool
- (* Types can get pretty crazy as we start to mix and match our forms. Ask
  students: which part of type captures which part of this expression? *)
- ("Hi", ([1, 2], false), [[3]]);
