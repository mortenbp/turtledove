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

    fun inc x = (x := !x + 1 ; !x)
    fun dec x = (x := !x - 1 ; !x)

    fun leftmost nil = NONE
      | leftmost (SOME x :: _) = SOME x
      | leftmost (NONE :: r) = leftmost r

    fun rightmost lst = leftmost (rev lst)

    fun pairOneFromEach lst1 lst2 =
        let
          fun pairOneFromEach' (x :: xs) lst2 res = pairOneFromEach' xs lst2 (List.foldl (fn (a,b) => (x,a) :: b) res lst2)
            | pairOneFromEach' [] _ res = res
        in
          pairOneFromEach' lst1 lst2 []
        end
end
