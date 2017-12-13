Layer := Object clone
Layer depth ::= 0
Layer range ::= 0
Layer collideVal := method(i,
    if((depth + i) % (2 * (range-1)) == 0, severity, 0) 
)
Layer severity := method(
    depth * range
)

layer := method(d, r, 
    obj := Layer clone
    obj setDepth(d)
    obj setRange(r)
    obj
)

// TODO parse
x := list(layer(0, 3),layer(1, 2),layer(2, 4),layer(4, 6),layer(6, 5),layer(8, 6),layer(10, 6),layer(12, 4),layer(14, 8),layer(16, 8),layer(18, 9),layer(20, 8),layer(22, 6),layer(24, 14),layer(26, 12),layer(28, 10),layer(30, 12),layer(32, 8),layer(34, 10),layer(36, 8),layer(38, 8),layer(40, 12),layer(42, 12),layer(44, 12),layer(46, 12),layer(48, 14),layer(52, 14),layer(54, 12),layer(56, 12),layer(58, 12),layer(60, 12),layer(62, 14),layer(64, 14),layer(66, 14),layer(68, 14),layer(70, 14),layer(72, 14),layer(80, 18),layer(82, 14),layer(84, 20),layer(86, 14),layer(90, 17),layer(96, 20),layer(98, 24))

Total := Object clone
Total total ::= 0
Total calculateTotal := method(i,
    x foreach(elt, setTotal(total + elt collideVal(i)))
    total
)

Total clone calculateTotal(0) print
"\n" print

Range 0 to(100000) foreach(i,
    res := Total clone calculateTotal(i)
    if(res == 0, 
        i print; "\n" print
        ) )
