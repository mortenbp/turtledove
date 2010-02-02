(* Utility functions *)

structure Utils :> Utils =
struct
    fun ofSome NONE = Crash.impossible "Utils.ofSome: Got NONE"
      | ofSome (SOME x) = x

    fun ofSomeWithMsg msg NONE = Crash.impossible msg
      | ofSomeWithMsg _ (SOME x) = x

    fun id x = x

    infix ^*

    fun f ^* 0 = id
      | f ^* n = f o (f ^* (n - 1))

    fun curry f x y = f (x, y)
    fun uncurry f (x, y) = f x y

    fun to (a, b) =
        if a <= b then
          a :: to (a + 1, b)
        else
          nil

    fun inc x = (x := !x + 1 ; !x)
    fun dec x = (x := !x - 1 ; !x)

    fun leftmost nil = NONE
      | leftmost (SOME x :: _) = SOME x
      | leftmost (NONE :: r) = leftmost r

    fun rightmost lst = leftmost (rev lst)
end

local open Utils in
val id = id
val ^* = ^*
val curry = curry
val uncurry = uncurry
val to = to

infix ^* to
end
