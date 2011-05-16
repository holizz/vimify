jQuery.fn.cursorPosition = (x, y) ->
  countInstances = (string, substring) =>
    string.split(substring).length - 1

  this.textarea = this[0]
  val = $(this.textarea).val()

  unless x? and y?

    # Determine position

    textBeforeCursor = val.substring(0, this.textarea.selectionStart)
    y = countInstances(textBeforeCursor, '\n') + 1
    if match = textBeforeCursor.match(/\n(.*$)/)
      textBeforeCursor = match[1]
    x = textBeforeCursor.length + 1

    window.log('x: '+x+', y: '+y)
    [x,y]

  else

    if x < 1 or y < 1
      return

    # Set position

    re = /^.*?\n/
    v = val
    n = -1
    if y > 1
      for yy in [1..y-1]
        n += v.match(re)[0].length
        v = v.replace(re, '')

    m = v.match(re)
    if m
      if x < m[0].length
        n += x
      else
        n += m[0].length

    this.textarea.selectionStart = n
    this.textarea.selectionEnd = this.textarea.selectionStart
    window.log('selectionStart: ' + this.textarea.selectionStart)


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

jQuery('#vim').vimify()
