class Color {
  static RESET { "\x1b[0m" }
  static BOLD { "\x1b[1m" }
  static FG_RED { "\x1b[31m" }
  static FG_CYAN { "\x1b[96m" }
}

class Console {
  static print(head, msg) {
    System.print("%(Color.FG_CYAN)[Wrenja] %(head)%(Color.RESET): %(msg)%(Color.RESET)")
  }

  static error(msg, code) {
    Console.print("%(Color.BOLD)%(Color.FG_RED)ERROR", Color.FG_RED + msg)

    if (code != null) {
      System.print("%(Color.FG_RED)%(code.trim()) %(Color.BOLD)<----- HERE%(Color.RESET)")
    }
  }
}