import "./console" for Console

class Statements {
  static getStatement(str) {
    var elems = str.split(" ")
    elems = elems.where(Fn.new { |v| v.trim() != "" }).toList

    if (elems[0] == "for") {
      return forStatement(elems)
    } else if (elems[0] == "endfor") { 
      return { "TYPE": "END_FOR" } 
    } else {
      Console.error("Undefined statement `%(elems[0])`", null)
      return null
    }
  }

  static forStatement(elems) {
    if (elems.count < 4) {
      Console.error("Syntax error with for loop", elems.join(" "))
      return null
    }

    var iName = elems[1]
    var inWord = elems[2]
    var range = elems[3]

    if (inWord != "in") {
      Console.error("Syntax error, expected `in`, found `%(inWord)`", elems.join(" "))
      return null 
    }

    return {
      "TYPE": "FOR_LOOP",
      "I_NAME": iName,
      "RANGE": range
    }
  }
}

class Variable {
  static S {{ 
    "VAR_NAME": 0,
    "FILTER": 1, "FILTER_ARG": 2
  }}

  construct new(varName, filters) {
    _vName = varName
    _filters = filters
  }

  export() {
    return { 
      "TYPE": "VAR", 
      "NAME": _vName,
      "FILTERS": _filters
    }
  }

  static parse(str) {
    var c = 0
    var ce = str.count
    var s = Variable.S["VAR_NAME"]
    var t = ""
    var vName = ""
    var filters = []

    while (c < ce) {
      var ch = str[c]
      var EOS = c == ce - 1

      var pushFilter = Fn.new {
        if (t.trim() == "") {
          Console.error("Found empty filter when parsing", str)
        } else {
          filters.add({ "NAME": t, "ARGS": [] })
        }
      }

      if (s == Variable.S["VAR_NAME"]) {
        if (ch == "|") {
          vName = t
          t = ""
          s = Variable.S["FILTER"]
        } else {
          t = t + ch
          if (EOS) { vName = t }
        }
      } else if (s == Variable.S["FILTER"]) {
        if (ch == "(") {
          pushFilter.call()
          t = ""
          s = Variable.S["FILTER_ARG"]
        } else if (ch == "|") {
          pushFilter.call()
          t = ""
        } else {
          t = t + ch
          if (EOS) { 
            pushFilter.call()
          }
        }
      } else if (s == Variable.S["FILTER_ARG"]) {
        if (ch == ")") {
          filters[-1]["ARGS"] = t.split(",")
          t = ""
          c = c + 1
          s = Variable.S["FILTER"]
        } else {
          t = t + ch
        }
      }

      c = c + 1
    }

    if (vName.trim() == "") {
      Console.error("Found empty variable name when parsing", str)
      return null
    } else {
      return (Variable.new(vName, filters)).export()
    }
  }
}

class Parser {
  construct new(tokens) {
    _tokens = tokens
  }

  parse() {
    var r = []

    for (token in _tokens) {
      if (token["TYPE"] == "VAR") {
        r.add(Variable.parse(token["VALUE"]))
      } else if (token["TYPE"] == "EXP") {
        r.add(Statements.getStatement(token["VALUE"]))
      } else if (token["TYPE"] == "TEXT") {
        r.add(token)
      }
    }

    return r
  }
}