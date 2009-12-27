signature SourceText =
sig
    type t

    val fromString : string -> t 
    val fromFile : string -> t
    val reread : t -> t

    val getSource : t -> int -> int -> string
    val getFileName : t -> string
    val getSize : t -> int

    val patch : t -> int -> int -> string -> t
    val patchLine : t -> int -> string -> t

    val makeReader : t -> int -> string

    val posToString : t -> int -> string
    val showPos : t -> int -> Report.t
end