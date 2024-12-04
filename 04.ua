Parse      ← ⊜∘≠@\n.
Horizontal ← /+/+ ⌕"XMAS"
Diagonal   ← /+/+ ⧈(≍"XMAS"⊡ ⍉⊟.⇡4) 4_4
Quadrant   ← +⊃Horizontal Diagonal
Half       ← +⊃(Quadrant ⇌⍉) Quadrant
Full       ← +⊃(Half⇌⍉⇌⍉) Half
PartA      ← Full Parse

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

PartA &fras "04.txt"
