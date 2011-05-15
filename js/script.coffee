jQuery.fn.vimify = ->
  this.mode = 'normal'
  this.normalCommands =
    i: =>
      this.mode = 'insert'

  this.keypress (e) =>
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

    false

jQuery('#vim').vimify()
