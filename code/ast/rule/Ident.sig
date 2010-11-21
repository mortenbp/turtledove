signature Ident =
sig
type t = string list * Fixity.t

structure Symbols : sig
  val equal : t
  val asterisk : t
end

val fromString : Fixity.t -> string -> t
val toString : t -> string
val show : t -> string
val isQual : t -> bool
val isUnqual : t -> bool
val isInfix : t -> bool
val isNonfix : t -> bool
val fixity : t -> Fixity.t
val explode : t -> string list
val setFixity : t -> Fixity.t -> t
val opify : t -> t
end
