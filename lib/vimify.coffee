jQuery.fn.vimify = ->
  # Init stuff

  this.mode = 'normal'
  this.textarea = this[0]
  this.cursor =
    x: 0
    y: 0

  # Functions

  this.functions =
    escape: =>
      this.mode = 'normal'
    moveCursor: (xx, yy) =>
      [x, y] = $(this.textarea).cursorPosition()
      $(this.textarea).cursorPosition(x+xx,y+yy)

  this.normalCommands =
    i: =>
      this.mode = 'insert'
    h: =>
      this.functions.moveCursor(-1, 0)
    j: =>
      this.functions.moveCursor(0, +1)
    k: =>
      this.functions.moveCursor(0, -1)
    l: =>
      this.functions.moveCursor(+1, 0)

  # Event "loop"

  this.keypress (e) =>

    if e.charCode == 27 # Esc
      this.functions.escape()
      return false

    c = String.fromCharCode(e.charCode)
    window.log(c)
    false
    switch this.mode
      when 'normal'
        if c of this.normalCommands
          this.normalCommands[c]()
        else
          window.log('Error: unknown normal mode command: '+c)
      when 'insert'
        return true
      else
        window.log('Error: WTF error: '+c)

    # No unwanted text input
    false
