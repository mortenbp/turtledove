fun sumlige [] = 0
  | sumlige (x :: xs) = (if x mod 2 = 0 then x div 2 else 0) + sumlige xs
