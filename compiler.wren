class Compiler {
  construct new(parsed) {
    _parsed = parsed
    _vars = []
    _lvl = 0
  }

  getHeader() {
    return "var t = \"\"\n"
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
      vName = "data%(nodesStr)" 
    } else { 
      vName = nodes[0] + nodesStr
    } 

    return vName
  }

  getVar(v) {
    return getVarName(v["NAME"])
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
    var r = getHeader()
    var openS = false
    
    var lvlVars = {}

    var closeS = Fn.new {
      if (openS) {
        r = r + "\"\n"
        openS = false
      }
    }

    var i = 0
    for (st in _parsed) {
      if (st["TYPE"] == "TEXT") {
        if (openS) {
          r = r + "%(st["VALUE"])"
        } else {
          r = r + "\n%(getIndent())t = t + \"%(st["VALUE"])"
          openS = true
        }
      } else if (st["TYPE"] == "VAR") {
        if (openS) {
          r = r + "\%(%(getVar(st)))"
        } else {
          r = r + "\n%(getIndent())t = t + %(getVar(st))"
        }
      } else if (st["TYPE"] == "FOR_LOOP") {
        closeS.call()

        r = r + "\n%(getIndent())for (%(st["I_NAME"]) in %(getVarName(st["RANGE"]))) {"
        _vars.add(st["I_NAME"])
        _lvl = _lvl + 1
        if (lvlVars[_lvl] == null) { lvlVars[_lvl] = []}
        lvlVars[_lvl].add(st["I_NAME"])
      } else if (st["TYPE"] == "END_FOR") {
        closeS.call()

        for (v in lvlVars[_lvl]) {
          removeFromVars(v)
        }
        lvlVars[_lvl] = []
        _lvl = _lvl - 1
        r = r + "%(getIndent())}"
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

    return r
  }
}