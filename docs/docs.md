# MixTape

**MixTape** (MT) is a new **esoteric programming language** (EsoLang) that is composed of a **Grid** and a **Tape** similar to Befunge’s and Brainfuck’s respectively.

You might be asking: “Why another language?”. Oh sweet summer child, do you think I need any reason to create a new dumb language? I just want to have fun.


## The Tape
After all what the hell is a **Tape**? A tape is just a 1-dimension collection of cells that can be manipulated.

```
+———+———+———+———+———+———+———+———+ . . .
│ 0 │ 1 │ 2 │ 3 │ 4 │ 5 │ 6 │ 7 │ . . .
+———+———+———+———+———+———+———+———+ . . .
              ^
```

Each **Cell** is a byte that can hold values from **0** to **255**. The Tape is made of **256** cells and a **Head** that points to the current cell.


## The Grid
A **Grid** is a 2-dimension 256x256 collection of characters that compose your program. Each character is assigned to a given operation that either manipulates the grid itself or the tape.

The Grid also has a **pointer** that stores the current coordinate of the program. It starts at the top-left **(0,0)** and starts moving to the right. If this pointer moves out of the grid borders it will wrap around.


## Manipulation of the Tape
The first thing we can manipulate is the **Head**.  If you want to move the head to the **left**, use `{` and if you want to move it to the right use `}`. 

The head wraps around, i.e. if you try to move left at index 0 it moves to index 255 and if you try to move right at index 255 it moves to index 0.
The second thing we can manipulate are the cells themselves. There are 4 kinds of operations that you can use on them: **Increment**, **Decrement**, **Set** and **Read**.

You can use the `+` command to **Increment** and `-` to **Decrement** the given cell. Both operations wrap in a similar way to the tape’s head movement.

**Setting** is a bit more interesting since there are several ways to do it:
`0` Sets the cell to 0.
Any letter character (from `A` to `z`) will set the cell to it’s corresponding ASCII values (ex: `A` is 65).
`?` will set the cell to a random value between 0 and 255. 
`”` will ask the user for a character and set the cell to it’s ASCII value
`=` will ask the user for an integer and set the cell to it’s value (mod 255)

**Reading** is also an interesting operation:
`$` Reads the value of the current cell, converts it to ASCII and prints it.
`#` Reads the value of the current cell, prints it without converting it to a ASCII (it prints an integer)
`@` Reads the value of the current cell and moves the head to the corresponding cell (ex: if the value is 10, the head will be moved to index 10)


## Manipulation of the Grid
The **Pointer** moves, but there are several ways to manipulate it’s movement.
`>` Sets the movement direction to **Right**
`<` Sets the movement direction to **Left**
`^` Sets the movement direction to **Up**
`v` Sets the movement direction to **Down**

There are two conditional movement operators. They look at the value of the current cell and move to a different direction according to the value
`|` If the value is 0, sets the direction to **Up**, otherwise sets it to **Down**
`_` If the value is 0, sets the direction to **Left**, otherwise sets it to **Right**

Sometimes, we might want want to ignore certain characters and just jump to the next one. The `~` command does exactly that. If the pointer finds this command, it will keep moving in the same direction, but ignore the command after `~`

The last way to manipulate the grid is to move it’s pointer to a specific place. This can be achieved with the `&` operator that sets **x** to the value of the current cell and **y** to the value of the next cell (mod 30 so that it does not overflow)


## Strings
Esolangs are famous for being hard to write and output strings (hello world programs become super interesting once you enter the esolangs world). Since Mixtape is somewhat a Befunge clone, I wanted to add some **String mode** like the on found on Befunge.

The string mode can be started and ended with the `”` command. Every character found between an opening and closing `”` will be interpreted as a string character and stored on the tape.

Let’s see an example to make the concept easier to understand:`“ABCD”`
Every character in this string will be converted to it’s ASCII representation, the current cell will be set to that value and the head will move right.

```
                           A   B   C   D
+—-—+—-—+—-—+—-—+—-—+    +—-—+—-—+—-—+—-—+—-—+
| 0 | 0 | 0 | 0 | 0 | -> | 65| 66| 67| 68| 0 | 
+—-—+—-—+—-—+—-—+—-—+    +—-—+—-—+—-—+—-—+—-—+
  ^                                        ^
```

## Resetting And Ending the program
There are two reset commands: `:` and `.`
`:` resets the grid, setting the pointer coordinates to (0,0)
`.` resets the tape, setting the head and every cell to 0

A nice mnemonic for this is that the grid is 2D and `:` has 2 dots, while the tape is 1D and `.` has 1 dot.

The program ends when it reaches a `!`. If it is the first character it will imediatamente stop and do nothing (not a very useful program if you ask me). If the program never reaches `!`, it will loop for ever (well, at least until you get bored and close the terminal)


## Cheat Sheet
* Grid
	* `>` Right
	* `<` Left
	* `^` Up
	* `v` Down
	* `_` Left / Right
	* `|` Up / Down
	* `~` Ignore
	* `&` Go to (x, y)
	* `”` Start/End the string mode
* Tape
	* `{` Head Left
	* `}` Head Right
	* `+` Cell Up
	* `-` Cell Down
	* `?` Cell Random
	* `’` Get character from input
	* `=` Get integer from input
	* `$` Print cell as ASCII
	* `#` Print cell as integer
	* `@` Head to x
	* `0` Cell becomes 0
	* `1-9` Repeat the last tape operation x times
* Resetting and Ending
	* `:` Reset the Grid
	* `.` Reset the Tape
	* `!` End the program

## Final Notes
Any unrecognised characters inside the grid will throw an error. This means that you shouldn’t use them, unless you like errors for some weird reason.

Suggestions and contributions are appreciated. If you have an idea, want to help with documentation or implementation, found a bug or anything else, please open a pull request, an issue or message me on twitter or instagram.
