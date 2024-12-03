PartA ← /+≡(/×⋕)⍉↘1⍉regex "mul\\((\\d+),(\\d+)\\)"

┌─╴test
  $ xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
  PartA
  ⍤. =161
└─╴

PartA &fras "03.txt"

PartB ← /+∵(PartA °□)▽∵(¬≍"don't()"⬚@ ↙⧻"don't()"°□).⊜□ +1\++⌕"don't()"⟜(⌕"do()").

┌─╴test
  $ xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
  PartB
  ⍤. =48
└─╴

PartB &fras "03.txt"
