(* map *)
fun map _ []        = []
  | map f (x :: xs) = f x :: map f xs

(* xor *)
fun xor (true,  b) = b
  | xor (false, b) = not b
