import std/strformat

import helper, grid, tape

########################################
# PROGRAM TYPE
########################################

type Program* = ref object
    grid: Grid
    tape: Tape
    isStrMode: bool

# Constructor for the program type
proc newProgram*(grid: GridArray): Program =
    Program(
        grid: newGrid(grid),
        tape: newTape(),
        isStrMode: false,
    )
    
# Process a given character according to the current state of the program
# Every character will be converted to byte, added to the tape and the head will move right
# " will not be added and will terminate the str mode
proc processStr*(p: Program) =
    let c = p.grid.getCurrent()
    if c == '"':
        p.isStrMode = false
    else:
        p.tape.setCurrentStr(c)

# Process a given character according to the current state of the program
# Unknown characters will throw an exception
# Returns a bool representing if the execution of the program should continue
proc process*(p: Program): bool =
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
        of '\'': 
            # Set cell to input char
            p.tape.setCurrent(parseSingleChar())
        of '=':
            # Set cell to input int
            p.tape.setCurrent(parseInteger())
        of '$': 
            # Print cell as char
            print char(p.tape.getCurrent())
        of '#': 
            # Print cell as int
            print p.tape.getCurrent()
        

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
                fmt"Found and unknown character '{c}' at coordinates {p.grid.getCoordStr()}",
            )

    # Keep the program running (true === don't stop)
    return true


# Run the full Program
# Stops on ! or on an unknown character
proc run*(p: Program) =
    try:
        while true:
            if p.isStrMode:
                p.processStr()
            else: 
                let isContinue = p.process()
                if not isContinue: 
                    break
            
            p.grid.move()

    except Exception as e:
        echo e.msg
