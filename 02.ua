Parse  ← ⊜(□⊜⋕≠@ .)≠@\n.
Diff   ← ↘¯1↘1⬚0-⊂0.
IsSafe ← >0+ /××>¯4⟜(<0) ⟜(/××<4⟜(>0))
PartA  ← /+∵(IsSafe Diff °□) Parse

┌─╴Test
  $ 7 6 4 2 1
  $ 1 2 7 8 9
  $ 9 7 6 2 1
  $ 1 3 2 4 5
  $ 8 6 4 4 1
  $ 1 3 6 7 9
  PartA
  ⍤. =2
└─╴
PartA &fras "02.txt"

IndicesToDrop    ← -1⇡+1⧻°□.□
DropIndex        ← □↻¯⟜(↘>¯1⟜↻)⊙°□
ReportCandidates ← ⊞(DropIndex) IndicesToDrop
HasSafeCandidate ← >0/+ ∵(IsSafe Diff °□) ReportCandidates
PartB            ← /+∵(HasSafeCandidate °□) Parse

┌─╴Test
  $ 7 6 4 2 1
  $ 1 2 7 8 9
  $ 9 7 6 2 1
  $ 1 3 2 4 5
  $ 8 6 4 4 1
  $ 1 3 6 7 9
  PartB
  ⍤. =4
└─╴
PartB &fras "02.txt"
