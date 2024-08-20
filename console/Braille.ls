
  do ->

    { new-instance } = dependency 'primitive.Instance'
    { Num, Bool } = dependency 'primitive.Type'
    { new-boolean-matrix } = dependency 'primitive.BooleanMatrix'
    { char } = dependency 'native.String'

    unicode = -> 0x2800 + it

    #

    row-increment = (row, left-value, right-value) ->

      increment = 0

      [ left, right ] = row

      increment += left-value if left
      increment += right-value if right

      increment

    char-code-of-braille-char = (char) ->

      char-code = unicode 0

      for index til 4

        row =

          * char.get index, 0
            char.get index, 1

        increment = switch index

          | 0 => row-increment row, 0x01, 0x08
          | 1 => row-increment row, 0x02, 0x10
          | 2 => row-increment row, 0x04, 0x20
          | 3 => row-increment row, 0x40, 0x80

        char-code += increment

      char-code

    #

    new-braille-char = ->

      var matrix

      clear = -> matrix := new-boolean-matrix 4 2

      clear!

      new-instance do

        get: member: (x, y) -> Num x ; Num y ; matrix.get x, y
        set: member: (x, y, value = on) !-> Num x ; Num y ; Bool value ; matrix.set x, y, value
        unset: member: (x, y) !-> Num x ; Num y ; matrix.unset x, y

        clear: member: -> clear!

        char-code: getter: -> char-code-of-braille-char @

        to-string: member: -> char @char-code

    #

    braille-char-from-char-code = (char-code) ->

      bits = [ 0x01, 0x02, 0x04, 0x40, 0x08, 0x10, 0x20, 0x80 ]

      char-bits = []

      for bit,index in bits

        char-bits[*] = char-code .&. bit

      result = new-braille-char!

      row = 0 ; column = 0

      for bit in char-bits

        result.set row, column, bit
        row++

        if row >= 4
          column++
          row = 0

      result

    is-braille-char-code = (char-code) ->

      return false if code < unicode 0
      return false if code > unicode 0xff

      true

    is-braille-char = (char) -> is-braille-char-code char.char-code-at 0

    #

    braille-char-from-char = (char) ->

      return unless is-braille-char char

      braille-char-from-char-code char.char-code-at 0

    #

    braille-char-from-string-list = (strings) ->

      char = new-braille-char!

      for string, row in strings

        break if row >= 4

        for bit, column in string / ''

          continue if column >= 2

          if bit is '*'

            char.set row, column

      char

    {
      new-braille-char,
      braille-char-from-char, braille-char-from-char-code,
      braille-char-from-string-list
    }