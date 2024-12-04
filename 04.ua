Parse      ← ⊜∘≠@\n.
Horizontal ← /+/+ ⌕"XMAS"
Diagonal   ← /+/+ ⧈(≍"XMAS"⊡ ⍉⊟.⇡4) 4_4
Quadrant   ← +⊃Horizontal Diagonal
Half!      ← +⊃(^0⇌⍉)^0
Full!      ← +⊃(Half!^0⇌⍉⇌⍉) Half!^0
PartA      ← Full!Quadrant Parse

┌─╴test
  $ MMMSXXMASM
  $ MSAMXMSMSA
  $ AMXSXMAAMM
  $ MSAMASMSMX
  $ XMASAMXAMM
  $ XXAMMXXAMA
  $ SMSMSASXSS
  $ SAXAMASAAA
  $ MAMMMXMMMM
  $ MXMXAXMASX
  PartA
  ⍤. =18
└─╴
PartA&fras "04.txt"

XMas  ← /+/+ ⧈(≍"MMASS" ⊡ [0_0 2_0 1_1 0_2 2_2]) 3_3
PartB ← Full!XMas Parse

┌─╴test
  $ MMMSXXMASM
  $ MSAMXMSMSA
  $ AMXSXMAAMM
  $ MSAMASMSMX
  $ XMASAMXAMM
  $ XXAMMXXAMA
  $ SMSMSASXSS
  $ SAXAMASAAA
  $ MAMMMXMMMM
  $ MXMXAXMASX
  PartB
  ⍤. =9
└─╴
PartB&fras "04.txt"
