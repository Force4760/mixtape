import std/parseutils, std/strformat

########################################
# BYTE TYPE [0..255]
########################################

# maximum value a byte can hold
const maxB = 256 - 1

type Byte* = range[0..maxB]

# Increment a Byte (wrapping it around)
func inc*(b: Byte): Byte =
    if b == maxB: 0 else: b + 1

# IDecrement a Byte (wrapping it around)
func dec*(b: Byte): Byte =
    if b == 0: maxB else: b - 1

# Convert an integer to a Byte
func toByte*(i: int): Byte =
    i mod (maxB + 1)

# Convert a character to a Byte
func toByte*(c: char): Byte =
    int(c) mod (maxB + 1)


########################################
# POINT TYPE (x, y)
########################################

# maximum value a Point coordinate in a Grid can hold
const maxG* = 256 - 1

type GridArray* = array[maxG + 1, array[maxG + 1, char]]

type Point* = tuple
    x: int
    y: int

# String representation of a point (x, y)
proc `$`*(p: Point): string =
    fmt"{p.x}, {p.y}"

# Move the point Up (wrapping it around)
func up*(p: Point): Point =
    if p.y == 0: 
        (p.x, maxG) 
    else: 
        (p.x, p.y - 1)

# Move the point Down (wrapping it around)
func down*(p: Point): Point =
    if p.y == maxG: 
        (p.x, 0) 
    else: 
        (p.x, p.y + 1)

# Move the point Left (wrapping it around)
func left*(p: Point): Point =
    if p.x == 0: 
        (maxG, p.y) 
    else: 
        (p.x - 1, p.y)

# Move the point Right (wrapping it around)
func right*(p: Point): Point =
    if p.x == maxG: 
        (0, p.y) 
    else: 
        (p.x + 1, p.y)

########################################
# PARSING | INPUT | OUTPUT
########################################

# Read an integer from stdin convert it to a byte
proc parseInteger*(): Byte =
    # Read input from stdin
    let str = readLine(stdin)
    
    var num: int
    
    # parseInt returns the number of parsed characters
    # it that number is not the length of the string
    # some part of the input could not be parsed correctly 
    if parseInt(str, num, 0) != len(str):
        raise newException(IOError, "Can't parse: " & str & " as an integer")

    return toByte(num)

        
# Read a single char from stdin and convert it to a byte
# If the input has more than one char it will be ignored 
proc parseSingleChar*(): Byte =
    # Read input from stdin
    let str = readLine(stdin)

    return toByte(str[0])

# Parse a single int character into it's integer value
# Defaults to 0
# 0 -> 0  |  a -> 0  |  : -> 0  |  ...
# 1 -> 1
# ......
# 9 -> 9
proc parseSingleInt*(c: char): int =
    case c:
    of '1': 1
    of '2': 2
    of '3': 3
    of '4': 4
    of '5': 5
    of '6': 6
    of '7': 7
    of '8': 8
    of '9': 9
    else:   0
