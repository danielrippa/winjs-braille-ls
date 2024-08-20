
  do ->

    { new-braille-char } = dependency 'console.Braille'
    { Num, Bool } = dependency 'primitive.Type'

    max-strings-length = (strings) ->

      max-length = 0

      for string in strings

        if string.length > max-length
          max-length = string.length

      max-length

    #

    new-braille-string = (length) ->

      Num length

      chars = void

      clear = -> chars := [ (new-braille-char!) for til length ]

      clear!

      #

      index = -> Math.floor it / 2

      get-char   = (y) -> chars[ index y ]
      get-char-y = (y) -> y - ( (index y) * 2 )

      #

      get: (x, y) -> Num x ; Num y ; char = get-char y ; return if char is void ; char.get x, get-char-y y
      set: (x, y, bit = on) -> Num x ; Num y ; Bool bit ; char = get-char y ; return if char is void ; char.set x, (get-char-y y), bit

      unset: (x, y) -> Num x ; Num y ; @set x, y, off

      clear: -> clear!

      to-string: -> [ (char.to-string!) for char in chars ] * ''

    #

    new-braille-string-from-string-list = (strings) ->

      string-length = max-strings-length strings

      result = new-braille-string string-length

      for row from 0 to 3

        string = strings[row]

        break if row >= strings.length

        for char, column in string / ''

          if char is '*'

            result.set row, column

      result

    {
      new-braille-string,
      new-braille-string-from-string-list
    }

