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

    m = v.match(/^.*?(\n|$)/)
    if m
      if x < m[0].length
        n += x
      else
        n += m[0].length

    this.textarea.selectionStart = n
    this.textarea.selectionEnd = this.textarea.selectionStart
    window.log('selectionStart: ' + this.textarea.selectionStart)
