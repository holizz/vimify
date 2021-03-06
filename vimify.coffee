class Vimify

  ## Init

  constructor: (textarea) ->

    this.textarea = textarea
    if(typeof this.textarea != HTMLTextAreaElement)
      this.textarea = this.textarea[0]

    this.mode = 'normal'

    this.setSelection()

    this.eventLoop()

  # Event "loop"

  eventLoop: ->

    $(this.textarea).keypress (e) =>

      if e.charCode == 27 # Esc
        this.escape()
        return false

      c = String.fromCharCode(e.charCode)
      window.log(c)
      false
      switch this.mode
        when 'normal'
          this.normalCommand(c)
        when 'insert'
          this.insertBeforeCursor(c)
        else
          window.log('Error: WTF error: '+c)

      # No unwanted text input
      false

  ## Commands

  normalCommands:
    i: (t) ->
      t.mode = 'insert'
    h: (t) ->
      t.moveCursor(-1, 0)
    j: (t) ->
      t.moveCursor(0, +1)
    k: (t) ->
      t.moveCursor(0, -1)
    l: (t) ->
      t.moveCursor(+1, 0)

  ## Methods

  normalCommand: (c) ->
    if c of this.normalCommands
      this.normalCommands[c](this)
    else
      window.log('Error: unknown normal mode command: '+c)

  escape: ->
    this.mode = 'normal'
    if this.getXY()[0] > 1
      this.setSelection(this.textarea.selectionStart-1)

  moveCursor: (xx, yy) ->
    [x, y] = this.getXY()
    this.setSelection(this.getSelectionStartFromXY(x+xx,y+yy))

  countInstances: (string, substring) ->
    string.split(substring).length - 1

  getXY: ->

    val = $(this.textarea).val()

    textBeforeCursor = val.substring(0, this.textarea.selectionStart)
    y = this.countInstances(textBeforeCursor, '\n') + 1
    if match = textBeforeCursor.match(/\n(.*$)/)
      textBeforeCursor = match[1]
    x = textBeforeCursor.length + 1

    window.log('x: '+x+', y: '+y)
    [x,y]

  getSelectionStartFromXY: (x,y) ->

    val = $(this.textarea).val()

    if x < 1 or y < 1
      return

    # Determine position

    re = /^.*?\n/
    v = val
    n = -1
    if y > 1
      for yy in [1..y-1]
        if m = v.match(re)
          n += m[0].length
        else
          window.log('errar no match: ' + v)
        v = v.replace(re, '')

    if m = v.match(/^.*?(\n|$)/)
      if x < m[0].length
        n += x
      else
        if v.match(/^.*?$/)
          n += m[0].length
        else
          n += m[0].length - 1

    n

  setSelection: (n) ->
    n = this.textarea.selectionStart unless n?

    window.log('setting selection: '+n)
    this.textarea.selectionStart = n
    this.textarea.selectionEnd = n+1

  insertBeforeCursor: (c) ->
    val = $(this.textarea).val()
    selStart = this.textarea.selectionStart
    newVal = val.substring(0,selStart) + c + val.substring(selStart)
    $(this.textarea).val(newVal)
    this.setSelection(selStart+1)

jQuery.fn.vimify = ->
  new Vimify(this)
