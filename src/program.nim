import std/strformat

import helper, grid, tape

type Program* = ref object
    grid: Grid
    tape: Tape

proc newProgram*(grid: array[30, array[30, char]]): Program =
    Program(
        grid: newGrid(grid),
        tape: newTape(),
    )
    
proc process*(p: Program, c: char): bool =
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
        of 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z':
            # Set cell to char
            p.tape.setCurrent(c)     
        of '"': 
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
        

        # RESET AND END
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

proc run*(p: Program) =
    try:
        while true:
            let isContinue = p.process(
                p.grid.getCurrent()
            )

            if not isContinue:
                break

            p.grid.move()

    except Exception as e:
        echo e.msg
