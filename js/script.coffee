jQuery.fn.vimify = ->
  # Init stuff

  this.mode = 'normal'

  # Functions

  this.escape = =>
    this.mode = 'normal'

  this.normalCommands =
    i: =>
      this.mode = 'insert'

  # Event "loop"

  this.keypress (e) =>

    if e.charCode == 27 # Esc
      this.escape()
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
