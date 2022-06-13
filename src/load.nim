import program, helper

# Get the char of str at a given index
# If that char does not exist returns def
proc charDef(str: string, index: int, def: char): char =
    if index >= len(str): def
    else: str[index]

# Get the next line of a file
# If that line does not exist returns def
proc lineDef(f: File, def: string): string =
    try: f.readLine()
    except EOFError: def

# Load a given file (from path) and convert it to a Program
proc load*(path: string): Program =
    # Open the given file and 
    # close it at the end of the function
    let f = open(path)
    defer: f.close()

    # Create a grid to store every character
    var grid: GridArray
    for i in 0..maxG:
        let lineI = f.lineDef("")
        for j in 0..maxG:
            grid[i][j] = lineI.charDef(j, ' ')

    # Create a Program from the grid and return it
    return newProgram(grid)
