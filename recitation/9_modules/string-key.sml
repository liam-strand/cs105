structure StringKey :> KEY where type key = string =
struct
  type key = string
  val cmp = String.compare
end
