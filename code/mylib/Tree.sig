

signature Tree =
sig
    type 'a t
    eqtype node

    val root : node

    val create : 'a -> 'a t
    val insert : 'a t -> node -> 'a -> node * 'a t
    val insertList : 'a t -> node -> 'a list -> node list * 'a t
    val insertTree : 'a t -> node -> 'a t -> node * 'a t
    val insertTrees : 'a t -> node -> 'a t list -> node list * 'a t

    val delete : 'a t -> node -> 'a t

    val lookup : 'a t -> node -> 'a
    val children : 'a t -> node -> node list
    val parent : 'a t -> node -> node option
    val sub : 'a t -> node -> 'a t
    val modify : ('a -> 'a) -> 'a t -> node -> 'a t
    val update : 'a t -> node -> 'a -> 'a t

    val toList : 'a t -> 'a list

    val size : 'a t -> int
    val height : 'a t -> int

    val map : ('a -> 'b) -> 'a t -> 'b t
    val fold : ('a * 'b -> 'b) -> 'b -> 'a t -> 'b

    structure Walk : sig
        val this : 'a t -> 'a
        val children : 'a t -> 'a t list
        val go : 'a -> 'a t list -> 'a t
    end
end
