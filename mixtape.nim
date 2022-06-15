import src/program, src/load, src/debug

# Create a program from a given file and run it
proc mixtape(path: string = "main.mt", debug: bool = false) =
    var prog: Program
    try:
        prog = load(path)

        if debug: prog.debugRun()
        else:     prog.run()

    except Exception as e:
        echo "\e[0;31m" & e.msg & "\e[0m"
    

when isMainModule:
    import cligen
    dispatch(mixtape)
