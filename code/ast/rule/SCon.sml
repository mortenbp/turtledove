structure SCon :> SCon =
struct
datatype t = String of string
           | Char of string
           | Int of string
           | Real of string
           | Word of string
end
