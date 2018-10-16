## Vertical alignment of elements
Space everything out to line up on the furthest elements. If your first column has two 5-character words and one 7, then the second column should start one space after the 7th character, then start the second element at the 9th column, and everything else will line up on that 9th column.
```
abcd:   :jklmnop
abcd:   :jklmnop
abcdef: :jklmnop
```
## Hash notation
Use hash notation on where clauses.
```
.where(name: 'MySubnet') do
```