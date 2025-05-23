package L25.utils

public struct Color {
    public static let ANSI_RESET  = "\u{001B}[0m"
    public static let ANSI_RED    = "\u{001B}[31m"
    public static let ANSI_GREEN  = "\u{001B}[32m"
    public static let ANSI_YELLOW = "\u{001B}[33m"
    public static let ANSI_BLUE   = "\u{001B}[34m"
    public static let ANSI_PURPLE = "\u{001B}[35m"
    public static let ANSI_CYAN   = "\u{001B}[36m"
    public static let ANSI_GRAY   = "\u{001B}[90m"
    public static let ANSI_ERROR_RED       = "\u{001B}[31;1m"  // 亮红色
    public static let ANSI_ERROR_HIGHLIGHT = "\u{001B}[37;41m" // 白字红底
    public static let ERROR_TAG = "\u{001B}[38;5;196m\u{001B}[48;5;232m" // 亮红字+深灰底
    public static let ERROR_LOC = "\u{001B}[38;5;226m"               // 亮黄色
    public static let ERROR_MSG = "\u{001B}[38;5;255m"               // 亮白色
    public static let ANSI_BRIGHT_PURPLE   = "\u{001B}[95m"
    public static let ANSI_UnderLine       = "\u{001B}[4m"
}
