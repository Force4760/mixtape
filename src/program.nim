import std/strformat

import helper, grid, tape

########################################
# PROGRAM TYPE
########################################

type Program* = ref object
    grid: Grid
    tape: Tape
    isStrMode: bool
    output: string

# Constructor for the program type
proc newProgram*(grid: GridArray): Program =
    Program(
        grid: newGrid(grid),
        tape: newTape(),
        isStrMode: false,
        output: ""
    )
    
# Print a value without a new line
proc print[T](p: Program, s: T, isOutput: bool) =
    p.output &= s
    
    if isOutput: 
        stdout.write s

# Process a given character according to the current state of the program
# Every character will be converted to byte, added to the tape and the head will move right
# " will not be added and will terminate the str mode
proc processStr*(p: Program) =
    let c = p.grid.getCurrent()
    if c == '"':
        p.isStrMode = false
    else:
        p.tape.setCurrentStr(c)

    p.grid.move()

# Process a given character according to the current state of the program
# Unknown characters will throw an exception
# Returns a bool representing if the execution of the program should continue
proc process*(p: Program, isOutput: bool): bool =
    let c = p.grid.getCurrent()
    case c:
        # GRID
        of '<': 
            # Left 
            p.grid.switchLeft()
        of '>': 
            # Right
            p.grid.switchRight()
        of '^': 
            # Up
            p.grid.switchUp()
        of 'v': 
            # Down
            p.grid.switchDown()
        of '_': 
            # Left or Right
            p.grid.switchLR(p.tape.getCurrent())
        of '|': 
            # Up or Down
            p.grid.switchUD(p.tape.getCurrent())
        of '~': 
            # Ignore next
            p.grid.move()
        of '&': 
            # Move To (x, y)
            let x = p.tape.getCurrent()
            let y = p.tape.getNext()
            p.grid.moveTo(x, y)
            return true

        # TAPE
        of '{':
            # Head Left 
            p.tape.left()
        of '}':
            # Head Right 
            p.tape.right()
        of '+': 
            # Cell Up
            p.tape.up()
        of '-': 
            # Cell Down
            p.tape.down()
        of '@': 
            # Move head to the current cell value
            p.tape.setHead()
        of '?': 
            # Set cell to random
            p.tape.setRand()
        of '0': 
            # Set cell to 0
            p.tape.set0()
        of '1', '2', '3', '4', '5', '6', '7', '8', '9': 
            # Repeat the last operation n times
            p.tape.repeatLast(parseSingleInt(c))
        of '\'': 
            # Set cell to input char
            p.tape.setCurrent(parseSingleChar())
        of '=':
            # Set cell to input int
            p.tape.setCurrent(parseInteger())
        of '$': 
            # Print cell as char
            p.print(
                char(p.tape.getCurrent()), 
                isOutput,
            )
        of '#': 
            # Print cell as int
            p.print(
                $p.tape.getCurrent(), 
                isOutput,
            )
        
        # RESET, END and MODE
        of '"':
            p.isStrMode = true
        of ':': 
            # Reset Grid
            p.grid.moveTo(0, 0)
        of '.':
            # Reset tape 
            p.tape.setHeadTo(0)
        of '!':
            # End program (false === stop)
            return false

        of ' ':
            # Empty space -> keep moving 
            discard
        else:
            # Unknown character
            raise newException(
                ValueError,
                fmt"Found and unknown character '{c}' at coordinates ({p.grid.getCoordStr()})",
            )

    p.grid.move()

    # Keep the program running (true === don't stop)
    return true

# Run one step of the program o
# true  === continues
# false === stop
proc next*(p: Program, isOutput: bool): bool =
    var isContinue = true
    if p.isStrMode:
        p.processStr()
    else: 
        isContinue = p.process(isOutput)

    return isContinue

# Run the full Program
# Stops on ! or on an unknown character
proc run*(p: Program) =
    while true:
        let isContinue = p.next(true)
        if not isContinue:
            break


proc debug*(p: Program): (
    Byte, Byte, Byte, Byte, string, array[5, char], bool, string
) =
    let (head, prev, curr, next) = p.tape.debug()
    let (xy, chars) = p.grid.debug()

    (head, prev, curr, next, xy, chars, p.isStrMode, p.output)