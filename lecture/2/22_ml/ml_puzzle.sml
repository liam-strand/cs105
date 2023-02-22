(*  Author: Richard Townsend
*   Date: 2-16-22
*
*   This is an activity for the first ML lecture. After going over a bunch of
*   basic expressions in a live coding demo, students are asked to figure
*   out what this big expression evaluates to.
*
*)

4 + (if not (let val x = "a" = "a" in x end)
     then 12
     else let val y = 1
              val x = y * 3
              val z = if false orelse (not (x = y))
                      then 2
                      else 4
          in z
          end)

