import "./console" for Console

class Token {
  static TOKENS { [VarToken, CommentToken, ExpressionToken] }

  construct new(openingChar, closingChar, type) {
    _oChr = openingChar
    _cChr = closingChar
    _type = type
  }

  export(value) {
    return { "TYPE": _type, "VALUE": value.trim() }
  }

  getChrs() {
    return [_oChr, _cChr]
  }

  static getToken(char) {
    return Token.TOKENS.where(Fn.new { |T| 
      return T.oChr == char
    }).toList
  }
}

class VarToken is Token {
  static oChr { "{" }
  static cChr { "}" }

  construct new() {
    super(VarToken.oChr, VarToken.cChr, "VAR")
  }
}

class CommentToken is Token {
  static oChr { "#" }
  static cChr { "#" }

  construct new() {
    super(CommentToken.oChr, CommentToken.cChr, "COM")
  }
}

class ExpressionToken is Token {
  static oChr { "$" }
  static cChr { "$" }

  construct new() {
    super(ExpressionToken.oChr, ExpressionToken.cChr, "EXP")
  }
}

class Lexer {
  construct new(str) {
    _str = str
  }

  tokenize() {
    var tokens = []
    var c = 0
    var cEnd = _str.count
    var token = null
    var store = ""

    var pushText = Fn.new {
      if (store.trim().count > 0) {
        tokens.add({ "TYPE": "TEXT", "VALUE": store })
      }
    }

    while (c < cEnd) {
      var EOF = c == cEnd - 1
      var char = _str[c]

      if (token == null) {
        if (char == "{" && !EOF) {
          pushText.call()
          store = ""
          var t = Token.getToken(_str[c + 1])

          if (t.count > 0) {
            c = c + 1
            token = t[0].new()
          } else {
            store = store + char
          }
        } else {
          store = store + char
          if (EOF) {
            pushText.call()
          }
        }
      } else {
        if (char == token.getChrs()[1]) {
          if (_str[c + 1] == "}") {
            if (store.trim().count < 1) {
              Console.error("Empty block", _str[0...c])
              return null
            }

            c = c + 1
            tokens.add(token.export(store))
            token = null
            store = ""
          } else {
            store = store + char
          }
        } else {
          store = store + char
        }
      }

      if (EOF && token != null) {
        Console.error("Block not closed", _str)
        return null
      }

      c = c + 1
    }

    return tokens
  }
}