jQuery.fn.vimify = ->
  # Init stuff

  this.mode = 'normal'
  this.textarea = this[0]

  # Functions

  this.functions =
    escape: =>
      this.mode = 'normal'
    moveCursor: (x) =>
      this.textarea.selectionStart += x
      this.textarea.selectionEnd = this.textarea.selectionStart

  this.normalCommands =
    i: =>
      this.mode = 'insert'
    h: =>
      this.functions.moveCursor(-1)
    l: =>
      this.functions.moveCursor(+1)

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

jQuery('#vim').vimify()
