import "./lexer" for Lexer
import "./parser" for Parser
import "./compiler" for Compiler
import "meta" for Meta

var ID = 0

class Wrenja {
  construct template(str) {
    var tokens = (Lexer.new(str)).tokenize()
    var parsed = (Parser.new(tokens)).parse()
    _compiled = (Compiler.new(parsed, ID)).compile()
    _id = ID
    ID = ID + 1
  }

  stringify(obj) {
    if (obj is Num || obj is Bool) {
      return obj.toString
    } else if (obj is String) {
      var substrings = []
      for (char in obj) {
        if (char == "\"") {
          substrings.add("\\\"")
        } else if (char == "\\") {
          substrings.add("\\\\")
        } else if (char == "\b") {
          substrings.add("\\b")
        } else if (char == "\f") {
          substrings.add("\\f")
        } else if (char == "\n") {
          substrings.add("\\n")
        } else if (char == "\r") {
          substrings.add("\\r")
        } else if (char == "\t") {
          substrings.add("\\t")
        } else {
          substrings.add(char)
        }
      }

      return "\"" + substrings.join("") + "\""
    } else if (obj is Null) {
      return "\"\""
    } else if (obj is List) {
      var substrings = obj.map { |o| stringify(o) }
      return "[" + substrings.join(",") + "]"
    } else if (obj is Map) {
      var substrings = obj.keys.map { |key|
        return stringify(key) + ":" + stringify(obj[key])
      }
      return "{" + substrings.join(",") + "}"
    }
  }

  render(data) {
    var templt = "var data%(_id) = %(stringify(data))\n" + _compiled + "\nreturn t%(_id)"
    return Meta.compile(templt).call()
  }

  save() {}
}
