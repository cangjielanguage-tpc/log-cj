package utils

public let DEFAULT_LOG_LEVEL = LogLevel.INFO

/**
 * 日志打印级别
 * */
public enum LogLevel {
    | ALL // open log
    | TRACE // track information
    | DEBUG // debug information
    | INFO // notification information
    | WARN // warning message
    | ERROR // error message
    | OFF // disabling logs

    /**
     * 获取日志级别数值
     * */
    public func level(): Int64 {
        let num = match (this) {
            case ALL => 1
            case TRACE => 2
            case DEBUG => 3
            case INFO => 4
            case WARN => 5
            case ERROR => 6
            case OFF => 7
        }
        return num
    }

    /**
     * 获取日志级别名称
     * */
    public func levelName(): String {
        let name = match (this) {
            case ALL => "ALL"
            case TRACE => "TRACE"
            case DEBUG => "DEBUG"
            case INFO => "INFO"
            case WARN => "WARN"
            case ERROR => "ERROR"
            case OFF => "OFF"
        }
        return name
    }

    /**
     * 重载 >= 运算符
     * */
    public operator func >=(target: LogLevel): Bool {
        return this.level() >= target.level()
    }

    /**
     * 根据字符串解析日志级别，未识别的字符串默认为 INFO 级别日志
     * */
    public static func getLevelByString(lable: String): LogLevel {
        let level = match (lable.toAsciiUpper()) {
            case "ALL" => ALL
            case "TRACE" => TRACE
            case "DEBUG" => DEBUG
            case "INFO" => INFO
            case "WARN" => WARN
            case "ERROR" => ERROR
            case "OFF" => OFF
            case _ => INFO
        }
        return level
    }
}
