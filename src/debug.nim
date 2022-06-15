import os
import illwill

########################################
# Initialize full screen
########################################
proc exitProc() {.noconv.} =
  illwillDeinit()
  showCursor()
  quit(0)

illwillInit(fullscreen=true)
setControlCHook(exitProc)
hideCursor()

var tb = newTerminalBuffer(terminalWidth(), terminalHeight())


# ┌─ Info ───────────┐                                                                                                                                             
# │  Head: xxx       │                                                                                                                                             
# │  x, y: xxx, xxx  │                                                                                                                                             
# │  Curr: x         │                                                                                                                                             
# └──────────────────┘
proc drawInfo(x, y: int, head, coordX, coordY, curr: string) = 
    tb.setForegroundColor(fgWhite, true)
    tb.setBackgroundColor(bgNone)

    tb.drawRect(x, y, x+19, y+4)
    tb.write(x+2, y, fgGreen, " Info ")
    tb.write(x+3, y+1, fgWhite, "Head: ")
    tb.write(x+3, y+2, fgWhite, "x, y: ")
    tb.write(x+3, y+3, fgWhite, "Curr: ")
    
    tb.write(x+9, y+1, fgGreen, head)
    tb.write(x+9, y+2, fgGreen, coordX, fgWhite, ", ", fgGreen, coordY)
    tb.write(x+9, y+3, fgGreen, curr)

#┌─ Tape ────────────────────────┐                                                                                                                            
#│     ┌─────┐┌─────┐┌─────┐     │                                                                                                                            
#│ ... │ xxx ││ xxx ││ xxx │ ... │                                                                                                                            
#│     └─────┘└─────┘└─────┘     │                                                                                                                            
#└────────────── ^ ──────────────┘
proc drawTape(x, y: int, val1, val2, val3: string) = 
    tb.setForegroundColor(fgWhite, true)
    tb.setBackgroundColor(bgNone)

    tb.drawRect(x, y, x+32, y+4)
    tb.drawRect(x+6,  y+1, x+12,  y+3)
    tb.drawRect(x+13, y+1, x+19, y+3)
    tb.drawRect(x+20, y+1, x+26, y+3)
    
    tb.write(x+2,  y,   fgGreen, " Tape ")
    tb.write(x+15, y+4, fgGreen, " ^ ")

    tb.write(x+8,  y+2, fgGreen, val1)
    tb.write(x+15, y+2, fgGreen, val2)
    tb.write(x+22, y+2, fgGreen, val2)

    tb.write(x+2,  y+2, fgGreen, "...")
    tb.write(x+28,  y+2, fgGreen, "...")
    

# ┌─ Grid ──┐                                                                                                                                                      
# │    u    │                                                                                                                                                      
# │  l c r  │                                                                                                                                                      
# │    d    │                                                                                                                                                      
# └─────────┘ 
proc drawGrid(x, y: int, curr, up, right, down, left: string) = 
    tb.setForegroundColor(fgWhite, true)


    tb.drawRect(x, y, x+10, y+4)
    
    tb.write(x+2,  y,   fgGreen, " Grid ")

    tb.write(x+5,  y+1, fgGreen, up)
    tb.write(x+3,  y+2, fgGreen, left)
    tb.write(x+7,  y+2, fgGreen, right)
    tb.write(x+5,  y+3, fgGreen, down)

    tb.write(x+5,  y+2, fgGreen, curr)


# 4. This is how the main event loop typically looks like: we keep polling for
# user input (keypress events), do something based on the input, modify the
# contents of the terminal buffer (if necessary), and then display the new
# frame.
while true:
  tb.setForegroundColor(fgWhite, true)
  tb.drawRect(0, 0, 36, 11)
  drawInfo(2, 1, "100", "101", "102", "c")
  drawgrid(24, 1, "c", "u", "r", "d", "l")
  drawTape(2, 6, "100", "101", "102")

  tb.display()
  sleep(20)


