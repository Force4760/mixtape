import random

import helper


########################################
# TAPE TYPE
########################################

type Tape* = ref object
    tape: array[256, Byte]
    head: Byte
    last: char

# Constructor for the tape type
proc newTape*(): Tape =
    var tape: array[256, Byte]
    for i in 0..255:
        tape[i] = 0

    Tape(tape: tape, head: 0, last: ' ')


########################################
# TAPE MOVEMENT
########################################

# Decrement the current cell value
#
# +-----+-----+-----+      +-----+-----+-----+
# |  0  | 110 |  0  |  ->  |  0  | 109 |  0  |
# +-----+-----+-----+      +-----+-----+-----+
#          ^                        ^
proc down* (t: Tape) = 
    t.tape[t.head] = dec t.tape[t.head]
    t.last = '-'

# Increment the current cell value
#
# +-----+-----+-----+      +-----+-----+-----+
# |  0  | 100 |  0  |  ->  |  0  | 101 |  0  |
# +-----+-----+-----+      +-----+-----+-----+
#          ^                        ^
proc up*(t: Tape) = 
    t.tape[t.head] = inc t.tape[t.head]
    t.last = '+'

# Decrement the head of the tape
#
# +-----+-----+-----+      +-----+-----+-----+
# |  0  | 110 |  0  |  ->  |  0  | 110 |  0  |
# +-----+-----+-----+      +-----+-----+-----+
#          ^                  ^
proc left*(t: Tape) = 
    t.head = dec t.head
    t.last = '{'

# Increment the head of the tape
#
# +-----+-----+-----+      +-----+-----+-----+
# |  0  | 110 |  0  |  ->  |  0  | 110 |  0  |
# +-----+-----+-----+      +-----+-----+-----+
#          ^                              ^
proc right*(t: Tape) = 
    t.head = inc t.head
    t.last = '}'

proc doLast*(t: Tape) =
    case t.last:
    of '+': t.up()
    of '-': t.down()
    of '{': t.left()
    of '}': t.right()
    else: discard

proc repeatLast*(t: Tape, n: int) =
    for i in 0..<n:
        t.doLast()

########################################
# TAPE GETTERS AND SETTERS
########################################

# Set the current cell to a given byte value
proc setCurrent*(t: Tape, b: Byte) =
    t.tape[t.head] = b

proc setCurrent*(t: Tape, i: int) =
    t.tape[t.head] = toByte(i)

# Set the current cell and move right
proc setCurrentStr*(t: Tape, c: char) =
    t.tape[t.head] = toByte(c)
    t.right()

# Set the current cell to a random byte value
proc setRand*(t: Tape) =
    t.tape[t.head] = toByte(rand(0..255))

# Set the current cell to 0
proc set0*(t: Tape) =
    t.tape[t.head] = 0

# Set the head of the tape to the value of the current cell
proc setHead*(t: Tape) =
    t.head = t.tape[t.head]

# Set the head of the tape to a given value
proc setHeadTo*(t: Tape, b: Byte) =
    t.head = b

# Get the value of the current cell
#
# +-----+-----+-----+
# |  0  | 110 | 200 |  ->  110  
# +-----+-----+-----+
#          ^
proc getCurrent*(t: Tape): Byte =
    t.tape[t.head]

# Get the value of the next cell
#
# +-----+-----+-----+
# |  0  | 110 | 200 |  ->  200  
# +-----+-----+-----+
#          ^
proc getNext*(t: Tape): Byte =
    if t.head == 255:
        t.tape[0]
    else:
        t.tape[t.head+1]

# Get the value of the previous cell
#
# +-----+-----+-----+
# |  0  | 110 | 200 |  ->  200  
# +-----+-----+-----+
#          ^
proc getPrev*(t: Tape): Byte =
    if t.head == 0:
        t.tape[255]
    else:
        t.tape[t.head-1]


########################################
# DEBUG
########################################
proc debug*(t: Tape): (Byte, Byte, Byte, Byte) =
    (t.head, t.getPrev(), t.getCurrent(), t.getNext())
