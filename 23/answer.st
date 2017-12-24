Object subclass: Env [
    | env pc muls |

    Env class >> new [
        | r |
        r := super new.
        r init.
        ^r
    ]

    init [
        env := LookupTable new.
        pc := 1.
        muls := 0.
        env at: 'a' put: 0.
        env at: 'b' put: 0.
        env at: 'c' put: 0.
        env at: 'd' put: 0.
        env at: 'e' put: 0.
        env at: 'f' put: 0.
        env at: 'g' put: 0.
        env at: 'h' put: 0.
    ]

    set: x to: val [
        env at: x put: val
    ]

    lookup: x [
        (x isNumeric | x asNumber ~= 0) 
            ifTrue: [ ^x asNumber ]
            ifFalse: [ ^env at: x ]
    ]

    pc [ ^pc ]

    pc: inc [ 
        pc := pc + inc.
    ]

    validPc: limit [
        ^pc >= 1 & pc < limit
    ]

    recordMul [
        muls := muls + 1.
    ]
    muls [ ^muls ]
]

Object subclass: Instr [
    | instr x y |

    Instr class >> new: instr x: ix y: iy  [
        | r |
        r := super new.
        r init: instr x: ix y:iy.
        ^r
    ]
    Instr class >> newInstr: instr x: ix y: iy [
        | sc |
        sc := self subclasses detect: [:first | first instr: instr].
        ^sc new: instr x: ix y: iy.
    ]

    init: cmd x: ix y: iy [
        x := ix.
        y := iy.
        instr := cmd.
    ]

    x [ ^x ]
    y [ ^y ]

    printOn: stream [
        <category: 'printing'>
        super printOn: stream.
        stream nextPutAll: ' cmd: '.
        instr printOn: stream.
        stream nextPutAll: ' '.
        x printOn: stream.
        stream nextPutAll: ' '.
        y printOn: stream.
    ]

    invoke: env [

    ]
]

Instr subclass: SetInstr [
    invoke: env [
        | yv |
        yv := env lookup: y.
        env set: x to: yv.

        env pc: 1.
    ]
    SetInstr class >> instr: cmd [ ^cmd = 'set' ]
]
Instr subclass: SubInstr [
    invoke: env [
        | yv xv |
        yv := env lookup: y.
        xv := env lookup: x.
        env set: x to: (xv - yv).

        env pc: 1.
    ]
    SubInstr class >> instr: cmd [ ^cmd = 'sub' ]
]
Instr subclass: MulInstr [
    invoke: env [
        | yv xv |
        yv := env lookup: y.
        xv := env lookup: x.
        env set: x to: (xv * yv).
        env recordMul.
        env pc: 1.
    ]
    MulInstr class >> instr: cmd [ ^cmd = 'mul' ]
]
Instr subclass: JnzInstr [
    invoke: env [
        | yv xv |
        yv := env lookup: y.
        xv := env lookup: x.
        (xv ~= 0) ifTrue: [ env pc: yv ] ifFalse: [ env pc: 1 ].
    ]
    JnzInstr class >> instr: cmd [ ^cmd = 'jnz' ]
]

instructions := Array new: 50.

file := (File name: 'input.txt') readStream.
lineNo := 0.
file linesDo: [:line |
    (line =~ '([a-z]{3}) ([^ ]+) ([^ ]+)') ifMatched: [:match |
        lineNo := lineNo + 1.
        instructions at: lineNo put: (Instr newInstr: (match at: 1) x: (match at: 2) y: (match at: 3))]].
instructions := instructions select: [:x | x notNil ].
env := Env new.

[env validPc: (instructions size)] whileTrue:
    [ 
        (instructions at: (env pc)) invoke: env.
    ]
(env muls) printNl.