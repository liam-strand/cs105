signature QUEUE = sig
  type 'a queue
  exception Empty

  val empty : 'a queue
  val put : 'a * 'a queue -> 'a queue
  val get : 'a queue -> 'a * 'a queue
end
