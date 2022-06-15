import helper

########################################
# DIRECTION TYPE
########################################

type Direction = enum 
    dUp,
    dDown,
    dLeft,
    dRight

########################################
# GRID TYPE
########################################

type Grid* = ref object
    grid: GridArray
    direction: Direction
    coord: Point

# Constructor for the Grid type
proc newGrid*(g: GridArray): Grid =
    Grid(
        grid: g, 
        direction: dRight,
        coord: (0, 0),
    )
    
########################################
# SWITCH MOVEMENT DIRECTION
########################################

# Switch the direction to Up
proc switchUp*(g: Grid) =
    g.direction = dUp

# Switch the direction to Down
proc switchDown*(g: Grid) =
    g.direction = dDown

# Switch the direction to Left
proc switchLeft*(g: Grid) =
    g.direction = dLeft

# Switch the direction to Right
proc switchRight*(g: Grid) =
    g.direction = dRight

# Conditionaly switch the direction to Up or Down
# b == 0 -> Up
# b == 1 -> Down
proc switchUD*(g: Grid, b: Byte) =
    if b == 0: 
        g.switchUp()
    else:
        g.switchDown()

# Conditionaly switch the direction to Left or Right
# b == 0 -> Left
# b == 1 -> Right
proc switchLR*(g: Grid, b: Byte) =
    if b == 0: 
        g.switchLeft()
    else:
        g.switchRight()

########################################
# MOVEMENT
########################################

# Move the 1 unit in the current direction
proc move*(g: Grid) =
    g.coord = case g.direction:
        of dUp:    g.coord.up()
        of dDown:  g.coord.down()
        of dLeft:  g.coord.left()
        of dRight: g.coord.right()

# Set the coordinate to a given (x, y) point 
proc moveTo*(g: Grid, x, y: int) =
    g.coord = (x mod 30, y mod 30)

########################################
# GETTERS | SETTERS | OUTPUT
########################################

# Get the character at coordinates (X, Y)
proc getXY*(g: Grid, x, y: int): char = 
    g.grid[y mod 30][x mod 30]

# Get the character ate the current coordinate
proc getCurrent*(g: Grid): char = 
    g.grid[g.coord.y][g.coord.x]

# String representation of the grid coordinate
proc getCoordStr*(g: Grid): string = 
    $g.coord


########################################
# DEBUG
########################################

proc debug*(g: Grid): (int, int, Direction, char) =
    (g.coord.x, g.coord.y, g.direction, g.getCurrent())
