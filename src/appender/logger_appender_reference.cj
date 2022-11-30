package appender

/**
   LoggerAppender 引用模型类
 * */
public class LoggerAppenderReference {
    // 日志级别，默认 info
    private var level: LogLevel = DEFAULT_LOG_LEVEL

    // appender 列表
    private var appenderList: ArrayList<LoggerAppender> = ArrayList<LoggerAppender>()

    public init(level: LogLevel, appenderList: ArrayList<LoggerAppender>) {
        this.level = level
        this.appenderList = appenderList
    }

    public init() {}

    public func getAppenderList() {
        return this.appenderList
    }

    public func setAppenderList(appenderList: ArrayList<LoggerAppender>) {
        this.appenderList = appenderList
    }

    public func getLevel() {
        return this.level
    }

    public func setLevel(level: LogLevel) {
        this.level = level
    }
}
