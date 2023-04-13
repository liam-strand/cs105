functor DictFn (structure Key : KEY) :> DICT where type key = Key.key =
struct
  type key = Key.key
  type 'a dict = (Key.key * 'a) list

  exception NotFound of key

  val empty = []
  
  fun find (k, [])          = raise NotFound k
    | find (k, (k', x)::rest) = 
        (case Key.cmp(k, k')
           of EQUAL => x
            | _     => find (k, rest))

  fun bind (k, v, []) = [(k, v)]
    | bind (k, v, (k', v')::rest) = 
        (case Key.cmp(k, k')
           of EQUAL => (k, v)::rest
            | _     => (k', v')::bind(k, v, rest))
end
