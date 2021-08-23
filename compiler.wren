class Compiler {
  static functions {{
    "toString": ""
  }}

  construct new(parsed, id) {
    _parsed = parsed
    _vars = []
    _fns = []
    _lvl = 0
    _id = id
  }

  getHeader() {
    return "var t%(_id) = \"\"\n"
  }

  getVarName(str) {
    return getVarName(str, true)
  }

  getVarName(str, cDef) {
    var range = str.split("...")
    if (range.count > 1) {
      return "%(getVarName(range[0], false))...%(getVarName(range[1], false))"
    }

    var nodes = str.split(".")
    var nodesStr = ""
    var rmin = 1

    var def = _vars.contains(nodes[0]) || !cDef
    if (!def) rmin = 0

    for (node in nodes[rmin...nodes.count]) {
      nodesStr = nodesStr + "[\"%(node)\"]"
    }

    var vName = ""
    if (!def) { 
      vName = "data%(_id)%(nodesStr)" 
    } else { 
      vName = nodes[0] + nodesStr
    } 

    return vName
  }

  getVar(v) {
    var vName = getVarName(v["NAME"])
    var r = ""
    // BUILT IN FUNCTIONS
    // ADDED ONLY IF ARE USED BY THE TEMPLATE
    System.print(v)
    return 
  }

  getIndent() {
    return "\t" * _lvl
  }

  removeFromVars(v) {
    for (i in 0..._vars.count) {
      if (_vars[i] == v) {
        _vars.removeAt(i)
        return
      }
    }
  }

  compile() {
    var r = ""
    var openS = false
    
    var lvlVars = {}

    var closeS = Fn.new {
      if (openS) {
        r = r + "\"\n"
        openS = false
      }
    }

    var goDown = Fn.new { |n|
      closeS.call()
      for (v in lvlVars[_lvl]) {
        removeFromVars(v)
      }
      lvlVars[_lvl] = []
      _lvl = _lvl - 1
      r = r + "%(getIndent())}"

      if (n) {
        r = r + "\n"
      }
    }    

    var i = 0
    for (st in _parsed) {
      if (lvlVars[_lvl] == null) { lvlVars[_lvl] = []}
      if (lvlVars[_lvl + 1] == null) { lvlVars[_lvl + 1] = []}
      if (st["TYPE"] == "TEXT") {
        if (openS) {
          r = r + "%(st["VALUE"])"
        } else {
          r = r + "\n%(getIndent())t%(_id) = t%(_id) + \"%(st["VALUE"])"
          openS = true
        }
      } else if (st["TYPE"] == "VAR") {
        if (openS) {
          r = r + "\%(%(getVar(st)))"
        } else {
          r = r + "\n%(getIndent())t%(_id) = t%(_id) + %(getVar(st))\n"
        }
      } else if (st["TYPE"] == "ELSE") {
        goDown.call(false)
        r = r + " else {"
        _lvl = _lvl + 1
      } else if (st["TYPE"] == "ELIF") {
        goDown.call(false)
        r = r + " else if (%(st["COND"])) {"
        _lvl = _lvl + 1
      } else if (st["TYPE"] == "IF") {
        closeS.call()
        r = r + "\n%(getIndent())if (%(st["COND"])) {"
        _lvl = _lvl + 1
      } else if (st["TYPE"] == "FOR_LOOP") {
        closeS.call()
        r = r + "\n%(getIndent())for (%(st["I_NAME"]) in %(getVarName(st["RANGE"]))) {"
        _vars.add(st["I_NAME"])
        _lvl = _lvl + 1
        lvlVars[_lvl].add(st["I_NAME"])
      } else if (st["TYPE"] == "END_FOR" || st["TYPE"] == "END_IF") {
        goDown.call(true)
      }

      if (i == _parsed.count - 1) {
        if (openS) {
          r = r + "\"\n"
        } else {
          r = r + "\n"
        }
      }

      i = i + 1
    }

    return getHeader() + r
  }
}