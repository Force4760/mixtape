import src/program, src/load

# Create a program from a given file and run it
proc main(path: string) =
    var prog: Program
    try:
        prog = load(path)
    except Exception as e:
        echo e.msg
        return

    prog.run()

when isMainModule:
    main("t.txt")
