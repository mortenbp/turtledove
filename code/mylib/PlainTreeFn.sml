(* Fully implemented - Yay *)

functor PlainTreeFn (Map : OrderedMap where type key = int) :> Tree =
struct
    type node = int list
    (* data * next_node * children *)
    datatype 'a t = T of 'a * int * 'a t Map.t

    val root = nil

    fun create x = T (x, 0, Map.empty)

    fun insertTrees t ns ts' =
        let
            (* Worst hack ever *)
            val n = ref 0
            val s = length ts'

            fun ins (n :: ns) (T (v, n', ts)) =
                T (v, n', Map.modify (ins ns) ts n)
              | ins nil (T (v, n', ts)) =
                (n := n' ;
                 T (v, n' + s,
                    #1 (foldl (fn (t', (ts, n')) =>
                                  (valOf (Map.insert ts (n', t')), n' + 1)
                              ) (ts, n') ts')
                   ) handle Option.Option => raise Domain
                )
        in
            (List.tabulate (s, fn x => ns @ [!n + x]), ins ns t)
        end

    fun insertList t n xs = insertTrees t n (map create xs)
    fun insertTree t n t' =
        let
            val (ns, t) = insertTrees t n [t']
        in
            (hd ns, t)
        end
    fun insert t n = insertTree t n o create

    fun delete (T (v, n', ts)) [n] =
        T (v, n', Map.delete ts n)
      | delete (T (v, n', ts)) (n :: ns) =
        T (v, n', Map.modify (fn t => delete t ns) ts n)
      | delete _ _ = raise Domain

    fun lookup (T (v, _, _)) nil = v
      | lookup (T (_, _, ts)) (n :: ns) = lookup (Map.lookup ts n) ns

    fun children t ns =
        let
            fun children' (T (_, _, ts)) nil =
                map (fn n => ns @ [n]) (Map.domain ts)
              | children' (T (_, _, ts)) (n :: ns) =
                children' (Map.lookup ts n) ns
        in
            children' t ns
        end

    fun parent _ nil = NONE
      | parent _ [_] = SOME nil
      | parent t (n :: ns) = SOME (n :: valOf (parent t ns))

    fun sub t nil = t
      | sub (T (_, _, ts)) (n :: ns) = sub (Map.lookup ts n) ns

    fun modify f (T (v, n', ts)) nil = T (f v, n', ts)
      | modify f (T (v, n', ts)) (n :: ns) =
        T (v, n', Map.modify (fn t => modify f t ns) ts n)

    fun update (T (_, n', ts)) nil v' = T (v', n', ts)
      | update (T (v, n', ts)) (n :: ns) v' =
        T (v, n', Map.modify (fn t => update t ns v') ts n)

    fun toList (T (v, _, ts)) = v :: (List.concat o map toList o Map.range) ts

    fun size (T (_, _, ts)) = 1 + (foldl op+ 0 o map size o Map.range) ts

    fun height (T (_, _, ts)) = 1 + (foldl Int.max 0 o map height o Map.range) ts

    fun map f (T (v, n', ts)) = T (f v, n', Map.map (map f) ts)

    fun fold f b (T (v, _, ts)) =
        foldl (fn (t, a) => fold f a t) (f (v, b)) (Map.range ts)

    structure Walk =
    struct
        fun this (T (v, _, _)) = v
        fun children (T (_, _, ts)) = Map.range ts
        fun go v ts =
            let
                val (_, t) = insertTrees (create v) root ts
            in
                t
            end
    end
end
