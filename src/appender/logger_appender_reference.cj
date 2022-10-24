package appender

/**
  LoggerAppender 引用模型类
**/
public class LoggerAppenderReference {
    // 日志级别，默认 info
    public var level: LogLevel = DEFAULT_LOG_LEVEL

    // appender 列表
    public var appender: ArrayList<LoggerAppender> = ArrayList<LoggerAppender>()

    public init(level: LogLevel, appender: ArrayList<LoggerAppender>) {
        this.level = level
        this.appender = appender
    }

    public init() {}
}