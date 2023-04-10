signature KEY = sig
  type key (* the type of our underlying keys *)

  (* compares keys to each other (good for tree-map) *)
  val cmp : key * key -> order
end
